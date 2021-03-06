local BACKPACK = ZO_PlayerInventoryBackpack
local BANK = ZO_PlayerBankBackpack
local GUILD_BANK = ZO_GuildBankBackpack
local DECONSTRUCTION = ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack

local ORNATE_TEXTURE = [[/esoui/art/tradinghouse/tradinghouse_sell_tabicon_disabled.dds]]
local ornateTextureSizeMax = 28
local INTRICATE_TEXTURE = [[/esoui/art/progression/progression_indexicon_guilds_up.dds]]
local intricateTextureSizeMax = 30

local RASettings = nil
local RAScanner = nil

local function AddTooltips(control, text)
	control:SetHandler("OnMouseEnter", function(self)
		ZO_Tooltips_ShowTextTooltip(self, TOP, text)
	end)
	control:SetHandler("OnMouseExit", function(self)
		ZO_Tooltips_HideTextTooltip()
	end)
end

local function RemoveTooltips(control)
	control:SetHandler("OnMouseEnter", nil)
	control:SetHandler("OnMouseExit", nil)
end

local function HandleTooltips(control, text)
	if RASettings:ShowTooltips() and text ~= "" then
		control:SetMouseEnabled(true)
		AddTooltips(control, text)
	else
		control:SetMouseEnabled(false)
		RemoveTooltips(control)
	end
end

local function SetToOrnate(indicatorControl)
	local textureSize = RASettings:GetTextureSize() + 12

	if textureSize > ornateTextureSizeMax then textureSize = ornateTextureSizeMax end

	indicatorControl:SetTexture(ORNATE_TEXTURE)
	indicatorControl:SetColor(unpack(RASettings:GetOrnateColor()))
	indicatorControl:SetDimensions(textureSize, textureSize)
	indicatorControl:SetHidden(false)

	HandleTooltips(indicatorControl, RA_Strings[RASettings:GetLanguage()].TOOLTIPS.ornate)
end

local function SetToIntricate(indicatorControl)
	local textureSize = RASettings:GetTextureSize() + 10

	if textureSize > intricateTextureSizeMax then textureSize = intricateTextureSizeMax end

	indicatorControl:SetTexture(INTRICATE_TEXTURE)
	indicatorControl:SetColor(unpack(RASettings:GetIntricateColor()))
	indicatorControl:SetDimensions(textureSize, textureSize)
	indicatorControl:SetHidden(false)

	HandleTooltips(indicatorControl, RA_Strings[RASettings:GetLanguage()].TOOLTIPS.intricate)
end

local function SetToNormal(indicatorControl)
	local textureSize = RASettings:GetTextureSize()

	indicatorControl:SetTexture(RASettings:GetTexturePath())
	indicatorControl:SetDimensions(textureSize, textureSize)
	indicatorControl:SetHidden(true)
end

local function CreateIndicatorControl(parent)
	local control = WINDOW_MANAGER:CreateControl(parent:GetName() .. "Research", parent, CT_TEXTURE)

	control:ClearAnchors()
	control:SetAnchor(CENTER, parent, CENTER, RASettings:GetTextureOffset())
	control:SetDrawTier(DT_HIGH)

	SetToNormal(control)
	return control
end

local function DisplayIndicator(indicatorControl, indicatorType)
	local textureOffset = 0
	indicatorType = indicatorType or "normal"

	if indicatorType == "intricate" then
    	textureOffset = RASettings:GetTextureOffset() - 6
	elseif indicatorType == "ornate" then
    	textureOffset = RASettings:GetTextureOffset() - 6
	else
    	textureOffset = RASettings:GetTextureOffset()
    end

	local control = indicatorControl:GetParent()
	indicatorControl:ClearAnchors()

	if control.isGrid or control:GetWidth() - control:GetHeight() < 5 then
		-- we're using Grid View
		indicatorControl:ClearAnchors()
		indicatorControl:SetAnchor(TOPLEFT, control, TOPLEFT, 3)
	else
		indicatorControl:ClearAnchors()
		indicatorControl:SetAnchor(LEFT, control:GetNamedChild("Name"), RIGHT, textureOffset)
	end

	indicatorControl:SetHidden(false)
end

--[[----------------------------------------------------------------------------
	puts an additional point of data into control.dataEntry.data called
	researchAssistant
	this can be called from inventory, bank, guild bank, deconstruction window,
	or trading house which contains one of the following strings:
		"baditemtype" (not weapon or armor)
		"traitless" "ornate" "intricate" "untracked" (untracked)
		"known" "researchable" "duplicate" (tracked)
--]]----------------------------------------------------------------------------
local function AddResearchIndicatorToSlot(control, linkFunction)
	local bagId = control.dataEntry.data.bagId
	local slotIndex = control.dataEntry.data.slotIndex
	local itemLink = bagId and linkFunction(bagId, slotIndex) or linkFunction(slotIndex)

	--get indicator control, or create one if it doesnt exist
	local indicatorControl = control:GetNamedChild("Research")
	if not indicatorControl then
		indicatorControl = CreateIndicatorControl(control)
	end

	--returns int traitKey, bool isResearchable, string reason
	local traitKey, isResearchable, reason = RAScanner:CheckIsItemResearchable(itemLink)

	if not isResearchable then
		-- if the item isn't armor or a weapon, hide and go away
		if reason == "WrongItemType" then
			indicatorControl:SetHidden(true)
			control.dataEntry.data.researchAssistant = "baditemtype"
			return
		end

		-- if the item has no trait and we don't want to display icon for traitless items, hide and go away
		if reason == "Traitless" and RASettings:ShowTraitless() == false then
			indicatorControl:SetHidden(true)
			control.dataEntry.data.researchAssistant = "traitless"
			return
		end

		-- if the item is ornate, make icon ornate if we show ornate and hide/go away if we don't show it
		if reason == "Ornate" then
			control.dataEntry.data.researchAssistant = "ornate"
			if (craftingSkill == -1 or (RASettings:IsMultiCharSkillOff(craftingSkill, itemType))) and not RASettings:ShowUntrackedOrnate() then
				indicatorControl:SetHidden(true)
			else
				SetToOrnate(indicatorControl)
				DisplayIndicator(indicatorControl, "ornate")
			end
			return
		end

		-- if the item is intricate, make icon intricate if we show that and hide/go away if we don't
		if reason == "Intricate" then
			control.dataEntry.data.researchAssistant = "intricate"
			if RASettings:IsMultiCharSkillOff(craftingSkill, itemType) and not RASettings:ShowUntrackedIntricate() then
				indicatorControl:SetHidden(true)
			else
				SetToIntricate(indicatorControl)
				DisplayIndicator(indicatorControl, "intricate")
			end
			return
		end
	end

	--now we get into the stuff that requires the craft skill and item type
	local craftingSkill = RAScanner:GetItemCraftingSkill(itemLink)
	local itemType = RAScanner:GetResearchLineIndex(itemLink)

	--if we aren't tracking anybody for that skill, hide and go away
	if RASettings:IsMultiCharSkillOff(craftingSkill, itemType) then
		control.dataEntry.data.researchAssistant = "untracked"
		indicatorControl:SetHidden(true)
		return
	end

	--preference value for the "best" item candidate for the trait in question
	local bestTraitPreferenceScore = RASettings:GetPreferenceValueForTrait(traitKey)
	if bestTraitPreferenceScore == nil then
		-- if the item is traitless, show "researched" color. if we've never seen this trait before, show "best" color.
		if reason == "Traitless" then
			bestTraitPreferenceScore = true
		else
			bestTraitPreferenceScore = 999999999
		end
	end

	if bestTraitPreferenceScore == true and not RASettings:ShowResearched() then
		control.dataEntry.data.researchAssistant = "known"
		indicatorControl:SetHidden(true)
		return
	end

	--here's the "display it" section
	SetToNormal(indicatorControl)
	DisplayIndicator(indicatorControl)

	--preference value for the current item
	local thisItemScore = RAScanner:CreateItemPreferenceValue(itemLink, bagId, slotIndex)
	local stackSize = control.dataEntry.data.stackCount or 0

	--d(GetItemName(bagId, slotIndex)..": "..tostring(bestTraitPreferenceScore).." best "..tostring(thisItemScore) .. " trait "..tostring(traitKey))

	--pretty colors time!
	--if we don't know it, color the icon something fun
	if bestTraitPreferenceScore ~= true then
		if thisItemScore > bestTraitPreferenceScore or stackSize > 1 then
			indicatorControl:SetColor(unpack(RASettings:GetDuplicateUnresearchedColor()))
			local whoKnows = RASettings:GetCharsWhoKnowTrait(traitKey)
			if whoKnows ~= "" then
				HandleTooltips(indicatorControl, RA_Strings[RASettings:GetLanguage()].TOOLTIPS.duplicate .. whoKnows)
			else
				HandleTooltips(indicatorControl, "")
			end
			control.dataEntry.data.researchAssistant = "duplicate"
		else
			indicatorControl:SetColor(unpack(RASettings:GetCanResearchColor()))
			local whoKnows = RASettings:GetCharsWhoKnowTrait(traitKey)
			if whoKnows ~= "" then
				HandleTooltips(indicatorControl, RA_Strings[RASettings:GetLanguage()].TOOLTIPS.canResearch .. whoKnows)
			else
				HandleTooltips(indicatorControl, "")
			end
			control.dataEntry.data.researchAssistant = "researchable"
		end
		return
	end
	--in any other case, color it known
	indicatorControl:SetColor(unpack(RASettings:GetAlreadyResearchedColor()))
	local whoKnows = RASettings:GetCharsWhoKnowTrait(traitKey)
	HandleTooltips(indicatorControl, RA_Strings[RASettings:GetLanguage()].TOOLTIPS.alreadyResearched .. whoKnows)
	if reason == "Traitless" then
		control.dataEntry.data.researchAssistant = "traitless"
	else
		control.dataEntry.data.researchAssistant = "known"
	end
end

local function AreAllHidden()
	return BANK:IsHidden() and BACKPACK:IsHidden() and GUILD_BANK:IsHidden() and DECONSTRUCTION:IsHidden()
end

--[[----------------------------------------------------------------------------
	a simple event buffer to make sure that the scan doesn't happen more than
	once in a single instance, as EVENT_INVENTORY_SINGLE_SLOT_UPDATE is very
	spammy, especially with junk and bank management add-ons
--]]----------------------------------------------------------------------------
local canUpdate = true
function ResearchAssistant_InvUpdate(...)
	if canUpdate then
		canUpdate = false
		zo_callLater(function()
			RAScanner:RescanBags()
			canUpdate = true
		end, 25)
	end
end

local function RA_HookTrading()
	EVENT_MANAGER:UnregisterForEvent("RA_TRADINGHOUSE", EVENT_TRADING_HOUSE_RESPONSE_RECEIVED)
	local hookedFunction = TRADING_HOUSE.m_searchResultsList.dataTypes[1].setupCallback
	if hookedFunction then
		TRADING_HOUSE.m_searchResultsList.dataTypes[1].setupCallback = function(...)
			local row, data = ...
			hookedFunction(...)
			AddResearchIndicatorToSlot(row, GetTradingHouseSearchResultItemLink)
		end
	end
end

local function ResearchAssistant_Loaded(eventCode, addOnName)
	if addOnName ~= "ResearchAssistant" then return end

	RASettings = ResearchAssistantSettings:New()
	RAScanner = ResearchAssistantScanner:New(RASettings)

	--inventories hook
	for _, v in pairs(PLAYER_INVENTORY.inventories) do
		local listView = v.listView
		if listView and listView.dataTypes and listView.dataTypes[1] then
			local hookedFunctions = listView.dataTypes[1].setupCallback

			listView.dataTypes[1].setupCallback = function(rowControl, slot)
				hookedFunctions(rowControl, slot)
				AddResearchIndicatorToSlot(rowControl, GetItemLink)
			end
		end
	end

	--deconstruction hook
	local hookedFunctions = DECONSTRUCTION.dataTypes[1].setupCallback
	DECONSTRUCTION.dataTypes[1].setupCallback = function(rowControl, slot)
		hookedFunctions(rowControl, slot)
		AddResearchIndicatorToSlot(rowControl, GetItemLink)
	end

	--trading house hook
	EVENT_MANAGER:RegisterForEvent("RA_TRADINGHOUSE", EVENT_TRADING_HOUSE_RESPONSE_RECEIVED, RA_HookTrading)
	EVENT_MANAGER:RegisterForEvent("RA_INV_SLOT_UPDATE", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, ResearchAssistant_InvUpdate)
end

EVENT_MANAGER:RegisterForEvent("ResearchAssistantLoaded", EVENT_ADD_ON_LOADED, ResearchAssistant_Loaded)
