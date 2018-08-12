
if not Harvest.Data then
	Harvest.Data = {}
end

local Harvest = _G["Harvest"]
local Data = Harvest.Data

local tonumber = _G["tonumber"]
local assert = _G["assert"]
local gmatch = string.gmatch
local tostring = _G["tostring"]
local insert = table.insert
local format = string.format
local concat = table.concat

-- constants/enums for the node encoding format
Data.LOCAL_X = "1"
Data.LOCAL_Y = "2"
Data.WORLD_Z = "3"
Data.ITEMS = "4"
Data.TIME = "5"
Data.VERSION = "6"
Data.GLOBAL_X = "7"
Data.GLOBAL_Y = "8"

local function GetNumberValue(getNextChunk)
	local number
	local typ, data = getNextChunk()
	if typ == "^N" then
		number = tonumber(data)
	elseif typ == "^F" then
		local typ2, data2 = getNextChunk()
		assert(typ2 == "^f")
		local mantissa = tonumber(data)
		local exponent = tonumber(data2)
		number = mantissa * (2^exponent)
	end
	return number
end

-- loads the node represented by serializedData without creating a node table
local function OldDeserialize(serializedData, pinTypeId)
	local x, y, z, items, globalX, globalY, timestamp
	local version = 0
	
	local getNextChunk = gmatch(serializedData, "(^.)([^^]*)")
	assert(getNextChunk() == "^1") -- split the ^1 part
	assert(getNextChunk() == "^T") -- split the ^T part
	local i = 0
	for typ, data in getNextChunk do
		if typ == "^N" then
			if data == Data.LOCAL_X then
				x = GetNumberValue(getNextChunk)
			elseif data == Data.LOCAL_Y then
				y = GetNumberValue(getNextChunk)
			elseif data == Data.WORLD_Z then
				z = GetNumberValue(getNextChunk)
				if z == 0 then z = nil end -- harvest merge sets unknown z values to 0
			elseif data == Data.ITEMS then
				assert(getNextChunk() == "^T",serializedData) -- split the ^T part
				if Harvest.ShouldSaveItemId(pinTypeId) then
					items = {}
					local itemId, stamp
					typ, data = getNextChunk()
					while typ == "^N" do -- while the table isn't over
						itemId = tonumber(data)
						typ, data = getNextChunk()
						assert(typ == "^N", serializedData)
						stamp = tonumber(data)
						items[itemId] = stamp
						typ, data = getNextChunk()
						i = i + 1
					end
					assert(typ == "^t",serializedData)
				else
					for typ in getNextChunk do
						if typ == "^t" then break end
					end
				end
			elseif data == Data.TIME then
				typ, data = getNextChunk()
				assert(typ == "^N",serializedData)
				timestamp = tonumber(data)
				if timestamp == 0 then timestamp = nil end -- harvest merge sets unknown values to 0
			elseif data == Data.VERSION then
				typ, data = getNextChunk()
				assert(typ == "^N",serializedData)
				version = tonumber(data)
			elseif data == Data.GLOBAL_X then
				globalX = GetNumberValue(getNextChunk)
				if globalX == 0 then globalX = nil end -- harvest merge sets unknown values to 0
			elseif data == Data.GLOBAL_Y then
				globalY = GetNumberValue(getNextChunk)
				if globalY == 0 then globalY = nil end -- harvest merge sets unknown values to 0
			end
		end
		i = i + 1
		if i > 30 then error(serializedData) end
	end
	assert(x)
	assert(y)
	--assert(globalX)
	--assert(globalY)
	assert(timestamp)
	return x, y, z, items, timestamp, version, globalX, globalY
end

function Data:OldDeserialize(serializedData, pinTypeId)
	return pcall(OldDeserialize, serializedData, pinTypeId)
end

function Data:OldSerialize(x, y, z, items, timestamp, version, globalX, globalY)
	local parts = {}
	insert(parts, "^1^T^N1^N")
	insert(parts, format("%.4f", x))
	insert(parts, "^N2^N")
	insert(parts, format("%.4f", y))
	if z then
		insert(parts, "^N3^N")
		insert(parts, format("%.1f", z))
	end
	if items then
		insert(parts, "^N4^T")
		for itemId, stamp in pairs(items) do
			insert(parts, "^N")
			insert(parts, tostring(itemId))
			insert(parts, "^N")
			insert(parts, tostring(stamp))
		end
		insert(parts, "^t")
	end
	insert(parts, "^N5^N")
	insert(parts, tostring(timestamp or 0))
	insert(parts, "^N6^N")
	insert(parts, tostring(version or 0))
	-- global coords
	if globalX and globalY then
		insert(parts, "^N7^N")
		insert(parts, format("%.7f", globalX))
		insert(parts, "^N8^N")
		insert(parts, format("%.7f", globalY))
	end
	insert(parts, "^t^^")
	return concat(parts)
end

local function Deserialize(serializedData, pinTypeId)
	local x, y, z, globalX, globalY, timestamp, version, flags
	
	local getNextChunk = gmatch(serializedData, "(-?%d*%.?%d*),?")
	
	x = tonumber(getNextChunk()) or 0
	y = tonumber(getNextChunk()) or 0
	z = tonumber(getNextChunk()) or 0
	timestamp = tonumber(getNextChunk()) or 0
	version = tonumber(getNextChunk()) or 0
	globalX = tonumber(getNextChunk()) or 0
	globalY = tonumber(getNextChunk()) or 0
	flags = tonumber(getNextChunk()) or 0
	
	if (x == 0) then return false, "invalid x " .. serializedData end
	if (y == 0) then return false, "invalid y " .. serializedData end
	--if (z == 0) then return false, "invalid z " .. serializedData end
	if z == 0 then z = nil end
	--if (timestamp == 0) then return false, "invalid time " .. serializedData end
	--if (version == 0) then return false, "invalid version " .. serializedData end
	--if timestamp > 1512767392 then -- new nodes require global coords
	--	if (globalX == 0) then return false, "invalid globalx " .. serializedData end
	--	if (globalZ == 0) then return false, "invalid globaly " .. serializedData end
	--end
	if globalX == 0 then globalX = nil end
	if globalY == 0 then globalY = nil end
	
	return true, x, y, z, timestamp, version, globalX, globalY, flags
end

function Data:Deserialize(serializedData, pinTypeId)
	return Deserialize(serializedData, pinTypeId)
end

function Data:Serialize(x, y, z, timestamp, version, globalX, globalY, flags)
	local parts = {}
	insert(parts, format("%.4f", x or 0))
	insert(parts, format("%.4f", y or 0))
	insert(parts, format("%.1f", z or 0))
	
	insert(parts, tostring(timestamp or 0))
	insert(parts, tostring(version or 0))
	
	insert(parts, format("%.7f", globalX or 0))
	insert(parts, format("%.7f", globalY or 0))
	
	insert(parts, tostring(flags or 0))
	
	return concat(parts, ",")
end
