--[[----------------------------------------------------------
	Srendarr - Aura (Buff & Debuff) Tracker
	----------------------------------------------------------
	*
	* Phinix, Kith, Garkin, silentgecko
	*
	*
]]--
local Srendarr				= _G['Srendarr'] -- grab addon table from global
local L						= Srendarr:GetLocale()

Srendarr.name				= 'Srendarr'
Srendarr.slash				= '/srendarr'
Srendarr.version			= '2.4.08'
Srendarr.versionDB			= 3

Srendarr.displayFrames		= {}
Srendarr.displayFramesScene	= {}
Srendarr.PassToAuraHandler	= {}
Srendarr.slotData			= {}

Srendarr.auraGroupStrings = {		-- used in several places to display the aura grouping text
	[Srendarr.GROUP_PLAYER_SHORT]	= L.Group_Player_Short,
	[Srendarr.GROUP_PLAYER_LONG]	= L.Group_Player_Long,
	[Srendarr.GROUP_PLAYER_TOGGLED]	= L.Group_Player_Toggled,
	[Srendarr.GROUP_PLAYER_PASSIVE]	= L.Group_Player_Passive,
	[Srendarr.GROUP_PLAYER_DEBUFF]	= L.Group_Player_Debuff,
	[Srendarr.GROUP_PLAYER_GROUND]	= L.Group_Player_Ground,
	[Srendarr.GROUP_PLAYER_MAJOR]	= L.Group_Player_Major,
	[Srendarr.GROUP_PLAYER_MINOR]	= L.Group_Player_Minor,
	[Srendarr.GROUP_PLAYER_ENCHANT]	= L.Group_Player_Enchant,
	[Srendarr.GROUP_PLAYER_GEAR]	= L.Group_Player_Gear,
	[Srendarr.GROUP_TARGET_BUFF]	= L.Group_Target_Buff,
	[Srendarr.GROUP_TARGET_DEBUFF]	= L.Group_Target_Debuff,
	[Srendarr.GROUP_PROMINENT]		= L.Group_Prominent,
	[Srendarr.GROUP_PROMINENT2]		= L.Group_Prominent2,
	[Srendarr.GROUP_PROMDEBUFFS]	= L.Group_Debuffs,
	[Srendarr.GROUP_PROMDEBUFFS2]	= L.Group_Debuffs2,
	[Srendarr.GROUP_CDTRACKER]		= L.Group_Cooldowns,
}

Srendarr.uiLocked			= true	-- flag for whether the UI is current drag enabled
Srendarr.uiHidden			= false	-- flag for whether auras should be hidden in UI state
Srendarr.groupUnits			= {}

-- ------------------------
-- ADDON INITIALIZATION
-- ------------------------
function Srendarr.OnInitialize(code, addon)
	if addon ~= Srendarr.name then return end

	EVENT_MANAGER:UnregisterForEvent(Srendarr.name, EVENT_ADD_ON_LOADED)
	SLASH_COMMANDS[Srendarr.slash] = Srendarr.SlashCommand

	Srendarr.db = ZO_SavedVars:NewAccountWide('SrendarrDB', Srendarr.versionDB, nil, Srendarr:GetDefaults())

	if (not Srendarr.db.useAccountWide) then -- not using global settings, generate (or load) character specific settings
		Srendarr.db = ZO_SavedVars:New('SrendarrDB', Srendarr.versionDB, nil, Srendarr:GetDefaults())
	end

	local displayBase

	-- create display frames
	for x = 1, Srendarr.NUM_DISPLAY_FRAMES do

		displayBase = (x > 10) and Srendarr.db.displayFrames[Srendarr:GetGroupRaidTab()].base or Srendarr.db.displayFrames[x].base

		Srendarr.displayFrames[x] = Srendarr.DisplayFrame:Create(x, displayBase.point, displayBase.x, displayBase.y, displayBase.alpha, displayBase.scale)

		Srendarr.displayFrames[x]:Configure()

		-- add each frame to the ZOS scene manager to control visibility
		Srendarr.displayFramesScene[x] = ZO_HUDFadeSceneFragment:New(Srendarr.displayFrames[x], 0, 0)

		HUD_SCENE:AddFragment(Srendarr.displayFramesScene[x])
		HUD_UI_SCENE:AddFragment(Srendarr.displayFramesScene[x])
		SIEGE_BAR_SCENE:AddFragment(Srendarr.displayFramesScene[x])

		Srendarr.displayFrames[x]:SetHandler('OnEffectivelyShown', function(f)
			f:SetAlpha(f.displayAlpha) -- ensure alpha is reset after a scene fade
		end)
	end

	Srendarr:PopulateFilteredAuras()		-- AuraData.lua
	Srendarr:ConfigureAuraFadeTime()		-- Aura.lua
	Srendarr:ConfigureDisplayAbilityID()	-- Aura.lua
	Srendarr:InitializeAuraControl()		-- AuraControl.lua
	Srendarr:InitializeCastBar()			-- CastBar.lua
	Srendarr:InitializeProcs()				-- Procs.lua
	Srendarr:InitializeSettings()			-- Settings.lua
	Srendarr:PartialUpdate()
	Srendarr:HideInMenus()

	-- setup events to handle actionbar slotted abilities (used for procs and the castbar)
	for slot = 3, 8 do
		Srendarr.slotData[slot] = {}
		Srendarr.OnActionSlotUpdated(nil, slot) -- populate initial data (before events registered so no triggers before setup is done)
	end

	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ACTION_SLOTS_FULL_UPDATE,	Srendarr.OnActionSlotsFullUpdate)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ACTION_SLOT_UPDATED,		Srendarr.OnActionSlotUpdated)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_TYPE_CHANGED, 		Srendarr.OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_MEMBER_JOINED, 		Srendarr.OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_MEMBER_LEFT, 			Srendarr.OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_UPDATE, 				Srendarr.OnGroupChanged)
end

function Srendarr.SlashCommand(text)
	local groupStart = Srendarr.GROUP_START_FRAME - 1
	if text == 'lock' then
		for x = 1, groupStart do
			Srendarr.displayFrames[x]:DisableDragOverlay()
		end
		Srendarr.Cast:DisableDragOverlay()
		Srendarr.uiLocked = true
		local auraLookup = Srendarr.auraLookup
		for unit, data in pairs(auraLookup) do
			for aura, ability in pairs(auraLookup[unit]) do
				ability:SetExpired()
				ability:Release()
			end
		end
	elseif text == 'unlock' then
		for x = 1, groupStart do
			Srendarr.displayFrames[x]:EnableDragOverlay()
		end
		Srendarr.Cast:EnableDragOverlay()
		Srendarr.uiLocked = false
		local auraLookup = Srendarr.auraLookup
		for unit, data in pairs(auraLookup) do
			for aura, ability in pairs(auraLookup[unit]) do
				ability:SetExpired()
				ability:Release()
			end
		end
	else
		CHAT_SYSTEM:AddMessage(L.Usage)
	end
end


-- ------------------------
-- GROUP DATA HANDLING
-- ------------------------
do
-- re-dock group frame windows when group size changes. (Phinix)
	function Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
		local GetGameTimeMillis	= GetGameTimeMilliseconds
		local PassToAuraHandler = Srendarr.PassToAuraHandler
		local auraName, finish, icon, effectType, abilityType, abilityID
		if numAuras > 0 then -- unit has auras, repopulate
			local ts = GetGameTimeMillis() / 1000
			for i = 1, numAuras do
				auraName, _, finish, _, _, icon, _, effectType, abilityType, _, abilityID = GetUnitBuffInfo(unitTag, i)
				PassToAuraHandler(true, auraName, unitTag, ts, finish, icon, effectType, abilityType, abilityID, 3)
			end
		end

		-- re-shuffle repopulated abilities to avoid gaps
		Srendarr.displayFrames[frame]:Configure()
		Srendarr.displayFrames[frame]:UpdateDisplay()
	end

	function Srendarr.AnchorGroupFrames(groupSize, s, numAuras, unitTag, frame)
		local gX = Srendarr.db.displayFrames[11].base.x
		local gY = Srendarr.db.displayFrames[11].base.y
		local rX = Srendarr.db.displayFrames[12].base.x
		local rY = Srendarr.db.displayFrames[12].base.y

		local fs = Srendarr.displayFrames[frame]
		fs:ClearAnchors() -- prepare to re-anchor display frames (addon support goes here)

--[[ -- LUI support is disabled as newer versions broke support. Needs recoding to match frames, may not be possible...
		if LUIESV then -- LUI support
			local EnableFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames_Enabled
			local GroupFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames.CustomFramesGroup
			local RaidFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames.CustomFramesRaid
			if groupSize <= 4 and (EnableFrames == true and GroupFrames == true) then
				local control = LUIE.UnitFrames.CustomFrames['SmallGroup'..s].control
				fs:SetAnchor(LEFT, control, RIGHT, gX, gY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize >= 5 and (EnableFrames == true and RaidFrames == true) then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = LUIE.UnitFrames.CustomFrames['RaidGroup'..groupSlot].control
				fs:SetAnchor(BOTTOM, control, BOTTOM, rX, rY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize <= 4 and (EnableFrames == false or GroupFrames == false) then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = GetControl('ZO_GroupUnitFramegroup'..groupSlot..'Name')
				fs:SetAnchor(BOTTOMLEFT, control, TOPLEFT, gX, gY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize >= 5 and (RaidFrames == false or EnableFrames == false) then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = GetControl('ZO_RaidUnitFramegroup'..groupSlot)
				fs:SetAnchor(BOTTOMLEFT, control, BOTTOMLEFT, rX, rY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			end
		end
--]]
		if FTC_VARS then -- Foundry Tactical support
			local EnableFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].EnableFrames
			local RaidFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].RaidFrames
			local GroupFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].GroupFrames
			if groupSize <= 4 and (EnableFrames == true and GroupFrames == true) then
				local control = GetControl('FTC_GroupFrame'..s..'_Class')
				fs:SetAnchor(LEFT, control, RIGHT, gX, gY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize >= 5 and (EnableFrames == true and RaidFrames == true) then
				local control = GetControl('FTC_RaidFrame'..s)
				fs:SetAnchor(BOTTOM, control, BOTTOM, rX, rY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize <= 4 and (EnableFrames == false or GroupFrames == false) then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = GetControl('ZO_GroupUnitFramegroup'..groupSlot..'Name')
				fs:SetAnchor(BOTTOMLEFT, control, TOPLEFT, gX, gY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize >= 5 and (RaidFrames == false or EnableFrames == false) then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = GetControl('ZO_RaidUnitFramegroup'..groupSlot)
				fs:SetAnchor(BOTTOMLEFT, control, BOTTOMLEFT, rX, rY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			end
		end

		if not FTC_VARS then -- standard group or raid frames
			if groupSize <= 4 then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = GetControl('ZO_GroupUnitFramegroup'..groupSlot..'Name')
				fs:SetAnchor(BOTTOMLEFT, control, TOPLEFT, gX, gY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			elseif groupSize >= 5 then
				local groupSlot = tostring(tostring(GetGroupUnitTagByIndex(s)):gsub("%a",''))
				local control = GetControl('ZO_RaidUnitFramegroup'..groupSlot)
				fs:SetAnchor(BOTTOMLEFT, control, BOTTOMLEFT, rX, rY)
				Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame)
				return
			end
		end
	end

	function Srendarr.OnGroupChanged()
		Srendarr.groupUnits = {}
		local auraLookup = Srendarr.auraLookup
		local GetGameTimeMillis = GetGameTimeMilliseconds

		if not Srendarr.GroupEnabled then return end -- abort if unsupported group frame detected

		for g = 1, 24 do -- clear auras when group changes to avoid floating remnants
			local unit = "group" .. tostring(g)	
			for aura, ability in pairs(auraLookup[unit]) do
				ability:SetExpired()
				ability:Release()
			end
		end

		if IsUnitGrouped("player") then
			local groupSize = GetGroupSize()
			for s = 1, groupSize do
				local frame = s + 10
				local unitTag = GetGroupUnitTagByIndex(s)
				local numAuras = GetNumBuffs(unitTag)
				Srendarr.groupUnits[unitTag] = {index = s + 199} -- store the group frame order
				Srendarr.AnchorGroupFrames(groupSize, s, numAuras, unitTag, frame)
			end
		end
	end
end


-- ------------------------
-- SLOTTED ABILITY DATA HANDLING
-- ------------------------
do
	local GetSlotBoundId		= GetSlotBoundId
	local GetAbilityName		= GetAbilityName
	local GetAbilityCastInfo	= GetAbilityCastInfo
	local GetAbilityIcon		= GetAbilityIcon
	local procAbilityNames		= Srendarr.procAbilityNames

	local abilityID, abilityName, slotData, isChannel, castTime, channelTime

	function Srendarr.OnActionSlotsFullUpdate()
		for slot = 3, 8 do
			Srendarr.OnActionSlotUpdated(nil, slot)
		end
	end

	function Srendarr.OnActionSlotUpdated(evt, slot)
		if (slot < 3 or slot > 8) then return end -- abort if not a main ability (or ultimate)

		abilityID	= GetSlotBoundId(slot)
		slotData	= Srendarr.slotData[slot]

		if slotData.abilityID == abilityID then return end -- nothing has changed, abort

		abilityName				= GetAbilityName(abilityID)

		slotData.abilityID		= abilityID
		slotData.abilityName	= abilityName
		slotData.abilityIcon	= GetAbilityIcon(abilityID)

		isChannel, castTime, channelTime = GetAbilityCastInfo(abilityID)

		if (castTime > 0 or channelTime > 0) then
			slotData.isDelayed		= true			-- check for needing a cast bar
			slotData.isChannel		= isChannel
			slotData.castTime		= castTime
			slotData.channelTime	= channelTime
		else
			slotData.isDelayed		= false
		end

		if (procAbilityNames[abilityName]) then -- this is currently a proc'd ability (or special case for crystal fragments)
			Srendarr:ProcAnimationStart(slot)
		elseif slot ~= 8 then -- cannot have procs on ultimate slot
			Srendarr:ProcAnimationStop(slot)
		end
	end
end


-- ------------------------
-- BLACKLIST AND PROMINENT AURAS CONTROL
do ------------------------
	local STR_PROMBYID			= Srendarr.STR_PROMBYID
	local STR_PROMBYID2			= Srendarr.STR_PROMBYID2
	local STR_BLOCKBYID			= Srendarr.STR_BLOCKBYID
	local STR_DEBUFFBYID		= Srendarr.STR_DEBUFFBYID
	local STR_DEBUFFBYID2		= Srendarr.STR_DEBUFFBYID2
	local STR_GROUPBYID			= Srendarr.STR_GROUPBYID
	
	local DoesAbilityExist		= DoesAbilityExist
	local GetAbilityName		= GetAbilityName
	local GetAbilityDuration	= GetAbilityDuration
	local GetAbilityDescription	= GetAbilityDescription
	local IsAbilityPassive		= IsAbilityPassive

	local fakeAuras				= Srendarr.fakeAuras
	local specialNames			= Srendarr.specialNames
	local fakeAuras				= Srendarr.fakeAuras
	local matchedIDs			= {}

	function Srendarr:RemoveAltProminent(auraName, list, listFormat, mode)
		local removed = 0
		local checkID = 0
		local string1
		local string2
		local var1
		local var2

		if mode == 1 then
			string1 = STR_PROMBYID
			string2 = STR_PROMBYID2
			var1 = self.db.prominentWhitelist
			var2 = self.db.prominentWhitelist2
		else
			string1 = STR_DEBUFFBYID
			string2 = STR_DEBUFFBYID2
			var1 = self.db.debuffWhitelist
			var2 = self.db.debuffWhitelist2
		end

		if listFormat == 1 then
			checkID = zo_strformat("<<t:1>>",GetAbilityName(tostring(auraName)))
		end

		if list == 1 then
			if (var1[string1]) then
				for k, v in pairs(var1[string1]) do
					if zo_strformat("<<t:1>>",GetAbilityName(k)) == auraName then
						var1[string1][k] = nil
						removed = removed + 1
					end
				end
			end
			if (var1[string1]) and (var1[string1][auraName]) then
				var1[string1][auraName] = nil
				removed = removed + 1
			end
			if (var1[auraName]) then
				for id in pairs(var1[auraName]) do
					var1[auraName][id] = nil
				end
				var1[auraName] = nil
				removed = removed + 1
			end
			if checkID ~= 0 then
				if (var1[checkID]) then
					for id in pairs(var1[checkID]) do
						var1[checkID][id] = nil
					end
					var1[checkID] = nil
					removed = removed + 1
				end
			end
			if removed > 0 then
				if mode == 1 then
					Srendarr:PopulateProminentAurasDropdown()
					Srendarr:PopulateProminentAurasDropdown2()
				else
					Srendarr:PopulateTargetDebuffDropdown()
					Srendarr:PopulateTargetDebuffDropdown2()
				end
			end
		elseif list == 2 then 
			if (var2[string2]) then
				for k, v in pairs(var2[string2]) do
					if zo_strformat("<<t:1>>",GetAbilityName(k)) == auraName then
						var2[string2][k] = nil
						removed = removed + 1
					end
				end
			end
			if (var2[string2]) and (var2[string2][auraName]) then
				var2[string2][auraName] = nil
				removed = removed + 1
			end
			if (var2[auraName]) then
				for id in pairs(var2[auraName]) do
					var2[auraName][id] = nil
				end
				var2[auraName] = nil
				removed = removed + 1
			end
			if checkID ~= 0 then
				if (var2[checkID]) then
					for id in pairs(var2[checkID]) do
						var2[checkID][id] = nil
					end
					var2[checkID] = nil
					removed = removed + 1
				end
			end
			if removed > 0 then
				if mode == 1 then
					Srendarr:PopulateProminentAurasDropdown()
					Srendarr:PopulateProminentAurasDropdown2()
				else
					Srendarr:PopulateTargetDebuffDropdown()
					Srendarr:PopulateTargetDebuffDropdown2()
				end
			end
		end
	end

	function Srendarr:FindIDByName(auraName, stage, list)
		local tempInt = (stage == 1) and 0 or 1
		local IdLow = (50000 * stage) - 50000
		local IdHigh = 50000 * stage
		IdLow = (IdLow > 0) and IdLow or 1
		local compareName

		if stage == 1 then
			for i in pairs(matchedIDs) do
				matchedIDs[i] = nil -- reset matches
			end
			if (fakeAuras[auraName]) then -- a fake aura exists for this ability, add its ID
				local abilityID = fakeAuras[auraName].abilityID
				table.insert(matchedIDs, abilityID)
			end
		end

		for i = IdLow, IdHigh do
			local cId = i+tempInt
			if (DoesAbilityExist(cId) and (GetAbilityDuration(cId) > 0 and not IsAbilityPassive(cId))) then
				compareName = (specialNames[cId] ~= nil) and zo_strformat("<<t:1>>",specialNames[cId].name) or zo_strformat("<<t:1>>",GetAbilityName(cId))
				if compareName == auraName then -- matching ability with a duration (no toggles or passives in prominence)
					table.insert(matchedIDs, cId)
				end
			end
			if i == IdHigh then
				if stage == 3 then
					if list == 1 then
						if next(matchedIDs) ~= nil then -- matches were found
					--	if #matchedIDs > 0 then -- matches were found
							Srendarr:RemoveAltProminent(auraName, 2, 0, 1) -- Can't add same ability to both prominent lists
							Srendarr.db.prominentWhitelist[auraName] = {} -- add a new whitelist entry
							for _, id in ipairs(matchedIDs) do
								Srendarr.db.prominentWhitelist[auraName][id] = true
							end
							Srendarr:ConfigureAuraHandler() -- update handler ref
							Srendarr:PopulateProminentAurasDropdown()
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddSuccess)) -- inform user of successful addition
						else
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
						end
					elseif list == 2 then
						if next(matchedIDs) ~= nil then -- matches were found
					--	if #matchedIDs > 0 then -- matches were found
							Srendarr:RemoveAltProminent(auraName, 1, 0, 1) -- Can't add same ability to both prominent lists
							self.db.prominentWhitelist2[auraName] = {} -- add a new whitelist entry
							for _, id in ipairs(matchedIDs) do
								self.db.prominentWhitelist2[auraName][id] = true
							end
							Srendarr:ConfigureAuraHandler() -- update handler ref
							Srendarr:PopulateProminentAurasDropdown2()
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddSuccess2)) -- inform user of successful addition
						else
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
						end
					elseif list == 3 then
						if next(matchedIDs) ~= nil then -- matches were found
					--	if (#matchedIDs > 0) then -- matches were found
							Srendarr:RemoveAltProminent(auraName, 2, 0, 2) -- Can't add same ability to both prominent lists
							self.db.debuffWhitelist[auraName] = {} -- add a new whitelist entry
							for _, id in ipairs(matchedIDs) do
								self.db.debuffWhitelist[auraName][id] = true
							end
							Srendarr:ConfigureAuraHandler() -- update handler ref
							Srendarr:PopulateTargetDebuffDropdown()
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraAddSuccess)) -- inform user of successful addition
						else
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
						end
					elseif list == 4 then
						if next(matchedIDs) ~= nil then -- matches were found
					--	if (#matchedIDs > 0) then -- matches were found
							Srendarr:RemoveAltProminent(auraName, 1, 0, 2) -- Can't add same ability to both prominent lists
							self.db.debuffWhitelist2[auraName] = {} -- add a new whitelist entry
							for _, id in ipairs(matchedIDs) do
								self.db.debuffWhitelist2[auraName][id] = true
							end
							Srendarr:ConfigureAuraHandler() -- update handler ref
							Srendarr:PopulateTargetDebuffDropdown2()
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraAddSuccess2)) -- inform user of successful addition
						else
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
						end
					elseif list == 5 then
						if next(matchedIDs) ~= nil then -- matches were found
					--	if (#matchedIDs > 0) then -- matches were found
							self.db.groupWhitelist[auraName] = {} -- add a new whitelist entry
							for _, id in ipairs(matchedIDs) do
								self.db.groupWhitelist[auraName][id] = true
							end
							Srendarr:ConfigureAuraHandler() -- update handler ref
							Srendarr:PopulateGroupAurasDropdown()
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraAddSuccess)) -- inform user of successful addition
						else
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
						end
					elseif list == 6 then
						if next(matchedIDs) ~= nil then -- matches were found
					--	if (#matchedIDs > 0) then -- matches were found
							self.db.blacklist[auraName] = {} -- add a new blacklist entry
							for _, id in ipairs(matchedIDs) do
								self.db.blacklist[auraName][id] = true
							end
							Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
							Srendarr:PopulateBlacklistAurasDropdown()
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraAddSuccess)) -- inform user of successful addition
						else
							CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraAddFail)) -- inform user of failed addition
						end
					end
					return 
				else
					zo_callLater(function() Srendarr:FindIDByName(auraName, stage+1, list) end, 500)
					return
				end
			end
		end
	end

	function Srendarr:ProminentAuraAdd(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < 250000 and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the prominence whitelist
				Srendarr:RemoveAltProminent(auraName, 2, 1, 1) -- Can't add same ability to both prominent lists
				if (not self.db.prominentWhitelist[STR_PROMBYID]) then
					self.db.prominentWhitelist[STR_PROMBYID] = {} -- ensure the by ID table is present
				end
				self.db.prominentWhitelist[STR_PROMBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, GetAbilityName(auraName), L.Prominent_AuraAddSuccess)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.prominentWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 1)
		end
	end

	function Srendarr:ProminentAuraAdd2(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < 250000 and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the prominence whitelist
				Srendarr:RemoveAltProminent(auraName, 1, 1, 1) -- Can't add same ability to both prominent lists
				if (not self.db.prominentWhitelist2[STR_PROMBYID2]) then
					self.db.prominentWhitelist2[STR_PROMBYID2] = {} -- ensure the by ID table is present
				end
				self.db.prominentWhitelist2[STR_PROMBYID2][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, GetAbilityName(auraName), L.Prominent_AuraAddSuccess2)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.prominentWhitelist2[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 2)
		end
	end

	function Srendarr:ProminentDebuffAdd(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < 250000 and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the debuff whitelist
				Srendarr:RemoveAltProminent(auraName, 2, 1, 2) -- Can't add same ability to both prominent lists
				if (not self.db.debuffWhitelist[STR_DEBUFFBYID]) then
					self.db.debuffWhitelist[STR_DEBUFFBYID] = {} -- ensure the by ID table is present
				end
				self.db.debuffWhitelist[STR_DEBUFFBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, GetAbilityName(auraName), L.Debuff_AuraAddSuccess)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.debuffWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 3)
		end
	end

	function Srendarr:ProminentDebuffAdd2(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < 250000 and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the debuff whitelist
				Srendarr:RemoveAltProminent(auraName, 1, 1, 2) -- Can't add same ability to both prominent lists
				if (not self.db.debuffWhitelist2[STR_DEBUFFBYID2]) then
					self.db.debuffWhitelist2[STR_DEBUFFBYID2] = {} -- ensure the by ID table is present
				end
				self.db.debuffWhitelist2[STR_DEBUFFBYID2][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, GetAbilityName(auraName), L.Debuff_AuraAddSuccess2)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.debuffWhitelist2[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 4)
		end
	end

	function Srendarr:GroupWhitelistAdd(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_GROUPBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < 250000 and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the group whitelist
				if (not self.db.groupWhitelist[STR_GROUPBYID]) then
					self.db.groupWhitelist[STR_GROUPBYID] = {} -- ensure the by ID table is present
				end
				self.db.groupWhitelist[STR_GROUPBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, GetAbilityName(auraName), L.Group_AuraAddSuccess)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.groupWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 5)
		end
	end

	function Srendarr:BlacklistAuraAdd(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_BLOCKBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < 250000) then -- sanity check on the ID given
				if (not self.db.blacklist[STR_BLOCKBYID]) then
					self.db.blacklist[STR_BLOCKBYID] = {} -- ensure the by ID table is present
				end
				self.db.blacklist[STR_BLOCKBYID][auraName] = true
				Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, GetAbilityName(auraName), L.Blacklist_AuraAddSuccess)) -- inform user of successful addition
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Blacklist_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.blacklist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 6)
		end
	end

	function Srendarr:ProminentAuraRemove(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.prominentWhitelist[STR_PROMBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.prominentWhitelist[STR_PROMBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.prominentWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.prominentWhitelist[auraName]) do
				self.db.prominentWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.prominentWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved)) -- inform user of removal
		end
	end

	function Srendarr:ProminentAuraRemove2(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.prominentWhitelist2[STR_PROMBYID2][auraName]) then -- ID is in list, remove and inform user
				self.db.prominentWhitelist2[STR_PROMBYID2][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved2)) -- inform user of removal
			end
		else
			if (not self.db.prominentWhitelist2[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.prominentWhitelist2[auraName]) do
				self.db.prominentWhitelist2[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.prominentWhitelist2[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved2)) -- inform user of removal
		end
	end

	function Srendarr:ProminentDebuffRemove(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.debuffWhitelist[STR_DEBUFFBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.debuffWhitelist[STR_DEBUFFBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.debuffWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.debuffWhitelist[auraName]) do
				self.db.debuffWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.debuffWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved)) -- inform user of removal
		end
	end

	function Srendarr:ProminentDebuffRemove2(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.debuffWhitelist2[STR_DEBUFFBYID2][auraName]) then -- ID is in list, remove and inform user
				self.db.debuffWhitelist2[STR_DEBUFFBYID2][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved2)) -- inform user of removal
			end
		else
			if (not self.db.debuffWhitelist2[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.debuffWhitelist2[auraName]) do
				self.db.debuffWhitelist2[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.debuffWhitelist2[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved2)) -- inform user of removal
		end
	end

	function Srendarr:GroupAuraRemove(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_GROUPBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.groupWhitelist[STR_GROUPBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.groupWhitelist[STR_GROUPBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.groupWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.groupWhitelist[auraName]) do
				self.db.groupWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.groupWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraRemoved)) -- inform user of removal
		end
	end

	function Srendarr:BlacklistAuraRemove(auraName)
		auraName = zo_strformat("<<t:1>>",auraName) -- strip out any control characters player may have entered
		if auraName == STR_BLOCKBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.blacklist[STR_BLOCKBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.blacklist[STR_BLOCKBYID][auraName] = nil
				Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.blacklist[auraName]) then return end -- not in blacklist, abort
			for id in pairs(self.db.blacklist[auraName]) do
				self.db.blacklist[auraName][id] = nil -- clean out blacklist entry
			end
			self.db.blacklist[auraName] = nil -- remove blacklist entrys
			Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraRemoved)) -- inform user of removal
		end
	end
end


-- ------------------------
-- UI HELPER FUNCTIONS
-- ------------------------
do
	local math_abs				= math.abs
	local WM					= WINDOW_MANAGER

	function Srendarr:GetEdgeRelativePosition(object)
		local left, top     = object:GetLeft(),		object:GetTop()
		local right, bottom = object:GetRight(),	object:GetBottom()
		local rootW, rootH  = GuiRoot:GetWidth(),	GuiRoot:GetHeight()
		local point         = 0
		local x, y

		if (left < (rootW - right) and left < math_abs((left + right) / 2 - rootW / 2)) then
			x, point = left, 2 -- 'LEFT'
		elseif ((rootW - right) < math_abs((left + right) / 2 - rootW / 2)) then
			x, point = right - rootW, 8 -- 'RIGHT'
		else
			x, point = (left + right) / 2 - rootW / 2, 0
		end

		if (bottom < (rootH - top) and bottom < math_abs((bottom + top) / 2 - rootH / 2)) then
			y, point = top, point + 1 -- 'TOP|TOPLEFT|TOPRIGHT'
		elseif ((rootH - top) < math_abs((bottom + top) / 2 - rootH / 2)) then
			y, point = bottom - rootH, point + 4 -- 'BOTTOM|BOTTOMLEFT|BOTTOMRIGHT'
		else
			y = (bottom + top) / 2 - rootH / 2
		end

		point = (point == 0) and 128 or point -- 'CENTER'
		return point, x, y
	end

	function Srendarr.AddControl(parent, cType, level)
		local c = WM:CreateControl(nil, parent, cType)
		c:SetDrawLayer(DL_OVERLAY)
		c:SetDrawLevel(level)
		return c, c
	end

	function Srendarr:GetGroupRaidTab()
		local groupSize = GetGroupSize()
		if groupSize <= 4 then
			return 11
		elseif groupSize >= 5 then
			return 12
		end
	end

	function Srendarr:HideInMenus() -- hide auras in menus except the move mouse cursor mode (Phinix)
		local hudScene = SCENE_MANAGER:GetScene("hud")
		hudScene:RegisterCallback("StateChange", function(oldState, newState)
			if newState == SCENE_HIDDEN and SCENE_MANAGER:GetNextScene():GetName() ~= "hudui" then
				Srendarr.uiHidden = true
				for i = 1, #Srendarr.db.displayFrames do
					if Srendarr.displayFrames[i] ~= nil then
						Srendarr.displayFrames[i]:SetHidden(true)
					end	
				end
			end
			if newState == SCENE_SHOWING then
				Srendarr.uiHidden = false
				if Srendarr.uiLocked == true then
					Srendarr.OnPlayerActivatedAlive(true)
				end

				for i = 1, #Srendarr.db.displayFrames do
					if Srendarr.displayFrames[i] ~= nil then
						Srendarr.displayFrames[i]:SetHidden(false)
					end
				end
			end
		end)
	end
end


EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ADD_ON_LOADED, Srendarr.OnInitialize)
