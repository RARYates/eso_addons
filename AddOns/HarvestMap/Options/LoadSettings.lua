
Harvest = Harvest or {}
Harvest.settings = Harvest.settings or {}
local Settings = Harvest.settings

-- some data structures canot be properly saved, this function restores them after the addon is fully loaded
function Settings:FixTint()
	-- tints cannot be saved (only as rgba table) so restore these tables to tint objects
	for _, layout in pairs( self.savedVars.settings.pinLayouts ) do
		layout.tint = ZO_ColorDef:New(layout.tint)
	end
end

function Settings:LoadSavedVars()
	self.savedVars = {}
	
	Harvest_SavedVars = Harvest_SavedVars or {}
	-- global settings that are computer wide (eg node/data settings)
	Harvest_SavedVars.global = Harvest_SavedVars.global or self.defaultGlobalSettings
	self.savedVars.global = Harvest_SavedVars.global
	-- fix for settings transfer addon
	-- currently it thinks the keys of the accountwide settings are characters
	-- remove the @ for the keys so this doesn't happen anymore
	if Harvest_SavedVars.account then
		for accountName, settings in pairs(Harvest_SavedVars.account) do
			if accountName:sub(1,1) == "@" then
				Harvest_SavedVars.account[accountName:sub(2,-1)] = settings
				Harvest_SavedVars.account[accountName] = nil
			end
		end
	end
	
	-- account wide settings
	local accountName = GetDisplayName():sub(2,-1)
	Harvest_SavedVars.account = Harvest_SavedVars.account or {}
	Harvest_SavedVars.account[accountName] = Harvest_SavedVars.account[accountName] or {}
	self.savedVars.account = Harvest_SavedVars.account[accountName]
	
	-- character wide settings
	local characterId = GetCurrentCharacterId()
	Harvest_SavedVars.character = Harvest_SavedVars.character or {}
	Harvest_SavedVars.character[characterId] = Harvest_SavedVars.character[characterId] or {}
	self.savedVars.character = Harvest_SavedVars.character[characterId]
	
	-- add default settings
	local tbl = self.savedVars.character
	for key, value in pairs(self.defaultSettings) do
		if tbl[key] == nil then
			tbl[key] = value
		end
	end
	
	tbl = self.savedVars.account
	for key, value in pairs(self.defaultSettings) do
		if tbl[key] == nil then
			tbl[key] = value
		end
	end
	
	-- depending on the account wide setting, the settings may not be saved per character
	if self.savedVars.account.accountWideSettings then
		self.savedVars.settings = self.savedVars.account
	else
		self.savedVars.settings = self.savedVars.character
	end
	
	-- changed worldpinwidth/height
	if self.savedVars.settings.worldPinHeight <= 10 then
		self.savedVars.settings.worldPinHeight = self.savedVars.settings.worldPinHeight * 100
	end
	if self.savedVars.settings.worldPinWidth <= 10 then
		self.savedVars.settings.worldPinWidth = self.savedVars.settings.worldPinWidth * 100
	end
	
	-- trusted user for merge website
	if self.savedVars.settings.trusted then
		Harvest.SetTrustedUser(true)
	end
end

function Settings:ConstructMapPinLayouts()
	self.mapPinLayouts = {}
	local pinLayout, level, size
	for i, pinTypeId in pairs(Harvest.PINTYPES) do
		pinLayout = self.savedVars.settings.pinLayouts[pinTypeId]
		if pinTypeId == Harvest.TOUR then
			level = 55
		else
			if Harvest.ArePinsAbovePOI() then
				level = 55
			else
				level = 20
			end
		end
		size = Harvest.GetMapPinSize(pinTypeId)
		self.mapPinLayouts[pinTypeId] = { texture = pinLayout.texture, level = level, size = size, tint = pinLayout.tint }
	end
end

function Settings:Initialize()
	self:LoadSavedVars()
	self:FixTint()
	self:InitializeLAM()
	--self:CreateMapFilterCheckboxes()
	self:ConstructMapPinLayouts()
end