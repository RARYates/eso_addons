
if not Harvest.Data then
	Harvest.Data = {}
end

-- This file handles updates of the serialized data. eg when something changes in the saveFile structure.
-- for instance after the DB update all itemIds for enchanting runes were removed.

local Harvest = _G["Harvest"]
local Data = Harvest.Data

-- updating the data can take quite some time
-- to prevent the game from freezing, we break each update process down into smaller parts
-- the smaller parts are executed with a small delay (see Harvest.OnUpdate(time) )
-- updating data as well as other heavy tasks such as importing data are added to the following queue
Harvest.updateQueue = {}
Harvest.updateQueue.first = 1
Harvest.updateQueue.afterLast = 1
function Harvest.IsUpdateQueueEmpty()
	return (Harvest.updateQueue.first == Harvest.updateQueue.afterLast)
end
-- adds a function to the back of the queue
function Harvest.AddToUpdateQueue(fun)
	Harvest.updateQueue[Harvest.updateQueue.afterLast] = fun
	Harvest.updateQueue.afterLast = Harvest.updateQueue.afterLast + 1
end
-- adds a funciton to the front of the queue
function Harvest.AddToFrontOfUpdateQueue(fun)
	Harvest.updateQueue.first = Harvest.updateQueue.first - 1
	Harvest.updateQueue[Harvest.updateQueue.first] = fun
end
-- executes the first function in the queue, if the player is activated yet
do
	local IsPlayerActivated = _G["IsPlayerActivated"]

	function Harvest.UpdateUpdateQueue() --shitty function name is shitty
		if not IsPlayerActivated() then return end
		
		local start = GetGameTimeMilliseconds()
		
		while GetGameTimeMilliseconds() - start < 1000 / 60 do
			local fun = Harvest.updateQueue[Harvest.updateQueue.first]
			Harvest.updateQueue[Harvest.updateQueue.first] = nil
			Harvest.updateQueue.first = Harvest.updateQueue.first + 1
			
			fun()

			if Harvest.IsUpdateQueueEmpty() then
				Harvest.updateQueue.first = 1
				Harvest.updateQueue.afterLast = 1
				Harvest.RefreshPins()
				return
			end
		end
	end
end

function Harvest.GetQueuePercent()
	return zo_floor((Harvest.updateQueue.first/Harvest.updateQueue.afterLast)*100)
end

------------------------
--#################################################
------------------------

local function UpdateNodeStructure()
	local accountWide, default
	local didImport
	local success, x, y, z, items, timestamp, version, globalX, globalY, flags
	for subModuleName, subModule in pairs(Data.subModules) do
		local saveFile = _G[subModule.savedVarsName]
		if saveFile then
			default = saveFile["Default"]
			if default then
				for accountName, saveData in pairs(default) do
					accountWide = saveData["$AccountWide"]
					if accountWide then
						if accountWide.nodes and accountWide.nodes.data then
							for map, mapData in pairs(accountWide.nodes.data) do
								didImport = true
								Harvest.AddToUpdateQueue(function()
									for _, pinTypeId in pairs(Harvest.PINTYPES) do
										if mapData[pinTypeId] then
											for nodeIndex, serializedNode in pairs(mapData[pinTypeId]) do
												success, x, y, z, items, timestamp, version, globalX, globalY = Data:OldDeserialize( serializedNode, pinTypeId )
												if success then
													version = version % Harvest.trustedFlag
													mapData[pinTypeId][nodeIndex] = Data:Serialize(x, y, z, timestamp, version, globalX, globalY)
												else
													mapData[pinTypeId][nodeIndex] = nil
												end
											end
										end
									end
									Data:ImportFromMap( map, mapData, Data:GetSaveFile(map) )
								end)
							end
						end
					end
				end
				if didImport then
					Harvest.AddToUpdateQueue(function()
						d("HarvestMap is importing nodes...") 
						saveFile["Default"] = nil
					end)
				end
			end
		end
	end
	if didImport then
		Harvest.AddToUpdateQueue(function()
			Data:AddMissingFields()
			d("HarvestMap finished importing nodes for this savefile.")
		end)
	end
end

local function ClearOldData()
	-- remove all data which hasn't been updated since the housing update
	local saveFile, accountWide
	for subModuleName, subModule in pairs(Data.subModules) do
		saveFile = _G[subModuleName.savedVarsName]
		if saveFile then
			saveFile = saveFile["Default"]
			if saveFile then
				for accountName, saveData in pairs(saveFile) do
					accountWide = saveData["$AccountWide"]
					if accountWide.nodes then
						if accountWide.nodes.dataVersion or 0 < 16 then
							accountWide.nodes = nil
						end
					end
				end
			end
		end
	end
end

local function FixNFBug()
	if not HarvestNF_SavedVars then return end
	
	for map, mapData in pairs(HarvestNF_SavedVars.data) do
		local newFile = Data:GetSaveFile(map)
		if newFile ~= HarvestNF_SavedVars then
			Harvest.AddToUpdateQueue(function()
				Data:ImportFromMap( map, mapData, newFile )
				HarvestNF_SavedVars.data[map] = nil
			end)
		end
	end
end

-- check if saved data is from an older version,
-- update the data if needed
function Data:UpdateDataVersion( saveFile )
	assert(not saveFile) -- in case someone is still using the import/export tool
	-- remove very old data
	ClearOldData()
	-- restructure the save file
	UpdateNodeStructure()
	-- fix nodes which were moved to NF file
	FixNFBug()
end

