local Srendarr		= _G['Srendarr'] -- grab addon table from global
local L				= Srendarr:GetLocale()
local LMP			= LibStub('LibMediaProvider-1.0')
local Aura			= {}

-- CONSTS --
local AURA_TYPE_TIMED		= Srendarr.AURA_TYPE_TIMED
local AURA_TYPE_TOGGLED		= Srendarr.AURA_TYPE_TOGGLED
local AURA_TYPE_PASSIVE		= Srendarr.AURA_TYPE_PASSIVE
local DEBUFF_TYPE_PASSIVE	= Srendarr.DEBUFF_TYPE_PASSIVE
local DEBUFF_TYPE_TIMED		= Srendarr.DEBUFF_TYPE_TIMED

local AURA_HEIGHT			= Srendarr.AURA_HEIGHT

local AURA_STYLE_FULL		= Srendarr.AURA_STYLE_FULL
local AURA_STYLE_ICON		= Srendarr.AURA_STYLE_ICON
local AURA_STYLE_MINI		= Srendarr.AURA_STYLE_MINI
local AURA_STYLE_GROUP		= Srendarr.AURA_STYLE_GROUP

local AURA_TIMERLOC_HIDDEN	= Srendarr.AURA_TIMERLOC_HIDDEN
local AURA_TIMERLOC_OVER	= Srendarr.AURA_TIMERLOC_OVER
local AURA_TIMERLOC_ABOVE	= Srendarr.AURA_TIMERLOC_ABOVE
local AURA_TIMERLOC_BELOW	= Srendarr.AURA_TIMERLOC_BELOW

local GROUP_START_FRAME		= Srendarr.GROUP_START_FRAME

-- UPVALUES --
local WM					= WINDOW_MANAGER
local TEXT_ALIGN_TOP		= TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM		= TEXT_ALIGN_BOTTOM
local TEXT_ALIGN_CENTER		= TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT		= TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT		= TEXT_ALIGN_LEFT
local GetGameTimeMillis		= GetGameTimeMilliseconds
local strformat				= string.format
local math_floor			= math.floor
local tremove				= table.remove
local tinsert				= table.insert
local zo_strformat			= zo_strformat
local AddControl			= Srendarr.AddControl

local tTenths				= L.Time_Tenths
local tSec					= L.Time_Seconds
local tMin					= L.Time_Minutes
local tHour					= L.Time_Hours
local tDay					= L.Time_Days
local tToggle				= L.Time_Toggle
local tPassive				= L.Time_Passive

local auraLookup			= Srendarr.auraLookup
local stackingAuras			= Srendarr.stackingAuras
local auraID				= 1		-- incremental counter to give each aura object a unique identifier
local activeTimedAuras		= {}	-- all active auras with timers, referenced by their auraID
local currentTime, colors, iconColors


-- ------------------------
-- CONFIGURE ABILITY ID DISPLAY
-- ------------------------
local showAbilityID			= false

function Srendarr:ConfigureDisplayAbilityID()
	showAbilityID = self.db.displayAbilityID
end


-- ------------------------
-- TIME FORMAT FUNCTION
-- ------------------------
local function FormatTime(remaining, frame)
	frame = (frame < GROUP_START_FRAME) and frame or Srendarr:GetGroupRaidTab()
	if remaining <= 0 then -- Hide when expires
		return ""
	elseif remaining < 5 then -- 10ths of seconds
		return strformat(tTenths, remaining)
	elseif remaining < 60 then -- seconds
		return strformat(tSec, remaining)
	elseif remaining < 3600 then -- minutes
		if (Srendarr.db.showSeconds) then
			local minutes = math_floor(remaining / 60)
			local minutestring = strformat(tMin, minutes)
			local secondstring = strformat(tSec, math_floor(remaining - (minutes * 60)))
			return minutestring..secondstring
		else
			return strformat(tMin, math_floor((remaining / 60) + 0.5))
		end
	elseif remaining > 172800 then -- days (2+, revert to hours when between 24-48hrs)
		return strformat(tDay, math_floor(remaining / 86400))
	else -- hours
		if (Srendarr.db.displayFrames[frame].timerHMS) then
			local sub = math_floor(remaining / 3600) * 60
			local hours = math_floor(remaining / 3600)
			local hourstring = strformat(tHour, hours)
			local minutes = math_floor(remaining / 60) - sub
			local minutestring = strformat(tMin, minutes)
			local secondstring = strformat(tSec, math_floor(remaining - (hours * 3600) - (minutes * 60)))
			if minutes > 0 then
				return hourstring..minutestring
			else
				return hourstring..secondstring
			end
		else
			return strformat(tHour, math_floor(remaining / 3600)).."+"
		end
	end
end


-- ------------------------
-- TOOLTIP HANDLERS
-- ------------------------
local function OnMouseEnter(aura)
	InitializeTooltip(InformationTooltip, aura, TOPRIGHT, 0, - 2, BOTTOMLEFT)

	if (aura.abilityID < 116000 and GetAbilityDescription(aura.abilityID) ~= '') then
		InformationTooltip:SetAbilityId(aura.abilityID)
	else
		SetTooltipText(InformationTooltip, aura.auraName)
	end
end

local function OnMouseExit()
	ClearTooltip(InformationTooltip)
end

local function OnMouseUp(aura, button, upInside)
	if button == 2 and upInside then -- right-click cancel eligible auras (Phinix)
		local nilCheck = (aura.abilityID ~= nil) and aura.abilityID or 0
		local abilityOffset = (nilCheck - 4000000 > 0) and nilCheck - 4000000 or (nilCheck - 2000000 > 0) and nilCheck - 2000000 or (nilCheck - 1000000 > 0) and nilCheck - 1000000 or nilCheck
		local numAuras = GetNumBuffs('player')
		for i = 1, numAuras do
			local _, _, _, buffSlot, _, _, _, _, _, _, abilityID = GetUnitBuffInfo('player', i)
			if abilityID == abilityOffset then
				CancelBuff(buffSlot)
			end
		end
	end
end


-- ------------------------
-- TIMER UPDATE HANDLER
do ------------------------
	local RATE				= Srendarr.AURA_UPDATE_RATE

	local strformat			= string.format
	local math_max			= math.max
	local GetFormattedTime	= FormatTime

	local timedAuras		= activeTimedAuras
	local auraFadeTime		= -2 -- need a base value before being set by config
	local nextUpdate		= 0
	local timeRemaining

	local function OnUpdate(self, updateTime)
		if updateTime >= nextUpdate then
			for _, aura in pairs(timedAuras) do
				timeRemaining = aura.finish - updateTime

				if timeRemaining <= auraFadeTime then -- expired and finished fading, done
					aura:Release()
				elseif timeRemaining <= 0 then -- expired, but not done fading yet
					if (not aura.isFading) then
						aura:SetExpired() -- set expired if we should be but aren't yet
					end

					aura:SetAlpha(math_max(0, 1 - (timeRemaining / auraFadeTime)))
				else -- normal countdown
					aura.bar:SetValue(1 - ((updateTime - aura.start) / (aura.finish - aura.start)))

					if (aura.auraType == AURA_TYPE_TIMED or aura.auraType == DEBUFF_TYPE_TIMED) then -- use timer for stack tracking when in icon mode (Phinix)
						aura.timer:SetText(GetFormattedTime(timeRemaining, Srendarr.db.auraGroups[aura.auraGroup]))
					else
						aura.timer:SetText('')
					end
				end
			end

			nextUpdate = updateTime + RATE
		end
	end

	Srendarr:SetHandler('OnUpdate', OnUpdate)

	function Srendarr:ConfigureAuraFadeTime()
		auraFadeTime = self.db.auraFadeTime * -1
	end
end


-- ------------------------
-- AURA
-- ------------------------
function Aura:Create(displayParent)
	local aura, ctrl

	aura, ctrl = AddControl(displayParent, CT_TEXTURE, 2)
	ctrl:SetDimensions(AURA_HEIGHT, AURA_HEIGHT)

	-- ICON BACKGROUND
	aura.iconBG, ctrl = AddControl(aura, CT_BACKDROP, 1)
	ctrl:SetDimensions(AURA_HEIGHT - 6, AURA_HEIGHT - 6)
	ctrl:SetAnchor(CENTER)
	ctrl:SetCenterColor( 0,0,0,1 )
	ctrl:SetEdgeColor( 0,0,0,1 )
	-- ICON
	aura.icon, ctrl = AddControl(aura, CT_TEXTURE, 2)
	ctrl:SetDimensions(AURA_HEIGHT - 6, AURA_HEIGHT - 6)
	ctrl:SetAnchor(CENTER)
	-- CD BACKGROUND
	aura.cdBG, ctrl = AddControl(aura, CT_BACKDROP, 0)
	ctrl:SetDimensions(AURA_HEIGHT, AURA_HEIGHT)
	ctrl:SetAnchor(CENTER)
	ctrl:SetCenterColor( 0,0,0,1 )	
	ctrl:SetEdgeColor( 0,0,0,1 )
	-- COOLDOWN
	aura.cooldown, ctrl = AddControl(aura.cdBG, CT_COOLDOWN, 0)
	ctrl:SetDimensions(AURA_HEIGHT, AURA_HEIGHT)
	ctrl:SetAnchor(CENTER)
	ctrl:SetHidden(true)
	-- TOGGLED HIGHLIGHT
	aura.highlight, ctrl = AddControl(aura, CT_TEXTURE, 3)
	ctrl:SetDimensions(AURA_HEIGHT -2, AURA_HEIGHT -2)
	ctrl:SetAnchor(CENTER)
	ctrl:SetTexture([[/esoui/art/actionbar/actionslot_toggledon.dds]])
	ctrl:SetHidden(true)
	-- LABELS
	aura.name, ctrl = AddControl(aura, CT_LABEL, 4)
	ctrl:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)
	ctrl:SetInheritScale(false)
	aura.timer, ctrl = AddControl(aura, CT_LABEL, 4)
	ctrl:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	ctrl:SetInheritScale(false)
	-- BAR
	aura.bar, ctrl = AddControl(aura, CT_STATUSBAR, 2)
	ctrl:SetHeight(16)
	ctrl:SetTexture([[/esoui/art/miscellaneous/progressbar_genericfill.dds]])
	ctrl:SetTextureCoords(0, 1, 0, 0.625)
	ctrl:SetLeadingEdge([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge.dds]], 8, 32)
	ctrl:SetLeadingEdgeTextureCoords(0, 1, 0, 0.625)
	ctrl:EnableLeadingEdge(true)
	ctrl:SetMinMax(0, 1)
	ctrl:SetHandler('OnValueChanged', function(bar, value) bar.gloss:SetValue(value) end) -- change gloss value as main bar changes
	-- BAR GLOSS
	aura.bar.gloss, ctrl = AddControl(aura.bar, CT_STATUSBAR, 3)
	ctrl:SetHeight(16)
	ctrl:SetAnchor(TOPLEFT)
	ctrl:SetTexture([[/esoui/art/miscellaneous/progressbar_genericfill_gloss.dds]])
	ctrl:SetTextureCoords(0, 1, 0, 0.625)
	ctrl:SetLeadingEdge([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge_gloss.dds]], 8, 32)
	ctrl:SetLeadingEdgeTextureCoords(0, 1, 0, 0.625)
	ctrl:EnableLeadingEdge(true)
	ctrl:SetMinMax(0, 1)
	-- BAR FRAME
	aura.barBorderL, ctrl = AddControl(aura.bar, CT_TEXTURE, 4)
	ctrl:SetDimensions(10, 16)
	ctrl:SetAnchor(TOPLEFT)
	ctrl:SetTexture([[/esoui/art/miscellaneous/progressbar_frame.dds]])
	aura.barBorderR, ctrl = AddControl(aura.bar, CT_TEXTURE, 4)
	ctrl:SetDimensions(10, 16)
	ctrl:SetAnchor(TOPRIGHT)
	ctrl:SetTexture([[/esoui/art/miscellaneous/progressbar_frame.dds]])
	aura.barBorderM, ctrl = AddControl(aura.bar, CT_TEXTURE, 4)
	ctrl:SetHeight(16)
	ctrl:SetAnchor(TOPLEFT, aura.bar, TOPLEFT, 10, 0)
	ctrl:SetTexture([[/esoui/art/miscellaneous/progressbar_frame.dds]])
	ctrl:SetTextureCoords(0.019500000402331, 0.58980000019073, 0, 0.625)
	-- BAR BACKDROP
	aura.barBackdropEnd, ctrl = AddControl(aura.bar, CT_TEXTURE, 1)
	ctrl:SetDimensions(10, 16)
	ctrl:SetTexture([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge.dds]])
	ctrl:SetColor(0,0,0,0.4)
	aura.barBackdrop, ctrl = AddControl(aura.bar, CT_TEXTURE, 1)
	ctrl:SetHeight(16)
	ctrl:SetTexture('')
	ctrl:SetColor(0,0,0,0.4)

	aura.displayParent		= displayParent
	aura.auraID				= auraID
	auraID					= auraID + 1

	aura.highlightToggled	= false	-- will both be set by the Configure function
	aura.barColors			= {}
	aura.cooldownColors		= {}

	-- aura exec
	aura['Initialize']		= Aura.Initialize
	aura['Update']			= Aura.Update
	aura['SetExpired']		= Aura.SetExpired
	aura['Release']			= Aura.Release
	-- configuration
	aura['Configure']		= Aura.Configure
	aura['UpdateVisuals']	= Aura.UpdateVisuals

	return aura
end


-- ------------------------
-- AURA EXECUTION
do ------------------------
	local alteredIcons = Srendarr.alteredAuraIcons

	function Aura:Initialize(auraGroup, auraType, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityID)
		self.auraGroup		= auraGroup
		self.auraType		= auraType
		self.auraName		= auraName
		self.unitTag		= unitTag or 'notag' -- ensure something is set here
		self.start			= start
		self.finish			= finish
		self.effectType		= effectType
		self.abilityType	= abilityType
		self.abilityID		= abilityID
		self.stacks			= (stackingAuras[abilityID]) and stackingAuras[abilityID].start or 0
		self.duration		= (start == finish) and 1000000 or finish - start
		self.isFading		= false		-- make sure to note aura is enabled again

		local parentID = self.displayParent.displayID
		local displayDB = Srendarr.db.displayFrames
		local displayID = (parentID < GROUP_START_FRAME) and parentID or Srendarr:GetGroupRaidTab()

		local nilCheck = (abilityID ~= nil) and abilityID or 0
		local abilityOffset = (nilCheck - 4000000 > 0) and nilCheck - 4000000 or (nilCheck - 2000000 > 0) and nilCheck - 2000000 or (nilCheck - 1000000 > 0) and nilCheck - 1000000 or nilCheck
		
		-- used to add stacks to name of auras that have them (Phinix)
		local stackString = (stackingAuras[abilityID]) and "\(" .. tostring(stackingAuras[abilityID].start) .. "\)" or ""

		auraLookup[unitTag][abilityID] = self -- add self to the aura lookup reference

		if (displayDB[displayID].style == AURA_STYLE_MINI) then
			if (self.cooldown) then self.cooldown:SetHidden(true) end
			if (self.iconBG) then self.iconBG:SetHidden(true) end
			if (self.cdBG) then self.cdBG:SetHidden(true) end
		else
			if (self.iconBG) then self.iconBG:SetHidden(false) end
			if (self.cdBG) then self.cdBG:SetHidden(false) end
			if start == finish and displayDB[displayID].auraCooldown then
				if (self.cooldown) then self.cooldown:SetHidden(true) end -- hide cooldown animation if no duration
			end
		end

		if (showAbilityID) then
			if self.auraStyle == AURA_STYLE_GROUP then
				self.name:SetText("")
			elseif self.auraStyle == AURA_STYLE_ICON then
				self.name:SetText(abilityOffset  .. " " .. stackString)
			else
				self.name:SetText(zo_strformat(SI_ABILITY_TOOLTIP_NAME, auraName) .. " " .. stackString .. ' [' .. abilityOffset .. ']')
			end
		else
			if self.auraStyle == AURA_STYLE_GROUP then
				self.name:SetText("")
			elseif self.auraStyle == AURA_STYLE_ICON then
				self.name:SetText(zo_strformat(SI_ABILITY_TOOLTIP_NAME, stackString))
			else
				self.name:SetText(zo_strformat(SI_ABILITY_TOOLTIP_NAME, auraName) .. " " .. stackString)
			end
		end

--[[
		if displayDB[displayID].auraCooldown then -- change icon size based on display mode
			self.icon:SetDimensions(AURA_HEIGHT - 6, AURA_HEIGHT - 6)
		else
			self.icon:SetDimensions(AURA_HEIGHT - 2, AURA_HEIGHT - 2)
		end
]]
		self.icon:SetTexture((alteredIcons[abilityOffset]) and alteredIcons[abilityOffset] or icon)
		self.icon:SetDesaturation(0)
		self.highlight:SetHidden(true)
		self:SetAlpha(1)

		if (auraType == AURA_TYPE_TIMED or auraType == DEBUFF_TYPE_TIMED) then
			currentTime = GetGameTimeMillis() / 1000

			self.timer:SetText(FormatTime(finish - currentTime, Srendarr.db.auraGroups[auraGroup]))
			self.bar:SetValue(1 - ((currentTime - start) / (finish - start)))

			if (displayDB[displayID].auraCooldown and displayDB[displayID].style ~= AURA_STYLE_MINI) then
				if (self.cooldown) then
					self.cooldown:StartCooldown( ( finish - currentTime ) * 1000 , ( finish - start ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
					self.cooldown:SetHidden(false)   
				end
			end

			activeTimedAuras[self.auraID] = self -- is a timed aura, add to timer tracking table (used in OnUpdate)

			if (self.cooldown) then
				iconColors = self.cooldownColors[auraType]
				self.cooldown:SetFillColor(iconColors.r1, iconColors.g1, iconColors.b1, 1)
			end

		elseif auraType == AURA_TYPE_TOGGLED then
			self.timer:SetText('')
			self.bar:SetValue(0.99)
			self.highlight:SetHidden(not self.highlightToggled)
		else -- AURA_TYPE_PASSIVE
			self.timer:SetText('')
			self.bar:SetValue(0.99)
		end

		colors = self.barColors[auraType]
		self.bar:SetGradientColors(colors.r1, colors.g1, colors.b1, 1, colors.r2, colors.g2, colors.b2, 1)

		self:SetHidden(false)
	end
end

function Aura:Update(start, finish, stacks, refresh)
	local abilityCooldowns = Srendarr.abilityCooldowns
	local alteredIcons = Srendarr.alteredAuraIcons
	local nStacks = (stacks ~= nil) and stacks or 0
	local stackString = ""
	local abilityStack
	local sStart
	local sFinish

	local nilCheck = (self.abilityID ~= nil) and self.abilityID or 0
	local abilityOffset = (nilCheck - 4000000 > 0) and nilCheck - 4000000 or (nilCheck - 2000000 > 0) and nilCheck - 2000000 or (nilCheck - 1000000 > 0) and nilCheck - 1000000 or nilCheck

	if stackingAuras[self.abilityID] then -- used to add stacks to name of auras that have them (Phinix)
		abilityStack = stackingAuras[self.abilityID].sID
		stackString = "\(" .. tostring(nStacks) .. "\)"
		if stackingAuras[abilityStack].base and not refresh then
			sStart = start
			sFinish = finish
		else
			sStart = (stackingAuras[abilityStack].rTimer) and start or self.start
			sFinish = (stackingAuras[abilityStack].rTimer) and finish or self.finish
		end

		if self.displayParent.settings.style ~= AURA_STYLE_ICON then
			if (showAbilityID) then
				self.name:SetText(zo_strformat(SI_ABILITY_TOOLTIP_NAME, self.auraName) .. " " .. stackString .. ' [' .. abilityOffset .. ']')
			else
				self.name:SetText(zo_strformat(SI_ABILITY_TOOLTIP_NAME, self.auraName) .. " " .. stackString)
			end
		else
			if (showAbilityID) then
				self.name:SetText(abilityOffset  .. " " .. stackString)
			else
				self.name:SetText(zo_strformat(SI_ABILITY_TOOLTIP_NAME, stackString))
			end
		end
	else
		sStart = start
		sFinish = finish
	end

	-- Change icon based on proc events (for stacking auras only) (Phinix)
	if stackingAuras[self.abilityID] then
		if nStacks ~= 0 and nStacks == stackingAuras[self.abilityID].proc then
			self.icon:SetTexture(stackingAuras[self.abilityID].picon)
		else
			self.icon:SetTexture(GetAbilityIcon(abilityOffset))
		end
	end

	self.stacks = nStacks

	if (self.start == sStart and self.finish == sFinish) then return end -- if they are the same nothing changed (repeat event firings probably), do nothing

	local parentID = self.displayParent.displayID
	local displayDB = Srendarr.db.displayFrames
	local displayID = (parentID < GROUP_START_FRAME) and parentID or Srendarr:GetGroupRaidTab()

	currentTime = GetGameTimeMillis() / 1000
	self.start	= start
	self.finish	= finish

	if (self.auraType == AURA_TYPE_TIMED or self.auraType == DEBUFF_TYPE_TIMED) then
		self.timer:SetText(FormatTime(finish - currentTime, Srendarr.db.auraGroups[self.auraGroup]))
	else
		self.timer:SetText('')
	end

	self.bar:SetValue(1 - ((currentTime - start) / (finish - start)))

	if displayDB[displayID].auraCooldown then
		if (self.cooldown) then
			self.cooldown:StartCooldown( ( finish - currentTime ) * 1000 , ( finish - start ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
			self.cooldown:SetHidden(false)    
		end
	end

	if (self.isFading) then -- aura (most likely) had expired in game but was still active internally due to fadeout
		self.isFading = false
		self:SetAlpha(1)
		self.icon:SetDesaturation(0)
	end

	self.displayParent:UpdateDisplay() -- time has changed, update parent display as ordering may have been altered
end

function Aura:SetExpired()
	if (not self.isFading) then -- if not already expired and fading, start
		self.finish = GetGameTimeMillis() / 1000 -- times up, make sure our internal finish time agrees
		self.icon:SetDesaturation(1)

		self.isFading = true -- note that its time to start fading
	end
end

function Aura:Release(flagBurst)
	self:SetHidden(true)

	activeTimedAuras[self.auraID] = nil -- whether timed aura or not, this removes self from tracking table

	auraLookup[self.unitTag][self.abilityID] = nil -- remove self from the aura lookup reference

	self.displayParent:OnAuraReleased(flagBurst, self)
end


-- ------------------------
-- CONFIGURATION
-- ------------------------
function Aura:Configure(settings)

	local displayDB = Srendarr.db.displayFrames
	local displayID = settings.base.id

	self.auraStyle = settings.style -- internal ref for currently active style

	-- configure local references for things that can change from ability to ability on the same aura object
	self.highlightToggled	= settings.highlightToggled
	self.barColors[AURA_TYPE_TIMED]			= settings.barColors[AURA_TYPE_TIMED]
	self.barColors[AURA_TYPE_TOGGLED]			= settings.barColors[AURA_TYPE_TOGGLED]
	self.barColors[AURA_TYPE_PASSIVE]			= settings.barColors[AURA_TYPE_PASSIVE]
	self.barColors[DEBUFF_TYPE_PASSIVE]		= settings.barColors[DEBUFF_TYPE_PASSIVE]
	self.barColors[DEBUFF_TYPE_TIMED]			= settings.barColors[DEBUFF_TYPE_TIMED]
	self.cooldownColors[AURA_TYPE_TIMED]		= settings.cooldownColors[AURA_TYPE_TIMED]
	self.cooldownColors[AURA_TYPE_TOGGLED]		= settings.cooldownColors[AURA_TYPE_TOGGLED]
	self.cooldownColors[AURA_TYPE_PASSIVE]		= settings.cooldownColors[AURA_TYPE_PASSIVE]
	self.cooldownColors[DEBUFF_TYPE_PASSIVE]	= settings.cooldownColors[DEBUFF_TYPE_PASSIVE]
	self.cooldownColors[DEBUFF_TYPE_TIMED]		= settings.cooldownColors[DEBUFF_TYPE_TIMED]

	self.name:SetFont(strformat('%s|%d|%s', LMP:Fetch('font', settings.nameFont), settings.nameSize, settings.nameStyle))
	self.name:SetColor(settings.nameColor[1], settings.nameColor[2], settings.nameColor[3], settings.nameColor[4])

	self.timer:SetFont(strformat('%s|%d|%s', LMP:Fetch('font', settings.timerFont), settings.timerSize, settings.timerStyle))
	self.timer:SetColor(settings.timerColor[1], settings.timerColor[2], settings.timerColor[3], settings.timerColor[4])
	self.timer:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

	-- configure tooltip control
	if (settings.style == AURA_STYLE_ICON and settings.enableTooltips) then -- only in icon mode
		if (not self:GetHandler('OnMouseEnter')) then
			self:SetHandler('OnMouseEnter',	OnMouseEnter)
			self:SetHandler('OnMouseExit',	OnMouseExit)
			self:SetHandler('OnMouseUp',	OnMouseUp)
		end

		self:SetMouseEnabled(true)
	else
		self:SetMouseEnabled(false)

		if (self:GetHandler('OnMouseEnter')) then
			self:SetHandler('OnMouseEnter', nil)
			self:SetHandler('OnMouseExit', nil)
			self:SetHandler('OnMouseUp', nil)
		end
	end

	if settings.style == AURA_STYLE_FULL then -- full style, must be growing up or down
		-- configure icon
		if (displayDB[displayID].auraCooldown) then
			self:SetTexture([[Srendarr/Icons/IconBG.dds]])
		else
			self:SetTexture([[/esoui/art/actionbar/abilityframe64_up.dds]])
		end
		self.icon:SetHidden(false)

		if (not displayDB[displayID].auraCooldown) then
			if (self.cooldown) then self.cooldown:SetHidden(true) end
		else
			if (self.cooldown) then self.cooldown:SetHidden(false) end
		end

		self.highlight:SetAlpha(1) -- allow toggle highlight to be seen again if set (is a hack, but it works without a lot of checking)
		-- configure timer
		self.timer:ClearAnchors()
		self.timer:SetAnchor(BOTTOM, self, BOTTOM, 0, -1) -- in full style, the timer is either over or hidden
		self.timer:SetHidden(settings.timerLocation == AURA_TIMERLOC_HIDDEN)

		-- configure bar display
		self.bar:SetDimensions(settings.barWidth, 16)
		self.bar:SetLeadingEdge([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge.dds]], 8, 32)
		self.bar.gloss:SetDimensions(settings.barWidth, 16)
		self.bar.gloss:SetLeadingEdge([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge_gloss.dds]], 8, 32)
		self.bar.gloss:SetHidden((not settings.barGloss or displayDB[displayID].hideFullBar))
		self.barBorderL:SetHeight(16)
		self.barBorderR:SetHeight(16)
		self.barBorderM:SetDimensions(settings.barWidth - 20, 16)
		self.barBackdrop:ClearAnchors()
		self.barBackdrop:SetDimensions(settings.barWidth - 10, 16)
		self.barBackdropEnd:ClearAnchors()
		self.barBackdropEnd:SetHeight(16)

		self.name:ClearAnchors()
		self.name:SetHidden(false)
		self.bar:ClearAnchors()
		self.bar:SetHidden(displayDB[displayID].hideFullBar)

		if (settings.barReverse) then
			self.barBackdrop:SetAnchor(TOPRIGHT, self.bar, TOPRIGHT, 0, 0)
			self.barBackdropEnd:SetAnchor(TOPLEFT, self.bar, TOPLEFT, 0, 0)
			self.bar:SetBarAlignment(BAR_ALIGNMENT_REVERSE)
			self.bar.gloss:SetBarAlignment(BAR_ALIGNMENT_REVERSE)
			self.barBorderL:SetTextureCoords(0.6133000254631, 0.59380000829697, 0, 0.625)
			self.barBorderR:SetTextureCoords(0.019500000402331, 0, 0, 0.625)
			self.barBackdropEnd:SetTextureCoords(1, 0, 0, 0.625)

			if (displayDB[displayID].hideFullBar) then
				self.name:SetAnchor(RIGHT, self, LEFT, -8, 0)
			else
				self.name:SetAnchor(BOTTOMRIGHT, self.bar, TOPRIGHT, -2, -1)
			end

			self.name:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
			self.bar:SetAnchor(BOTTOMRIGHT, self, BOTTOMLEFT, -3, 0)
		else
			self.barBackdrop:SetAnchor(TOPLEFT, self.bar, TOPLEFT, 0, 0)
			self.barBackdropEnd:SetAnchor(TOPRIGHT, self.bar, TOPRIGHT, 0, 0)
			self.bar:SetBarAlignment(BAR_ALIGNMENT_NORMAL)
			self.bar.gloss:SetBarAlignment(BAR_ALIGNMENT_NORMAL)
			self.barBorderL:SetTextureCoords(0, 0.019500000402331, 0, 0.625)
			self.barBorderR:SetTextureCoords(0.59380000829697, 0.6133000254631, 0, 0.625)
			self.barBackdropEnd:SetTextureCoords(0, 1, 0, 0.625)

			if (displayDB[displayID].hideFullBar) then
				self.name:SetAnchor(LEFT, self, RIGHT, 8, 0)
			else
				self.name:SetAnchor(BOTTOMLEFT, self.bar, TOPLEFT, 2, -1)
			end

			self.name:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
			self.bar:SetAnchor(BOTTOMLEFT, self, BOTTOMRIGHT, 3, 0)
		end
	elseif (settings.style == AURA_STYLE_ICON or settings.style == AURA_STYLE_GROUP) then -- icon only style, hide unused elements
		-- configure icon
		if (displayDB[displayID].auraCooldown) then
			self:SetTexture([[Srendarr/Icons/IconBG.dds]])
		else
			self:SetTexture([[/esoui/art/actionbar/abilityframe64_up.dds]])
		end
		self.icon:SetHidden(false)

		if (not displayDB[displayID].auraCooldown) then
			if (self.cooldown) then self.cooldown:SetHidden(true) end
		else
			if (self.cooldown) then self.cooldown:SetHidden(false) end
		end

		self.highlight:SetAlpha(1) -- allow toggle highlight to be seen again if set (is a hack, but it works without a lot of checking)
		-- configure timer
		self.timer:ClearAnchors()

		if settings.timerLocation == AURA_TIMERLOC_ABOVE then
			self.timer:SetAnchor(BOTTOM, self, TOP, 0, 0)
		elseif settings.timerLocation == AURA_TIMERLOC_BELOW then
			self.timer:SetAnchor(TOP, self, BOTTOM, 0, -1)
			self.timer:SetVerticalAlignment(TEXT_ALIGN_TOP)
		else -- settings.timerLocation == AURA_TIMERLOC_OVER (or hidden, makes no difference)
			self.timer:SetAnchor(BOTTOM, self, BOTTOM, 0, -1)
		end

		self.timer:SetHidden(settings.timerLocation == AURA_TIMERLOC_HIDDEN)

		if (showAbilityID) then -- repurpose name display for abilityID display
			self.name:SetFont(strformat('%s|13|soft-shadow-thin', LMP:Fetch('font', 'Univers 57')))
		end

		self.name:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		self.name:ClearAnchors()
		self.name:SetAnchor(TOP, self, TOP, 0, 1)
		self.name:SetHidden(false)

		self.bar:SetHidden(true)
	elseif settings.style == AURA_STYLE_MINI then -- style == AURA_STYLE_MINI

		-- configure icon
		self:SetTexture(0, 0, 0, 0)	-- make icon inivisble (cannot set alpha as it is the base of the aura object)
		self.icon:SetHidden(true)	-- hide the icon for this ability
		if (self.cooldown) then self.cooldown:SetHidden(true) end
		self.highlight:SetAlpha(0)	-- disable toggle highlight (is a hack, but it works without a lot of checking)
		-- configure timer
		self.timer:SetHidden(true) -- no timer text in this style

		-- configure bar display
		self.bar:SetDimensions(settings.barWidth, 9)
		self.bar:SetLeadingEdge([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge.dds]], 8, 18)
		self.bar.gloss:SetDimensions(settings.barWidth, 9)
		self.bar.gloss:SetLeadingEdge([[/esoui/art/miscellaneous/progressbar_genericfill_leadingedge_gloss.dds]], 8, 18)
		self.bar.gloss:SetHidden(not settings.barGloss)
		self.barBorderL:SetHeight(9)
		self.barBorderR:SetHeight(9)
		self.barBorderM:SetDimensions(settings.barWidth - 20, 9)
		self.barBackdrop:ClearAnchors()
		self.barBackdrop:SetDimensions(settings.barWidth - 10, 9)
		self.barBackdropEnd:ClearAnchors()
		self.barBackdropEnd:SetHeight(9)

		self.name:ClearAnchors()
		self.name:SetHidden(false)
		self.bar:ClearAnchors()
		self.bar:SetHidden(false)

		if (settings.barReverse) then
			self.barBackdrop:SetAnchor(TOPRIGHT, self.bar, TOPRIGHT, 0, 0)
			self.barBackdropEnd:SetAnchor(TOPLEFT, self.bar, TOPLEFT, 0, 0)
			self.bar:SetBarAlignment(BAR_ALIGNMENT_REVERSE)
			self.bar.gloss:SetBarAlignment(BAR_ALIGNMENT_REVERSE)
			self.barBorderL:SetTextureCoords(0.6133000254631, 0.59380000829697, 0, 0.625)
			self.barBorderR:SetTextureCoords(0.019500000402331, 0, 0, 0.625)
			self.barBackdropEnd:SetTextureCoords(1, 0, 0, 0.625)
			self.name:SetAnchor(BOTTOMRIGHT, self.bar, TOPRIGHT, -2, -1)
			self.name:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
			self.bar:SetAnchor(BOTTOMRIGHT, self, BOTTOMRIGHT, 0, -5)
		else
			self.barBackdrop:SetAnchor(TOPLEFT, self.bar, TOPLEFT, 0, 0)
			self.barBackdropEnd:SetAnchor(TOPRIGHT, self.bar, TOPRIGHT, 0, 0)
			self.bar:SetBarAlignment(BAR_ALIGNMENT_NORMAL)
			self.bar.gloss:SetBarAlignment(BAR_ALIGNMENT_NORMAL)
			self.barBorderL:SetTextureCoords(0, 0.019500000402331, 0, 0.625)
			self.barBorderR:SetTextureCoords(0.59380000829697, 0.6133000254631, 0, 0.625)
			self.barBackdropEnd:SetTextureCoords(0, 1, 0, 0.625)
			self.name:SetAnchor(BOTTOMLEFT, self.bar, TOPLEFT, 2, -1)
			self.name:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
			self.bar:SetAnchor(BOTTOMLEFT, self, BOTTOMLEFT, 0, -5)
		end
	end
end

function Aura:UpdateVisuals() -- updates visuals on active auras, only called by settings changes
	if (self.auraType and self.auraType == AURA_TYPE_TOGGLED) then
		self.highlight:SetHidden(not self.highlightToggled) -- update toggle highlighting
	end

	colors = self.barColors[self.auraType]
	self.bar:SetGradientColors(colors.r1, colors.g1, colors.b1, 1, colors.r2, colors.g2, colors.b2, 1)

end


Srendarr.Aura = Aura
