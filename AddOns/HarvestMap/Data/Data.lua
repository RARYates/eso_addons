local Lib3D = LibStub("Lib3D2")

if not Harvest.Data then
	Harvest.Data = {}
end

local Harvest = _G["Harvest"]
local Data = Harvest.Data
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

Data.dataDefault = {
	data = {},
	dataVersion = Harvest.dataVersion,
	-- table below is only added for backward compatibility with the merge website, until it gets updated
	--["Default"] = {
	--	["@MergeCompatibility"] = {
	--		["$AccountWide"] = {
	--			["nodes"] =  {
	--				["data"] =  {},
	--				["dataVersion"] = 16,
	--			},
	--		},
	--	},
	--},
}
Data.subModules = {}

-- when retrieved data from merge, remove very old data
function Data:GetMinGameVersionFromMerge()
	local lastMerge = self.backupSavedVars.lastMerge
	if lastMerge then
		-- "2017-09-24 14:58:11 [342938]"
		local year, month, day = lastMerge:match("(%d+)-(%d+)-(%d+)")
		if tonumber(year) >= 2017 and tonumber(month) >= 8 and tonumber(day) >= 1 then
			local version, update, patch = 2, 7, 0
			return version * 10000 + update * 100 + patch
		end
	end
	return 0
end

local addOnNameToGlobal = {
	HarvestMapAD = "HarvestAD",
	HarvestMapEP = "HarvestEP",
	HarvestMapDC = "HarvestDC",
	HarvestMapDLC = "HarvestDLC",
	HarvestMapNF = "HarvestNF",
	HarvestMap = "Harvest"
}
local addOnNameToZones = {
	HarvestMapAD = {
		["auridon"] = true,
		["grahtwood"] = true,
		["greenshade"] = true,
		["malabaltor"] = true,
		["reapersmarch"] = true
	},
	HarvestMapEP = {
		["bleakrock"] = true,
		["stonefalls"] = true,
		["deshaan"] = true,
		["shadowfen"] = true,
		["eastmarch"] = true,
		["therift"] = true
	},
	HarvestMapDC = {
		["glenumbra"] = true,
		["stormhaven"] = true,
		["rivenspire"] = true,
		["alikr"] = true,
		["bangkorai"] = true
	},
	HarvestMapDLC = {
		--imperialcity, part of cyrodiil
		["wrothgar"] = true,
		["thievesguild"] = true,
		["darkbrotherhood"] = true,
		--dungeonthingy, does that one even have a prefix?
		["vvardenfell"] = true,
		-- 2nd dungeon thingy
		["clockwork"] = true,
	},
}

function Data:CheckSubModule(addOnName)
	local globalVarName = addOnNameToGlobal[addOnName]
	if not globalVarName then return end
	
	subModule = {}
	subModule.zones = addOnNameToZones[addOnName]
	self.subModules[globalVarName] = subModule
	
end

local function addMissing(result, template)
	for key, value in pairs(template) do
		if type(value) == "table" then
			result[key] = result[key] or {}
			addMissing(result[key], value)
		else
			result[key] = result[key] or value
		end
	end
end

function Data:LoadSavedVars()
	-- load data stored in submodules
	local savedVarName
	for subModuleName, module in pairs(self.subModules) do
		savedVarName = subModuleName .. "_SavedVars"
		_G[savedVarName] = _G[savedVarName] or {}
		module.savedVars = _G[savedVarName]
		module.savedVarsName = savedVarName
		
		if not module.savedVars.firstLoaded then
			module.savedVars.firstLoaded = Harvest.GetCurrentTimestamp()
		end
		module.savedVars.lastLoaded = Harvest.GetCurrentTimestamp()
	end
	self.backupSavedVars = self.subModules["Harvest"].savedVars
	
	self:AddMissingFields()
end

function Data:AddMissingFields()
	for subModuleName, module in pairs(self.subModules) do
		addMissing(module.savedVars, self.dataDefault)
	end
end

function Data:ClearCaches()
	self.currentZoneCache = nil
	self.mapCaches = {}
	self.numCaches = 0
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "cacheCleared")
end

function Data:Initialize()
	-- cache the ACE deserialized nodes
	-- this way changing maps multiple times will create less lag
	self.mapCaches = {}
	self.numCaches = 0
	
	-- load nodes
	Harvest.AddToUpdateQueue(function() self:LoadSavedVars() end)
	
	-- check if saved data is from an older version,
	-- update the data if needed
	Harvest.AddToUpdateQueue(function() self:UpdateDataVersion() end)
	
	-- move data to correct save files
	-- if AD was disabled while harvesting in AD, everything was saved in self.savedvars
	-- when ad is enabled, everything needs to be moved to that save file
	-- HOWEVER, only execute this after the save files were updated!
	Harvest.AddToUpdateQueue(function() self:MoveData() end)
	
	if HM_Exchange then
		HM_Exchange.Init()
	end
	
	-- when the time setting is changed, all caches need to be reloaded
	local clearCache = function(event, setting, value)
		if setting == "applyTimeDifference" then
			self:ClearCaches()
		end
	end
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, clearCache)
	
	EVENT_MANAGER:RegisterForEvent("HarvestMapNewZone", EVENT_PLAYER_ACTIVATED, function() self:OnPlayerActivated() end)
end

function Data:IsNodeDataValid( map, x, y, z, measurement, zoneIndex, pinTypeId )
	if not map then
		Harvest.Debug( "SaveData failed: map is nil" )
		return false
	end
	if type(x) ~= "number" or type(y) ~= "number" then
		Harvest.Debug( "SaveData failed: coordinates aren't numbers" )
		return false
	end
	if not measurement then
		Harvest.Debug( "SaveData failed: measurement is nil" )
		return false
	end
	if not pinTypeId then
		Harvest.Debug( "SaveData failed: pin type id is nil" )
		return false
	end
	if Harvest.IsMapBlacklisted( map ) then
		Harvest.Debug( "SaveData failed: map " .. tostring(map) .. " is blacklisted" )
		return
	end
	return true
end

-- this function tries to save the given data
-- this function is only used by the harvesting part of HarvestMap
function Data:SaveNode( map, x, y, z, measurement, zoneIndex, pinTypeId )
	
	if not self:IsNodeDataValid( map, x, y, z, measurement, zoneIndex, pinTypeId ) then return end

	local saveFile = self:GetSaveFile( map )
	if not saveFile then return end
	-- save file tables might not exist yet
	saveFile.data[ map ] = saveFile.data[ map ] or {}
	saveFile.data[ map ][ pinTypeId ] = saveFile.data[ map ][ pinTypeId ] or {}

	local cache = self:GetMapCache( pinTypeId, map, measurement, zoneIndex )
	if not cache then return end

	local stamp = Harvest.GetCurrentTimestamp()

	-- If we have found this node already then we don't need to save it again
	local nodeId = cache:GetMergeableNode( pinTypeId, x, y )
	if nodeId then
		local oldStamp = cache.timestamp[nodeId] or 0
		local x, y, z, stamp, nodeVersion, globalX, globalY, flags = cache:Merge(nodeId, x, y, z, stamp, Harvest.nodeVersion)
		-- serialize the node for the save file
		local nodeIndex = cache.nodeIndex[ nodeId ]
		saveFile.data[ map ][ pinTypeId ][ nodeIndex ] = self:Serialize( x, y, z, stamp, nodeVersion, globalX, globalY, flags )
		
		if stamp - oldStamp > 30 * 24 * 60 * 60 then
			self:LogNode(map, globalX, globalY, z, GetZoneId(zoneIndex), pinTypeId)
		end
		
		CallbackManager:FireCallbacks(Events.NODE_UPDATED, map, pinTypeId, nodeId)

		-- hide the node, if the respawn timer is used for recently harvested resources
		if Harvest.IsHiddenOnHarvest() and Harvest.GetHiddenTime() > 0 then
			cache:SetHidden( nodeId, true )
		end

		Harvest.Debug( "data was merged with a previous node" )
		return
	end

	-- we need to save the data in serialized form in the save file,
	-- but also as deserialized table in the cache table for faster access.

	local nodeIndex = (#saveFile.data[ map ][ pinTypeId ]) + 1
	nodeId = cache:Add( pinTypeId, nodeIndex, x, y, z, stamp, Harvest.nodeVersion )
	local globalX = cache.globalX[nodeId]
	local globalY = cache.globalY[nodeId]
	local flags = cache.flags[nodeId]
	saveFile.data[ map ][ pinTypeId ][nodeIndex] = self:Serialize( x, y, z, stamp, Harvest.nodeVersion, globalX, globalY, flags )
	self:LogNode(map, globalX, globalY, z, GetZoneId(zoneIndex), pinTypeId)

	CallbackManager:FireCallbacks( Events.NODE_ADDED, map, pinTypeId, nodeId )

	-- hide the node, if the respawn timer is used for recently harvested resources
	if Harvest.IsHiddenOnHarvest() and Harvest.GetHiddenTime() > 0 then
		cache:SetHidden( nodeId, true )
	end

	Harvest.Debug( "data was saved and a new pin was created" )
end

-- imports all the nodes on 'map' from the table 'data' into the save file table 'saveFile'
-- if checkPinType is true, data will be skipped if Harvest.IsPinTypeSavedOnImport(pinTypeId) returns false
function Data:ImportFromMap( map, data, saveFile, checkPinType )
	local insert = table.insert
	local pairs = _G["pairs"]
	local zo_max = _G["zo_max"]
	local type = _G["type"]
	local next = _G["next"]

	-- nothing to merge, data can simply be copied
	if saveFile.data[ map ] == nil then
		saveFile.data[ map ] = data
		return
	end
	-- the target table contains already a bunch of nodes, so the data has to be merged
	local targetData = nil
	local newNode = nil
	local index = 0
	local oldNode = nil
	local distance = Harvest.GetMinDistanceBetweenPins()
	local timestamp = Harvest.GetCurrentTimestamp()
	local maxTimeDifference = Harvest.GetMaxTimeDifference() * 3600
	local success, x, y, x2, y2, z, stamp, version, dx, dy, globalX, globalY, flags
	local isValid
	local cache = Data.MapCache:New(map)
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if (not checkPinType) or Harvest.IsPinTypeSavedOnImport( pinTypeId ) then
			cache:InitializePinType(pinTypeId)
			if saveFile.data[ map ][ pinTypeId ] == nil then
				-- nothing to merge for this pin type, just copy the data
				saveFile.data[ map ][ pinTypeId ] = data[ pinTypeId ]
			else
				-- deserialize target data and clear the serialized target data table (we'll fill it again at the end)
				local startIndex = cache.lastNodeId+1
				for nodeIndex, node in pairs( saveFile.data[ map ][ pinTypeId ] ) do
					success, x, y, z, stamp, version, globalX, globalY, flags = self:Deserialize(node, pinTypeId)
					if success then -- check if something went wrong while deserializing the node
						cache:Add(pinTypeId, nil, x, y, z, stamp, version, globalX, globalY, flags )
					end
				end
				local endIndex = cache.lastNodeId

				saveFile.data[ map ][ pinTypeId ] = {}
				-- deserialize every new node and merge them with the old nodes
				data[ pinTypeId ] = data[ pinTypeId ] or {}
				for nodeIndex, node in pairs( data[ pinTypeId ] ) do
					success, x, y, z, stamp, version, globalX, globalY, flags = self:Deserialize(node, pinTypeId)
					if success then -- check if something went wrong while deserializing the node
						-- If the node is new enough to be saved
						isValid = true
						if maxTimeDifference > 0 and (timestamp - stamp) > maxTimeDifference then
							isValid = false
						end

						if isValid then
							-- If we have found this node already then we don't need to save it again
							for nodeId = startIndex, endIndex do
								x2 = cache.localX[nodeId]
								y2 = cache.localY[nodeId]

								dx = x - x2
								dy = y - y2
								-- the nodes are too close
								if dx * dx + dy * dy < distance then
									cache:Merge(nodeId, x, y, z, stamp, version, globalX, globalY, flags)
									isValid = false
									break
								end
							end
						end

						if isValid then
							cache:Add(pinTypeId, nil, x, y, z, stamp, version, globalX, globalY, flags )
						end
					end
				end
				-- serialize the new data
				for nodeIndex, nodeId in pairs( cache.nodesOfPinType[pinTypeId] ) do
					x = cache.localX[nodeId]
					y = cache.localY[nodeId]
					z = cache.worldZ[nodeId]
					globalX = cache.globalX[nodeId]
					globalY = cache.globalY[nodeId]
					stamp = cache.timestamp[nodeId]
					version = cache.version[nodeId]
					flags = cache.flags[nodeId]
					saveFile.data[ map ][ pinTypeId ][ nodeIndex ] = self:Serialize(x, y, z, stamp, version, globalX, globalY, flags )
				end
			end
		end
	end
	-- as new data was added to the map, the appropiate cache has to be cleared
	local existingCache = self.mapCaches[map]
	if existingCache then
		self.mapCaches[map] = nil
		self.numCaches = self.numCaches - 1
		CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "cacheCleared", map)
	end
end

-- returns the correct table for the map (HarvestMap, HarvestMapAD/DC/EP save file tables)
-- will return HarvestMap's table if the correct table doesn't currently exist.
-- ie the HarvestMapAD addon isn't currently active
function Data:GetSaveFile( map )
	return self:GetSpecialSaveFile( map ) or self.backupSavedVars
end

-- returns the correct (external) table for the map or nil if no such table exists
function Data:GetSpecialSaveFile( map )
	local zone = string.gsub( map, "/.*$", "" )
	for subModuleName, subModule in pairs(self.subModules) do
		if subModule.zones and subModule.zones[ zone ] then
			return subModule.savedVars
		end
	end
	if self.subModules["HarvestNF"] then
		for name, zones in pairs(addOnNameToZones) do
			if zones[map] then
				return nil
			end
		end
		return self.subModules["HarvestNF"].savedVars
	end
	return nil
end

-- this function moves data from the HarvestMap addon to HarvestMapAD/DC/EP
function Data:MoveData()
	for map, data in pairs( self.backupSavedVars.data ) do
		local zone = string.gsub( map, "/.*$", "" )
		local file = self:GetSpecialSaveFile( map )
		if file ~= nil then
			Harvest.AddToUpdateQueue(function()
				self:ImportFromMap( map, data, file )
				self.backupSavedVars.data[ map ] = nil
				Harvest.Debug("Moving old data to the correct save files. " .. tostring(Harvest.GetQueuePercent()) .. "%")
			end)
		end
	end
end

-- data is stored as ACE strings
-- this functions deserializes the strings and saves the results in the cache
function Data:LoadToCache(pinTypeId, cache)
	cache:InitializePinType(pinTypeId)
	--local lastMerge = self.savedVars.lastMerge
	--if lastMerge then
	--	local y, m, d = string.match(lastMerge,"(%d*)-(%d*)-(%d*)")
	--	lastMerge = ((tonumber(y) or 0) * 100 + (tonumber(m) or 0)) * 100 + (tonumber(d) or 0)
	--end
	local map = cache.map
	local measurement = cache.measurement
	if not measurement then
		Harvest.Debug("no measurement when loading cache!")
		return
	end
	local saveFile = self:GetSaveFile(map)
	saveFile.data[ map ] = (saveFile.data[ map ]) or {}
	saveFile.data[ map ][ pinTypeId ] = (saveFile.data[ map ][ pinTypeId ]) or {}
	local serializedNodes = saveFile.data[ map ][ pinTypeId ]

	local currentTimestamp = Harvest.GetCurrentTimestamp()
	local maxTimeDifference = Harvest.GetMaxTimeDifference() * 3600
	local distance = Harvest.GetGlobalMinDistanceBetweenPins() / (measurement.distanceCorrection * measurement.distanceCorrection)
	distance = distance * Harvest.GetPinTypeDistanceMultiplier(pinTypeId)^2
	local startIndex = cache.lastNodeId + 1
	
	local minGameVersion = zo_max(Harvest.GetMinGameVersion(), self:GetMinGameVersionFromMerge())
	
	
	local valid, updated, globalX, globalY, addonVersion, gameVersion
	local success, x, y, z, names, timestamp, version, flags
	local globalX2, globalY2, dx, dy, stamp, stamp2
	-- deserialize the nodes
	for nodeIndex, node in pairs( serializedNodes ) do
		success, x, y, z, timestamp, version, globalX, globalY, flags = self:Deserialize( node, pinTypeId )
		if not success then--or not x or not y then
			Harvest.AddToErrorLog("invalid node:" .. x)
			serializedNodes[nodeIndex] = nil
		else
			-- just a simple test if de/encoding works properly
			--if globalX and globalY then
			--	local x1,y1,z1,zo,p = self:Maximize(self:Minimize(globalX, globalY, z, measurement.zoneId, pinTypeId))
			--	if x1 ~= globalX or y1 ~= globalY or z1 ~= z or zo ~= measurement.zoneId or p ~= pinTypeId then
			--		d("error1", globalX, globalY, z, measurement.zoneId, pinTypeId)
			--		d("error2", x1,y1,z1,zo,p)
			--	end
			--end
			valid = true
			updated = false
			-- some timestamps are too large because of repeated multiplying with 3600 of the bugged update routine
			if valid then
				if currentTimestamp < timestamp then
					timestamp = 0
					updated = true
				end
			end
			-- remove nodes that are too old (either number of days or patch)
			if maxTimeDifference > 0 and currentTimestamp - timestamp > maxTimeDifference then
				valid = false
				Harvest.AddToErrorLog("outdated node:" .. map .. node )
			end
			
			if minGameVersion > 0 and zo_floor(version / 1000) < minGameVersion then
				valid = false
				Harvest.AddToErrorLog("outdated node:" .. map .. node )
			end
			
			-- nodes must be inside the current map
			if valid then
				valid = (0 <= x and x < 1 and 0 <= y and x < 1)
				if not valid then
					Harvest.AddToErrorLog("invalid coord:" .. map .. node )
				end
			end
			
			if valid then
				if (not globalX) or (not globalY) then
					globalX = x * measurement.scaleX + measurement.offsetX
					globalY = y * measurement.scaleY + measurement.offsetY
					updated = true
				end
				-- remove nodes which were wrongfully saved on their global position
				addonVersion = version % 1000
				gameVersion = zo_floor(version / 1000)
				
				if addonVersion < 1 then
					if (globalX - x)^2 + (globalY - y)^2 < 0.009 then
						Harvest.AddToErrorLog("old addon version, global-local-bug:" .. map .. node )
						valid = false
					end
				end
				
				-- hew's bane was rescaled some time between 5th and 11th december (no patch maintenance, so it's really weird...)
				-- the same rescale also happened during the DB update (though the scaling was done in the other direction)
				-- let's try to repair it by merging nodes:
				-- the newer node is kept when two nodes can reconstruct each other by rescaling the map
				if valid then
					if map == "thievesguild/hewsbane_base" then
						for nodeId = startIndex, cache.lastNodeId do
							dx = cache.localX[nodeId] - x * 0.9871
							dy = cache.localY[nodeId] - y * 0.9871
							-- the nodes are too close
							if dx * dx + dy * dy < 0.00003 then
								x, y, z, timestamp, version, globalX, globalY, flags = cache:Merge(nodeId, x, y, z, timestamp, version, globalX, globalY, flags, isDatabase)
								-- update the old node
								serializedNodes[cache.nodeIndex[nodeId] ] = self:Serialize(x, y, z, timestamp, version, globalX, globalY, flags)
								Harvest.AddToErrorLog("node was merged:" .. map .. node )
								valid = false -- set this to false, so the node isn't added to the cache
								break
							end
							dx = cache.localX[nodeId] - x / 0.9871
							dy = cache.localY[nodeId] - y / 0.9871
							-- the nodes are too close
							if dx * dx + dy * dy < 0.00003 then
								x, y, z, timestamp, version, globalX, globalY, flags = cache:Merge(nodeId, x, y, z, timestamp, version, globalX, globalY, flags, isDatabase)
								-- update the old node
								serializedNodes[cache.nodeIndex[nodeId] ] = self:Serialize(x, y, z, timestamp, version, globalX, globalY, flags)
								Harvest.AddToErrorLog("node was merged:" .. map .. node )
								valid = false -- set this to false, so the node isn't added to the cache
								break
							end
						end
					end
				end
				
			end
			-- remove close nodes (ie duplicates on cities)
			if valid then
				-- compare distance to previous nodes
				for nodeId = startIndex, cache.lastNodeId do
					globalX2 = cache.globalX[nodeId]
					globalY2 = cache.globalY[nodeId]

					dx = globalX - globalX2
					dy = globalY - globalY2
					-- the nodes are too close
					if dx * dx + dy * dy < distance then
						x, y, z, timestamp, version, globalX, globalY = cache:Merge(nodeId, x, y, z, timestamp, version, globalX, globalY, flags, isDatabase)
						-- update the old node
						serializedNodes[cache.nodeIndex[nodeId] ] = self:Serialize(x, y, z, timestamp, version, globalX, globalY, flags)
						Harvest.AddToErrorLog("node was merged:" .. map .. node )
						valid = false -- set this to false, so the node isn't added to the cache
						break
					end
				end
			end
			
			if valid then
				cache:Add(pinTypeId, nodeIndex, x, y, z, timestamp, version, globalX, globalY, flags, isDatabase)
				if updated then
					serializedNodes[nodeIndex] = self:Serialize(x, y, z, timestamp, version, globalX, globalY, flags)
				end
			else
				serializedNodes[nodeIndex] = nil
			end
		end
	end
end

-- loads the nodes to cache and returns them
function Data:GetMapCache(pinTypeId, map, measurement, zoneIndex, forceZoneIndex)
	if (not map) or (not measurement) or (not zoneIndex) then
		Harvest.Debug("map, measurement or zoneId missing")
		return
	end
	
	if not Harvest.IsUpdateQueueEmpty() then return end
	-- if the current map isn't in the cache, create the cache
	if not self.mapCaches[map] then
		if not measurement or not zoneIndex then return end
		
		local cache = Data.MapCache:New(map, measurement, zoneIndex)
		
		self.mapCaches[map] = cache
		self.numCaches = self.numCaches + 1
		
		local oldest = cache
		local oldestMap
		for i = 1, self.numCaches - Harvest.GetMaxCachedMaps() do
			for map, cache in pairs(self.mapCaches) do
				if cache.time < oldest.time and cache.accessed == 0 then
					oldest = cache
					oldestMap = map
				end
			end
			
			if not oldestMap then break end
			
			Harvest.Debug("Clear cache for map " .. oldestMap)
			self.mapCaches[oldestMap] = nil
			oldest = cache
			self.numCaches = self.numCaches - 1
		end
		
		-- fill the newly created cache with data
		for _, pinTypeId in ipairs(Harvest.PINTYPES) do
			if Harvest.IsPinTypeVisible(pinTypeId) then
				self:LoadToCache(pinTypeId, cache)
			end
		end
		
		if self.currentZoneCache and zoneIndex == self.currentZoneCache.zoneIndex then
			self.currentZoneCache:AddCache(cache)
			CallbackManager:FireCallbacks(Events.MAP_ADDED_TO_ZONE, cache, self.currentZoneCache)
		end
		
		return cache
	end
	local cache = self.mapCaches[map]
	-- if there was a pin type given, make sure the given pin type is in the cache
	if pinTypeId then
		self:CheckPinTypeInCache(pinTypeId, cache)
	else
		for _, pinTypeId in ipairs(Harvest.PINTYPES) do
			if Harvest.IsPinTypeVisible(pinTypeId) then
				self:CheckPinTypeInCache(pinTypeId, cache)
			end
		end
	end
	
	if forceZoneIndex then
		cache.zoneIndex = zoneIndex
		if self.currentZoneCache and zoneIndex == self.currentZoneCache.zoneIndex then
			self.currentZoneCache:AddCache(cache)
			CallbackManager:FireCallbacks(Events.MAP_ADDED_TO_ZONE, cache, self.currentZoneCache)
		end
	end

	return cache
end

function Data:GetCurrentZoneCache()
	return self.currentZoneCache
end

function Data:OnPlayerActivated()
	local zoneIndex = GetUnitZoneIndex("player")
	if not self.currentZoneCache or self.currentZoneCache.zoneIndex ~= zoneIndex then
		if self.currentZoneCache then
			self.currentZoneCache:Dispose()
		end
		
		self.currentZoneCache = self.ZoneCache:New(zoneIndex)
		for map, mapCache in pairs(self.mapCaches) do
			if mapCache.zoneIndex == zoneIndex then
				self.currentZoneCache:AddCache(mapCache)
			end
		end
		
		local map, x, y, measurement = Harvest.GetLocation()
		
		if not self.currentZoneCache:HasMapCache() then
			Data:GetMapCache(nil, map, measurement, zoneIndex, true)
		end
		
		CallbackManager:FireCallbacks(Events.NEW_ZONE_ENTERED, self.currentZoneCache, measurement.distanceCorrection)
		
	end
end

function Data:CheckPinTypeInCache(pinTypeId, mapCache)
	if not mapCache.nodesOfPinType[pinTypeId] then
		self:LoadToCache(pinTypeId, mapCache)
	end
end
