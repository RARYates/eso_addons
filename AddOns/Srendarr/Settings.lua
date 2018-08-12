local Srendarr		= _G['Srendarr'] -- grab addon table from global
local L				= Srendarr:GetLocale()
local LAM			= LibStub('LibAddonMenu-2.0')
local LMP			= LibStub('LibMediaProvider-1.0')

-- CONSTS --
local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES
local GROUP_START_FRAME		= Srendarr.GROUP_START_FRAME
local GROUP_END_FRAME		= Srendarr.GROUP_END_FRAME

local AURA_STYLE_FULL		= Srendarr.AURA_STYLE_FULL
local AURA_STYLE_ICON		= Srendarr.AURA_STYLE_ICON
local AURA_STYLE_MINI		= Srendarr.AURA_STYLE_MINI
local AURA_STYLE_GROUP		= Srendarr.AURA_STYLE_GROUP
local AURA_GROW_UP			= Srendarr.AURA_GROW_UP
local AURA_GROW_DOWN		= Srendarr.AURA_GROW_DOWN
local AURA_GROW_LEFT		= Srendarr.AURA_GROW_LEFT
local AURA_GROW_RIGHT		= Srendarr.AURA_GROW_RIGHT
local AURA_GROW_CENTERLEFT	= Srendarr.AURA_GROW_CENTERLEFT
local AURA_GROW_CENTERRIGHT	= Srendarr.AURA_GROW_CENTERRIGHT

local AURA_TYPE_TIMED		= Srendarr.AURA_TYPE_TIMED
local AURA_TYPE_TOGGLED		= Srendarr.AURA_TYPE_TOGGLED
local AURA_TYPE_PASSIVE		= Srendarr.AURA_TYPE_PASSIVE
local DEBUFF_TYPE_PASSIVE	= Srendarr.DEBUFF_TYPE_PASSIVE
local DEBUFF_TYPE_TIMED		= Srendarr.DEBUFF_TYPE_TIMED

local AURA_SORT_NAMEASC		= Srendarr.AURA_SORT_NAMEASC
local AURA_SORT_TIMEASC		= Srendarr.AURA_SORT_TIMEASC
local AURA_SORT_CASTASC		= Srendarr.AURA_SORT_CASTASC
local AURA_SORT_NAMEDESC	= Srendarr.AURA_SORT_NAMEDESC
local AURA_SORT_TIMEDESC	= Srendarr.AURA_SORT_TIMEDESC
local AURA_SORT_CASTDESC	= Srendarr.AURA_SORT_CASTDESC

local AURA_TIMERLOC_HIDDEN	= Srendarr.AURA_TIMERLOC_HIDDEN
local AURA_TIMERLOC_OVER	= Srendarr.AURA_TIMERLOC_OVER
local AURA_TIMERLOC_ABOVE	= Srendarr.AURA_TIMERLOC_ABOVE
local AURA_TIMERLOC_BELOW	= Srendarr.AURA_TIMERLOC_BELOW

local GROUP_PLAYER_SHORT	= Srendarr.GROUP_PLAYER_SHORT
local GROUP_PLAYER_LONG		= Srendarr.GROUP_PLAYER_LONG
local GROUP_PLAYER_TOGGLED	= Srendarr.GROUP_PLAYER_TOGGLED
local GROUP_PLAYER_PASSIVE	= Srendarr.GROUP_PLAYER_PASSIVE
local GROUP_PLAYER_DEBUFF	= Srendarr.GROUP_PLAYER_DEBUFF
local GROUP_PLAYER_GROUND	= Srendarr.GROUP_PLAYER_GROUND
local GROUP_PLAYER_MAJOR	= Srendarr.GROUP_PLAYER_MAJOR
local GROUP_PLAYER_MINOR	= Srendarr.GROUP_PLAYER_MINOR
local GROUP_PLAYER_ENCHANT	= Srendarr.GROUP_PLAYER_ENCHANT
local GROUP_PLAYER_GEAR		= Srendarr.GROUP_PLAYER_GEAR
local GROUP_TARGET_BUFF		= Srendarr.GROUP_TARGET_BUFF
local GROUP_TARGET_DEBUFF	= Srendarr.GROUP_TARGET_DEBUFF
local GROUP_PROMINENT		= Srendarr.GROUP_PROMINENT
local GROUP_PROMINENT2		= Srendarr.GROUP_PROMINENT2
local GROUP_PROMDEBUFFS		= Srendarr.GROUP_PROMDEBUFFS
local GROUP_PROMDEBUFFS2	= Srendarr.GROUP_PROMDEBUFFS2
local GROUP_CDTRACKER		= Srendarr.GROUP_CDTRACKER

local STR_PROMBYID			= Srendarr.STR_PROMBYID
local STR_PROMBYID2			= Srendarr.STR_PROMBYID2
local STR_DEBUFFBYID		= Srendarr.STR_DEBUFFBYID
local STR_DEBUFFBYID2		= Srendarr.STR_DEBUFFBYID2
local STR_GROUPBYID			= Srendarr.STR_GROUPBYID
local STR_BLOCKBYID			= Srendarr.STR_BLOCKBYID
local sampleAuraData		= Srendarr.sampleAuraData

local specialNames			= Srendarr.specialNames

-- UPVALUES --
local WM					= GetWindowManager()
local CM					= CALLBACK_MANAGER
local tinsert	 			= table.insert
local tremove				= table.remove
local tsort		 			= table.sort
local strformat				= string.format
local GetAbilityName		= GetAbilityName

-- DROPDOWN CHOICES --
local dropProminentAuras	= {}
local dropProminentAuras2	= {}
local dropTargetDebuffs		= {}
local dropTargetDebuffs2	= {}
local dropGroupAuras		= {}
local dropBlacklistAuras	= {}

local dropGroup				= {L.DropGroup_1, L.DropGroup_2, L.DropGroup_3, L.DropGroup_4, L.DropGroup_5, L.DropGroup_6, L.DropGroup_7, L.DropGroup_8, L.DropGroup_9, L.DropGroup_10, L.DropGroup_None}
local dropGroupRef			= {[L.DropGroup_1] = 1, [L.DropGroup_2] = 2, [L.DropGroup_3] = 3, [L.DropGroup_4] = 4, [L.DropGroup_5] = 5, [L.DropGroup_6] = 6, [L.DropGroup_7] = 7, [L.DropGroup_8] = 8, [L.DropGroup_9] = 9, [L.DropGroup_10] = 10, [L.DropGroup_None] = 0}

local dropStyle				= {L.DropStyle_Full, L.DropStyle_Icon, L.DropStyle_Mini}
local dropStyleRef			= {[L.DropStyle_Full] = AURA_STYLE_FULL, [L.DropStyle_Icon] = AURA_STYLE_ICON, [L.DropStyle_Mini] = AURA_STYLE_MINI}

local dropGrowthFullMini	= {L.DropGrowth_Up, L.DropGrowth_Down}
local dropGrowthIcon		= {L.DropGrowth_Up, L.DropGrowth_Down, L.DropGrowth_Left, L.DropGrowth_Right, L.DropGrowth_CenterLeft, L.DropGrowth_CenterRight}
local dropGrowthRef			= {[L.DropGrowth_Up] = AURA_GROW_UP, [L.DropGrowth_Down] = AURA_GROW_DOWN, [L.DropGrowth_Left] = AURA_GROW_LEFT, [L.DropGrowth_Right] = AURA_GROW_RIGHT, [L.DropGrowth_CenterLeft] = AURA_GROW_CENTERLEFT, [L.DropGrowth_CenterRight] = AURA_GROW_CENTERRIGHT}

local dropSort				= {L.DropSort_NameAsc, L.DropSort_TimeAsc, L.DropSort_CastAsc, L.DropSort_NameDesc, L.DropSort_TimeDesc, L.DropSort_CastDesc}
local dropSortRef			= {[L.DropSort_NameAsc] = AURA_SORT_NAMEASC, [L.DropSort_TimeAsc] = AURA_SORT_TIMEASC, [L.DropSort_CastAsc] = AURA_SORT_CASTASC, [L.DropSort_NameDesc] = AURA_SORT_NAMEDESC, [L.DropSort_TimeDesc] = AURA_SORT_TIMEDESC, [L.DropSort_CastDesc] = AURA_SORT_CASTDESC}

local dropTimerFull			= {L.DropTimer_Hidden, L.DropTimer_Over}
local dropTimerIcon			= {L.DropTimer_Hidden, L.DropTimer_Over, L.DropTimer_Above, L.DropTimer_Below}
local dropTimerRef			= {[L.DropTimer_Hidden] = AURA_TIMERLOC_HIDDEN, [L.DropTimer_Over] = AURA_TIMERLOC_OVER, [L.DropTimer_Above] = AURA_TIMERLOC_ABOVE, [L.DropTimer_Below] = AURA_TIMERLOC_BELOW}

local dropAuraClass			= {L.DropAuraClassBuff, L.DropAuraClassDebuff, L.DropAuraClassDefault}
local dropAuraClassRef		= {[L.DropAuraClassBuff] = AURA_TYPE_TIMED, [L.DropAuraClassDebuff] = DEBUFF_TYPE_TIMED, [L.DropAuraClassDefault] = 3}

local dropFontStyle			= {'none', 'outline', 'thin-outline', 'thick-outline', 'shadow', 'soft-shadow-thin', 'soft-shadow-thick'}

local subWidgets = { -- custom panel submenu data (Phinix)
-- Add 40 to height for each single-line option added to section.
	["SrendarrBlacklistSubmenu"]			= {height = 162, widgets = {}},
	["SrendarrAuraWhitelistSubmenu"]		= {height = 381, widgets = {}},
	["SrendarrDebuffWhitelistSubmenu"]		= {height = 457, widgets = {}},
	["SrendarrGroupWhitelistSubmenu"]		= {height = 278, widgets = {}},
	["SrendarrPlayerFilterSubmenu"]			= {height = 358, widgets = {}},
	["SrendarrTargetFilterSubmenu"]			= {height = 481, widgets = {}},
	["SrendarrDisplayGroupSubmenu"]			= {height = 572, widgets = {}},
	["SrendarrGeneralSubmenu"]				= {height = 401, widgets = {}},
	["SrendarrDebugSubmenu"]				= {height = 278, widgets = {}},
}

local tabButtons			= {}
local tabPanels				= {}
local tabDisplayWidgetRef	= {}	-- reference to widgets of the DisplayFrame settings for manipulation
local lastAddedControl		= {}
local settingsGlobalStr		= strformat('%s_%s', Srendarr.name, 'Settings')
local settingsGlobalStrBtns	= strformat('%s_%s', settingsGlobalStr, 'TabButtons')
local currentDisplayFrame	= 1		-- set that the display frame settings refer to the given display frame ID
local controlPanel, controlPanelWidth, tabButtonsPanel, displayDB, tabPanelData
local prominentAurasWidgetRef, prominentAurasSelectedAura
local prominentAurasWidgetRef2, prominentAurasSelectedAura2
local prominentDebuffsWidgetRef, prominentDebuffsSelectedAura
local prominentDebuffsWidgetRef2, prominentDebuffsSelectedAura2
local blacklistAurasWidgetRef, blacklistAurasSelectedAura
local groupAurasWidgetRef, groupAurasSelectedAura

local profileGuard			= false
local profileCopyList		= {}
local profileDeleteList		= {}
local profileCopyToCopy, profileDeleteToDelete, profileDeleteDropRef

local sampleAurasActive		= false


-- ------------------------
-- SAMPLE AURAS
-- ------------------------
local function ShowSampleAuras()
	for _, fragment in pairs(Srendarr.displayFramesScene) do
		SCENE_MANAGER:AddFragment(fragment)	-- make sure displayframes are visible while in the options panel
	end

	Srendarr.OnPlayerActivatedAlive() -- reset to a clean slate

	for i = 1, #Srendarr.db.displayFrames do -- show the display frames once emptied by above
		if Srendarr.displayFrames[i] ~= nil then
			Srendarr.displayFrames[i]:SetHidden(false)
		end
	end
	
	Srendarr.uiHidden = false

	local current = GetGameTimeMilliseconds() / 1000

	for id, data in pairs(sampleAuraData) do
		Srendarr.OnEffectChanged(nil, EFFECT_RESULT_GAINED, nil, data.auraName, data.unitTag, current, current + data.duration, nil, data.icon, nil, data.effectType, data.abilityType, nil, nil, nil, id, 1)
	end
end


-- ------------------------
-- PROFILE FUNCTIONS
-- ------------------------
local function CopyTable(src, dest)
	if (type(dest) ~= 'table') then
		dest = {}
	end

	if (type(src) == 'table') then
		for k, v in pairs(src) do
			if (type(v) == 'table') then
				CopyTable(v, dest[k])
			end

			dest[k] = v
		end
	end
end

local function CopyProfile()
	local usingGlobal	= SrendarrDB.Default[GetDisplayName()]['$AccountWide'].useAccountWide
	local destProfile	= (usingGlobal) and '$AccountWide' or GetUnitName('player')
	local sourceData, destData

	for account, accountData in pairs(SrendarrDB.Default) do
		for profile, data in pairs(accountData) do
			if (profile == profileCopyToCopy) then
				sourceData = data -- get source data to copy
			end

			if (profile == destProfile) then
				destData = data -- get destination to copy to
			end
		end
	end

	if (not sourceData or not destData) then -- something went wrong, abort
		CHAT_SYSTEM:AddMessage(strformat('%s: %s', L.Srendarr, L.Profile_CopyCannotCopy))
	else
		CopyTable(sourceData, destData)
		ReloadUI()
	end
end

local function DeleteProfile()
	for account, accountData in pairs(SrendarrDB.Default) do
		for profile, data in pairs(accountData) do
			if (profile == profileDeleteToDelete) then -- found unwanted profile
				accountData[profile] = nil
				break
			end
		end
	end

	for i, profile in ipairs(profileDeleteList) do
		if (profile == profileDeleteToDelete) then
			tremove(profileDeleteList, i)
			break
		end
	end

	profileDeleteToDelete = false
	profileDeleteDropRef:UpdateChoices()
	profileDeleteDropRef:UpdateValue()
end

local function PopulateProfileLists()
	local usingGlobal	= SrendarrDB.Default[GetDisplayName()]['$AccountWide'].useAccountWide
	local currentPlayer	= GetUnitName('player')
	local versionDB		= Srendarr.versionDB

	for account, accountData in pairs(SrendarrDB.Default) do
		for profile, data in pairs(accountData) do
			if (data.version == versionDB) then -- only populate current DB version
				if (usingGlobal) then
					if (profile ~= '$AccountWide') then
						tinsert(profileCopyList, profile) -- don't add accountwide to copy selection
						tinsert(profileDeleteList, profile) -- don't add accountwide to delete selection
					end
				else
					if (profile ~= currentPlayer) then
						tinsert(profileCopyList, profile) -- don't add current player to copy selection

						if (profile ~= '$AccountWide') then
							tinsert(profileDeleteList, profile) -- don't add accountwide or current player to delete selection
						end
					end
				end
			end
		end
	end

	tsort(profileCopyList)
	tsort(profileDeleteList)
end


-- ------------------------
-- PANEL CONSTRUCTION
-- ------------------------
function Srendarr:PopulateProminentAurasDropdown()
	for i in pairs(dropProminentAuras) do
		dropProminentAuras[i] = nil -- clean out dropdown
	end

	tinsert(dropProminentAuras, L.GenericSetting_ClickToViewAuras) -- insert 'dummy' first entry

	for name in pairs(Srendarr.db.prominentWhitelist) do
		if (name == STR_PROMBYID) then -- special case for auras added by abilityID
			for id in pairs(Srendarr.db.prominentWhitelist[STR_PROMBYID]) do
				local idName = (specialNames[abilityId] ~= nil) and zo_strformat("<<t:1>>",specialNames[abilityId].name) or zo_strformat("<<t:1>>",GetAbilityName(id))
				tinsert(dropProminentAuras, strformat('[%d] %s', id, idName))
			end
		else
			tinsert(dropProminentAuras, name) -- add current aura selection
		end
	end

	prominentAurasWidgetRef:UpdateChoices()
	prominentAurasWidgetRef:UpdateValue()
end

function Srendarr:PopulateProminentAurasDropdown2()
	for i in pairs(dropProminentAuras2) do
		dropProminentAuras2[i] = nil -- clean out dropdown
	end

	tinsert(dropProminentAuras2, L.GenericSetting_ClickToViewAuras) -- insert 'dummy' first entry

	for name in pairs(Srendarr.db.prominentWhitelist2) do
		if (name == STR_PROMBYID2) then -- special case for auras added by abilityID
			for id in pairs(Srendarr.db.prominentWhitelist2[STR_PROMBYID2]) do
				local idName = (specialNames[abilityId] ~= nil) and zo_strformat("<<t:1>>",specialNames[abilityId].name) or zo_strformat("<<t:1>>",GetAbilityName(id))
				tinsert(dropProminentAuras2, strformat('[%d] %s', id, idName))
			end
		else
			tinsert(dropProminentAuras2, name) -- add current aura selection
		end
	end

	prominentAurasWidgetRef2:UpdateChoices()
	prominentAurasWidgetRef2:UpdateValue()
end

function Srendarr:PopulateTargetDebuffDropdown()
	for i in pairs(dropTargetDebuffs) do
		dropTargetDebuffs[i] = nil -- clean out dropdown
	end

	tinsert(dropTargetDebuffs, L.GenericSetting_ClickToViewAuras) -- insert 'dummy' first entry

	for name in pairs(Srendarr.db.debuffWhitelist) do
		if (name == STR_DEBUFFBYID) then -- special case for auras added by abilityID
			for id in pairs(Srendarr.db.debuffWhitelist[STR_DEBUFFBYID]) do
				local idName = (specialNames[abilityId] ~= nil) and zo_strformat("<<t:1>>",specialNames[abilityId].name) or zo_strformat("<<t:1>>",GetAbilityName(id))
				tinsert(dropTargetDebuffs, strformat('[%d] %s', id, idName))
			end
		else
			tinsert(dropTargetDebuffs, name) -- add current aura selection
		end
	end

	prominentDebuffsWidgetRef:UpdateChoices()
	prominentDebuffsWidgetRef:UpdateValue()
end

function Srendarr:PopulateTargetDebuffDropdown2()
	for i in pairs(dropTargetDebuffs2) do
		dropTargetDebuffs2[i] = nil -- clean out dropdown
	end

	tinsert(dropTargetDebuffs2, L.GenericSetting_ClickToViewAuras) -- insert 'dummy' first entry

	for name in pairs(Srendarr.db.debuffWhitelist2) do
		if (name == STR_DEBUFFBYID2) then -- special case for auras added by abilityID
			for id in pairs(Srendarr.db.debuffWhitelist2[STR_DEBUFFBYID2]) do
				local idName = (specialNames[abilityId] ~= nil) and zo_strformat("<<t:1>>",specialNames[abilityId].name) or zo_strformat("<<t:1>>",GetAbilityName(id))
				tinsert(dropTargetDebuffs2, strformat('[%d] %s', id, idName))
			end
		else
			tinsert(dropTargetDebuffs2, name) -- add current aura selection
		end
	end

	prominentDebuffsWidgetRef2:UpdateChoices()
	prominentDebuffsWidgetRef2:UpdateValue()
end

function Srendarr:PopulateGroupAurasDropdown()
	for i in pairs(dropGroupAuras) do
		dropGroupAuras[i] = nil -- clean out dropdown
	end

	tinsert(dropGroupAuras, L.GenericSetting_ClickToViewAuras) -- insert 'dummy' first entry

	for name in pairs(Srendarr.db.groupWhitelist) do
		if (name == STR_GROUPBYID) then -- special case for auras added by abilityID
			for id in pairs(Srendarr.db.groupWhitelist[STR_GROUPBYID]) do
				local idName = (specialNames[abilityId] ~= nil) and zo_strformat("<<t:1>>",specialNames[abilityId].name) or zo_strformat("<<t:1>>",GetAbilityName(id))
				tinsert(dropGroupAuras, strformat('[%d] %s', id, idName))
			end
		else
			tinsert(dropGroupAuras, name) -- add current aura selection
		end
	end

	groupAurasWidgetRef:UpdateChoices()
	groupAurasWidgetRef:UpdateValue()
end

function Srendarr:PopulateBlacklistAurasDropdown()
	for i in pairs(dropBlacklistAuras) do
		dropBlacklistAuras[i] = nil -- clean out dropdown
	end

	tinsert(dropBlacklistAuras, L.GenericSetting_ClickToViewAuras) -- insert 'dummy' first entry

	for name in pairs(Srendarr.db.blacklist) do
		if (name == STR_BLOCKBYID) then -- special case for auras added by abilityID
			for id in pairs(Srendarr.db.blacklist[STR_BLOCKBYID]) do
				local idName = (specialNames[abilityId] ~= nil) and zo_strformat("<<t:1>>",specialNames[abilityId].name) or zo_strformat("<<t:1>>",GetAbilityName(id))
				tinsert(dropBlacklistAuras, strformat('[%d] %s', id, idName))
			end
		else
			tinsert(dropBlacklistAuras, name) -- add current aura selection
		end
	end

	blacklistAurasWidgetRef:UpdateChoices()
	blacklistAurasWidgetRef:UpdateValue()
end

local function CreateWidgets(panelID, panelData)
	local panel = tabPanels[panelID]
	local isLastHalf = false
	local anchorOffset = 0

	for entry, widgetData in ipairs(panelData) do
		local widgetType = widgetData.type
		local widget = LAMCreateControl[widgetType](panel, widgetData)

		local function ToggleSubmenu(clicked) -- toggle simulated sub-menus (Phinix)
			local control = clicked:GetParent()
			local subWidgetsDB = subWidgets[control.data.reference]

			if control.open then
				control.bg:SetDimensions(panel:GetWidth() + 19, 30)
				control.label:SetDimensions(panel:GetWidth(), 30)
				control.arrow:SetTexture("EsoUI\\Art\\Miscellaneous\\list_sortdown.dds")
				for s = 1, #subWidgetsDB.widgets do
					local subWidget = subWidgetsDB.widgets[s].w
					subWidget:SetHidden(true)
				end
				control.open = false
			else
				control.bg:SetDimensions(panel:GetWidth() + 19, subWidgetsDB.height)
				control.label:SetDimensions(panel:GetWidth(), subWidgetsDB.height)
				control.arrow:SetTexture("EsoUI\\Art\\Miscellaneous\\list_sortup.dds")
				for s = 1, #subWidgetsDB.widgets do
					local subWidget = subWidgetsDB.widgets[s].w
					subWidget:SetHidden(false)
				end
				control.open = true
			end
		end

		if widgetData.controls ~= nil then -- simulate sub-menu widgets for custom panels (Phinix)
			local lastSubWidget = widget.label
			local subWidgetsDB = subWidgets[widget.data.reference]
			widget.label:SetHandler("OnMouseUp", ToggleSubmenu)

			widget.scroll:SetDimensionConstraints(panel:GetWidth() + 19, 0, panel:GetWidth() + 19, 0)
			widget.label:SetDimensions(panel:GetWidth(), (widget.open) and subWidgetsDB.height or 30)
			widget.bg:SetDimensions(panel:GetWidth() + 19, (widget.open) and subWidgetsDB.height or 30)

			for subEntry, subWidgetData in ipairs(widgetData.controls) do
				local subWidgetType = subWidgetData.type
				local subWidget = LAMCreateControl[subWidgetType](panel, subWidgetData)
				subWidget:SetAnchor(TOPLEFT, lastSubWidget, (lastSubWidget == widget.label) and TOPLEFT or BOTTOMLEFT, 0, (lastSubWidget == widget.label) and 45 or 15)
				subWidgetsDB.widgets[subEntry] = {w = subWidget}

				if (panelID == 2 and subWidget.data.isProminentAurasWidget) then -- General panel, grab the 1st prominent auras dropdown list for later
					prominentAurasWidgetRef = subWidget
				elseif (panelID == 2 and subWidget.data.isProminentAurasWidget2) then -- General panel, grab the 2nd prominent auras dropdown list for later
					prominentAurasWidgetRef2 = subWidget
				elseif (panelID == 2 and subWidget.data.isProminentDebuffsWidget) then -- General panel, grab the 1st debuff whitelist auras dropdown list for later
					prominentDebuffsWidgetRef = subWidget
				elseif (panelID == 2 and subWidget.data.isProminentDebuffsWidget2) then -- General panel, grab the 2nd debuff whitelist auras dropdown list for later
					prominentDebuffsWidgetRef2 = subWidget
				elseif (panelID == 2 and subWidget.data.isGroupAurasWidget) then -- General panel, grab the group whitelist auras dropdown list for later
					groupAurasWidgetRef = subWidget
				elseif (panelID == 2 and subWidget.data.isBlacklistAurasWidget) then -- Filters panel, grab the blacklist auras dropdown list for later
					blacklistAurasWidgetRef = subWidget
				end

				if not widget.open then
					subWidget:SetHidden(true)
				else
					subWidget:SetHidden(false)
				end
				lastSubWidget = subWidget
			end
		end

		if (panelID ~= 10 and widget.data.widgetRightAlign) then -- display frames (10) does its own config
			widget.thumb:ClearAnchors()
			widget.thumb:SetAnchor(RIGHT, widget.color, RIGHT, 0, 0)
		end

		if (panelID ~= 10 and widget.data.widgetPositionAndResize) then -- display frames (10) does its own config
			widget:SetAnchor(TOPLEFT, lastAddedControl[panelID], TOPLEFT, 0, 0) -- overlay widget with previous
			widget:SetWidth(controlPanelWidth - (controlPanelWidth / 3) + widget.data.widgetPositionAndResize) -- shrink widget to give appearance of sharing a row
		else
			widget:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 15)
			lastAddedControl[panelID] = widget
		end

		if (panelID == 5 and widgetData.isProfileDeleteDrop) then -- Profile panel, grab the delete dropdown list for later
			profileDeleteDropRef = widget
		elseif (panelID == 10) then -- make a reference to each widget for the Display Frames settings
			tabDisplayWidgetRef[entry] = widget
		end
	end
end

local function CreateTabPanel(panelID)
	local panel = WM:CreateControl(nil, controlPanel.scroll, CT_CONTROL)
	panel.panel = controlPanel
	panel:SetWidth(controlPanelWidth)
	panel:SetAnchor(TOPLEFT, tabButtonsPanel, BOTTOMLEFT, 0, 6)
	panel:SetResizeToFitDescendents(true)

	tabPanels[panelID] = panel

	local ctrl = LAMCreateControl.header(panel, {
		type = 'header',
		name = (panelID < 10 and panelID ~= 2) and L['TabHeader' .. panelID] or L.FilterHeader, -- header is set for display frames later
	})
	ctrl:SetAnchor(TOPLEFT)
	lastAddedControl[panelID] = ctrl

	if (panelID == 2) then
		local ctrl2 = LAMCreateControl.description(panel, {
			type = 'description',
			text = L.Filter_Desc,
		})
		ctrl2:SetAnchor(TOPLEFT, ctrl, BOTTOMLEFT, 0, 15)
		lastAddedControl[panelID] = ctrl2
	end

	panel.headerRef = ctrl -- set reference to header for later update

	if (panelID == 10) then -- add string below header (shows aura groups on the given DisplayFrame)
		ctrl = WM:CreateControl(nil, panel, CT_LABEL)
		ctrl:SetFont('$(CHAT_FONT)|14|soft-shadow-thin')
		ctrl:SetText('')
		ctrl:SetDimensions(controlPanelWidth)
		ctrl:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)
		ctrl:SetAnchor(TOPLEFT, panel.headerRef, BOTTOMLEFT, 0, 1)
		
		lastAddedControl[panelID] = ctrl
		panel.groupRef = ctrl -- set reference to string for later update
	end

	CreateWidgets(panelID, tabPanelData[panelID]) -- create the actual setting elements

	if (panelID == 2) then -- populate blacklist and prominent auras dropdown lists
		Srendarr:PopulateBlacklistAurasDropdown()
		Srendarr:PopulateGroupAurasDropdown()
		Srendarr:PopulateProminentAurasDropdown()
		Srendarr:PopulateProminentAurasDropdown2()
		Srendarr:PopulateTargetDebuffDropdown()
		Srendarr:PopulateTargetDebuffDropdown2()
	end
end


-- ------------------------
-- PANEL CONFIGURATION
-- ------------------------
local function ConfigurePanelDisplayFrame(fromStyleFlag)
	if (not fromStyleFlag) then -- set the header for the current display frame (unless called by a style change which doesn't change these)
		tabPanels[10].headerRef.data.name = strformat('%s [|cffd100%d|r]', L.TabHeaderDisplay, currentDisplayFrame)

		-- set the displayed groups info entry for the current display frame
		local groupText = strformat('%s: ', L.Group_Displayed_Here)
		local noGroups = true

		for group, frame in pairs(Srendarr.db.auraGroups) do
			if frame == GROUP_START_FRAME and (frame == currentDisplayFrame) then
				groupText = strformat('%s |cffd100%s|r,', groupText, L.Group_Group)
				noGroups = false
			elseif ((frame == GROUP_START_FRAME + 1) and (frame == currentDisplayFrame)) then
				groupText = strformat('%s |cffd100%s|r,', groupText, L.Group_Raid)
				noGroups = false
			elseif (frame == currentDisplayFrame) then -- this group is being show on this frame
				groupText = strformat('%s |cffd100%s|r,', groupText, Srendarr.auraGroupStrings[group])
				noGroups = false
			end
		end

		if (noGroups) then
			groupText = strformat('%s |cffd100%s|r,', groupText, L.Group_Displayed_None)
		end

		tabPanels[10].groupRef:SetText(string.sub(groupText, 1, -2))
	end

	lastAddedControl[10] = tabDisplayWidgetRef[3] -- the aura display divider, grab ref for future anchoring

	local displayStyle = displayDB[currentDisplayFrame].style -- get the style for current frame

	for entry, widget in ipairs(tabDisplayWidgetRef) do
		if (entry > 3) then -- we never need to adjust the first 3 widgets
			-- should widget be visible with the current display frame's style

			if (widget.data.hideOnStyle[displayStyle]) then
				widget:SetHidden(true)
			else -- widget is visible, reanchor to maintain the appearance of the settings panel
				widget:SetHidden(false)

				if (widget.data.widgetRightAlign) then
					widget.thumb:ClearAnchors() -- widget needs manipulation, anchor swatch to the right for later
					widget.thumb:SetAnchor(RIGHT, widget.color, RIGHT, 0, 0)
				end

				if (widget.data.widgetPositionAndResize) then
					widget:SetAnchor(TOPLEFT, lastAddedControl[10], TOPLEFT, 0, 0) -- overlay widget with previous
					widget:SetWidth(controlPanelWidth - (controlPanelWidth / 3) + widget.data.widgetPositionAndResize)
				else
					widget:SetAnchor(TOPLEFT, lastAddedControl[10], BOTTOMLEFT, 0, 15)
					lastAddedControl[10] = widget
				end
			end
		end
	end
end

local function OnStyleChange(style)
	if (style == AURA_STYLE_FULL or style == AURA_STYLE_MINI) then -- these styles have restricted auraGrowth options

		if (displayDB[currentDisplayFrame].auraGrowth ~= AURA_GROW_UP and displayDB[currentDisplayFrame].auraGrowth ~= AURA_GROW_DOWN) then
			displayDB[currentDisplayFrame].auraGrowth = AURA_GROW_DOWN -- force (now) invalid growth choice to a valid setting

			Srendarr.displayFrames[currentDisplayFrame]:Configure()		-- growth has changed, update DisplayFrame
			Srendarr.displayFrames[currentDisplayFrame]:ConfigureDragOverlay()
			Srendarr.displayFrames[currentDisplayFrame]:UpdateDisplay()
		end
	end

	if (style == AURA_STYLE_FULL) then -- this style has restricted timerLocation options
		if (displayDB[currentDisplayFrame].timerLocation ~= AURA_TIMERLOC_OVER and displayDB[currentDisplayFrame].timerLocation ~= AURA_TIMERLOC_HIDDEN) then
			displayDB[currentDisplayFrame].timerLocation = AURA_TIMERLOC_OVER -- force (now) invalid placement choice to a valid setting
		end
	end

	Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras() -- auras have changed style, update their appearance
end


-- ------------------------
-- TAB BUTTON HANDLER
-- ------------------------
local function TabButtonOnClick(self)
	if (not tabPanels[self.panelID]) then
		CreateTabPanel(self.panelID) -- call to create appropriate panel if not created yet
	end

	for x = 1, 17 do
		tabButtons[x].button:SetState(0) -- unset selected state for all buttons
	end

	if (self.buttonID == 4) then -- display frames primary button
		for x = 6, 17 do
			tabButtons[x]:SetHidden(false) -- show display frame tab buttons
		end

		tabButtons[currentDisplayFrame + 5].button:SetState(1, true) -- set current display button selected

		ConfigurePanelDisplayFrame() -- configure the settings for Display Frames (changes for multiple reasons)
	elseif (self.buttonID >= 6) then -- one of the display frame buttons
		currentDisplayFrame = self.displayID
		tabButtons[4].button:SetState(1, true) -- set display primary selected

		ConfigurePanelDisplayFrame() -- configure the settings for Display Frames (changes for multiple reasons)
	else -- one of the other 3 tab buttons
		for x = 6, 17 do
			tabButtons[x]:SetHidden(true) -- hide display frame tab buttons
		end
	end

	tabButtons[self.buttonID].button:SetState(1, true) -- set selected state for current button

	for id, panel in pairs(tabPanels) do
		panel:SetHidden(not (id == self.panelID)) -- hide all other tab panels but intended
	end
end


-- -----------------------
-- ID FUNCTIONS
-- -----------------------
local pChars = {
	["Quantus Gravitus"] = "Maker of Things",
	["Dar'jazad"] = "Rajhin's Echo",
	["Sanya Lightspear"] = "Solar Centurion",
	["Hiero Nymus"] = "The Mountain",
	["Nina Romari"] = "Sanguine Coalescence",
	["Cythirea"] = "Mazken Stormclaw",
	["Irae Aundae"] = "Prismatic Inversion",
	["Wax-in-Winter"] = "Entropic Regenesis",
	["Fear-No-Pain"] = "Soul Sap",
	["Dreloth Nivehk"] = "Dragon's Breath",
	["Divad Arbolas"] = "Gravity of Words",
	["Nateo Mythweaver"] = "In Strange Lands",
	["Dro'samir"] = "Lightning Sands",
	["Cindari Atropa"] = "Dragon's Teeth",
	["Kailyn Duskwhisper"] = "Nowhere's End",
}

local function modifyTitle(oTitle, uName)
	local tLang = {
		en = "Volunteer",
		fr = "Volontaire",
		de = "Freiwillige",
	}
	local client = GetCVar("Language.2")
	if oTitle == tLang[client] then
		return (pChars[uName] ~= nil) and pChars[uName] or oTitle
	end
	return oTitle
end

local modifyGetTitle = GetTitle
GetTitle = function(index)
	local oTitle = modifyGetTitle(index)
	local uName = GetUnitName("player")
	local rTitle = modifyTitle(oTitle, uName)
	return rTitle
end

local modifyGetUnitTitle = GetUnitTitle
GetUnitTitle = function(unitTag)
	local oTitle = modifyGetUnitTitle(unitTag)
	local uName = GetUnitName(unitTag)
	local rTitle = modifyTitle(oTitle, uName)
	return rTitle
end


-- -----------------------
-- INITIALIZATION
-- -----------------------
local function CompleteInitialization(panel)
	if (panel ~= controlPanel) then return end -- only proceed if this is our settings panel

	tabButtonsPanel		= _G[settingsGlobalStrBtns] -- setup reference to tab buttons (custom) panel
	controlPanelWidth	= controlPanel:GetWidth() - 60 -- used several times

	local btn

	for x = 1, 17 do
		btn = LAMCreateControl.button(tabButtonsPanel, { -- create our tab buttons
			type = 'button',
			name = (x <= 5) and L['TabButton' .. x] or (x == 16) and 'G' or (x == 17) and 'R' or tostring(x - 5),
			func = TabButtonOnClick,
		})
		btn.button.buttonID = x -- reference lookup to refer to buttons

		if (x <= 5) then -- main tab buttons (General, Filters, Display Frames & Profiles)
			btn:SetWidth((controlPanelWidth / 5) - 2)
			btn.button:SetWidth((controlPanelWidth / 5) - 2)
			btn:SetAnchor(TOPLEFT, tabButtonsPanel, TOPLEFT, (x == 1) and 0 or ((controlPanelWidth / 5) * (x - 1)), 0)

			btn.button.panelID = (x == 4) and 10 or x -- reference lookup to refer to panels
		else -- display frame tab buttons
			btn:SetWidth((controlPanelWidth / 12) - 2)
			btn.button:SetWidth((controlPanelWidth / 12) - 2)
			btn:SetAnchor(TOPLEFT, tabButtonsPanel, TOPLEFT, (x == 6) and 0 or ((controlPanelWidth / 12) * (x - 6)), 34)
			btn:SetHidden(true)

			btn.button.panelID		= 10	-- reference lookup to refer to panels (special case for display frames)
			btn.button.displayID	= x - 5	-- for later reference to relate to DisplayFrames
		end

		tabButtons[x] = btn
	end

	tabButtons[1].button:SetState(1, true) -- set selected state for first (General) panel

	CreateTabPanel(1) -- create first (General) panel on settings first load

	-- build a button to show sample castbar
	btn = WM:CreateControlFromVirtual(nil, controlPanel, 'ZO_DefaultButton')
	btn:SetWidth((controlPanelWidth / 3) - 30)
	btn:SetText(L.Show_Example_Castbar)
	btn:SetAnchor(TOPRIGHT, controlPanel, TOPRIGHT, -60, -4)
	btn:SetHandler('OnClicked', function()
		local currentTime = GetGameTimeMilliseconds() / 1000

		Srendarr.Cast:OnCastStart(
			true,
			strformat('%s - %s', L.Srendarr_Basic, L.CastBar),
			currentTime,
			currentTime + 600,
			[[esoui/art/icons/ability_mageguild_001.dds]],
			116016
		)
		Srendarr.Cast:SetHidden(false)
	end)

	-- build a button to trigger sample auras
	btn = WM:CreateControlFromVirtual(nil, controlPanel, 'ZO_DefaultButton')
	btn:SetWidth((controlPanelWidth / 3) - 30)
	btn:SetText(L.Show_Example_Auras)
	btn:SetAnchor(TOPRIGHT, controlPanel, TOPRIGHT, -230, -4)
	btn:SetHandler('OnClicked', function()
		sampleAurasActive = true
		ShowSampleAuras()
	end)

	PopulateProfileLists() -- populate available profiles

	ZO_PreHookHandler(tabButtonsPanel, 'OnEffectivelyHidden', function()
    	showSampleAuras = false
		Srendarr.OnPlayerActivatedAlive() -- closed options, reset auras

		if (Srendarr.uiLocked) then -- stop any ongoing (most likely faked) casts if the ui isn't unlocked
			Srendarr.Cast:DisableDragOverlay() -- using existing function to save time
		end
    end)
end

function Srendarr:InitializeSettings()
	displayDB = self.db.displayFrames -- local reference just to make things easier

	local panelData = {
		type = 'panel',
		name = L.Srendarr_Basic,
		displayName = L.Srendarr,
		author = 'Phinix, Kith, Garkin & silentgecko',
		version = self.version,
		registerForRefresh = true,
		registerForDefaults = false,
	}

	controlPanel = LAM:RegisterAddonPanel(settingsGlobalStr, panelData)

	local optionsData = {
		[1] = {
			type = 'custom',
			reference = settingsGlobalStrBtns,
		},
	}

	LAM:RegisterOptionControls(settingsGlobalStr, optionsData)
	CM:RegisterCallback("LAM-PanelControlsCreated", CompleteInitialization)

	Srendarr:PartialUpdate()
	Srendarr:ConfigureDisplayAbilityID()
end

function Srendarr:PartialUpdate()
	if self.db.frameVersion < 1.05 then -- section for future updates as needed.
		local resetGroups = GROUP_START_FRAME -- make sure group frames get proper index for old saved vars
		self.db.displayFrames[GROUP_START_FRAME].style = AURA_STYLE_GROUP
		self.displayFrames[GROUP_START_FRAME].style = AURA_STYLE_GROUP
		self.db.displayFrames[GROUP_START_FRAME + 1].style = AURA_STYLE_GROUP
		self.displayFrames[GROUP_START_FRAME + 1].style = AURA_STYLE_GROUP
		for i = 200, 223 do
			self.db.auraGroups[i] = resetGroups
			resetGroups = resetGroups + 1
		end
		self.db.frameVersion = 1.05
	end
end


-- -----------------------
-- OPTIONS DATA TABLES
-- -----------------------
tabPanelData = {
	-- -----------------------
	-- GENERAL SETTINGS
	-- -----------------------
	[1] = {
		{
			type = 'description',
			text = L.General_UnlockDesc,
		},
		{
			type = 'button',
			name = L.General_UnlockUnlock,
			func = function(btn)
				Srendarr.OnPlayerActivatedAlive() -- reset to a clean slate
				if (Srendarr.uiLocked) then
					Srendarr.SlashCommand('unlock')
					btn:SetText(L.General_UnlockLock)
					for _, fragment in pairs(Srendarr.displayFramesScene) do
						SCENE_MANAGER:AddFragment(fragment)	-- make sure displayframes are visible
					end
				else
					Srendarr.SlashCommand('lock')
					btn:SetText(L.General_UnlockUnlock)
				end
			end,
		},
		{
			type = 'button',
			name = L.General_UnlockReset,
			func = function(btn)
				if (btn.resetCheck) then -- button has been clicked twice, perform the reset
					local defaults = (Srendarr:GetDefaults()).displayFrames -- get original positions

					local groupFrame2 = GROUP_START_FRAME + 1
					for frame = 1, groupFrame2 do
						local point, x, y = defaults[frame].base.point, defaults[frame].base.x, defaults[frame].base.y
						-- update player settings to defaults
						Srendarr.db.displayFrames[frame].base.point = point
						Srendarr.db.displayFrames[frame].base.x = x
						Srendarr.db.displayFrames[frame].base.y = y
						-- set displayframes to original locations
						Srendarr.displayFrames[frame]:ClearAnchors()
						Srendarr.displayFrames[frame]:SetAnchor(point, GuiRoot, point, x, y)
					end

					-- reset cast bar
					defaults = (Srendarr:GetDefaults()).castBar.base

					Srendarr.db.castBar.base.point = defaults.point
					Srendarr.db.castBar.base.x = defaults.x
					Srendarr.db.castBar.base.y = defaults.y

					Srendarr.Cast:ClearAnchors()
					Srendarr.Cast:SetAnchor(defaults.point, GuiRoot, defaults.point, defaults.x, defaults.y)


					btn.resetCheck = false
					btn:SetText(L.General_UnlockReset)
				else -- first time click in a reset attempt
					btn.resetCheck = true
					btn:SetText(L.General_UnlockResetAgain)
				end
			end,
			widgetPositionAndResize	= -200,
		},
		-- -----------------------
		-- AURA CONTROL: DISPLAY GROUPS
		-- -----------------------
		{
			type = 'submenu',
			name = L.General_ControlHeader,
			tooltip = L.General_ControlBaseTip,
			controls = {
				[1] = {
					type = 'dropdown',
					name = L.Group_Player_Short,
					tooltip = L.General_ControlShortTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_SHORT] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_SHORT])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_SHORT] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[2] = {
					type = 'dropdown',
					name = L.Group_Player_Long,
					tooltip = L.General_ControlLongTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_LONG] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_LONG])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_LONG] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[3] = {
					type = 'dropdown',
					name = L.Group_Player_Major,
					tooltip = L.General_ControlMajorTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_MAJOR] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_MAJOR])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_MAJOR] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[4] = {
					type = 'dropdown',
					name = L.Group_Player_Minor,
					tooltip = L.General_ControlMinorTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_MINOR] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_MINOR])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_MINOR] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[5] = {
					type = 'dropdown',
					name = L.Group_Player_Toggled,
					tooltip = L.General_ControlToggledTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_TOGGLED] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_TOGGLED])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_TOGGLED] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[6] = {
					type = 'dropdown',
					name = L.Group_Player_Ground,
					tooltip = L.General_ControlGroundTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_GROUND] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_GROUND])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_GROUND] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[7] = {
					type = 'dropdown',
					name = L.Group_Player_Enchant,
					tooltip = L.General_ControlEnchantTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_ENCHANT] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_ENCHANT])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_ENCHANT] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[8] = {
					type = 'dropdown',
					name = L.Group_Player_Gear,
					tooltip = L.General_ControlGearTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_GEAR] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_GEAR])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_GEAR] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[9] = {
					type = 'dropdown',
					name = L.Group_Player_Cooldowns,
					tooltip = L.General_ControlCooldownTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_CDTRACKER] == 0) and 11 or Srendarr.db.auraGroups[GROUP_CDTRACKER])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_CDTRACKER] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[10] = {
					type = 'dropdown',
					name = L.Group_Player_Passive,
					tooltip = L.General_ControlPassiveTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_PASSIVE] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_PASSIVE])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_PASSIVE] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[11] = {
					type = 'dropdown',
					name = L.Group_Player_Debuff,
					tooltip = L.General_ControlDebuffTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PLAYER_DEBUFF] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PLAYER_DEBUFF])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PLAYER_DEBUFF] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[12] = {
					type = 'dropdown',
					name = L.Group_Target_Buff,
					tooltip = L.General_ControlTargetBuffTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_TARGET_BUFF] == 0) and 11 or Srendarr.db.auraGroups[GROUP_TARGET_BUFF])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_TARGET_BUFF] = dropGroupRef[v]
						Srendarr:ConfigureOnTargetChanged()
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[13] = {
					type = 'dropdown',
					name = L.Group_Target_Debuff,
					tooltip = L.General_ControlTargetDebuffTip,
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_TARGET_DEBUFF] == 0) and 11 or Srendarr.db.auraGroups[GROUP_TARGET_DEBUFF])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_TARGET_DEBUFF] = dropGroupRef[v]
						Srendarr:ConfigureOnTargetChanged()
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
			},
			reference = "SrendarrDisplayGroupSubmenu",
		},
		-- -----------------------
		-- GENERAL OPTIONS
		-- -----------------------
		{
			type = 'submenu',
			name = L.General_GeneralOptions,
			tooltip = L.General_GeneralOptionsDesc,
			controls = {
				[1] = {
					type = 'slider',
					name = L.General_AuraFadeout,
					tooltip = L.General_AuraFadeoutTip,
					min = 0,
					max = 5000,
					step = 100,
					getFunc = function()
						return Srendarr.db.auraFadeTime * 1000
					end,
					setFunc = function(v)
						Srendarr.db.auraFadeTime = v / 1000
						Srendarr:ConfigureAuraFadeTime()
					end,
				},
				[2] = {
					type = 'slider',
					name = L.General_ShortThreshold,
					tooltip = L.General_ShortThresholdTip,
					warning = L.General_ShortThresholdWarn,
					min = 10,
					max = 120,
					getFunc = function()
						return Srendarr.db.shortBuffThreshold
					end,
					setFunc = function(v)
						Srendarr.db.shortBuffThreshold = v
						for frame = GROUP_START_FRAME, GROUP_END_FRAME do Srendarr.displayFrames[frame]:Configure() end
						Srendarr.OnPlayerActivatedAlive()
						Srendarr:ConfigureAuraHandler()
					end,
				},
				[3] = {
					type = 'checkbox',
					name = L.General_ConsolidateEnabled,
					tooltip = L.General_ConsolidateEnabledTip,
					getFunc = function()
						return Srendarr.db.consolidateEnabled
					end,
					setFunc = function(v)
						Srendarr.db.consolidateEnabled = v
					end,
				},
				[4] = {
					type = 'checkbox',
					name = L.General_PassiveEffectsAsPassive,
					tooltip = L.General_PassiveEffectsAsPassiveTip,
					getFunc = function()
						return Srendarr.db.passiveEffectsAsPassive
					end,
					setFunc = function(v)
						Srendarr.db.passiveEffectsAsPassive = v
						Srendarr:ConfigureAuraHandler()
					end,
				},
				[5] = {
					type = 'checkbox',
					name = L.General_ProcEnableAnims,
					tooltip = L.General_ProcEnableAnimsTip,
					getFunc = function()
						return Srendarr.db.procEnableAnims
					end,
					setFunc = function(v)
						Srendarr.db.procEnableAnims = v
						Srendarr:ConfigureProcs()
					end,
				},
				[6] = {
					type = 'dropdown',
					name = L.General_ProcPlaySound,
					tooltip = L.General_ProcPlaySoundTip,
					choices = LMP:List('sound'),
					getFunc = function()
						return Srendarr.db.procPlaySound
					end,
					setFunc = function(v)
						PlaySound(LMP:Fetch('sound', v))
						Srendarr.db.procPlaySound = v
						Srendarr:ConfigureProcs()
					end,
					scrollable = 7,
				},
				[7] = {
					type = 'checkbox',
					name = L.ShowSeconds,
					tooltip = L.ShowSecondsTip,
					getFunc = function()
						return Srendarr.db.showSeconds
					end,
					setFunc = function(v)
						Srendarr.db.showSeconds = v
					end,
				},
				[8] = {
					type = 'checkbox',
					name = L.General_CombatOnly,
					tooltip = L.General_CombatOnlyTip,
					getFunc = function()
						return Srendarr.db.combatDisplayOnly
					end,
					setFunc = function(v)
						Srendarr.db.combatDisplayOnly = v
						Srendarr:ConfigureOnCombatState()
					end,
				},
				[9] = {
					type = 'checkbox',
					name = L.HideOnDeadTargets,
					tooltip = L.HideOnDeadTargetsTip,
					getFunc = function()
						return Srendarr.db.HideOnDeadTargets
					end,
					setFunc = function(v)
						Srendarr.db.HideOnDeadTargets = v
					end,
				},
			},
			reference = "SrendarrGeneralSubmenu",
		},
		-- -----------------------
		-- DEBUG OPTIONS
		-- -----------------------
		{
			type = 'submenu',
			name = L.General_DebugOptions,
			tooltip = L.General_DebugOptionsDesc,
			controls = {
				[1] = {
					type = 'checkbox',
					name = L.General_DisplayAbilityID,
					tooltip = L.General_DisplayAbilityIDTip,
					getFunc = function()
						return Srendarr.db.displayAbilityID
					end,
					setFunc = function(v)
						Srendarr.db.displayAbilityID = v
						Srendarr:ConfigureDisplayAbilityID()

						for frame = 1, NUM_DISPLAY_FRAMES do
							Srendarr.displayFrames[frame]:ConfigureAssignedAuras()
						end

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
				},
				[2] = {
					type = 'checkbox',
					name = L.General_ShowCombatEvents,
					tooltip = L.General_ShowCombatEventsTip,
					getFunc = function()
						return Srendarr.db.showCombatEvents
					end,
					setFunc = function(v)
						Srendarr.db.showCombatEvents = v
					end,
				},
				[3] = {
					type = 'checkbox',
					name = L.General_AllowManualDebug,
					tooltip = L.General_AllowManualDebugTip,
					getFunc = function()
						return Srendarr.db.manualDebug
					end,
					setFunc = function(v)
						Srendarr.db.manualDebug = v
					end,
					disabled = function() return not Srendarr.db.showCombatEvents end,
				},
				[4] = {
					type = 'checkbox',
					name = L.General_DisableSpamControl,
					tooltip = L.General_DisableSpamControlTip,
					getFunc = function()
						return Srendarr.db.disableSpamControl
					end,
					setFunc = function(v)
						Srendarr.db.disableSpamControl = v
					end,
					disabled = function() return not Srendarr.db.showCombatEvents end,
				},
				[5] = {
					type = 'checkbox',
					name = L.General_VerboseDebug,
					tooltip = L.General_VerboseDebugTip,
					getFunc = function()
						return Srendarr.db.showVerboseDebug
					end,
					setFunc = function(v)
						Srendarr.db.showVerboseDebug = v
					end,
					disabled = function() return not Srendarr.db.showCombatEvents end,
				},
				[6] = {
					type = 'checkbox',
					name = L.General_ShowNoNames,
					tooltip = L.General_ShowNoNamesTip,
					getFunc = function()
						return Srendarr.db.showNoNames
					end,
					setFunc = function(v)
						Srendarr.db.showNoNames = v
					end,
					disabled = function() return not Srendarr.db.showCombatEvents end,
				},
			},
			reference = "SrendarrDebugSubmenu",
		},
	},
	-- -----------------------
	-- FILTER SETTINGS
	-- -----------------------
	[2] = {
		-- -----------------------
		-- AURA BLACKLIST
		-- -----------------------
		{
			type = 'submenu',
			name = L.Filter_BlacklistHeader,
			tooltip = L.Filter_BlacklistDesc,
			controls = {
				[1] = {
					type = 'editbox',
					name = L.Filter_BlacklistAdd,
					tooltip = L.Filter_BlacklistAddTip,
					warning = L.Filter_ListAddWarn,
					getFunc = function ()
						return ''
					end,
					setFunc = function(v)
						if (v ~= '') then
							-- need to add to blacklist
							Srendarr:BlacklistAuraAdd(v)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateBlacklistAurasDropdown()
					end,
					isMultiline = false,
				},
				[2] = {
					type = 'dropdown',
					name = L.Filter_BlacklistList,
					tooltip = L.Filter_BlacklistListTip,
					choices = dropBlacklistAuras,
					sort = 'name-down',
					getFunc = function()
						blacklistAurasSelectedAura = nil
						return dropBlacklistAuras[1]
					end,
					setFunc = function(v)
						blacklistAurasSelectedAura = (v ~= '' and v ~= L.GenericSetting_ClickToViewAuras) and v or nil
					end,
					isBlacklistAurasWidget = true,
					scrollable = 7,
				},
				[3] = {
					type = 'button',
					name = L.Filter_RemoveSelected,
					func = function(btn)
						if (blacklistAurasSelectedAura) then
							if (string.find(blacklistAurasSelectedAura, '%[%d+%]')) then -- this is a 'by abilityID' aura
								blacklistAurasSelectedAura = string.match(blacklistAurasSelectedAura, '%d+') -- correct user display to just abilityID
							end

							Srendarr:BlacklistAuraRemove(blacklistAurasSelectedAura)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateBlacklistAurasDropdown()
					end,
				},
			},
			reference = "SrendarrBlacklistSubmenu",
		},
		-- -----------------------
		-- PROMINENT BUFFS
		-- -----------------------
		{
			type = 'submenu',
			name = L.Filter_ProminentHeader,
			tooltip = L.Filter_ProminentDesc,
			controls = {
				[1] = {
					type = 'dropdown',
					name = L.Group_Prominent,
					tooltip = strformat('%s\n\n%s', L.General_ControlBaseTip, L.General_ControlProminentTip),
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PROMINENT] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PROMINENT])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PROMINENT] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[2] = {
					type = 'editbox',
					name = L.Filter_ProminentAdd,
					tooltip = L.Filter_ProminentAddTip,
					warning = L.Filter_ListAddWarn,
					getFunc = function ()
						return ''
					end,
					setFunc = function(v)
						if (v ~= '') then
							Srendarr:ProminentAuraAdd(v)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateProminentAurasDropdown()
					end,
					isMultiline = false,
				},
				[3] = {
					type = 'dropdown',
					name = L.Filter_ProminentList1,
					tooltip = L.Filter_ProminentListTip,
					choices = dropProminentAuras,
					sort = 'name-down',
					getFunc = function()
						prominentAurasSelectedAura = nil
						return dropProminentAuras[1]
					end,
					setFunc = function(v)
						prominentAurasSelectedAura = (v ~= '' and v ~= L.GenericSetting_ClickToViewAuras) and v or nil
					end,
					isProminentAurasWidget = true,
					scrollable = 7,
				},
				[4] = {
					type = 'button',
					name = L.Filter_RemoveSelected,
					func = function(btn)
						if (prominentAurasSelectedAura) then
							if (string.find(prominentAurasSelectedAura, '%[%d+%]')) then -- this is a 'by abilityID' aura
								prominentAurasSelectedAura = string.match(prominentAurasSelectedAura, '%d+') -- correct user display to just abilityID
							end

							Srendarr:ProminentAuraRemove(prominentAurasSelectedAura)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateProminentAurasDropdown()
					end,
				},
				[5] = {
					type = 'description',
				},
				[6] = {
					type = 'dropdown',
					name = L.Group_Prominent2,
					tooltip = strformat('%s\n\n%s', L.General_ControlBaseTip, L.General_ControlProminentTip),
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PROMINENT2] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PROMINENT2])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PROMINENT2] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[7] = {
					type = 'editbox',
					name = L.Filter_ProminentAdd,
					tooltip = L.Filter_ProminentAddTip,
					warning = L.Filter_ListAddWarn,
					getFunc = function ()
						return ''
					end,
					setFunc = function(v)
						if (v ~= '') then
							Srendarr:ProminentAuraAdd2(v)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateProminentAurasDropdown2()
					end,
					isMultiline = false,
				},
				[8] = {
					type = 'dropdown',
					name = L.Filter_ProminentList2,
					tooltip = L.Filter_ProminentListTip,
					choices = dropProminentAuras2,
					sort = 'name-down',
					getFunc = function()
						prominentAurasSelectedAura2 = nil
						return dropProminentAuras2[1]
					end,
					setFunc = function(v)
						prominentAurasSelectedAura2 = (v ~= '' and v ~= L.GenericSetting_ClickToViewAuras) and v or nil
					end,
					isProminentAurasWidget2 = true,
					scrollable = 7,
				},
				[9] = {
					type = 'button',
					name = L.Filter_RemoveSelected,
					func = function(btn)
						if (prominentAurasSelectedAura2) then
							if (string.find(prominentAurasSelectedAura2, '%[%d+%]')) then -- this is a 'by abilityID' aura
								prominentAurasSelectedAura2 = string.match(prominentAurasSelectedAura2, '%d+') -- correct user display to just abilityID
							end

							Srendarr:ProminentAuraRemove2(prominentAurasSelectedAura2)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateProminentAurasDropdown2()
					end,
				},
			},
			reference = "SrendarrAuraWhitelistSubmenu",
		},
		-- -----------------------
		-- PROMINENT DEBUFFS
		-- -----------------------
		{
			type = 'submenu',
			name = L.Filter_DebuffHeader,
			tooltip = L.Filter_DebuffDesc,
			controls = {
				[1] = {
					type = 'dropdown',
					name = L.Group_Debuffs,
					tooltip = strformat('%s\n\n%s', L.General_ControlBaseTip, L.General_ControlProminentDebuffTip),
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PROMDEBUFFS])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[2] = {
					type = 'editbox',
					name = L.Filter_DebuffAdd,
					tooltip = L.Filter_DebuffAddTip,
					warning = L.Filter_DebuffAddWarn,
					getFunc = function ()
						return ''
					end,
					setFunc = function(v)
						if (v ~= '') then
							Srendarr:ProminentDebuffAdd(v)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateTargetDebuffDropdown()
					end,
					isMultiline = false,
				},
				[3] = {
					type = 'dropdown',
					name = L.Filter_DebuffList1,
					tooltip = L.Filter_DebuffListTip,
					choices = dropTargetDebuffs,
					sort = 'name-down',
					getFunc = function()
						prominentDebuffsSelectedAura = nil
						return dropTargetDebuffs[1]
					end,
					setFunc = function(v)
						prominentDebuffsSelectedAura = (v ~= '' and v ~= L.GenericSetting_ClickToViewAuras) and v or nil
					end,
					isProminentDebuffsWidget = true,
					scrollable = 7,
				},
				[4] = {
					type = 'button',
					name = L.Filter_RemoveSelected,
					func = function(btn)
						if (prominentDebuffsSelectedAura) then
							if (string.find(prominentDebuffsSelectedAura, '%[%d+%]')) then -- this is a 'by abilityID' aura
								prominentDebuffsSelectedAura = string.match(prominentDebuffsSelectedAura, '%d+') -- correct user display to just abilityID
							end

							Srendarr:ProminentDebuffRemove(prominentDebuffsSelectedAura)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateTargetDebuffDropdown()
					end,
				},
				[5] = {
					type = 'checkbox',
					name = L.Filter_OnlyPlayerProminentDebuffs1,
					tooltip = L.Filter_OnlyPlayerProminentDebuffsTip,
					getFunc = function()
						return Srendarr.db.filtersGroup.onlyPromPlayerDebuffs
					end,
					setFunc = function(v)
						Srendarr.db.filtersGroup.onlyPromPlayerDebuffs = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[6] = {
					type = 'description',
				},
				[7] = {
					type = 'dropdown',
					name = L.Group_Debuffs2,
					tooltip = strformat('%s\n\n%s', L.General_ControlBaseTip, L.General_ControlProminentDebuffTip),
					choices = dropGroup,
					getFunc = function()
						-- just handle a special case with the 'dont display' setting internally being 0 and the settings menu wanting a >1 number
						return dropGroup[((Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] == 0) and 11 or Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2])]
					end,
					setFunc = function(v)
						Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] = dropGroupRef[v]
						Srendarr:ConfigureAuraHandler()

						if (sampleAurasActive) then
							ShowSampleAuras() -- sample auras calls OnPlayerActivatedAlive as well
						else
							Srendarr.OnPlayerActivatedAlive()
						end
					end,
					scrollable = 7,
				},
				[8] = {
					type = 'editbox',
					name = L.Filter_DebuffAdd,
					tooltip = L.Filter_DebuffAddTip,
					warning = L.Filter_DebuffAddWarn,
					getFunc = function ()
						return ''
					end,
					setFunc = function(v)
						if (v ~= '') then
							Srendarr:ProminentDebuffAdd2(v)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateTargetDebuffDropdown2()
					end,
					isMultiline = false,
				},
				[9] = {
					type = 'dropdown',
					name = L.Filter_DebuffList2,
					tooltip = L.Filter_DebuffListTip,
					choices = dropTargetDebuffs2,
					sort = 'name-down',
					getFunc = function()
						prominentDebuffsSelectedAura2 = nil
						return dropTargetDebuffs2[1]
					end,
					setFunc = function(v)
						prominentDebuffsSelectedAura2 = (v ~= '' and v ~= L.GenericSetting_ClickToViewAuras) and v or nil
					end,
					isProminentDebuffsWidget2 = true,
					scrollable = 7,
				},
				[10] = {
					type = 'button',
					name = L.Filter_RemoveSelected,
					func = function(btn)
						if (prominentDebuffsSelectedAura2) then
							if (string.find(prominentDebuffsSelectedAura2, '%[%d+%]')) then -- this is a 'by abilityID' aura
								prominentDebuffsSelectedAura2 = string.match(prominentDebuffsSelectedAura2, '%d+') -- correct user display to just abilityID
							end

							Srendarr:ProminentDebuffRemove2(prominentDebuffsSelectedAura2)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateTargetDebuffDropdown2()
					end,
				},
				[11] = {
					type = 'checkbox',
					name = L.Filter_OnlyPlayerProminentDebuffs2,
					tooltip = L.Filter_OnlyPlayerProminentDebuffsTip,
					getFunc = function()
						return Srendarr.db.filtersGroup.onlyPromPlayerDebuffs2
					end,
					setFunc = function(v)
						Srendarr.db.filtersGroup.onlyPromPlayerDebuffs2 = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
			},
			reference = "SrendarrDebuffWhitelistSubmenu",
		},
		-- -----------------------
		-- GROUP BUFFS
		-- -----------------------
		{
			type = 'submenu',
			name = L.Filter_GroupAuraHeader,
			tooltip = L.Filter_GroupAuraDesc,
			controls = {
				[1] = {
					type = 'editbox',
					name = L.Filter_GroupAuraAdd,
					tooltip = L.Filter_GroupAuraAddTip,
					warning = L.Filter_ListAddWarn,
					getFunc = function ()
						return ''
					end,
					setFunc = function(v)
						if (v ~= '') then
							Srendarr:GroupWhitelistAdd(v)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateGroupAurasDropdown()
					end,
					isMultiline = false,
				},
				[2] = {
					type = 'dropdown',
					name = L.Filter_GroupList,
					tooltip = L.Filter_GroupListTip,
					choices = dropGroupAuras,
					sort = 'name-down',
					getFunc = function()
						groupAurasSelectedAura = nil
						return dropGroupAuras[1]
					end,
					setFunc = function(v)
						groupAurasSelectedAura = (v ~= '' and v ~= L.GenericSetting_ClickToViewAuras) and v or nil
					end,
					isGroupAurasWidget = true,
					scrollable = 7,
				},
				[3] = {
					type = 'button',
					name = L.Filter_RemoveSelected,
					func = function(btn)
						if (groupAurasSelectedAura) then
							if (string.find(groupAurasSelectedAura, '%[%d+%]')) then -- this is a 'by abilityID' aura
								groupAurasSelectedAura = string.match(groupAurasSelectedAura, '%d+') -- correct user display to just abilityID
							end

							Srendarr:GroupAuraRemove(groupAurasSelectedAura)
							Srendarr.OnPlayerActivatedAlive()
						end

						Srendarr:PopulateGroupAurasDropdown()
					end,
				},
				[4] = {
					type = 'checkbox',
					name = L.Filter_GroupByDuration,
					tooltip = L.Filter_GroupByDurationTip,
					getFunc = function()
						return Srendarr.db.filtersGroup.groupDuration
					end,
					setFunc = function(v)
						Srendarr.db.filtersGroup.groupDuration = v
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[5] = {
					type = 'slider',
					name = L.Filter_GroupThreshold,
					min = 5,
					max = 600,
					step = 1,
					getFunc = function()
						return Srendarr.db.filtersGroup.groupThreshold
					end,
					setFunc = function(v)
						Srendarr.db.filtersGroup.groupThreshold = v
						Srendarr.OnPlayerActivatedAlive()
					end,
					disabled = function() return not Srendarr.db.filtersGroup.groupDuration end,
				},
				[6] = {
					type = 'checkbox',
					name = L.Filter_GroupWhitelistOff,
					tooltip = L.Filter_GroupWhitelistOffTip,
					getFunc = function()
						return Srendarr.db.filtersGroup.groupBlacklist
					end,
					setFunc = function(v)
						Srendarr.db.filtersGroup.groupBlacklist = v
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
			},
			reference = "SrendarrGroupWhitelistSubmenu",
		},
		-- -----------------------
		-- FILTERS FOR PLAYER
		-- -----------------------
		{
			type = 'submenu',
			name = L.Filter_PlayerHeader,
			tooltip = L.FilterToggle_Desc,
			controls = {
				[1] = {
					type = 'checkbox',
					name = L.Filter_Block,
					tooltip = L.Filter_BlockPlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.block
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.block = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[2] = {
					type = 'checkbox',
					name = L.Filter_ESOPlus,
					tooltip = L.Filter_ESOPlusPlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.esoplus
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.esoplus = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[3] = {
					type = 'checkbox',
					name = L.Filter_MundusBoon,
					tooltip = L.Filter_MundusBoonPlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.mundusBoon
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.mundusBoon = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[4] = {
					type = 'checkbox',
					name = L.Filter_Cyrodiil,
					tooltip = L.Filter_CyrodiilPlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.cyrodiil
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.cyrodiil = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[5] = {
					type = 'checkbox',
					name = L.Filter_Disguise,
					tooltip = L.Filter_DisguisePlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.disguise
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.disguise = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[6] = {
					type = 'checkbox',
					name = L.Filter_SoulSummons,
					tooltip = L.Filter_SoulSummonsPlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.soulSummons
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.soulSummons = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[7] = {
					type = 'checkbox',
					name = L.Filter_VampLycan,
					tooltip = L.Filter_VampLycanPlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.vampLycan
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.vampLycan = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
				[8] = {
					type = 'checkbox',
					name = L.Filter_VampLycanBite,
					tooltip = L.Filter_VampLycanBitePlayerTip,
					getFunc = function()
						return Srendarr.db.filtersPlayer.vampLycanBite
					end,
					setFunc = function(v)
						Srendarr.db.filtersPlayer.vampLycanBite = v
						Srendarr:PopulateFilteredAuras()
						Srendarr.OnPlayerActivatedAlive()
					end,
				},
			},
			reference = "SrendarrPlayerFilterSubmenu",
		},
		-- -----------------------
		-- FILTERS FOR TARGET
		-- -----------------------
		{
			type = 'submenu',
			name = L.Filter_TargetHeader,
			tooltip = L.FilterToggle_Desc,
			controls = {
				[1] = {
					type = 'checkbox',
					name = L.Filter_OnlyPlayerDebuffs,
					tooltip = L.Filter_OnlyPlayerDebuffsTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.onlyPlayerDebuffs
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.onlyPlayerDebuffs = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[2] = {
					type = 'checkbox',
					name = L.Filter_Block,
					tooltip = L.Filter_BlockTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.block
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.block = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[3] = {
					type = 'checkbox',
					name = L.Filter_ESOPlus,
					tooltip = L.Filter_ESOPlusTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.esoplus
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.esoplus = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[4] = {
					type = 'checkbox',
					name = L.Filter_MundusBoon,
					tooltip = L.Filter_MundusBoonTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.mundusBoon
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.mundusBoon = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[5] = {
					type = 'checkbox',
					name = L.Filter_Cyrodiil,
					tooltip = L.Filter_CyrodiilTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.cyrodiil
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.cyrodiil = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[6] = {
					type = 'checkbox',
					name = L.Filter_Disguise,
					tooltip = L.Filter_DisguiseTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.disguise
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.disguise = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[7] = {
					type = 'checkbox',
					name = L.Filter_MajorEffects,
					tooltip = L.Filter_MajorEffectsTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.majorEffects
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.majorEffects = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[8] = {
					type = 'checkbox',
					name = L.Filter_MinorEffects,
					tooltip = L.Filter_MinorEffectsTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.minorEffects
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.minorEffects = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[9] = {
					type = 'checkbox',
					name = L.Filter_SoulSummons,
					tooltip = L.Filter_SoulSummonsTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.soulSummons
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.soulSummons = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[10] = {
					type = 'checkbox',
					name = L.Filter_VampLycan,
					tooltip = L.Filter_VampLycanTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.vampLycan
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.vampLycan = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
				[11] = {
					type = 'checkbox',
					name = L.Filter_VampLycanBite,
					tooltip = L.Filter_VampLycanBiteTargetTip,
					getFunc = function()
						return Srendarr.db.filtersTarget.vampLycanBite
					end,
					setFunc = function(v)
						Srendarr.db.filtersTarget.vampLycanBite = v
						Srendarr:PopulateFilteredAuras()
					end,
				},
			},
			reference = "SrendarrTargetFilterSubmenu",
		},
	},
		-- -----------------------
		-- CAST BAR SETTINGS
		-- -----------------------
	[3] = {
		{
			type = 'checkbox',
			name = L.CastBar_Enable,
			tooltip = L.CastBar_EnableTip,
			getFunc = function()
				return Srendarr.db.castBar.enabled
			end,
			setFunc = function(v)
				Srendarr.db.castBar.enabled = v
				Srendarr:ConfigureCastBar()
			end,
		},
		{
			type = 'slider',
			name = L.CastBar_Alpha,
			tooltip = L.CastBar_AlphaTip,
			min = 5,
			max = 100,
			step = 5,
			getFunc = function()
				return Srendarr.db.castBar.base.alpha * 100
			end,
			setFunc = function(v)
				Srendarr.db.castBar.base.alpha = v / 100
				Srendarr.Cast:SetAlpha(v / 100)
			end,
		},
		{
			type = 'slider',
			name = L.CastBar_Scale,
			tooltip = L.CastBar_ScaleTip,
			min = 50,
			max = 150,
			step = 5,
			getFunc = function()
				return Srendarr.db.castBar.base.scale * 100
			end,
			setFunc = function(v)
				Srendarr.db.castBar.base.scale = v / 100
				Srendarr.Cast:SetScale(v / 100)
			end,
		},
		-- -----------------------
		-- CASTED ABILITY TEXT SETTINGS
		-- -----------------------
		{
			type = 'header',
			name = L.CastBar_NameHeader,
		},
		{
			type = 'checkbox',
			name = L.CastBar_NameShow,
			getFunc = function()
				return Srendarr.db.castBar.nameShow
			end,
			setFunc = function(v)
				Srendarr.db.castBar.nameShow = v
				Srendarr:ConfigureCastBar()
			end,
		},
		{
			type = 'dropdown',
			name = L.GenericSetting_NameFont,
			choices = LMP:List('font'),
			getFunc = function()
				return Srendarr.db.castBar.nameFont
			end,
			setFunc = function(v)
				Srendarr.db.castBar.nameFont = v
				Srendarr:ConfigureCastBar()
			end,
			scrollable = 7,
		},
		{
			type = 'dropdown',
			name = L.GenericSetting_NameStyle,
			choices = dropFontStyle,
			getFunc = function()
				return Srendarr.db.castBar.nameStyle
			end,
			setFunc = function(v)
				Srendarr.db.castBar.nameStyle = v
				Srendarr:ConfigureCastBar()
			end,
			scrollable = 7,
		},
		{
			type = 'colorpicker',
			getFunc = function()
				return unpack(Srendarr.db.castBar.nameColor)
			end,
			setFunc = function(r, g, b, a)
				Srendarr.db.castBar.nameColor[1] = r
				Srendarr.db.castBar.nameColor[2] = g
				Srendarr.db.castBar.nameColor[3] = b
				Srendarr.db.castBar.nameColor[4] = a
				Srendarr:ConfigureCastBar()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= -15,
		},
		{
			type = 'slider',
			name = L.GenericSetting_NameSize,
			min = 8,
			max = 32,
			getFunc = function()
				return Srendarr.db.castBar.nameSize
			end,
			setFunc = function(v)
				Srendarr.db.castBar.nameSize = v
				Srendarr:ConfigureCastBar()
			end,
		},
		-- -----------------------
		-- CAST TIMER TEXT SETTINGS
		-- -----------------------
		{
			type = 'header',
			name = L.CastBar_TimerHeader,
		},
		{
			type = 'checkbox',
			name = L.CastBar_TimerShow,
			getFunc = function()
				return Srendarr.db.castBar.timerShow
			end,
			setFunc = function(v)
				Srendarr.db.castBar.timerShow = v
				Srendarr:ConfigureCastBar()
			end,
		},
		{
			type = 'dropdown',
			name = L.GenericSetting_TimerFont,
			choices = LMP:List('font'),
			getFunc = function()
				return Srendarr.db.castBar.timerFont
			end,
			setFunc = function(v)
				Srendarr.db.castBar.timerFont = v
				Srendarr:ConfigureCastBar()
			end,
			scrollable = 7,
		},
		{
			type = 'dropdown',
			name = L.GenericSetting_TimerStyle,
			choices = dropFontStyle,
			getFunc = function()
				return Srendarr.db.castBar.timerStyle
			end,
			setFunc = function(v)
				Srendarr.db.castBar.timerStyle = v
				Srendarr:ConfigureCastBar()
			end,
			scrollable = 7,
		},
		{
			type = 'colorpicker',
			getFunc = function()
				return unpack(Srendarr.db.castBar.timerColor)
			end,
			setFunc = function(r, g, b, a)
				Srendarr.db.castBar.timerColor[1] = r
				Srendarr.db.castBar.timerColor[2] = g
				Srendarr.db.castBar.timerColor[3] = b
				Srendarr.db.castBar.timerColor[4] = a
				Srendarr:ConfigureCastBar()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= -15,
		},
		{
			type = 'slider',
			name = L.GenericSetting_TimerSize,
			min = 8,
			max = 32,
			getFunc = function()
				return Srendarr.db.castBar.timerSize
			end,
			setFunc = function(v)
				Srendarr.db.castBar.timerSize = v
				Srendarr:ConfigureCastBar()
			end,
		},
		-- -----------------------
		-- STATUSBAR SETTINGS
		-- -----------------------
		{
			type = 'header',
			name = L.CastBar_BarHeader,
		},
		{
			type = 'checkbox',
			name = L.CastBar_BarReverse,
			tooltip = L.CastBar_BarReverseTip,
			getFunc = function()
				return Srendarr.db.castBar.barReverse
			end,
			setFunc = function(v)
				Srendarr.db.castBar.barReverse = v
				Srendarr:ConfigureCastBar()
			end,
		},
		{
			type = 'checkbox',
			name = L.CastBar_BarGloss,
			tooltip = L.CastBar_BarGlossTip,
			getFunc = function()
				return Srendarr.db.castBar.barGloss
			end,
			setFunc = function(v)
				Srendarr.db.castBar.barGloss = v
				Srendarr:ConfigureCastBar()
			end,
		},
		{
			type = 'slider',
			name = L.GenericSetting_BarWidth,
			tooltip = L.GenericSetting_BarWidthTip,
			min = 200,
			max = 400,
			step = 5,
			getFunc = function()
				return Srendarr.db.castBar.barWidth
			end,
			setFunc = function(v)
				Srendarr.db.castBar.barWidth = v
				Srendarr:ConfigureCastBar()
			end,
		},
		{
			type = 'colorpicker',
			name = L.CastBar_BarColor,
			tooltip = L.CastBar_BarColorTip,
			getFunc = function()
				local colors = Srendarr.db.castBar.barColor
				return colors.r2, colors.g2, colors.b2
			end,
			setFunc = function(r, g, b)
				Srendarr.db.castBar.barColor.r2 = r
				Srendarr.db.castBar.barColor.g2 = g
				Srendarr.db.castBar.barColor.b2 = b
				Srendarr:ConfigureCastBar()
			end,
			widgetRightAlign		= true,
		},
		{
			type = 'colorpicker',
			tooltip = L.CastBar_BarColorTip,
			getFunc = function()
				local colors = Srendarr.db.castBar.barColor
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				Srendarr.db.castBar.barColor.r1 = r
				Srendarr.db.castBar.barColor.g1 = g
				Srendarr.db.castBar.barColor.b1 = b
				Srendarr:ConfigureCastBar()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
		},
	},
	-- -----------------------
	-- PROFILE SETTINGS
	-- -----------------------
	[5] = {
		[1] = {
			type = 'description',
			text = L.Profile_Desc
		},
		[2] = {
			type = 'checkbox',
			name = L.Profile_UseGlobal,
			warning = L.Profile_UseGlobalWarn,
			getFunc = function()
				return SrendarrDB.Default[GetDisplayName()]['$AccountWide'].useAccountWide
			end,
			setFunc = function(v)
				SrendarrDB.Default[GetDisplayName()]['$AccountWide'].useAccountWide = v
				ReloadUI()
			end,
			disabled = function()
				return not profileGuard
			end,
		},
		[3] = {
			type = 'dropdown',
			name = L.Profile_Copy,
			tooltip = L.Profile_CopyTip,
			choices = profileCopyList,
			getFunc = function()
				if (#profileCopyList >= 1) then -- there are entries, set first as default
					profileCopyToCopy = profileCopyList[1]
					return profileCopyList[1]
				end
			end,
			setFunc = function(v)
				profileCopyToCopy = v
			end,
			disabled = function()
				return not profileGuard
			end,
			scrollable = 7,
		},
		[4] = {
			type = 'button',
			name = L.Profile_CopyButton,
			warning = L.Profile_CopyButtonWarn,
			func = function(btn)
				CopyProfile()
			end,
			disabled = function()
				return not profileGuard
			end,
		},
		[5] = {
			type = 'dropdown',
			name = L.Profile_Delete,
			tooltip = L.Profile_DeleteTip,
			choices = profileDeleteList,
			getFunc = function()
				if (#profileDeleteList >= 1) then
					if (not profileDeleteToDelete) then -- nothing selected yet, return first
						profileDeleteToDelete = profileDeleteList[1]
						return profileDeleteList[1]
					else
						return profileDeleteToDelete
					end
				end
			end,
			setFunc = function(v)
				profileDeleteToDelete = v
			end,
			disabled = function()
				return not profileGuard
			end,
			isProfileDeleteDrop = true,
			scrollable = 7,
		},
		[6] = {
			type = 'button',
			name = L.Profile_DeleteButton,
			func = function(btn)
				DeleteProfile()
			end,
			disabled = function()
				return not profileGuard
			end,
		},
		[7] = {
			type = 'description'
		},
		[8] = {
			type = 'header'
		},
		[9] = {
			type = 'checkbox',
			name = L.Profile_Guard,
			getFunc = function()
				return profileGuard
			end,
			setFunc = function(v)
				profileGuard = v
			end,
		},
	},
	-- -----------------------
	-- DISPLAY FRAME SETTINGS
	-- -----------------------
	[10] = {
		{
			type = 'slider',
			name = L.DisplayFrame_Alpha,
			tooltip = L.DisplayFrame_AlphaTip,
			min = 5,
			max = 100,
			step = 5,
			getFunc = function()
				return displayDB[currentDisplayFrame].base.alpha * 100
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].base.alpha = v / 100
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:SetAlpha(v / 100)
					Srendarr.displayFrames[currentDisplayFrame].displayAlpha = v / 100
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:SetAlpha(v / 100)
						Srendarr.displayFrames[i].displayAlpha = v / 100
						Srendarr.displayFrames[i]:Configure()
						Srendarr.displayFrames[i]:UpdateDisplay()
					end
				end
			end,
		},
		{
			type = 'slider',
			name = L.DisplayFrame_Scale,
			tooltip = L.DisplayFrame_ScaleTip,
			min = 10,
			max = 150,
			step = 5,
			getFunc = function()
				return displayDB[currentDisplayFrame].base.scale * 100
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].base.scale = v / 100
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:SetScale(v / 100)
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:SetScale(v / 100)
						Srendarr.displayFrames[i]:Configure()
						Srendarr.displayFrames[i]:UpdateDisplay()
					end
				end
			end,
		},
		-- -----------------------
		-- AURA DISPLAY SETTINGS
		-- -----------------------
		{
			type = 'header',
			name = L.DisplayFrame_AuraHeader,
		},
		{					-- style							FULL, ICON, MINI
			type = 'dropdown',
			name = L.DisplayFrame_Style,
			tooltip = L.DisplayFrame_StyleTip,
			choices = dropStyle,
			getFunc = function()
				return dropStyle[displayDB[currentDisplayFrame].style]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].style = dropStyleRef[v]
				OnStyleChange(dropStyleRef[v]) -- update several options dependent on current style
				ConfigurePanelDisplayFrame(true) -- changing this changes a lot of the following options
				local auraLookup = Srendarr.auraLookup
				for unit, data in pairs(auraLookup) do
					for aura, ability in pairs(auraLookup[unit]) do
						ability:SetExpired()
						ability:Release()
					end
				end
				for frame = 1, (GROUP_START_FRAME - 1) do Srendarr.displayFrames[frame]:Configure() end
				Srendarr.OnPlayerActivatedAlive()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
			scrollable = 7,
		},
		{					-- hideFullBar						FULL
			type = 'checkbox',
			name = L.DisplayFrame_HideFullBar,
			tooltip = L.DisplayFrame_HideFullBarTip,
			getFunc = function()
				return displayDB[currentDisplayFrame].hideFullBar
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].hideFullBar = v
				for frame = 1, Srendarr.NUM_DISPLAY_FRAMES do Srendarr.displayFrames[frame]:Configure() end
				Srendarr.OnPlayerActivatedAlive()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = true},
		},
		{					-- groupX							GROUP ONLY
			type = 'slider',
			name = L.DisplayFrame_GRX,
			tooltip = L.DisplayFrame_GRXTip,
			min = -128,
			max = 128,
			getFunc = function()
				return displayDB[currentDisplayFrame].base.x
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].base.x = v
				Srendarr.OnPlayerActivatedAlive()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = true, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = false},
		},
		{					-- groupY							GROUP ONLY
			type = 'slider',
			name = L.DisplayFrame_GRY,
			tooltip = L.DisplayFrame_GRYTip,
			min = -128,
			max = 128,
			getFunc = function()
				return displayDB[currentDisplayFrame].base.y
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].base.y = v
				Srendarr.OnPlayerActivatedAlive()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = true, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = false},
		},
		{					-- auraCooldown						FULL, ICON, GROUP
			type = 'checkbox',
			name = L.DisplayFrame_AuraCooldown,
			tooltip = L.DisplayFrame_AuraCooldownTip,
			getFunc = function()
				return displayDB[currentDisplayFrame].auraCooldown
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].auraCooldown = v
				for frame = 1, Srendarr.NUM_DISPLAY_FRAMES do Srendarr.displayFrames[frame]:Configure() end
				Srendarr.OnPlayerActivatedAlive()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = false},
		},
		{					-- cooldownDebuffColor[TIMED]		FULL, ICON, GROUP
			type = 'colorpicker',
			name = L.DisplayFrame_CooldownTimed,
			tooltip = L.DisplayFrame_CooldownTimedTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].cooldownColors[DEBUFF_TYPE_TIMED]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].cooldownColors[DEBUFF_TYPE_TIMED].r1 = r
				displayDB[currentDisplayFrame].cooldownColors[DEBUFF_TYPE_TIMED].g1 = g
				displayDB[currentDisplayFrame].cooldownColors[DEBUFF_TYPE_TIMED].b1 = b
				Srendarr.OnPlayerActivatedAlive()
			end,
			widgetRightAlign		= true,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = false},
		},
		{					-- cooldownBuffColor[TIMED]			FULL, ICON, GROUP
			type = 'colorpicker',
			tooltip = L.DisplayFrame_CooldownTimedTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].cooldownColors[AURA_TYPE_TIMED]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].cooldownColors[AURA_TYPE_TIMED].r1 = r
				displayDB[currentDisplayFrame].cooldownColors[AURA_TYPE_TIMED].g1 = g
				displayDB[currentDisplayFrame].cooldownColors[AURA_TYPE_TIMED].b1 = b
				Srendarr.OnPlayerActivatedAlive()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = false},
		},
		{					-- auraGrowth						FULL, MINI
			type = 'dropdown',
			name = L.DisplayFrame_Growth,
			tooltip = L.DisplayFrame_GrowthTip,
			choices = dropGrowthFullMini,
			getFunc = function()
				return dropGrowthFullMini[displayDB[currentDisplayFrame].auraGrowth]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].auraGrowth = dropGrowthRef[v]
				Srendarr.displayFrames[currentDisplayFrame]:Configure()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureDragOverlay()
				Srendarr.displayFrames[currentDisplayFrame]:UpdateDisplay()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
			scrollable = 7,
		},
		{					-- auraGrowth 						ICON
			type = 'dropdown',
			name = L.DisplayFrame_Growth,
			tooltip = L.DisplayFrame_GrowthTip,
			choices = dropGrowthIcon,
			getFunc = function()
				return dropGrowthIcon[displayDB[currentDisplayFrame].auraGrowth]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].auraGrowth = dropGrowthRef[v]
				Srendarr.displayFrames[currentDisplayFrame]:Configure()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureDragOverlay()
				Srendarr.displayFrames[currentDisplayFrame]:UpdateDisplay()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = true, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = true},
		},
		{					-- auraPadding						FULL, ICON, MINI, GROUP
			type = 'slider',
			name = L.DisplayFrame_Padding,
			tooltip = L.DisplayFrame_PaddingTip,
			min = -25,
			max = 75,
			getFunc = function()
				return displayDB[currentDisplayFrame].auraPadding
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].auraPadding = v
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:Configure()
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureDragOverlay()
					Srendarr.displayFrames[currentDisplayFrame]:UpdateDisplay()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:Configure()
						Srendarr.displayFrames[i]:UpdateDisplay()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
		},
		{					-- auraSort							FULL, ICON, MINI, GROUP
			type = 'dropdown',
			name = L.DisplayFrame_Sort,
			tooltip = L.DisplayFrame_SortTip,
			choices = dropSort,
			sort = 'name-up',
			getFunc = function()
				return dropSort[displayDB[currentDisplayFrame].auraSort]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].auraSort = dropSortRef[v]
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:Configure()
					Srendarr.displayFrames[currentDisplayFrame]:UpdateDisplay()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:Configure()
						Srendarr.displayFrames[i]:UpdateDisplay()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
			scrollable = 7,
		},
		{					-- auraClassIverride				FULL, ICON, MINI
			type = 'dropdown',
			name = L.DisplayFrame_AuraClassOverride,
			tooltip = L.DisplayFrame_AuraClassOverrideTip,
			choices = dropAuraClass,
			sort = 'name-up',
			getFunc = function()
				local checkDB = {[1] = L.DropAuraClassBuff, [3] = L.DropAuraClassDefault, [5] = L.DropAuraClassDebuff}
				return checkDB[displayDB[currentDisplayFrame].auraClassOverride]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].auraClassOverride = dropAuraClassRef[v]
				Srendarr.OnPlayerActivatedAlive()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
			scrollable = 7,
		},
		{					-- highlightToggled					FULL, ICON
			type = 'checkbox',
			name = L.DisplayFrame_Highlight,
			tooltip = L.DisplayFrame_HighlightTip,
			getFunc = function()
				return displayDB[currentDisplayFrame].highlightToggled
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].highlightToggled = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = true},
		},
		{					-- enableTooltips					ICON
			type = 'checkbox',
			name = L.DisplayFrame_Tooltips,
			tooltip = L.DisplayFrame_TooltipsTip,
			warning = L.DisplayFrame_TooltipsWarn,
			getFunc = function()
				return displayDB[currentDisplayFrame].enableTooltips
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].enableTooltips = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = true, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = true},
		},
		-- -----------------------
		-- ABILITY TEXT SETTINGS
		-- -----------------------
		{					-- nameHeader						FULL, MINI
			type = 'header',
			name = L.DisplayFrame_NameHeader,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- nameFont							FULL, MINI
			type = 'dropdown',
			name = L.GenericSetting_NameFont,
			choices = LMP:List('font'),
			getFunc = function()
				return displayDB[currentDisplayFrame].nameFont
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].nameFont = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
			scrollable = 7,
		},
		{					-- nameStyle						FULL, MINI
			type = 'dropdown',
			name = L.GenericSetting_NameStyle,
			choices = dropFontStyle,
			getFunc = function()
				return displayDB[currentDisplayFrame].nameStyle
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].nameStyle = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
			scrollable = 7,
		},
		{					-- nameColor						FULL, MINI
			type = 'colorpicker',
			getFunc = function()
				return unpack(displayDB[currentDisplayFrame].nameColor)
			end,
			setFunc = function(r, g, b, a)
				displayDB[currentDisplayFrame].nameColor[1] = r
				displayDB[currentDisplayFrame].nameColor[2] = g
				displayDB[currentDisplayFrame].nameColor[3] = b
				displayDB[currentDisplayFrame].nameColor[4] = a
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= -15,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- nameSize							FULL, MINI
			type = 'slider',
			name = L.GenericSetting_NameSize,
			min = 8,
			max = 32,
			getFunc = function()
				return displayDB[currentDisplayFrame].nameSize
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].nameSize = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		-- -----------------------
		-- TIMER TEXT SETTINGS
		-- -----------------------
		{					-- timerHeader						FULL, ICON, MINI, GROUP
			type = 'header',
			name = L.DisplayFrame_TimerHeader,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
		},
		{					-- timerFont						FULL, ICON, MINI, GROUP
			type = 'dropdown',
			name = L.GenericSetting_TimerFont,
			choices = LMP:List('font'),
			getFunc = function()
				return displayDB[currentDisplayFrame].timerFont
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].timerFont = v
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:ConfigureAssignedAuras()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
			scrollable = 7,
		},
		{					-- timerStyle						FULL, ICON, MINI, GROUP
			type = 'dropdown',
			name = L.GenericSetting_TimerStyle,
			choices = dropFontStyle,
			getFunc = function()
				return displayDB[currentDisplayFrame].timerStyle
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].timerStyle = v
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:ConfigureAssignedAuras()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
			scrollable = 7,
		},
		{					-- timerColor						FULL, ICON, MINI, GROUP
			type = 'colorpicker',
			getFunc = function()
				return unpack(displayDB[currentDisplayFrame].timerColor)
			end,
			setFunc = function(r, g, b, a)
				displayDB[currentDisplayFrame].timerColor[1] = r
				displayDB[currentDisplayFrame].timerColor[2] = g
				displayDB[currentDisplayFrame].timerColor[3] = b
				displayDB[currentDisplayFrame].timerColor[4] = a
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:ConfigureAssignedAuras()
					end
				end
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= -15,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
		},
		{					-- timerSize						FULL, ICON, MINI, GROUP
			type = 'slider',
			name = L.GenericSetting_TimerSize,
			min = 8,
			max = 32,
			getFunc = function()
				return displayDB[currentDisplayFrame].timerSize
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].timerSize = v
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:ConfigureAssignedAuras()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
		},
		{					-- timerLocation					FULL
			type = 'dropdown',
			name = L.DisplayFrame_TimerLocation,
			tooltip = L.DisplayFrame_TimerLocationTip,
			choices = dropTimerFull,
			getFunc = function()
				return dropTimerFull[displayDB[currentDisplayFrame].timerLocation]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].timerLocation = dropTimerRef[v]
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = true},
			scrollable = 7,
		},
		{					-- timerLocation					ICON, GROUP
			type = 'dropdown',
			name = L.DisplayFrame_TimerLocation,
			tooltip = L.DisplayFrame_TimerLocationTip,
			choices = dropTimerIcon,
			getFunc = function()
				return dropTimerIcon[displayDB[currentDisplayFrame].timerLocation]
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].timerLocation = dropTimerRef[v]
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:ConfigureAssignedAuras()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = true, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = true, [AURA_STYLE_GROUP] = false},
			scrollable = 7,
		},
		{					-- timerHMS							FULL, ICON, MINI, GROUP
			type = 'checkbox',
			name = L.DisplayFrame_TimerHMS,
			tooltip = L.DisplayFrame_TimerHMSTip,
			getFunc = function()
				return displayDB[currentDisplayFrame].timerHMS
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].timerHMS = v
				if currentDisplayFrame < GROUP_START_FRAME then
					Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				else
					for i = GROUP_START_FRAME, GROUP_END_FRAME do
						Srendarr.displayFrames[i]:ConfigureAssignedAuras()
					end
				end
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = false, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = false},
		},
		-- -----------------------
		-- STATUSBAR SETTINGS
		-- -----------------------
		{					-- barHeader						FULL, MINI
			type = 'header',
			name = L.DisplayFrame_BarHeader,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barGloss							FULL, MINI
			type = 'checkbox',
			name = L.DisplayFrame_BarGloss,
			tooltip = L.DisplayFrame_BarGlossTip,
			getFunc = function()
				return displayDB[currentDisplayFrame].barGloss
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].barGloss = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barReverse						FULL, MINI
			type = 'checkbox',
			name = L.DisplayFrame_BarReverse,
			tooltip = L.DisplayFrame_BarReverseTip,
			getFunc = function()
				return displayDB[currentDisplayFrame].barReverse
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].barReverse = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureDragOverlay()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barWidth							FULL, MINI
			type = 'slider',
			name = L.GenericSetting_BarWidth,
			tooltip = L.GenericSetting_BarWidthTip,
			min = 40,
			max = 240,
			step = 5,
			getFunc = function()
				return displayDB[currentDisplayFrame].barWidth
			end,
			setFunc = function(v)
				displayDB[currentDisplayFrame].barWidth = v
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureDragOverlay()
			end,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barBuffColor[TIMED]:2			FULL, MINI
			type = 'colorpicker',
			name = L.DisplayFrame_BarBuffTimed,
			tooltip = L.DisplayFrame_BarBuffTimedTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED]
				return colors.r2, colors.g2, colors.b2
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED].r2 = r
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED].g2 = g
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED].b2 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barBuffColor[TIMED]:1			FULL, MINI
			type = 'colorpicker',
			tooltip = L.DisplayFrame_BarBuffTimedTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED].r1 = r
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED].g1 = g
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TIMED].b1 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barBuffColor[PASSIVE]:2			FULL, MINI
			type = 'colorpicker',
			name = L.DisplayFrame_BarBuffPassive,
			tooltip = L.DisplayFrame_BarBuffPassiveTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE]
				return colors.r2, colors.g2, colors.b2
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE].r2 = r
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE].g2 = g
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE].b2 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barBuffColor[PASSIVE]:1			FULL, MINI
			type = 'colorpicker',
			tooltip = L.DisplayFrame_BarBuffPassiveTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE].r1 = r
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE].g1 = g
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_PASSIVE].b1 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barDebuffColor[TIMED]:2			FULL, MINI
			type = 'colorpicker',
			name = L.DisplayFrame_BarDebuffTimed,
			tooltip = L.DisplayFrame_BarDebuffTimedTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED]
				return colors.r2, colors.g2, colors.b2
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED].r2 = r
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED].g2 = g
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED].b2 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barDebuffColor[TIMED]:1			FULL, MINI
			type = 'colorpicker',
			tooltip = L.DisplayFrame_BarDebuffTimedTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED].r1 = r
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED].g1 = g
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_TIMED].b1 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barDebuffColor[PASSIVE]:2		FULL, MINI
			type = 'colorpicker',
			name = L.DisplayFrame_BarDebuffPassive,
			tooltip = L.DisplayFrame_BarDebuffPassiveTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE]
				return colors.r2, colors.g2, colors.b2
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE].r2 = r
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE].g2 = g
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE].b2 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barDebuffColor[PASSIVE]:1		FULL, MINI
			type = 'colorpicker',
			tooltip = L.DisplayFrame_BarDebuffPassiveTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE].r1 = r
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE].g1 = g
				displayDB[currentDisplayFrame].barColors[DEBUFF_TYPE_PASSIVE].b1 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barColor[TOGGLED]:2				FULL, MINI
			type = 'colorpicker',
			name = L.DisplayFrame_BarToggled,
			tooltip = L.DisplayFrame_BarToggledTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED]
				return colors.r2, colors.g2, colors.b2
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED].r2 = r
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED].g2 = g
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED].b2 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
		{					-- barColor[TOGGLED]:1				FULL, MINI
			type = 'colorpicker',
			tooltip = L.DisplayFrame_BarToggledTip,
			getFunc = function()
				local colors = displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED]
				return colors.r1, colors.g1, colors.b1
			end,
			setFunc = function(r, g, b)
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED].r1 = r
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED].g1 = g
				displayDB[currentDisplayFrame].barColors[AURA_TYPE_TOGGLED].b1 = b
				Srendarr.displayFrames[currentDisplayFrame]:ConfigureAssignedAuras()
			end,
			widgetRightAlign		= true,
			widgetPositionAndResize	= 127,
			hideOnStyle = {[AURA_STYLE_FULL] = false, [AURA_STYLE_ICON] = true, [AURA_STYLE_MINI] = false, [AURA_STYLE_GROUP] = true},
		},
	}
}
