
Harvest = Harvest or {}

-- constants/enums for the pin types
Harvest.BLACKSMITH = 1
Harvest.CLOTHING = 2
Harvest.ENCHANTING = 3
Harvest.MUSHROOM = 4 -- used to be alchemy
Harvest.WOODWORKING = 5
Harvest.CHESTS = 6
Harvest.WATER = 7
Harvest.FISHING = 8
Harvest.HEAVYSACK = 9
Harvest.TROVE = 10
Harvest.JUSTICE = 11
Harvest.STASH = 12 -- loose panels etc
Harvest.FLOWER = 13
Harvest.WATERPLANT = 14

Harvest.TOUR = 100 -- pin which displays the next resource of the farming tour

-- order in which pins are displayed in the filters etc
Harvest.PINTYPES = {
	Harvest.BLACKSMITH, Harvest.CLOTHING,
	Harvest.WOODWORKING, Harvest.ENCHANTING,
	Harvest.MUSHROOM, Harvest.FLOWER,
	Harvest.WATERPLANT, Harvest.WATER,
	Harvest.CHESTS, Harvest.HEAVYSACK,
	Harvest.TROVE, Harvest.JUSTICE, Harvest.STASH,
	Harvest.FISHING,
	Harvest.TOUR
}

local pinTypeMultiplier = {
	[Harvest.FISHING] = 5
}

function Harvest.GetPinTypeDistanceMultiplier(pinTypeId)
	return 1--pinTypeMultiplier[pinTypeId] or 1
end

-- this function returns the pinTypeId for the given item id and node name
function Harvest.GetPinTypeId( itemId, nodeName )
	-- get two pin types based on the item id and node name
	local itemIdPinType = Harvest.itemId2PinType[ itemId ]
	Harvest.Debug( "Item id " .. tostring(itemId) .. " returns pin type " .. tostring(itemIdPinType))
	-- heavy sacks can contain material for different professions
	-- so don't use the item id to determine the pin type
	if Harvest.IsHeavySack( nodeName ) then
		return Harvest.HEAVYSACK
	end
	if Harvest.IsTrove( nodeName ) then
		return Harvest.TROVE
	end
	if Harvest.IsStash( nodeName ) then
		return Harvest.STASH
	end
	-- both returned the same pin type (or both are unknown/nil)
	return itemIdPinType
end

local isNodeNameHeavySack = {
	["heavy sack"] = true,
	["heavy crate"] = true, -- special nodes in cold harbor
	["schwerer sack"] = true,
	["sac lourd"] = true,
	["Т�?жeлый мeшoк"] = true, -- russian
	["Тяжелый мешок"] = true, -- updated russian
	["тяжелый мешок"] = true, -- updated russian
}
function Harvest.IsHeavySack( nodeName )
	return isNodeNameHeavySack[ zo_strlower( nodeName) ]
end

local isNodeNameTrove = {
	["thieves trove"] = true,
	["diebesgut"] = true,
	["trésor des voleurs"] = true,
	["Вopoвcкoй тaйник"] = true,  -- russian
	["Воровской тайник"] = true, -- updated russian
	["воровской тайник"] = true, -- updated russian
}
function Harvest.IsTrove( nodeName )
	return isNodeNameTrove[ zo_strlower( nodeName) ]
end

local isNodeNameStash = {
	["loose panel"] = true,
	["loose tile"] = true,
	["loose stone"] = true,
	
	["panneau mobile"] = true,
	["tuile descellée"] = true,
	["pierre délogée"] = true,
	
	["lose tafel"] = true,
	["lose platte"] = true,
	["loser stein"] = true,
	-- russian
	["Податливая панель"] = true,
	-- loose tile is not translated in the ru.lang file of RuESO
	["Податливый камень"] = true,
}
function Harvest.IsStash( nodeName )
	return isNodeNameStash[ zo_strlower( nodeName) ]
end

-- HarvestMap uses pinTypeIds (numbers)
-- but zenimax's map pin API needs a string for each pin type
-- the following two functions convert between pinType string
-- and pinType Id
local pintypes = {} -- string creation is expensive, cache the result
for _, pinTypeId in ipairs(Harvest.PINTYPES) do
	pintypes[pinTypeId] = "HrvstPin" .. pinTypeId
end
function Harvest.GetPinType( pinTypeId )
	return pintypes[pinTypeId] or ("HrvstPin" .. pinTypeId)
end

function Harvest.GetPinId( pinType )
	pinType = string.gsub( pinType, "HrvstPin", "" )
	return tonumber( pinType )
end

local saveItemId = {
	[Harvest.MUSHROOM] = true,
	[Harvest.FLOWER] = true,
	[Harvest.WATERPLANT] = true,
}
function Harvest.ShouldSaveItemId(pinTypeId)
	-- given that we know the 3 groups, we no longer have to track this
	return false--saveItemId[pinTypeId]
end

Harvest.itemId2PinType = {
	[808] = Harvest.BLACKSMITH,
	[4482] = Harvest.BLACKSMITH,
	[4995] = Harvest.BLACKSMITH,
	[5820] = Harvest.BLACKSMITH,
	[23103] = Harvest.BLACKSMITH,
	[23104] = Harvest.BLACKSMITH,
	[23105] = Harvest.BLACKSMITH,
	[23133] = Harvest.BLACKSMITH,
	[23134] = Harvest.BLACKSMITH,
	[23135] = Harvest.BLACKSMITH,
	[71198] = Harvest.BLACKSMITH,
	[114889] = Harvest.BLACKSMITH, -- regulus

	[812] = Harvest.CLOTHING,
	[4464] = Harvest.CLOTHING,
	[23129] = Harvest.CLOTHING,
	[23130] = Harvest.CLOTHING,
	[23131] = Harvest.CLOTHING,
	[33217] = Harvest.CLOTHING,
	[33218] = Harvest.CLOTHING,
	[33219] = Harvest.CLOTHING,
	[33220] = Harvest.CLOTHING,
	[71200] = Harvest.CLOTHING,
	[114890] = Harvest.CLOTHING, -- bast

	[45806] = Harvest.ENCHANTING,
	[45807] = Harvest.ENCHANTING,
	[45808] = Harvest.ENCHANTING,
	[45809] = Harvest.ENCHANTING,
	[45810] = Harvest.ENCHANTING,
	[45811] = Harvest.ENCHANTING,
	[45812] = Harvest.ENCHANTING,
	[45813] = Harvest.ENCHANTING,
	[45814] = Harvest.ENCHANTING,
	[45815] = Harvest.ENCHANTING,
	[45816] = Harvest.ENCHANTING,
	[45817] = Harvest.ENCHANTING,
	[45818] = Harvest.ENCHANTING,
	[45819] = Harvest.ENCHANTING,
	[45820] = Harvest.ENCHANTING,
	[45821] = Harvest.ENCHANTING,
	[45822] = Harvest.ENCHANTING,
	[45823] = Harvest.ENCHANTING,
	[45824] = Harvest.ENCHANTING,
	[45825] = Harvest.ENCHANTING,
	[45826] = Harvest.ENCHANTING,
	[45827] = Harvest.ENCHANTING,
	[45828] = Harvest.ENCHANTING,
	[45829] = Harvest.ENCHANTING,
	[45830] = Harvest.ENCHANTING,
	[45831] = Harvest.ENCHANTING,
	[45832] = Harvest.ENCHANTING,
	[45833] = Harvest.ENCHANTING,
	[45834] = Harvest.ENCHANTING,
	[45835] = Harvest.ENCHANTING,
	[45836] = Harvest.ENCHANTING,
	[45837] = Harvest.ENCHANTING,
	[45838] = Harvest.ENCHANTING,
	[45839] = Harvest.ENCHANTING,
	[45840] = Harvest.ENCHANTING,
	[45841] = Harvest.ENCHANTING,
	[45842] = Harvest.ENCHANTING,
	[45843] = Harvest.ENCHANTING,
	[45844] = Harvest.ENCHANTING,
	[45845] = Harvest.ENCHANTING,
	[45846] = Harvest.ENCHANTING,
	[45847] = Harvest.ENCHANTING,
	[45848] = Harvest.ENCHANTING,
	[45849] = Harvest.ENCHANTING,
	[45850] = Harvest.ENCHANTING,
	[45851] = Harvest.ENCHANTING,
	[45852] = Harvest.ENCHANTING,
	[45853] = Harvest.ENCHANTING,
	[45854] = Harvest.ENCHANTING,
	[45855] = Harvest.ENCHANTING,
	[45856] = Harvest.ENCHANTING,
	[45857] = Harvest.ENCHANTING,
	[54248] = Harvest.ENCHANTING,
	[54253] = Harvest.ENCHANTING,
	[54289] = Harvest.ENCHANTING,
	[54294] = Harvest.ENCHANTING,
	[54297] = Harvest.ENCHANTING,
	[54299] = Harvest.ENCHANTING,
	[54306] = Harvest.ENCHANTING,
	[54330] = Harvest.ENCHANTING,
	[54331] = Harvest.ENCHANTING,
	[54342] = Harvest.ENCHANTING,
	[54373] = Harvest.ENCHANTING,
	[54374] = Harvest.ENCHANTING,
	[54375] = Harvest.ENCHANTING,
	[54481] = Harvest.ENCHANTING,
	[54482] = Harvest.ENCHANTING,
	[64509] = Harvest.ENCHANTING,
	[68341] = Harvest.ENCHANTING,
	[64508] = Harvest.ENCHANTING,
	[68340] = Harvest.ENCHANTING,
	[68342] = Harvest.ENCHANTING,
	[114892] = Harvest.ENCHANTING,

	[30148] = Harvest.MUSHROOM,
	[30149] = Harvest.MUSHROOM,
	[30151] = Harvest.MUSHROOM,
	[30152] = Harvest.MUSHROOM,
	[30153] = Harvest.MUSHROOM,
	[30154] = Harvest.MUSHROOM,
	[30155] = Harvest.MUSHROOM,
	[30156] = Harvest.MUSHROOM,
	[30157] = Harvest.FLOWER,
	[30158] = Harvest.FLOWER,
	[30159] = Harvest.FLOWER,
	[30160] = Harvest.FLOWER,
	[30161] = Harvest.FLOWER,
	[30162] = Harvest.FLOWER,
	[30163] = Harvest.FLOWER,
	[30164] = Harvest.FLOWER,
	[30165] = Harvest.WATERPLANT,
	[30166] = Harvest.WATERPLANT,
	[77590] = Harvest.FLOWER, -- Nightshade, added in DB

	[521] = Harvest.WOODWORKING,
	[802] = Harvest.WOODWORKING,
	[818] = Harvest.WOODWORKING,
	[4439] = Harvest.WOODWORKING,
	[23117] = Harvest.WOODWORKING,
	[23118] = Harvest.WOODWORKING,
	[23119] = Harvest.WOODWORKING,
	[23137] = Harvest.WOODWORKING,
	[23138] = Harvest.WOODWORKING,
	[71199] = Harvest.WOODWORKING,
	[114895] = Harvest.WOODWORKING,--heartwood

	[883] = Harvest.WATER,
	[1187] = Harvest.WATER,
	[4570] = Harvest.WATER,
	[23265] = Harvest.WATER,
	[23266] = Harvest.WATER,
	[23267] = Harvest.WATER,
	[23268] = Harvest.WATER,
	[64500] = Harvest.WATER,
	[64501] = Harvest.WATER
}
