local Srendarr		= _G['Srendarr'] -- grab addon table from global
local L				= Srendarr:GetLocale()

-- CONSTS --
local ABILITY_TYPE_CHANGEAPPEARANCE	= ABILITY_TYPE_CHANGEAPPEARANCE
local BUFF_EFFECT_TYPE_DEBUFF		= BUFF_EFFECT_TYPE_DEBUFF

local GROUP_START_FRAME				= Srendarr.GROUP_START_FRAME
local GROUP_END_FRAME				= Srendarr.GROUP_END_FRAME

local GROUP_PLAYER_SHORT			= Srendarr.GROUP_PLAYER_SHORT
local GROUP_PLAYER_LONG				= Srendarr.GROUP_PLAYER_LONG
local GROUP_PLAYER_TOGGLED			= Srendarr.GROUP_PLAYER_TOGGLED
local GROUP_PLAYER_PASSIVE			= Srendarr.GROUP_PLAYER_PASSIVE
local GROUP_PLAYER_DEBUFF			= Srendarr.GROUP_PLAYER_DEBUFF
local GROUP_PLAYER_GROUND			= Srendarr.GROUP_PLAYER_GROUND
local GROUP_PLAYER_MAJOR			= Srendarr.GROUP_PLAYER_MAJOR
local GROUP_PLAYER_MINOR			= Srendarr.GROUP_PLAYER_MINOR
local GROUP_PLAYER_ENCHANT			= Srendarr.GROUP_PLAYER_ENCHANT
local GROUP_PLAYER_GEAR				= Srendarr.GROUP_PLAYER_GEAR
local GROUP_TARGET_BUFF				= Srendarr.GROUP_TARGET_BUFF
local GROUP_TARGET_DEBUFF			= Srendarr.GROUP_TARGET_DEBUFF
local GROUP_PROMINENT				= Srendarr.GROUP_PROMINENT
local GROUP_PROMINENT2				= Srendarr.GROUP_PROMINENT2
local GROUP_PROMDEBUFFS				= Srendarr.GROUP_PROMDEBUFFS
local GROUP_PROMDEBUFFS2			= Srendarr.GROUP_PROMDEBUFFS2
local GROUP_CDTRACKER				= Srendarr.GROUP_CDTRACKER
local GROUP_GROUP1					= Srendarr.GROUP_GROUP1
local GROUP_GROUP2					= Srendarr.GROUP_GROUP2
local GROUP_GROUP3					= Srendarr.GROUP_GROUP3
local GROUP_GROUP4					= Srendarr.GROUP_GROUP4
local GROUP_GROUP5					= Srendarr.GROUP_GROUP5
local GROUP_GROUP6					= Srendarr.GROUP_GROUP6
local GROUP_GROUP7					= Srendarr.GROUP_GROUP7
local GROUP_GROUP8					= Srendarr.GROUP_GROUP8
local GROUP_GROUP9					= Srendarr.GROUP_GROUP9
local GROUP_GROUP10					= Srendarr.GROUP_GROUP10
local GROUP_GROUP11					= Srendarr.GROUP_GROUP11
local GROUP_GROUP12					= Srendarr.GROUP_GROUP12
local GROUP_GROUP13					= Srendarr.GROUP_GROUP13
local GROUP_GROUP14					= Srendarr.GROUP_GROUP14
local GROUP_GROUP15					= Srendarr.GROUP_GROUP15
local GROUP_GROUP16					= Srendarr.GROUP_GROUP16
local GROUP_GROUP17					= Srendarr.GROUP_GROUP17
local GROUP_GROUP18					= Srendarr.GROUP_GROUP18
local GROUP_GROUP19					= Srendarr.GROUP_GROUP19
local GROUP_GROUP20					= Srendarr.GROUP_GROUP20
local GROUP_GROUP21					= Srendarr.GROUP_GROUP21
local GROUP_GROUP22					= Srendarr.GROUP_GROUP22
local GROUP_GROUP23					= Srendarr.GROUP_GROUP23
local GROUP_GROUP24					= Srendarr.GROUP_GROUP24

local AURA_TYPE_TIMED				= Srendarr.AURA_TYPE_TIMED
local AURA_TYPE_TOGGLED				= Srendarr.AURA_TYPE_TOGGLED
local AURA_TYPE_PASSIVE				= Srendarr.AURA_TYPE_PASSIVE
local DEBUFF_TYPE_PASSIVE			= Srendarr.DEBUFF_TYPE_PASSIVE
local DEBUFF_TYPE_TIMED				= Srendarr.DEBUFF_TYPE_TIMED

-- UPVALUES --
local GetGameTimeMillis				= GetGameTimeMilliseconds
local IsToggledAura					= Srendarr.IsToggledAura
local IsMajorEffect					= Srendarr.IsMajorEffect	-- technically only used for major|minor buffs on the player, major|minor debuffs
local IsMinorEffect					= Srendarr.IsMinorEffect	-- are filtered to the debuff grouping before being checked for
local IsEnchantProc					= Srendarr.IsEnchantProc
local IsGearProc					= Srendarr.IsGearProc
local IsAlternateAura				= Srendarr.IsAlternateAura
local auraLookup					= Srendarr.auraLookup
local filteredAuras					= Srendarr.filteredAuras
local trackTargets					= {}
local prominentAuras				= {}
local prominentAuras2				= {}
local prominentDebuffs				= {}
local prominentDebuffs2				= {}
local groupAuras					= {}
local displayFrameRef				= {}
local debugAuras					= {}
local playerName = zo_strformat("<<t:1>>",GetUnitName('player'))
local shortBuffThreshold, passiveEffectsAsPassive, filterDisguisesOnPlayer, filterDisguisesOnTarget


-- ------------------------
-- HELPER FUNCTIONS
-- ------------------------
local displayFrameFake = {
	['AddAuraToDisplay'] = function()
 		-- do nothing : used to make the AuraHandler code more manageable, redirects unwanted auras to nil
	end,
}

local groupFrames = {
	[1] = {frame = GROUP_GROUP1},
	[2] = {frame = GROUP_GROUP2},
	[3] = {frame = GROUP_GROUP3},
	[4] = {frame = GROUP_GROUP4},
	[5] = {frame = GROUP_GROUP5},
	[6] = {frame = GROUP_GROUP6},
	[7] = {frame = GROUP_GROUP7},
	[8] = {frame = GROUP_GROUP8},
	[9] = {frame = GROUP_GROUP9},
	[10] = {frame = GROUP_GROUP10},
	[11] = {frame = GROUP_GROUP11},
	[12] = {frame = GROUP_GROUP12},
	[13] = {frame = GROUP_GROUP13},
	[14] = {frame = GROUP_GROUP14},
	[15] = {frame = GROUP_GROUP15},
	[16] = {frame = GROUP_GROUP16},
	[17] = {frame = GROUP_GROUP17},
	[18] = {frame = GROUP_GROUP18},
	[19] = {frame = GROUP_GROUP19},
	[20] = {frame = GROUP_GROUP20},
	[21] = {frame = GROUP_GROUP21},
	[22] = {frame = GROUP_GROUP22},
	[23] = {frame = GROUP_GROUP23},
	[24] = {frame = GROUP_GROUP24},
}


-- ------------------------
-- AURA HANDLER
-- ------------------------
local function AuraHandler(flagBurst, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, castByPlayer, stacks)
	local groupBlacklist = Srendarr.db.filtersGroup.groupBlacklist
	local IsGroupUnit = Srendarr.IsGroupUnit
	local IsTrackedCooldown = Srendarr.IsTrackedCooldown
	local abilityCooldowns = Srendarr.abilityCooldowns
	local groupUnits = Srendarr.groupUnits
	local nStacks = (stacks ~= nil) and stacks or 0
	local nilCheck = (abilityId ~= nil) and abilityId or 0
	local abilityOffset = (castByPlayer == 1) and nilCheck - 1000000 or ((castByPlayer == 2) and nilCheck - 2000000 or nilCheck)
	local minTime = 2.00

	if (start ~= finish and (finish - start) < minTime) then return end -- abort showing any timed auras with a duration of < minTime seconds

	if nilCheck > 0 then

		if filteredAuras[unitTag] ~= nil then -- abort immediately if this is an ability we've filtered and not whitelisted
			if (filteredAuras[unitTag][abilityOffset]) then
				if (prominentAuras[abilityOffset] == nil and prominentAuras2[abilityOffset] == nil and prominentDebuffs[abilityOffset] == nil and prominentDebuffs2[abilityOffset] == nil) then
					return
				end
			end
		end

		-- Send proc to cooldown tracker separate from ability tracking (Phinix)
		if (IsTrackedCooldown(abilityOffset)) then
			if (auraLookup[unitTag][abilityOffset+4000000]) then return end -- abort if cooldown present, fixes duplicate aura bugs (Phinix)
			if (castByPlayer == 1) then -- only track player's proc cooldowns to avoid giant mess (Phinix)
				if Srendarr.db.auraGroups[GROUP_CDTRACKER] ~= 0 then -- only process if frame is actually assigned/shown (Phinix)
					auraName = (abilityCooldowns[abilityOffset].altName ~= nil) and GetAbilityName(abilityCooldowns[abilityOffset].altName) or auraName
					displayFrameRef[GROUP_CDTRACKER]:AddAuraToDisplay(flagBurst, GROUP_CDTRACKER, AURA_TYPE_TIMED, auraName..' '..L.Group_Cooldown, unitTag, start, start+abilityCooldowns[abilityOffset].cooldown, icon, effectType, abilityType, abilityOffset+4000000, nStacks)
				end
			end
			unitTag = abilityCooldowns[abilityOffset].unitTag -- swap proc abilities to ground AOE where appropriate (Phinix)
			if unitTag == 'reticleover' then effectType = BUFF_EFFECT_TYPE_DEBUFF end -- if timed effect is on target switch to debuff (Phinix)
			if (not abilityCooldowns[abilityOffset].hasTimer) then return end -- avoid sending non-timer procs to handler (Phinix)
		end

		-- Aura exists, update its data (assume would not exist unless passed filters earlier)
		if (auraLookup[unitTag][abilityId]) then
			if (unitTag == 'player') then
				auraLookup[unitTag][abilityId]:Update(start, finish, nStacks) -- Pass stack info for player auras that track them (Phinix)
			elseif IsGroupUnit(unitTag) then
				if Srendarr.GroupEnabled then auraLookup[unitTag][abilityId]:Update(start, finish) else return end
			else
				auraLookup[unitTag][abilityId]:Update(start, finish)
			end
			return
		end

		-- Prominent aura detected, assign to appropriate window
		if (prominentAuras[abilityOffset]) then
			if (unitTag ~= 'reticleover' and not IsGroupUnit(unitTag)) then
				if Srendarr.db.auraGroups[GROUP_PROMINENT] ~= 0 then -- allow prominent buffs to go to normal frames if prominent 1 not assigned to a window (Phinix)
					displayFrameRef[GROUP_PROMINENT]:AddAuraToDisplay(flagBurst, GROUP_PROMINENT, (start == finish) and AURA_TYPE_PASSIVE or AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					return
				end
			end
		end
		if (prominentAuras2[abilityOffset]) then
			if (unitTag ~= 'reticleover' and not IsGroupUnit(unitTag)) then
				if Srendarr.db.auraGroups[GROUP_PROMINENT2] ~= 0 then -- allow prominent buffs to go to normal frames if prominent 2 not assigned to a window (Phinix)
					displayFrameRef[GROUP_PROMINENT2]:AddAuraToDisplay(flagBurst, GROUP_PROMINENT2, (start == finish) and AURA_TYPE_PASSIVE or AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					return
				end
			end
		end
		if (prominentDebuffs[abilityOffset]) and unitTag == 'reticleover' then
			if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] ~= 0 and effectType == BUFF_EFFECT_TYPE_DEBUFF) then -- ignore non-debuff whitelist entries
				displayFrameRef[GROUP_PROMDEBUFFS]:AddAuraToDisplay(flagBurst, GROUP_PROMDEBUFFS, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				return -- allow prominent debuffs to go to normal frames if prominent not assigned to a window (Phinix)
			end
		end
		if (prominentDebuffs2[abilityOffset]) and unitTag == 'reticleover' then
			if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] ~= 0 and effectType == BUFF_EFFECT_TYPE_DEBUFF) then -- ignore non-debuff whitelist entries
				displayFrameRef[GROUP_PROMDEBUFFS2]:AddAuraToDisplay(flagBurst, GROUP_PROMDEBUFFS2, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				return -- allow prominent debuffs to go to normal frames if prominent not assigned to a window (Phinix)
			end
		end
	
		if (unitTag == 'reticleover') then -- new aura on target
			if (effectType == BUFF_EFFECT_TYPE_DEBUFF) then
				-- debuff on target, check for it being a passive (not sure they can be, but just to be sure as things break with a 'timed' passive)
				displayFrameRef[GROUP_TARGET_DEBUFF]:AddAuraToDisplay(flagBurst, GROUP_TARGET_DEBUFF, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
			else
				-- buff on target, sort as passive, toggle or timed and add
				if (filterDisguisesOnTarget and abilityType == ABILITY_TYPE_CHANGEAPPEARANCE) then return end -- is a disguise and they are filtered
	
				if (start == finish) then -- toggled or passive
					displayFrameRef[GROUP_TARGET_BUFF]:AddAuraToDisplay(flagBurst, GROUP_TARGET_BUFF, (IsToggledAura(abilityOffset)) and AURA_TYPE_TOGGLED or AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				else -- timed buff
					displayFrameRef[GROUP_TARGET_BUFF]:AddAuraToDisplay(flagBurst, GROUP_TARGET_BUFF, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				end
			end
		elseif (unitTag == 'player') then -- new aura on player
			if (effectType == BUFF_EFFECT_TYPE_DEBUFF) then
				-- debuff on player, check for it being a passive (not sure they can be, but just to be sure as things break with a 'timed' passive)
				displayFrameRef[GROUP_PLAYER_DEBUFF]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_DEBUFF, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
			else
				-- buff on player, sort as passive, toggled or timed and add
				if (filterDisguisesOnPlayer and abilityType == ABILITY_TYPE_CHANGEAPPEARANCE) then return end -- is a disguise and they are filtered
	
				if (start == finish) then -- toggled or passive
					if (IsMajorEffect(abilityOffset) and not passiveEffectsAsPassive) then -- major buff on player
						displayFrameRef[GROUP_PLAYER_MAJOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MAJOR, AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					elseif (IsMinorEffect(abilityOffset) and not passiveEffectsAsPassive) then -- minor buff on player
						displayFrameRef[GROUP_PLAYER_MINOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MINOR, AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					elseif (IsToggledAura(abilityOffset)) then -- toggled
						displayFrameRef[GROUP_PLAYER_TOGGLED]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_TOGGLED, AURA_TYPE_TOGGLED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					else -- passive, including passive major and minor effects, not seperated out before
						displayFrameRef[GROUP_PLAYER_PASSIVE]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_PASSIVE, AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					end
				else -- timed buff
					if (IsEnchantProc(abilityOffset)) then -- enchant proc on player
						displayFrameRef[GROUP_PLAYER_ENCHANT]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_ENCHANT, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					elseif ((IsGearProc(abilityOffset)) or (IsTrackedCooldown(abilityOffset))) then -- enchant proc on player
						displayFrameRef[GROUP_PLAYER_GEAR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_GEAR, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					elseif (IsMajorEffect(abilityOffset)) then -- major buff on player
						displayFrameRef[GROUP_PLAYER_MAJOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MAJOR, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					elseif (IsMinorEffect(abilityOffset)) then -- minor buff on player
						displayFrameRef[GROUP_PLAYER_MINOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MINOR, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					elseif ((finish - start) > shortBuffThreshold) then -- is considered a long duration buff
						displayFrameRef[GROUP_PLAYER_LONG]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_LONG, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					else
						displayFrameRef[GROUP_PLAYER_SHORT]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_SHORT, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					end
				end
			end
		elseif IsGroupUnit(unitTag) and groupUnits[unitTag] and Srendarr.GroupEnabled then -- new group aura detected, assign to appropriate window
			if (not groupBlacklist and groupAuras[abilityOffset]) or (groupBlacklist and not groupAuras[abilityOffset]) then
				local groupDuration = Srendarr.db.filtersGroup.groupDuration
				local groupThreshold = Srendarr.db.filtersGroup.groupThreshold
				local duration = finish - start

			--	if ((not groupDuration or duration <= groupThreshold) and duration ~= 0) then -- filter group by duration
				if (not groupDuration or duration <= groupThreshold) then -- filter group by duration
					local groupFrame = groupUnits[unitTag].index
					displayFrameRef[groupFrame]:AddAuraToDisplay(flagBurst, groupFrame, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				end
			end
		elseif (unitTag == 'groundaoe') then -- new ground aoe cast by player (assume always timed)
			displayFrameRef[GROUP_PLAYER_GROUND]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_GROUND, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
		end

	end
end

Srendarr.PassToAuraHandler = function(flagBurst, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, castByPlayer, stacks)
	AuraHandler(flagBurst, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, castByPlayer, stacks)
end

function Srendarr:ConfigureAuraHandler()
	for group, frameNum in pairs(self.db.auraGroups) do
		-- if a group is set to hidden, auras will be sent to a fake frame that does nothing (simplifies things)
		displayFrameRef[group] = (frameNum > 0) and self.displayFrames[frameNum] or displayFrameFake
	end

	shortBuffThreshold		= self.db.shortBuffThreshold
	passiveEffectsAsPassive	= self.db.passiveEffectsAsPassive
	filterDisguisesOnPlayer	= self.db.filtersPlayer.disguise
	filterDisguisesOnTarget	= self.db.filtersTarget.disguise

	for id in pairs(prominentAuras) do
		prominentAuras[id] = nil -- clean out prominent 1 auras list
	end

	for id in pairs(prominentAuras2) do
		prominentAuras2[id] = nil -- clean out prominent 2 auras list
	end

	for id in pairs(prominentDebuffs) do
		prominentDebuffs[id] = nil -- clean out prominent 1 debuff list
	end

	for id in pairs(prominentDebuffs2) do
		prominentDebuffs2[id] = nil -- clean out prominent 2 debuff list
	end

	for id in pairs(groupAuras) do
		groupAuras[id] = nil -- clean out group auras list
	end

	for _, abilityIds in pairs(self.db.prominentWhitelist) do
		for id in pairs(abilityIds) do
			prominentAuras[id] = true -- populate prominent 1 list from saved database
		end
	end

	for _, abilityIds in pairs(self.db.prominentWhitelist2) do
		for id in pairs(abilityIds) do
			prominentAuras2[id] = true -- populate prominent 2 list from saved database
		end
	end

	for _, abilityIds in pairs(self.db.debuffWhitelist) do
		for id in pairs(abilityIds) do
			prominentDebuffs[id] = true -- populate debuff list from saved database
		end
	end

	for _, abilityIds in pairs(self.db.debuffWhitelist2) do
		for id in pairs(abilityIds) do
			prominentDebuffs2[id] = true -- populate debuff list from saved database
		end
	end

	for _, abilityIds in pairs(self.db.groupWhitelist) do
		for id in pairs(abilityIds) do
			groupAuras[id] = true -- populate group list from saved database
		end
	end

end


-- ------------------------
-- EVENT: EVENT_PLAYER_ACTIVATED, EVENT_PLAYER_ALIVE
do ------------------------
    local GetNumBuffs       	= GetNumBuffs
    local GetUnitBuffInfo   	= GetUnitBuffInfo
    local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES

	local auraLookup			= Srendarr.auraLookup
	local alternateAura			= Srendarr.alternateAura
	local activeAuras			= {}
	local abilityOffset
	local sourceCast
	local numAuras
	local auraName, start, finish, icon, effectType, abilityType, abilityId, castByPlayer

	local function CheckGroupFunction()
		Srendarr.GroupEnabled = true
		-- LUI uses custom sorting which is currently not supported due to ZOS group indexing bug
		if LUIESV then
			local EnableFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames_Enabled
			local GroupFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames.CustomFramesGroup
			local RaidFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames.CustomFramesRaid
			if EnableFrames == true and (RaidFrames == true or GroupFrames == true) then
				Srendarr.GroupEnabled = false
			end
		end
		-- JoGroup uses custom sorting which is currently not supported due to ZOS group indexing bug
		if JoGroup then
			Srendarr.GroupEnabled = false
		end
		-- Initialize group buff support if passes above checks
		if Srendarr.GroupEnabled then
			Srendarr.OnGroupChanged()
		end
	end

	Srendarr.OnPlayerActivatedAlive = function(keepAuras)
		if not keepAuras then
			for _, auras in pairs(auraLookup) do -- iterate all aura lookups
				for _, aura in pairs(auras) do -- iterate all auras for each lookup
					aura:Release(true)
				end
			end
		end

		numAuras = GetNumBuffs('player')

		if numAuras > 0 then -- player has auras, scan and send to handle
			for i = 1, numAuras do
				auraName, start, finish, _, _, icon, _, effectType, abilityType, _, abilityId, _, castByPlayer = GetUnitBuffInfo('player', i)
				if (castByPlayer) then abilityOffset = abilityId + 1000000 else abilityOffset = abilityId + 2000000 end
				sourceCast = (castByPlayer) and 1 or 2

				
				table.insert(activeAuras, abilityOffset, true)

				if Srendarr.db.consolidateEnabled == true then -- Handles multi-aura passive abilities like Restoring Aura
					if (IsAlternateAura(abilityId)) then -- Consolidate multi-aura passive abilities
						AuraHandler(true, alternateAura[abilityId].altName, 'player', start, finish, icon, effectType, abilityType, abilityOffset, sourceCast)
					else
						AuraHandler(true, auraName, 'player', start, finish, icon, effectType, abilityType, abilityOffset, sourceCast)
					end
				else
					AuraHandler(true, auraName, 'player', start, finish, icon, effectType, abilityType, abilityOffset, sourceCast)
				end
			end
		end

		for k, v in pairs(auraLookup['player']) do -- remove any stuck passive auras (things like empowered fetcherflies that don't send end events when zoning)
			if not activeAuras[k] and v.start == v.finish then
				v:Release()
			end
		end

		for k, v in pairs(auraLookup['reticleover']) do -- clear target auras which no longer get end events when zoning
			v:Release()
		end

		for x = 1, NUM_DISPLAY_FRAMES do
			Srendarr.displayFrames[x]:UpdateDisplay() -- update the display for all frames
		end

		zo_callLater(CheckGroupFunction, 1000)

		activeAuras = {}
	end
end


-- ------------------------
-- EVENT: EVENT_PLAYER_DEAD
do ------------------------
    local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES

    local auraLookup			= Srendarr.auraLookup

	Srendarr.OnPlayerDead = function()
		for _, auras in pairs(auraLookup) do -- iterate all aura lookups
			for _, aura in pairs(auras) do -- iterate all auras for each lookup
				aura:Release(true)
			end
		end

		for x = 1, NUM_DISPLAY_FRAMES do
			Srendarr.displayFrames[x]:UpdateDisplay() -- update the display for all frames
		end
	end
end


-- ------------------------
-- EVENT: EVENT_PLAYER_COMBAT_STATE
do -----------------------
    local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES

    local displayFramesScene	= Srendarr.displayFramesScene

	OnCombatState = function(e, inCombat)
		if (inCombat) then
			if (Srendarr.db.combatDisplayOnly) then
				for x = 1, NUM_DISPLAY_FRAMES do
					displayFramesScene[x]:SetHiddenForReason('combatstate', false)
				end
			end
		else
			if (Srendarr.db.combatDisplayOnly) then
				for x = 1, NUM_DISPLAY_FRAMES do
					displayFramesScene[x]:SetHiddenForReason('combatstate', true)
				end
			end
		end
	end

	function Srendarr:ConfigureOnCombatState()
		if (self.db.combatDisplayOnly) then
			EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, OnCombatState)

			OnCombatState(nil, IsUnitInCombat('player')) -- force an update
		else
			EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE)

			if (self.displayFramesScene[1]:IsHiddenForReason('combatstate')) then -- if currently hidden due to setting, show
				for x = 1, NUM_DISPLAY_FRAMES do
					self.displayFramesScene[x]:SetHiddenForReason('combatstate', false)
				end
			end
		end
	end

	Srendarr.OnCombatState = OnCombatState
end


-- ------------------------
-- EVENT: EVENT_ACTION_SLOT_ABILITY_USED
do ------------------------
	local ABILITY_TYPE_NONE 	= ABILITY_TYPE_NONE		-- no fakes have any specifc ability type
	local BUFF_EFFECT_TYPE_BUFF = BUFF_EFFECT_TYPE_BUFF -- all fakes are buffs or gtaoe

	local GetGameTimeMillis		= GetGameTimeMilliseconds
	local GetLatency			= GetLatency

	local slotData				= Srendarr.slotData
	local fakeAuras				= Srendarr.fakeAuras
	local slotAbilityName, currentTime
	local abilityOffset

	Srendarr.OnActionSlotAbilityUsed = function(e, slotID)
		if (slotID < 3 or slotID > 8) then return end -- abort if not a main ability (or ultimate)

		slotAbilityName = slotData[slotID].abilityName

		if fakeAuras[slotAbilityName] == nil then return end -- no fake aura needed for this ability (majority case)

		local slotAbility = fakeAuras[slotAbilityName].abilityID
  		currentTime = GetGameTimeMillis() / 1000

		abilityOffset = (slotAbility ~= nil) and slotAbility or 0

		AuraHandler(
			false,
			slotAbilityName,
			fakeAuras[slotAbilityName].unitTag,
			currentTime,
			currentTime + fakeAuras[slotAbilityName].duration + (GetLatency() / 1000), -- + cooldown? GetSlotCooldownInfo(slotID)
			slotData[slotID].abilityIcon,
			BUFF_EFFECT_TYPE_BUFF,
			ABILITY_TYPE_NONE,
			abilityOffset,
			3
		)
	end

	function Srendarr:ConfigureOnActionSlotAbilityUsed()
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACTION_SLOT_ABILITY_USED,	Srendarr.OnActionSlotAbilityUsed)
	end
end


-- ------------------------
-- EVENT: EVENT_RETICLE_TARGET_CHANGED
do ------------------------
    local GetNumBuffs      			= GetNumBuffs
    local GetUnitBuffInfo  			= GetUnitBuffInfo
    local DoesUnitExist    			= DoesUnitExist
    local IsUnitDead				= IsUnitDead

	local alternateAura				= Srendarr.alternateAura
	local specialNames				= Srendarr.specialNames
	local fakeTargetDebuffs			= Srendarr.fakeTargetDebuffs
	local debuffAuras				= Srendarr.debuffAuras
	local auraLookupReticle			= Srendarr.auraLookup['reticleover'] -- local ref for speed, this functions expensive
	local targetDisplayFrame1		= false -- local refs to frames displaying target auras (if any)
	local targetDisplayFrame2		= false -- local refs to frames displaying target auras (if any)
	local hideOnDead				= false
	local currentTime
	local abilityOffset
	local numAuras
	local debuffSwitch
	local auraName, start, finish, icon, effectType, abilityType, abilityId, castByPlayer

	local function OnTargetChanged()
		local unitName = zo_strformat("<<t:1>>",GetUnitName('reticleover'))
		local sourceCast
		local nilCheck

		for _, aura in pairs(auraLookupReticle) do
			aura:Release(true) -- old auras cleaned out
		end

		if (DoesUnitExist('reticleover') and not (hideOnDead and IsUnitDead('reticleover'))) then -- have a target, scan for auras
			local function ActiveFakes() -- check for active fake debuffs (Phinix)
				local total = 0
				for k,v in pairs(fakeTargetDebuffs) do
					currentTime = GetGameTimeMillis() / 1000
					if trackTargets[k] ~= nil and trackTargets[k][unitName] ~= nil then
						if trackTargets[k][unitName] < currentTime then
							trackTargets[k][unitName] = nil -- clear expired targets from cache
						else
							total = total + 1
						end
					end
				end
				return total
			end

			numAuras = GetNumBuffs('reticleover') + ActiveFakes()

			if (numAuras > 0) then -- target has auras, scan and send to handler
				for k,v in pairs(fakeTargetDebuffs) do -- reassign still-existing fake debuffs on target (Phinix)
					currentTime = GetGameTimeMillis() / 1000
					if trackTargets[k] ~= nil and trackTargets[k][unitName] ~= nil then
						if trackTargets[k][unitName] > currentTime then
							AuraHandler(
								false,
								(specialNames[k] ~= nil) and specialNames[k].name or GetAbilityName(k),
								'reticleover',
								currentTime,
								trackTargets[k][unitName],
								fakeTargetDebuffs[k].icon,
								BUFF_EFFECT_TYPE_DEBUFF,
								ABILITY_TYPE_NONE,
								k,
								0
							)
						end
					end
				end

				for i = 1, numAuras do
					auraName, start, finish, _, _, icon, _, effectType, abilityType, _, abilityId, _, castByPlayer = GetUnitBuffInfo('reticleover', i)
					sourceCast = (castByPlayer) and 1 or 2
					nilCheck = (abilityId ~= nil) and abilityId or 0

					if (castByPlayer) then abilityOffset = nilCheck + 1000000 else abilityOffset = nilCheck + 2000000 end
					
					debuffSwitch = (debuffAuras[abilityId]) and BUFF_EFFECT_TYPE_DEBUFF or effectType -- fix for debuffs game tracks as buffs (Phinix)

					 -- option to only show player's debuffs on target (Phinix)
					if (debuffSwitch == BUFF_EFFECT_TYPE_DEBUFF and not castByPlayer) then
						if (prominentDebuffs[abilityId]) then
							if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] == 0 or Srendarr.db.filtersGroup.onlyPromPlayerDebuffs) then
								return
							end
						elseif (prominentDebuffs2[abilityId]) then
							if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] == 0 or Srendarr.db.filtersGroup.onlyPromPlayerDebuffs2) then
								return
							end
						elseif Srendarr.db.filtersTarget.onlyPlayerDebuffs then
							return
						end
					end

					if (Srendarr.db.consolidateEnabled == true and IsAlternateAura(abilityId) == true) then -- handles multi-aura passive abilities like restoring aura (Phinix)
						AuraHandler(true, alternateAura[abilityId].altName, 'reticleover', start, finish, icon, debuffSwitch, abilityType, abilityId, sourceCast)
					else
						AuraHandler(true, (specialNames[abilityId] ~= nil) and specialNames[abilityId].name or auraName, 'reticleover', start, finish, icon, debuffSwitch, abilityType, abilityOffset, sourceCast)
					end
				end
			end
		end

		-- no matter, update the display of the 1-2 frames displaying targets auras
		if (targetDisplayFrame1) then targetDisplayFrame1:UpdateDisplay() end
		if (targetDisplayFrame2) then targetDisplayFrame2:UpdateDisplay() end
	end

	function Srendarr:ConfigureOnTargetChanged()
		-- figure out which frames currently display target auras
		local targetBuff	= self.db.auraGroups[Srendarr.GROUP_TARGET_BUFF]
		local targetDebuff	= self.db.auraGroups[Srendarr.GROUP_TARGET_DEBUFF]

		targetDisplayFrame1 = (targetBuff ~= 0) and self.displayFrames[targetBuff] or false
		targetDisplayFrame2 = (targetDebuff ~= 0) and self.displayFrames[targetDebuff] or false
		
		targetBuffControl	= self.displayFrames[targetBuff]
		targetDebuffControl	= self.displayFrames[targetDebuff]

		hideOnDead			= self.db.hideOnDeadTargets -- set whether to show auras on dead targets

		if (targetDisplayFrame1 or targetDisplayFrame2) then -- event configured and needed, start tracking
			EVENT_MANAGER:RegisterForEvent(self.name, EVENT_RETICLE_TARGET_CHANGED,	OnTargetChanged)
		else -- not needed (not displaying any target auras)
			EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_RETICLE_TARGET_CHANGED)
		end
	end

	Srendarr.OnTargetChanged = OnTargetChanged
end


-- ------------------------
-- EVENT: EVENT_EFFECT_CHANGED
do ------------------------
	local EFFECT_RESULT_FADED			= EFFECT_RESULT_FADED
	local ABILITY_TYPE_AREAEFFECT		= ABILITY_TYPE_AREAEFFECT
	local AURA_TYPE_TIMED				= Srendarr.AURA_TYPE_TIMED
	local GetAbilityDescription			= GetAbilityDescription
	local crystalFragmentsPassive		= Srendarr.crystalFragmentsPassive -- special case for tracking fragments proc
	local fakeAuras						= Srendarr.fakeAuras
	local alternateAura					= Srendarr.alternateAura
	local debuffAuras					= Srendarr.debuffAuras
	local alteredAuraDuration			= Srendarr.alteredAuraDuration
	local specialNames					= Srendarr.specialNames
	local catchTriggers					= Srendarr.catchTriggers
	local abilityCooldowns				= Srendarr.abilityCooldowns
	local sampleAuraData				= Srendarr.sampleAuraData
	local auraLookup					= Srendarr.auraLookup
	local IsGroupUnit					= Srendarr.IsGroupUnit
	local debuffSwitch
	local altDuration
	local fadedAura
	local abilityOffset
	local sourceCast
	local nStacks
	local nilCheck
	local altAura, startA, finishA, effectTypeA, abilityTypeA


	Srendarr.OnEffectChanged = function(e, change, slot, auraName, unitTag, start, finish, stack, icon, buffType, effectType, abilityType, statusType, unitName, unitId, abilityId, sourceType)
		-- check if the aura is on either the player or a group member, or a target or ground aoe -- the description check filters a lot of extra auras attached to many ground effects
		unitTag = (unitTag == 'player' or unitTag == 'reticleover' or IsGroupUnit(unitTag)) and unitTag or (abilityType == ABILITY_TYPE_AREAEFFECT and (GetAbilityDescription(abilityId) ~= '' or sampleAuraData[abilityId] ~= nil)) and 'groundaoe' or nil

		if (abilityCooldowns[abilityId] ~= nil) then return end -- avoid duplicating cooldown abilities tracked through combat events (Phinix)

		-- possible sourceType values:
		--	COMBAT_UNIT_TYPE_NONE			= 0
		--	COMBAT_UNIT_TYPE_PLAYER			= 1
		--	COMBAT_UNIT_TYPE_PLAYER_PET		= 2
		--	COMBAT_UNIT_TYPE_GROUP			= 3
		--	COMBAT_UNIT_TYPE_TARGET_DUMMY	= 4
		--	COMBAT_UNIT_TYPE_OTHER			= 5

		nilCheck = (abilityId ~= nil) and abilityId or 0
		if specialNames[abilityId] ~= nil then auraName = specialNames[abilityId].name end
		if (sourceType == 1) then abilityOffset = nilCheck + 1000000 else abilityOffset = nilCheck + 2000000 end
	
		debuffSwitch = (debuffAuras[abilityId]) and BUFF_EFFECT_TYPE_DEBUFF or effectType -- fix for debuffs game tracks as buffs (Phinix)

		sourceCast = (sourceType == 1) and 1 or 2 -- separate into player cast, not player cast, and group cast for easy offset grouping (Phinix)
		if IsGroupUnit(unitTag) then abilityOffset = nilCheck sourceCast = 3 end

		if (unitTag == 'groundaoe' and sourceType ~= 1) then return end -- only track AOE created by the player
		if (not unitTag) then return end -- don't care about this unit and isn't a ground aoe, abort

		if unitTag == 'reticleover' then -- option to only show player's debuffs on target (Phinix)
			if (debuffSwitch == BUFF_EFFECT_TYPE_DEBUFF and sourceType ~= 1) then
				if (prominentDebuffs[abilityId]) then
					if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] == 0 or Srendarr.db.filtersGroup.onlyPromPlayerDebuffs) then
						return
					end
				elseif (prominentDebuffs2[abilityId]) then
					if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] == 0 or Srendarr.db.filtersGroup.onlyPromPlayerDebuffs2) then
						return
					end
				elseif Srendarr.db.filtersTarget.onlyPlayerDebuffs then
					return
				end
			end
		end

		if change == EFFECT_RESULT_FADED then -- aura has faded

			fadedAura = auraLookup[unitTag][abilityOffset]

			if fadedAura ~= nil and alteredAuraDuration[abilityId] == nil then -- aura exists, tell it to expire if timed, or aaa otherwise
				if (fadedAura.auraType == AURA_TYPE_TIMED) then
					if fadedAura.abilityType == ABILITY_TYPE_AREAEFFECT then return end -- gtaoes expire internally (repeated casting, only one timer)
					fadedAura:SetExpired()
				else
					fadedAura:Release()
				end
			end

			if auraName == crystalFragmentsPassive and sourceType == 1 then -- special case for tracking fragments proc
				Srendarr:OnCrystalFragmentsProc(false)
			end
		else -- aura has been gained or changed, dispatch to handler

			if (sourceType == 1 and fakeAuras[GetAbilityName(abilityId)] ~= nil) then return end -- ignore game default tracking of player bar abilities we've modified (Phinix)

			altDuration = (alteredAuraDuration[abilityId] ~= nil) and start + alteredAuraDuration[abilityId].duration or finish -- fix rare cases game reports wrong duration for an aura (Phinix)
			nStacks = (stack ~= nil) and stack or 0 -- used to add stacks to name of auras that have them (Phinix)

			if catchTriggers[abilityId] ~= nil then -- fix game sending wrong stack building event for some morphs (Phinix)
				if (unitTag == 'player' and auraLookup[unitTag][catchTriggers[abilityId]] ~= nil) then
					altAura = catchTriggers[abilityId]
					startA = auraLookup[unitTag][altAura].start
					finishA = auraLookup[unitTag][altAura].finish
					effectTypeA = auraLookup[unitTag][altAura].effectType
					abilityTypeA = auraLookup[unitTag][altAura].abilityType
					AuraHandler(false, auraName, unitTag, startA, finishA, icon, effectTypeA, abilityTypeA, altAura, sourceCast, nStacks)
					return
				end
			end

			if (Srendarr.db.consolidateEnabled and IsAlternateAura(abilityId)) then -- handles multi-aura passive abilities like Restoring Aura (Phinix)
				AuraHandler(false, alternateAura[abilityId].altName, unitTag, start, altDuration, icon, debuffSwitch, abilityType, abilityOffset, sourceCast, nStacks)
			else
				AuraHandler(false, auraName, unitTag, start, altDuration, icon, debuffSwitch, abilityType, abilityOffset, sourceCast, nStacks)
			end

			if (auraName == crystalFragmentsPassive and sourceType == 1) then -- special case for tracking fragments proc
				Srendarr:OnCrystalFragmentsProc(true)
			end
		end
	end
end


-- ------------------------
-- EVENT: EVENT_COMBAT_EVENT
do ------------------------
	local ABILITY_TYPE_NONE 	= ABILITY_TYPE_NONE
	local BUFF_EFFECT_TYPE_BUFF = BUFF_EFFECT_TYPE_BUFF
	local GetGameTimeMillis		= GetGameTimeMilliseconds
	local GetLatency			= GetLatency
	local enchantProcs			= Srendarr.enchantProcs
	local gearProcs				= Srendarr.gearProcs
	local specialProcs			= Srendarr.specialProcs
	local specialNames			= Srendarr.specialNames
	local releaseTriggers		= Srendarr.releaseTriggers
	local fakeTargetDebuffs		= Srendarr.fakeTargetDebuffs
	local stackingAuras			= Srendarr.stackingAuras
	local abilityCooldowns		= Srendarr.abilityCooldowns
	local auraLookup			= Srendarr.auraLookup
	local sourceCast
	local targetName
	local currentTime
	local stopTime
	local dbTime
	local dbTag
	local dbIcon
	local abilityOffset
	local releaseOffset
	local nilCheck
	local expired


	local function EventToChat(e, result, isError, aName, aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
		if (aName ~= "" and aName ~= nil) or Srendarr.db.showNoNames then
			if sName == playerName then sName = "Player" end
			if tName == playerName then tName = "Player" end
			if not Srendarr.db.disableSpamControl then debugAuras[abilityId] = true end

			if not Srendarr.db.showVerboseDebug then
				d(tostring(abilityId)..": "..aName.." --> [S] "..tostring(sName).."  [T] "..tostring(tName))
			else
				d(aName.." ("..tostring(abilityId)..")")
				d("event: "..e.." || result: "..result.." || isError: "..tostring(isError).." || aName: "..aName.." || aGraphic: "..tostring(aGraphic).." || aActionSlotType: "..tostring(aActionSlotType).." || sName: "..tostring(sName).." || sType: "..tostring(sType).." || tName: "..tostring(tName).." || tType: "..tostring(tType).." || hitValue: "..tostring(hitValue).." || pType: "..tostring(pType).." || dType: "..tostring(dType).." || log: "..tostring(elog).." || sUnitId: "..tostring(sUnitId).." || tUnitId: "..tostring(tUnitId).." || abilityId: "..tostring(abilityId))
				d("Icon: "..GetAbilityIcon(abilityId))
				d("=========================================================")
			end
		end
	end

	local function ProcessEvent(aName, sName, sType, tName, abilityId)
		nilCheck = (abilityId ~= nil) and abilityId or 0

		if enchantProcs[abilityId] ~= nil then
			dbTime = enchantProcs[abilityId].duration
			dbTag = enchantProcs[abilityId].unitTag
			dbIcon = enchantProcs[abilityId].icon
		elseif gearProcs[abilityId] ~= nil then
			dbTime = gearProcs[abilityId].duration
			dbTag = gearProcs[abilityId].unitTag
			dbIcon = gearProcs[abilityId].icon
		elseif specialProcs[abilityId] ~= nil then
			dbTime = specialProcs[abilityId].duration
			dbTag = specialProcs[abilityId].unitTag
			dbIcon = specialProcs[abilityId].icon
		elseif abilityCooldowns[abilityId] ~= nil then
			dbTime = (abilityCooldowns[abilityId].altDuration ~= nil) and abilityCooldowns[abilityId].altDuration or GetAbilityDuration(abilityId) / 1000
			dbTag = "player"
			dbIcon = (abilityCooldowns[abilityId].altIcon ~= nil) and abilityCooldowns[abilityId].altIcon or GetAbilityIcon(abilityId)
		end

		if releaseTriggers[abilityId] ~= nil then -- release event for tracked proc so remove aura
			releaseOffset = releaseTriggers[abilityId].release + 1000000

			-- Catch stack building aura reset events (Phinix)
			if stackingAuras[releaseOffset] and auraLookup['player'][releaseOffset] then
				auraLookup['player'][releaseOffset]:Update(start, finish, stackingAuras[releaseOffset].start, true)
				return
			end

			expired = auraLookup['player'][releaseOffset]
			if expired ~= nil then expired:Release() end
		elseif specialProcs[abilityId] ~= nil and sName == "" then -- tracked ability removed from bar so remove aura
			abilityOffset = nilCheck + 1000000
			expired = auraLookup['player'][abilityOffset]
			if expired ~= nil then expired:Release() end

	-- adding a custom "invisible proc" aura (meaning an aura that doesn't show on the character sheet)

		elseif fakeTargetDebuffs[abilityId] ~= nil then -- new invisible debuff
			if sName ~= "" then
				if tName == "" then return end
				currentTime = GetGameTimeMillis() / 1000
				stopTime = currentTime + fakeTargetDebuffs[abilityId].duration + (GetLatency() / 1000)

				if tName == playerName then
					abilityOffset = nilCheck + 2000000
					sourceCast = 2
					targetName = 'player'
				else
					if sType ~= 1 then return end -- only show player's fake debuffs on the target 

					abilityOffset = nilCheck + 1000000
					sourceCast = 1
					targetName = 'reticleover'
					trackTargets[abilityId] = trackTargets[abilityId] or {}
					trackTargets[abilityId] [tName] = stopTime -- simply unit name tracking, more is not possible
				end

				AuraHandler(
					false,
					zo_strformat("<<t:1>>",aName),
					targetName,
					currentTime,
					stopTime,
					fakeTargetDebuffs[abilityId].icon,
					BUFF_EFFECT_TYPE_DEBUFF,
					ABILITY_TYPE_NONE,
					abilityOffset,
					sourceCast
				)
			end
		else -- New invisible proc on the player
			if sType ~= 1 then return end -- only show player's fake buffs

			abilityOffset = nilCheck + 1000000
			currentTime = GetGameTimeMillis() / 1000
			if dbTime == 0 then -- use duration 0 to indicate this is a toggle/passive not timer
				stopTime = currentTime
			else
				stopTime = currentTime + dbTime + (GetLatency() / 1000)
			end

			AuraHandler(
				false,
				zo_strformat("<<t:1>>",aName),
				dbTag,
				currentTime,
				stopTime,
				dbIcon,
				BUFF_EFFECT_TYPE_BUFF,
				ABILITY_TYPE_NONE,
				abilityOffset,
				1
			)
		end
	end

	Srendarr.OnCombatEvent = function(e, result, isError, aName, aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
		-- Special database for name-swapping custom auras the game doesn't track or name correctly (Phinix)
		if specialNames[abilityId] ~= nil then aName = specialNames[abilityId].name end

		sName = zo_strformat("<<t:1>>",sName)
		tName = zo_strformat("<<t:1>>",tName)

		-- Debug mode for tracking new auras. Type /sdbclear or reloadui to reset (Phinix)
		if Srendarr.db.showCombatEvents == true then
			if Srendarr.db.disableSpamControl == true and Srendarr.db.manualDebug == false then
				EventToChat(e, result, isError, zo_strformat("<<t:1>>",aName), aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
			else
				if debugAuras[abilityId] == nil then
					EventToChat(e, result, isError, zo_strformat("<<t:1>>",aName), aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
				end
			end
		end
		
	-- Cascading check for valid combat event conditions for speed (Phinix)
		if releaseTriggers[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId)
		elseif enchantProcs[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId)
		elseif gearProcs[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId)
		elseif specialProcs[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId)
		elseif fakeTargetDebuffs[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId)
		elseif abilityCooldowns[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId)
		else
			return
		end
	end

	function Srendarr:ConfigureOnCombatEvent()
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_COMBAT_EVENT,	Srendarr.OnCombatEvent)
	end
end


-- ------------------------
-- DEBUG FUNCTIONS
-- ------------------------
local function ClearDebug()
	debugAuras = {}
end

local function dbAdd(option)
	option = tostring(option):gsub("%D",'')
	if option ~= "" then
		debugAuras[tonumber(option)] = true
		d('+'..option)
	end
end

local function dbRemove(option)
	option = tostring(option):gsub("%D",'')
	if option ~= "" then
		if debugAuras[tonumber(option)] ~= nil then
			debugAuras[tonumber(option)] = nil
			d('-'..option)
		end
	end
end


-- ------------------------
-- INITIALIZATION
-- ------------------------
function Srendarr:InitializeAuraControl()
	-- setup debug system (Phinix)
	SLASH_COMMANDS['/sdbclear']		= ClearDebug
	SLASH_COMMANDS['/sdbadd']		= function(option) dbAdd(option) end
	SLASH_COMMANDS['/sdbremove']	= function(option) dbRemove(option) end
	
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED,			Srendarr.OnPlayerActivatedAlive) -- same action for both events
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ALIVE,				Srendarr.OnPlayerActivatedAlive) -- same action for both events
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_DEAD,				Srendarr.OnPlayerDead)
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_EFFECT_CHANGED,				Srendarr.OnEffectChanged)

	self:ConfigureOnCombatState()			-- EVENT_PLAYER_COMBAT_STATE
	self:ConfigureOnTargetChanged()			-- EVENT_RETICLE_TARGET_CHANGED
	self:ConfigureOnActionSlotAbilityUsed()	-- EVENT_ACTION_SLOT_ABILITY_USED
	self:ConfigureOnCombatEvent()			-- EVENT_COMBAT_EVENT

	self:ConfigureAuraHandler()

end
