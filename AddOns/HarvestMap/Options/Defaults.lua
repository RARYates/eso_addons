
Harvest = Harvest or {}
Harvest.settings = Harvest.settings or {}
local Settings = Harvest.settings

Settings.defaultGlobalSettings = {
	maxTimeDifference = 0,
	minGameVersion = 0,
	errorlog = {start = 1, last = 0},
	measurements = {},
}

Settings.availableTextures = {
	[Harvest.BLACKSMITH]  = { "HarvestMap/Textures/Map/mining.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.CLOTHING]    = { "HarvestMap/Textures/Map/clothing.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.ENCHANTING]  = { "HarvestMap/Textures/Map/enchanting.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.MUSHROOM]    = { "HarvestMap/Textures/Map/mushroom.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.FLOWER]      = { "HarvestMap/Textures/Map/flower.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.WATERPLANT]  = { "HarvestMap/Textures/Map/waterplant.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.WOODWORKING] = { "HarvestMap/Textures/Map/wood.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.CHESTS]      = { "HarvestMap/Textures/Map/chest.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.WATER]       = { "HarvestMap/Textures/Map/solvent.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.FISHING]     = { "HarvestMap/Textures/Map/fish.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.HEAVYSACK]   = { "HarvestMap/Textures/Map/heavysack.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.TROVE]       = { "HarvestMap/Textures/Map/trove.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.JUSTICE]     = { "HarvestMap/Textures/Map/justice.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.STASH]       = { "HarvestMap/Textures/Map/stash.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.TOUR]        = { "HarvestMap/Textures/Map/tour.dds", "HarvestMap/Textures/Map/circle.dds", "HarvestMap/Textures/Map/diamond.dds", },
	[Harvest.GetPinType( "Debug" )] = {""},
}

Settings.defaultSettings = {
	-- which pins are displayed on the map/compass
	isPinTypeVisible = {
		[Harvest.BLACKSMITH]  = true,
		[Harvest.CLOTHING]    = true,
		[Harvest.ENCHANTING]  = true,
		[Harvest.MUSHROOM]    = true,
		[Harvest.FLOWER]      = true,
		[Harvest.WATERPLANT]  = true,
		[Harvest.WOODWORKING] = true,
		[Harvest.CHESTS]      = true,
		[Harvest.WATER]       = true,
		[Harvest.FISHING]     = false,
		[Harvest.HEAVYSACK]   = true,
		[Harvest.TROVE]       = true,
		[Harvest.JUSTICE]     = true,
		[Harvest.STASH]       = true,
		[Harvest.TOUR]        = true,
		[Harvest.GetPinType( "Debug" )] = false
	},
	
	isWorldFilterActive = false,
	isWorldPinTypeVisible = {
		[Harvest.BLACKSMITH]  = false,
		[Harvest.CLOTHING]    = false,
		[Harvest.ENCHANTING]  = false,
		[Harvest.MUSHROOM]    = false,
		[Harvest.FLOWER]      = false,
		[Harvest.WATERPLANT]  = false,
		[Harvest.WOODWORKING] = false,
		[Harvest.CHESTS]      = false,
		[Harvest.WATER]       = false,
		[Harvest.FISHING]     = false,
		[Harvest.HEAVYSACK]   = false,
		[Harvest.TROVE]       = false,
		[Harvest.JUSTICE]     = false,
		[Harvest.STASH]       = false,
		[Harvest.TOUR]        = false,
		[Harvest.GetPinType( "Debug" )] = false
	},
	
	isCompassFilterActive = false,
	isCompassPinTypeVisible = {
		[Harvest.BLACKSMITH]  = false,
		[Harvest.CLOTHING]    = false,
		[Harvest.ENCHANTING]  = false,
		[Harvest.MUSHROOM]    = false,
		[Harvest.FLOWER]      = false,
		[Harvest.WATERPLANT]  = false,
		[Harvest.WOODWORKING] = false,
		[Harvest.CHESTS]      = false,
		[Harvest.WATER]       = false,
		[Harvest.FISHING]     = false,
		[Harvest.HEAVYSACK]   = false,
		[Harvest.TROVE]       = false,
		[Harvest.JUSTICE]     = false,
		[Harvest.STASH]       = false,
		[Harvest.TOUR]        = false,
		[Harvest.GetPinType( "Debug" )] = false
	},
	-- which pin types are skipped when gathered
	isPinTypeSavedOnGather = {
		[Harvest.BLACKSMITH]     = true,
		[Harvest.CLOTHING]       = true,
		[Harvest.ENCHANTING]     = true,
		[Harvest.MUSHROOM]       = true,
		[Harvest.FLOWER]         = true,
		[Harvest.WATERPLANT]     = true,
		[Harvest.WOODWORKING]    = true,
		[Harvest.CHESTS]         = true,
		[Harvest.WATER]          = true,
		[Harvest.FISHING]        = true,
		[Harvest.HEAVYSACK]      = true,
		[Harvest.TROVE]          = true,
		[Harvest.JUSTICE]        = true,
		[Harvest.STASH]          = true,
	},

	pinLayouts = {
		[Harvest.BLACKSMITH]  = { texture = "HarvestMap/Textures/Map/mining.dds", size = 20, tint = ZO_ColorDef:New(0.447, 0.49, 1, 1) },
		[Harvest.CLOTHING]    = { texture = "HarvestMap/Textures/Map/clothing.dds", size = 20, tint = ZO_ColorDef:New(0.588, 0.988, 1, 1) },
		[Harvest.ENCHANTING]  = { texture = "HarvestMap/Textures/Map/enchanting.dds", size = 20, tint = ZO_ColorDef:New(1, 0.455, 0.478, 1) },
		[Harvest.MUSHROOM]    = { texture = "HarvestMap/Textures/Map/mushroom.dds", size = 20, tint = ZO_ColorDef:New(0.451, 0.569, 0.424, 1) },
		[Harvest.FLOWER]   	  = { texture = "HarvestMap/Textures/Map/flower.dds", size = 20, tint = ZO_ColorDef:New(0.557, 1, 0.541, 1) },
		[Harvest.WATERPLANT]  = { texture = "HarvestMap/Textures/Map/waterplant.dds", size = 20, tint = ZO_ColorDef:New(0.439, 0.937, 0.808, 1) },
		[Harvest.WOODWORKING] = { texture = "HarvestMap/Textures/Map/wood.dds", size = 20, tint = ZO_ColorDef:New(1, 0.694, 0.494, 1) },
		[Harvest.CHESTS]      = { texture = "HarvestMap/Textures/Map/chest.dds", size = 20, tint = ZO_ColorDef:New(1, 0.937, 0.38, 1) },
		[Harvest.WATER]       = { texture = "HarvestMap/Textures/Map/solvent.dds", size = 20, tint = ZO_ColorDef:New(0.569, 0.827, 1, 1) },
		[Harvest.FISHING]     = { texture = "HarvestMap/Textures/Map/fish.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1, 1) },
		[Harvest.HEAVYSACK]   = { texture = "HarvestMap/Textures/Map/heavysack.dds", size = 20, tint = ZO_ColorDef:New(0.424, 0.69, .36, 1) },
		[Harvest.TROVE]       = { texture = "HarvestMap/Textures/Map/trove.dds", size = 20, tint = ZO_ColorDef:New(0.780, 0.404, 1, 1) },
		[Harvest.JUSTICE]     = { texture = "HarvestMap/Textures/Map/justice.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1, 1) },
		[Harvest.STASH]       = { texture = "HarvestMap/Textures/Map/stash.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1, 1) },
		[Harvest.TOUR]        = { texture = "HarvestMap/Textures/Map/tour.dds", size = 32, tint = ZO_ColorDef:New(1, 0, 0, 1) },
	},

	displayCompassPins = true,
	displayWorldPins = true,
	showDebugOutput = false,
	rangeMuliplier = 1,
	hiddenTime = 0,
	hiddenOnHarvest = false,
	maxVisibleDistance = 0.02,
	hasMaxVisibleDistance = false,
	displaySpeed = 500,
	delayWhenInFight = true,
	delayUntilMapOpen = false,
	
	compassDistance = 0.004062019202318,
	worldDistance = 0.004062019202318,
	worldPinDepth = true,
	worldPinHeight = 200,
	worldPinWidth = 100,
	minimapPinSize = 20,
	pinsAbovePoi = false,
}

Settings.defaultAccountSettings = {
	accountWideSettings = false,
}

for key, value in pairs(Settings.defaultSettings) do
	Settings.defaultAccountSettings[key] = value
end
