
local LAM = LibStub("LibAddonMenu-2.0")

Harvest = Harvest or {}
Harvest.settings = Harvest.settings or {}
local Settings = Harvest.settings

local function CreateFilter( pinTypeId )
	local pinTypeId = pinTypeId
	local filter = {
		type = "checkbox",
		name = Harvest.GetLocalization( "pintype" .. pinTypeId ),
		tooltip = Harvest.GetLocalization( "pintypetooltip" .. pinTypeId ),
		getFunc = function()
			return Harvest.IsMapPinTypeVisible( pinTypeId )
		end,
		setFunc = function( value )
			Harvest.SetMapPinTypeVisible( pinTypeId, value )
		end,
		default = Harvest.settings.defaultSettings.isPinTypeVisible[ pinTypeId ],
	}
	return filter
end

local function CreateIconPicker( pinTypeId )
	local pinTypeId = pinTypeId
	local filter = {
		type = "iconpicker",
		name = Harvest.GetLocalization( "pintexture" ),
		--tooltip = Harvest.GetLocalization( "pintexturetooltip" .. pinTypeId ),
		getFunc = function()
			return Harvest.GetPinTypeTexture( pinTypeId )
		end,
		setFunc = function( value )
			Harvest.SetPinTypeTexture( pinTypeId, value )
		end,
		choices = Harvest.settings.availableTextures[pinTypeId],
		default = Harvest.settings.defaultSettings.pinLayouts[ pinTypeId ].texture,
	}
	return filter
end

local function CreateGatherFilter( pinTypeId )
	local pinTypeId = pinTypeId
	local gatherFilter = {
		type = "checkbox",
		name = zo_strformat( Harvest.GetLocalization( "savepin" ), Harvest.GetLocalization( "pintype" .. pinTypeId ) ),
		tooltip = Harvest.GetLocalization( "savetooltip" ),
		getFunc = function()
			return Harvest.IsPinTypeSavedOnGather( pinTypeId )
		end,
		setFunc = function( value )
			Harvest.SetPinTypeSavedOnGather( pinTypeId, value )
		end,
		default = Harvest.settings.defaultSettings.isPinTypeSavedOnGather[ pinTypeId ],
	}
	return gatherFilter
end

local function CreateSizeSlider( pinTypeId )
	local pinTypeId = pinTypeId
	local sizeSlider = {
		type = "slider",
		name = Harvest.GetLocalization( "pinsize" ),
		tooltip =  zo_strformat( Harvest.GetLocalization( "pinsizetooltip" ), Harvest.GetLocalization( "pintype" .. pinTypeId ) ),
		min = 16,
		max = 64,
		getFunc = function()
			return Harvest.GetMapPinSize( pinTypeId )
		end,
		setFunc = function( value )
			Harvest.SetMapPinSize( pinTypeId, value )
		end,
		default = Harvest.settings.defaultSettings.pinLayouts[ pinTypeId ].size,
		width = "half",
	}
	return sizeSlider
end

local function CreateColorPicker( pinTypeId )
	local pinTypeId = pinTypeId
	local colorPicker = {
		type = "colorpicker",
		name = Harvest.GetLocalization( "pincolor" ),
		tooltip = zo_strformat( Harvest.GetLocalization( "pincolortooltip" ), Harvest.GetLocalization( "pintype" .. pinTypeId ) ),
		getFunc = function() return Harvest.GetPinColor( pinTypeId ) end,
		setFunc = function( r, g, b ) Harvest.SetPinColor( pinTypeId, r, g, b ) end,
		default = Harvest.settings.defaultSettings.pinLayouts[ pinTypeId ].tint,
		width = "half",
	}
	return colorPicker
end

function Settings:InitializeLAM()
	-- first LAM stuff, at the end of this function we will also create
	-- a custom checkbox in the map's filter menu for the heat map
	local panelData = {
		type = "panel",
		name = "HarvestMap",
		displayName = ZO_HIGHLIGHT_TEXT:Colorize("HarvestMap"),
		author = Harvest.author,
		version = Harvest.displayVersion,
		registerForRefresh = true,
		registerForDefaults = true,
		website = "http://www.esoui.com/downloads/info57",
	}

	local optionsTable = setmetatable({}, { __index = table })

	optionsTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("esouidescription"),
		width = "full",
	})

	optionsTable:insert({
		type = "button",
		name = Harvest.GetLocalization("openesoui"),
		func = function() RequestOpenUnsafeURL("http://www.esoui.com/downloads/info57") end,
		width = "half",
	})
	
	optionsTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("exchangedescription"),
		width = "full",
	})
	
	--[[
	currently outdated :(
	optionsTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("mergedescription"),
		width = "full",
	})

	optionsTable:insert({
		type = "button",
		name = Harvest.GetLocalization("openmerge"),
		func = function() RequestOpenUnsafeURL("http://www.teso-harvest-merge.de") end,
		width = "half",
	})
	--]]
	
	optionsTable:insert({
		type = "header",
		name = "",
	})
	
	optionsTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("debuginfodescription"),
		width = "full",
	})
	
	optionsTable:insert({
		type = "button",
		name = Harvest.GetLocalization("printdebuginfo"),
		func = function() HarvestDebugClipboardOutputBox:SetText(Harvest.GenerateDebugInfo()) end,
		width = "half",
	})
	
	--[[
	optionsTable:insert({
		type = "header",
		name= Harvest.GetLocalization("outdateddata"),
	})
	
	optionsTable:insert({
		type = "button",
		name = Harvest.GetLocalization("apply"),
		func = Harvest.ApplyTimeDifference,
		width = "half",
		warning = Harvest.GetLocalization("applywarning")
	})
	--]]
	
	optionsTable:insert({
		type = "header",
		name = "",
	})
	
	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("outdateddata"),
		controls = submenuTable,
	})
	
	submenuTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("outdateddatainfo")
	})
	
	submenuTable:insert({
		type = "dropdown",
		name = Harvest.GetLocalization("mingameversion"),
		tooltip = Harvest.GetLocalization("mingameversiontooltip"),
		choices = Harvest.validGameVersionsDisplay,
		choicesValues = Harvest.validGameVersions,
		getFunc = Harvest.GetDisplayedMinGameVersion,
		setFunc = Harvest.SetDisplayedMinGameVersion,
		width = "half",
		--default = Harvest.settings.defaultSettings.minGameVersion,
	})
	
	submenuTable:insert({--optionsTable
		type = "slider",
		name = Harvest.GetLocalization("timedifference"),
		tooltip = Harvest.GetLocalization("timedifferencetooltip"),
		min = 0,
		max = 712,
		getFunc = function()
			return Harvest.GetDisplayedMaxTimeDifference() / 24
		end,
		setFunc = function( value )
			Harvest.SetDisplayedMaxTimeDifference(value * 24)
		end,
		width = "half",
		default = 0,
	})
	
	submenuTable:insert({
		type = "button",
		name = GetString(SI_APPLY),--Harvest.GetLocalization("apply"),
		func = Harvest.ApplyTimeDifference,
		width = "half",
		warning = Harvest.GetLocalization("applywarning")
	})

	optionsTable:insert({
		type = "header",
		name = "",
	})

	optionsTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("account"),
		tooltip = Harvest.GetLocalization("accounttooltip"),
		getFunc = Harvest.AreSettingsAccountWide,
		setFunc = Harvest.SetSettingsAccountWide,
		width = "full",
		warning = Harvest.GetLocalization("accountwarning"),
		--requireReload = true, -- doesn't work?
	})
	
	
	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("performance"),
		controls = submenuTable,
	})
	
	--[[
	optionsTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("refreshonharvest"),
		tooltip = Harvest.GetLocalization("refreshonharvesttooltip"),
		getFunc = Harvest.ShouldRefreshPinsOnHarvest,
		setFunc = Harvest.SetRefreshPinsOnHarvest,
		default = Harvest.settings.defaultSettings.refreshOnHarvest,
	})
	--]]
	
	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("hasdrawdistance"),
		tooltip = Harvest.GetLocalization("hasdrawdistancetooltip"),
		getFunc = Harvest.HasPinVisibleDistance,
		setFunc = Harvest.SetHasPinVisibleDistance,
		default = Harvest.settings.defaultSettings.hasMaxVisibleDistance,
		width = "half",
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("drawdistance"),
		tooltip = Harvest.GetLocalization("drawdistancetooltip"),
		min = 100,
		max = 1000,
		getFunc = Harvest.GetDisplayPinVisibleDistance,
		setFunc = Harvest.SetPinVisibleDistance,
		default = 100,
		width = "half",
	})
	
	local disabled = (FyrMM ~= nil)
	local tooltip
	if disabled then
		tooltip = Harvest.GetLocalization("minimapconflict")
	else
		tooltip = Harvest.GetLocalization("drawspeedtooltip")
	end
	
	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("drawspeed"),
		tooltip = tooltip,
		min = 10,
		max = 500,
		getFunc = Harvest.GetDisplaySpeed,
		setFunc = Harvest.SetDisplaySpeed,
		default = Harvest.settings.defaultSettings.displaySpeed,
		disabled = disabled,
	})
	
	if disabled then
		tooltip = Harvest.GetLocalization("minimapconflict")
	else
		tooltip = Harvest.GetLocalization("delaywheninfighttooltip")
	end
	
	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("delaywheninfight"),
		tooltip = tooltip,
		min = 10,
		max = 500,
		getFunc = Harvest.IsDelayedWhenInFight,
		setFunc = Harvest.SetDelayedWhenInFight,
		default = Harvest.settings.defaultSettings.delayWhenInFight,
		width = "half",
		disabled = disabled,
	})
	
	if disabled then
		tooltip = Harvest.GetLocalization("minimapconflict")
	else
		tooltip = Harvest.GetLocalization("delaywhenmapclosedtooltip")
	end

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("delaywhenmapclosed"),
		tooltip = tooltip,
		min = 10,
		max = 500,
		getFunc = Harvest.IsDelayedWhenMapClosed,
		setFunc = Harvest.SetDelayedWhenMapClosed,
		default = Harvest.settings.defaultSettings.delayUntilMapOpen,
		width = "half",
		disabled = disabled,
	})
	
	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("farmandrespawn"),
		controls = submenuTable,
	})
	
	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("rangemultiplier"),
		tooltip = Harvest.GetLocalization("rangemultipliertooltip"),
		min = 5,
		max = 20,
		getFunc = Harvest.GetDisplayedVisitedRangeMultiplier,
		setFunc = Harvest.SetDisplayedVisitedRangeMultiplier,
		default = 10,
	})
	
	local disabled = (FyrMM ~= nil)
	local tooltip
	if disabled then
		tooltip = Harvest.GetLocalization("minimapconflict")
	else
		tooltip = Harvest.GetLocalization("hiddentimetooltip")
	end
	
	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("hiddentime"),
		tooltip = tooltip,
		warning = Harvest.GetLocalization("hiddentimewarning"),
		min = 0,
		max = 30,
		getFunc = Harvest.GetHiddenTime,
		setFunc = Harvest.SetHiddenTime,
		default = 0,
		disabled = disabled,
	})
	
	if disabled then
		tooltip = Harvest.GetLocalization("minimapconflict")
	else
		tooltip = Harvest.GetLocalization("hiddenonharvesttooltip")
	end

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("hiddenonharvest"),
		tooltip = tooltip,
		getFunc = Harvest.IsHiddenOnHarvest,
		setFunc = Harvest.SetHiddenOnHarvest,
		default = Harvest.settings.defaultSettings.hiddenOnHarvest,
		disabled = disabled,
	})
	
	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("compassandworld"),
		controls = submenuTable,
	})
	
	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("compass"),
		tooltip = Harvest.GetLocalization("compasstooltip"),
		getFunc = Harvest.AreCompassPinsVisible,
		setFunc = function(...)
			Harvest.SetCompassPinsVisible(...)
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestMapInRangeMenu.panel)
		end,
		default = Harvest.settings.defaultSettings.displayCompassPins,
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("compassdistance"),
		tooltip = Harvest.GetLocalization("compassdistancetooltip"),
		min = 50,
		max = 250,
		getFunc = Harvest.GetDisplayedCompassDistance,
		setFunc = Harvest.SetDisplayedCompassDistance,
		default = 100,
	})
	
	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("worldpins"),
		tooltip = Harvest.GetLocalization("worldpinstooltip"),
		--warning = Harvest.GetLocalization("worldpinswarning"),
		getFunc = Harvest.AreWorldPinsVisible,
		setFunc = function(...)
			Harvest.SetWorldPinsVisible(...)
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestMapInRangeMenu.panel)
		end,
		default = Harvest.settings.defaultSettings.displayWorldPins,
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("worlddistance"),
		tooltip = Harvest.GetLocalization("worlddistancetooltip"),
		min = 50,
		max = 250,
		getFunc = Harvest.GetDisplayedWorldDistance,
		setFunc = Harvest.SetDisplayedWorldDistance,
		default = 100,
	})
	
	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("worldpinwidth"),
		tooltip = Harvest.GetLocalization("worldpinwidthtooltip"),
		min = 50,
		max = 300,
		getFunc = Harvest.GetWorldPinWidth,
		setFunc = Harvest.SetWorldPinWidth,
		default = Harvest.settings.defaultSettings.worldPinWidth,
	})
	
	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("worldpinheight"),
		tooltip = Harvest.GetLocalization("worldpinheighttooltip"),
		min = 100,
		max = 600,
		getFunc = Harvest.GetWorldPinHeight,
		setFunc = Harvest.SetWorldPinHeight,
		default = Harvest.settings.defaultSettings.worldPinHeight,
	})
	
	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("worldpinsdepth"),
		tooltip = Harvest.GetLocalization("worldpinsdepthtooltip"),
		--warning = Harvest.GetLocalization("worldpinsdepthwarning"),
		getFunc = Harvest.DoWorldPinsUseDepth,
		setFunc = Harvest.SetWorldPinsUseDepth,
		default = Harvest.settings.defaultSettings.worldPinDepth,
	})
	--[[
	local res = Harvest.Get3DResolution()
	local uWidth, uHeight = Harvest.GetUIResolution()
	local sub = Harvest.GetSubSampling()
	optionsTable:insert({
		type = "description",
		title = nil,
		text = zo_strformat(Harvest.GetLocalization("worldpininfo"), res, uWidth, uHeight, sub )
	})
	
	optionsTable:insert({
		type = "button",
		name = Harvest.GetLocalization("worldpingraphic"),
		func = Harvest.SetToCompatibleGraphicSettings,
	})
	--]]
	
	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("pinoptions"),
		controls = submenuTable,
	})
	
	submenuTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("extendedpinoptions"),
		width = "full",
	})

	submenuTable:insert({
		type = "button",
		name = Harvest.GetLocalization("extendedpinoptionsbutton"),
		func = function() Harvest.menu:Toggle() end,
		width = "half",
	})
	
	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("level"),
		tooltip = Harvest.GetLocalization("leveltooltip"),
		getFunc = Harvest.ArePinsAbovePOI,
		setFunc = Harvest.SetPinsAbovePOI,
		default = Harvest.settings.defaultSettings.pinsAbovePoi,
	})
	
	if FyrMM or VOTANS_MINIMAP then
		submenuTable:insert({
			type = "slider",
			name = Harvest.GetLocalization( "pinsize" ),
			--tooltip =  zo_strformat( Harvest.GetLocalization( "pinsizetooltip" ), Harvest.GetLocalization( "pintype" .. pinTypeId ) ),
			min = 16,
			max = 64,
			getFunc = function()
				return Harvest.GetMapPinSize( 0 )
			end,
			setFunc = function( value )
				Harvest.SetMapPinSize( 0, value )
			end,
			default = Harvest.settings.defaultSettings.minimapPinSize,
			width = "half",
		})
	end
	
	for _, pinTypeId in ipairs( Harvest.PINTYPES ) do
		if pinTypeId ~= Harvest.TOUR then--and not Harvest.GetPinTypeInGroup(pinTypeId) then
			submenuTable:insert({
				type = "header",
				name = zo_strformat( Harvest.GetLocalization( "options" ), Harvest.GetLocalization( "pintype" .. pinTypeId ) )
			})
			submenuTable:insert( CreateFilter( pinTypeId ) )
			--optionsTable:insert( CreateImportFilter( pinTypeId ) ) -- moved to the HarvestImport folder
			submenuTable:insert( CreateGatherFilter( pinTypeId ) )
			submenuTable:insert( CreateColorPicker( pinTypeId ) )
			submenuTable:insert( CreateIconPicker( pinTypeId ) )
			if not FyrMM and not VOTANS_MINIMAP then
				submenuTable:insert( CreateSizeSlider( pinTypeId ) )
			end
		end
	end

	optionsTable:insert({
		type = "header",
		name = Harvest.GetLocalization("debugoptions"),
	})

	optionsTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization( "debug" ),
		tooltip = Harvest.GetLocalization( "debugtooltip" ),
		getFunc = Harvest.AreDebugMessagesEnabled,
		setFunc = Harvest.SetDebugMessagesEnabled,
		default = Harvest.settings.defaultSettings.debug,
	})
	
	Harvest.optionsPanel = LAM:RegisterAddonPanel("HarvestMapControl", panelData)
	LAM:RegisterOptionControls("HarvestMapControl", optionsTable)

end
