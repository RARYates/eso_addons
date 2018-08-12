
Harvest = Harvest or {}

local Harvest = _G["Harvest"]
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events
local GPS = LibStub("LibGPS2")
local Lib3D = LibStub("Lib3D2")

-- local references for global functions to improve the performance
-- of the functions called every frame
local GetMapPlayerPosition = _G["GetMapPlayerPosition"]
local GetInteractionType = _G["GetInteractionType"]
local INTERACTION_HARVEST = _G["INTERACTION_HARVEST"]
local pairs = _G["pairs"]
local tostring = _G["tostring"]
local zo_floor = _G["zo_floor"]

-- not just called by EVENT_LOOT_RECEIVED but also by Harvest.OnLootUpdated
function Harvest.OnLootReceived( eventCode, receivedBy, objectName, stackCount, soundCategory, lootType, lootedBySelf )
	-- don't touch the save files/tables while they are still being updated/refactored
	if not Harvest.IsUpdateQueueEmpty() then
		Harvest.Debug( "OnLootReceived failed: HarvestMap is updating" )
		return
	end

	if not lootedBySelf then
		Harvest.Debug( "OnLootReceived failed: wasn't looted by self" )
		return
	end
	
	local map, x, y, measurement, zoneIndex = Harvest.GetLocation()
	
	Harvest.farm.helper:GainedItem(objectName, stackCount)
	
	local isHeist = false
	-- only save something if we were harvesting or the target is a heavy sack, thieves trove or stash
	if (not Harvest.wasHarvesting) and (not Harvest.IsHeavySack( Harvest.lastInteractableName )) and (not Harvest.IsTrove( Harvest.lastInteractableName )) and not Harvest.IsStash( Harvest.lastInteractableName ) then
		-- additional check for heist containers
		if not (lootType == LOOT_TYPE_QUEST_ITEM) or not Harvest.GetBaseHeistMap(map) then
			Harvest.Debug( "OnLootReceived failed: wasn't harvesting" )
			Harvest.Debug( "OnLootReceived failed: wasn't heist quest item" )
			Harvest.Debug( "Interactable name is:" .. tostring(Harvest.lastInteractableName))
			return
		else
			isHeist = true
		end
	end
	
	-- get the information we want to save
	local itemName, itemId
	local pinTypeId = nil
	if not isHeist then
		itemName, _, _, itemId = ZO_LinkHandler_ParseLink( objectName )
		itemId = tonumber(itemId)
		if itemId == nil then
			-- wait what? does this even happen?! abort mission!
			Harvest.Debug( "OnLootReceived failed: item id is nil" )
			return
		end
		-- get the pin type depending on the item we looted and the name of the harvest node
		-- eg jute will be saved as a clothing pin
		pinTypeId = Harvest.GetPinTypeId(itemId, Harvest.lastInteractableName)
		-- sometimes we can't get the pin type based on the itemId and node name
		-- ie some data in the localization is missing and nirncrux can be found in ore and wood
		-- abort if we couldn't find the correct pin type
		if pinTypeId == nil then
			Harvest.Debug( "OnLootReceived failed: pin type id is nil" )
			return
		end
		-- if this pin type is supposed to be saved
		if not Harvest.IsPinTypeSavedOnGather( pinTypeId ) then
			Harvest.Debug( "OnLootReceived failed: pin type is disabled in the options" )
			return
		end
	else
		pinTypeId = Harvest.JUSTICE
	end
	
	local _, z, _ = Harvest.Get3DPosition()
	
	Harvest.Data:SaveNode( map, x, y, z, measurement, zoneIndex, pinTypeId )
	Harvest.Debug( "Data was saved, set harvesting state to false" )
	-- tell the farming helper we harvested something, so it can update the statistics
	Harvest.farm.helper:FarmedANode(objectName, stackCount)
	
	Harvest.wasHarvesting = false
	
	-- reset the interactable name variable
	-- otherwise looting a container item after opening heavy sacks, thieves troves, stashes etc can cause wrong pins
	if pinTypeId == Harvest.HEAVYSACK or pinTypeId == Harvest.TROVE or pinTypeId == Harvest.STASH then
		Harvest.lastInteractableName = ""
	end
end

-- neded for those players that play without auto loot
function Harvest.OnLootUpdated()
	-- only save something if we were harvesting or the target is a heavy sack or thieves trove
	if (not Harvest.wasHarvesting) and (not Harvest.IsHeavySack( Harvest.lastInteractableName )) and (not Harvest.IsTrove( Harvest.lastInteractableName )) and not Harvest.IsStash( Harvest.lastInteractableName ) then
		Harvest.Debug( "OnLootUpdated failed: wasn't harvesting" )
		return
	end

	-- i usually play with auto loot on
	-- everything was programmed with auto loot in mind
	-- if auto loot is disabled (ie OnLootUpdated is called)
	-- let harvestmap believe auto loot is enabled by calling
	-- OnLootReceived for each item in the loot window
	local items = GetNumLootItems()
	Harvest.Debug( "HarvestMap will check " .. tostring(items) .. " items." )
	for lootIndex = 1, items do
		local lootId, _, _, count = GetLootItemInfo( lootIndex )
		Harvest.OnLootReceived( nil, nil, GetLootItemLink( lootId, LINK_STYLE_DEFAULT ), count, nil, nil, true )
		if not Harvest.wasHarvesting then
			break
		end
	end

	-- when looting something, we have definitely finished the harvesting process
	if Harvest.wasHarvesting then
		Harvest.Debug( "All loot was handled. Set harvesting state to false." )
		Harvest.wasHarvesting = false
	end
end

-- refreshes the pins of the given pin type
-- if no pinType is given, all pins are refreshed
function Harvest.RefreshPins( pinTypeId )
	Harvest.mapPins:RefreshPins( pinTypeId )
	Harvest.InRangePins:RefreshCustomPins( pinTypeId )
	--Harvest.compassPins:RefreshPins( pinTypeId )
end

-- simple helper function which checks if a value is inside the table
-- does lua really not have a default function for this?
function Harvest.contains( table, value)
	for index, element in pairs(table) do
		if element == value then
			return index
		end
	end
	return false
end

function Harvest.OnUpdate(timeInMs)

	-- update the update queue (importing/refactoring data)
	if not Harvest.IsUpdateQueueEmpty() then
		Harvest.UpdateUpdateQueue()
		return
	end

	local interactionType = GetInteractionType()
	local isHarvesting = (interactionType == INTERACTION_HARVEST)

	-- update the harvesting state. check if the character was harvesting something during the last two seconds
	if not isHarvesting then
		if Harvest.wasHarvesting and timeInMs - Harvest.harvestTime > 2000 then
			Harvest.Debug( "Two seconds since last harvesting action passed. Set harvesting state to false." )
			Harvest.wasHarvesting = false
		end
	else
		
		if not Harvest.wasHarvesting then
			Harvest.Debug( "Started harvesting. Set harvesting state to true." )
		end
		Harvest.wasHarvesting = true
		Harvest.harvestTime = timeInMs
	end

	-- the character started a new interaction
	if interactionType ~= Harvest.lastInteractType then
		Harvest.lastInteractType = interactionType
		-- the character started picking a lock
		if interactionType == INTERACTION_LOCKPICK then
			local z
			if IsInteractionUsingInteractCamera() then
				z = Harvest.GetCameraHeight()
			end
			-- if the interactable is owned by an NPC but the action isn't called "Steal From"
			-- then it wasn't a safebox but a simple door: don't place a chest pin
			if Harvest.lastInteractableOwned and Harvest.lastInteractableAction ~= GetString(SI_GAMECAMERAACTIONTYPE20) then
				Harvest.Debug( "not a chest or justice container(?)" )
				return
			end
			local map, x, y, measurement, zoneIndex = Harvest.GetLocation()
			-- normal chests aren't owned and their interaction is called "unlock"
			-- other types of chests (ie for heists) aren't owned but their interaction is "search"
			-- safeboxes are owned
			if (not Harvest.lastInteractableOwned) and Harvest.lastInteractableAction == GetString(SI_GAMECAMERAACTIONTYPE12) then
				-- normal chest
				if not Harvest.IsPinTypeSavedOnGather( Harvest.CHESTS ) then
					Harvest.Debug( "chests are disabled" )
					return
				end
				Harvest.Data:SaveNode( map, x, y, z, measurement, zoneIndex, Harvest.CHESTS )
			elseif Harvest.lastInteractableOwned then
				-- heist chest or safebox
				if not Harvest.IsPinTypeSavedOnGather( Harvest.JUSTICE ) then
					Harvest.Debug( "justice containers are disabled" )
					return
				end
				Harvest.Data:SaveNode( map, x, y, z, measurement, zoneIndex, Harvest.JUSTICE )
			end
		end
		-- the character started fishing
		if interactionType == INTERACTION_FISH then
			-- don't create new pin if fishing pins are disabled
			if not Harvest.IsPinTypeSavedOnGather( Harvest.FISHING ) then
				Harvest.Debug( "fishing spots are disabled" )
				return
			end
			local _, z, _ = Harvest.Get3DPosition()
			local map, x, y, measurement, zoneIndex = Harvest.GetLocation()
			Harvest.Data:SaveNode( map, x, y, z, measurement, zoneIndex, Harvest.FISHING )
		end
	end
	
	if Harvest.HasPinVisibleDistance() then
		if Harvest.lastViewedUpdate < timeInMs - 5000 then
			local map = Harvest.GetMap()
			local x, y = GetMapPlayerPosition("player")
			Harvest.mapPins:AddAndRemoveVisblePins(map, x, y)
			Harvest.lastViewedUpdate = timeInMs
		end
	end
	
	if not FyrMM then
		Harvest.mapPins:PerformActions(true)
	end

	if Harvest.GetHiddenTime() > 0 then
		Harvest.UpdateHiddenTime( timeInMs )
	end
end

function Harvest.UpdateHiddenTime( timeInMs )
	if not Harvest.IsHiddenOnHarvest() then
		local cache = Harvest.Data:GetCurrentZoneCache()
		local x, y = GPS:LocalToGlobal( GetMapPlayerPosition( "player" ) )
		-- some maps don't work (ie aurbis)
		if x then
			for _, mapCache in pairs(cache.mapCaches) do
				mapCache:ForNearbyNodes(x, y, mapCache.SetHidden, true)
			end
		end
	end

	local hiddenTime = Harvest.GetHiddenTime() * 60000
	for map, cache in pairs(Harvest.Data.mapCaches) do
		for nodeId, time in pairs(cache.hiddenTime) do
			if timeInMs - time > hiddenTime then
				cache:SetHidden( nodeId, false )
			end
		end
	end
end

-- this hack saves the name of the object that was last interacted with
local oldInteract = FISHING_MANAGER.StartInteraction
FISHING_MANAGER.StartInteraction = function(...)
	local action, name, blockedNode, isOwned = GetGameCameraInteractableActionInfo()
	Harvest.lastInteractableAction = action
	Harvest.lastInteractableName = name
	Harvest.lastInteractableOwned = isOwned
	
	return oldInteract(...)
end

-- returns hours since 1970
function Harvest.GetCurrentTimestamp()
	return GetTimeStamp()--zo_floor(GetTimeStamp() / 3600)
end

function Harvest.GetCurrentItemTimestamp()
	return zo_floor(GetTimeStamp() / 3600)
end

function Harvest.OnLoad(eventCode, addOnName)
	
	Harvest.Data:CheckSubModule(addOnName)

	if addOnName ~= "HarvestMap" then
		return
	end
	
	Harvest.CheckFolderStructure()
	
	-- initialize temporary variables
	Harvest.wasHarvesting = false
	Harvest.action = nil
	Harvest.lastViewedUpdate = 0
	Harvest.interactPosition = {}
	
	Harvest.settings:Initialize()
	
	-- initialize the data/caching system
	Harvest.Data:Initialize()
	-- initialize pin callback functions
	Harvest.mapPinClickHandler:Initialize()
	Harvest.mapPins:Initialize()
	--Harvest.InitializeCompassMarkers()
	Harvest.InRangePins:Initialize()
	
	-- main menu
	Harvest.menu:Initialize()
	Harvest.filters:Initialize()
	Harvest.farm:Initialize()
	Harvest.menu:Finalize()
	
	-- initialize bonus features
	if Harvest.IsHeatmapActive() then
		HarvestHeat.Initialize()
	end

	EVENT_MANAGER:RegisterForUpdate("HarvestMap", 200, Harvest.OnUpdate)
	-- add these callbacks only after the addon has loaded to fix SnowmanDK's bug (comment section 20.12.15)
	EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_RECEIVED, Harvest.OnLootReceived)
	EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_UPDATED, Harvest.OnLootUpdated)
	
end

-- initialization which is dependant on other addons is done on EVENT_PLAYER_ACTIVATED
-- because harvestmap might've been loaded before them
function Harvest.OnActivated()
	Harvest.farm:PostInitialize()
	EVENT_MANAGER:UnregisterForEvent("HarvestMap", EVENT_PLAYER_ACTIVATED, Harvest.OnActivated)
end

EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_ADD_ON_LOADED, Harvest.OnLoad)
EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_PLAYER_ACTIVATED, Harvest.OnActivated)
