
local Filters = {}
Harvest.filters = Filters

function Filters:Initialize()
	ZO_CreateStringId("SI_HARVEST_INRANGE_MENU_TITLE", Harvest.GetLocalization("pinvisibilitymenu"))
	
	self.iconData = {
		categoryName = SI_HARVEST_INRANGE_MENU_TITLE,
		descriptor = "HarvestInRangeScene",
		normal = "EsoUI/Art/Inventory/inventory_tabicon_quest_up.dds",
		pressed = "EsoUI/Art/Inventory/inventory_tabicon_quest_down.dds",
		highlight = "EsoUI/Art/Inventory/inventory_tabicon_quest_over.dds",
	}
	Harvest.menu:Register(self.iconData)
	
	self:CreateControls()
	self:InitializeScene()
end

function Filters:InitializeScene()
	self.scene = ZO_Scene:New("HarvestInRangeScene", SCENE_MANAGER)   
    
	-- Mouse standard position and background
	self.scene:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	self.scene:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
	--  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
	self.scene:AddFragment(RIGHT_BG_FRAGMENT)
    
	-- The title fragment
	self.scene:AddFragment(TITLE_FRAGMENT)
    
	-- Set Title
	local TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_HARVEST_MAIN_MENU_TITLE)
	self.scene:AddFragment(TITLE_FRAGMENT)
    
	-- Add the XML to our scene
	local MAIN_WINDOW = ZO_FadeSceneFragment:New(HarvestMapInRangeMenu)
	self.scene:AddFragment(MAIN_WINDOW)
	
	self.scene:AddFragment(MAIN_MENU_KEYBOARD.categoryBarFragment)
	self.scene:AddFragment(TOP_BAR_FRAGMENT)
end

function Filters:CreateControls()
	-- the descriptions and sliders of LibAddonMenu are nice, I'm gonna steal them :)
	HarvestMapInRangeMenu.panel = HarvestMapInRangeMenu
	HarvestMapInRangeMenu.panel.data = {registerForRefresh = true}
	HarvestMapInRangeMenu.panel.controlsToRefresh = {}
	
	self:InitializeWorldControl()
	self:InitializeCompassControl()
	
	local definition = {
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("extendedpinoptions"),
		width = "half",
	}
	local control = LAMCreateControl.description(HarvestMapInRangeMenu, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, HarvestMapInRangeMenu, TOPLEFT, 640, 20)
	--control:SetWidth(48)
	control.desc:SetWidth(280)
end

function Filters:InitializeCompassControl()
	
	local definition = {
		type = "checkbox",
		name = "Compass Pins",
		getFunc = Harvest.AreCompassPinsVisible,
		setFunc = function(...)
			Harvest.SetCompassPinsVisible(...)
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", Harvest.optionsPanel)
		end,
	}
	local control = LAMCreateControl.checkbox(HarvestMapInRangeMenu, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, HarvestMapInRangeMenu, TOPLEFT, 340, 20)
	control:SetWidth(300)
	control.container:SetWidth(64)
	local lastControl = control
	
	definition = {
		type = "checkbox",
		name = "Override map pin filter",
		getFunc = Harvest.IsCompassFilterActive,
		setFunc = Harvest.SetCompassFilterActive,
	}
	local control = LAMCreateControl.checkbox(HarvestMapInRangeMenu, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 40)
	control:SetWidth(300)
	control.container:SetWidth(64)
	lastControl = control
	
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if pinTypeId ~= Harvest.TOUR then
			definition = {
				type = "checkbox",
				name = Harvest.GetLocalization( "pintype" .. pinTypeId ),
				disabled = function() return not Harvest.IsCompassFilterActive() end,
				getFunc = function()
					return Harvest.IsCompassPinTypeVisible(pinTypeId)
				end,
				setFunc = function( value )
					Harvest.SetCompassPinTypeVisible(pinTypeId, value)
				end,
			}
			local control = LAMCreateControl.checkbox(HarvestMapInRangeMenu, definition)
			control:ClearAnchors()
			control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
			control:SetWidth(300)
			control.container:SetWidth(64)
			lastControl = control
		end
	end
end

function Filters:InitializeWorldControl()
	
	local definition = {
		type = "checkbox",
		name = "3D Pins",
		getFunc = Harvest.AreWorldPinsVisible,
		setFunc = function(...)
			Harvest.SetWorldPinsVisible(...)
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", Harvest.optionsPanel)
		end,
	}
	local control = LAMCreateControl.checkbox(HarvestMapInRangeMenu, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, HarvestMapInRangeMenu, TOPLEFT, 0, 20)
	control:SetWidth(300)
	control.container:SetWidth(64)
	local lastControl = control
	
	definition = {
		type = "checkbox",
		name = "Override map pin filter",
		getFunc = Harvest.IsWorldFilterActive,
		setFunc = Harvest.SetWorldFilterActive,
	}
	local control = LAMCreateControl.checkbox(HarvestMapInRangeMenu, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 40)
	control:SetWidth(300)
	control.container:SetWidth(64)
	lastControl = control
	
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if pinTypeId ~= Harvest.TOUR then
			definition = {
				type = "checkbox",
				name = Harvest.GetLocalization( "pintype" .. pinTypeId ),
				disabled = function() return not Harvest.IsWorldFilterActive() end,
				getFunc = function()
					return Harvest.IsWorldPinTypeVisible(pinTypeId)
				end,
				setFunc = function( value )
					Harvest.SetWorldPinTypeVisible(pinTypeId, value)
				end,
			}
			local control = LAMCreateControl.checkbox(HarvestMapInRangeMenu, definition)
			control:ClearAnchors()
			control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
			control:SetWidth(300)
			control.container:SetWidth(64)
			lastControl = control
		end
	end
end

