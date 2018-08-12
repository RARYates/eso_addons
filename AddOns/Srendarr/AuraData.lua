local Srendarr		= _G['Srendarr'] -- grab addon table from global
local L				= Srendarr:GetLocale()

-- UPVALUES --
local GetAbilityName		= GetAbilityName
local strformat				= string.format
local sTable = {}

-- Major & Minor Effect Identifiers
local EFFECT_AEGIS				= 1
local EFFECT_BERSERK			= 2
local EFFECT_BREACH				= 3
local EFFECT_BRUTALITY			= 4
local EFFECT_COWARDICE			= 5
local EFFECT_DEFILE				= 6
local EFFECT_ENDURANCE			= 7
local EFFECT_EVASION			= 8
local EFFECT_EXPEDITION			= 9
local EFFECT_FORCE				= 10
local EFFECT_FORTITUDE			= 11
local EFFECT_FRACTURE			= 12
local EFFECT_GALLOP				= 13
local EFFECT_HEROISM			= 14
local EFFECT_HINDRANCE			= 15
local EFFECT_INTELLECT			= 16
local EFFECT_LIFESTEAL			= 17
local EFFECT_MAGICKASTEAL		= 18
local EFFECT_MAIM				= 19
local EFFECT_MANGLE				= 20
local EFFECT_MENDING			= 21
local EFFECT_PARDON				= 22
local EFFECT_PROPHECY			= 23
local EFFECT_PROTECTION			= 24
local EFFECT_RESOLVE			= 25
local EFFECT_SAVAGERY			= 26
local EFFECT_SLAYER				= 27
local EFFECT_SORCERY			= 28
local EFFECT_TOUGHNESS			= 29
local EFFECT_UNCERTAINTY		= 30
local EFFECT_VITALITY			= 31
local EFFECT_VULNERABILITY		= 32
local EFFECT_WARD				= 33
local EFFECT_WOUND				= 34

local minorEffects, majorEffects -- populated at the end of file due to how large they are (legibility reasons)

local alteredAuraIcons = { -- used to alter the default icon for selected auras
	[45902] = [[/esoui/art/icons/ability_mage_065.dds]],		-- Off-Balance
	[35771]	= [[Srendarr/Icons/Vamp_Stage1.dds]],				-- Stage 1 Vampirism
	[35776]	= [[Srendarr/Icons/Vamp_Stage2.dds]],				-- Stage 2 Vampirism
	[35783]	= [[Srendarr/Icons/Vamp_Stage3.dds]],				-- Stage 3 Vampirism
	[35786]	= [[Srendarr/Icons/Vamp_Stage4.dds]],				-- Stage 4 Vampirism
	[35792]	= [[Srendarr/Icons/Vamp_Stage4.dds]],				-- Stage 4 Vampirism
	[23392] = [[/esoui/art/icons/ability_mage_042.dds]],		-- Altmer Glamour
	[31272] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Arrow Spray Rank I
	[40760] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Arrow Spray Rank II
	[40763] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Arrow Spray Rank III
	[40766] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Arrow Spray Rank IV
	[38706] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Bombard Rank I
	[40770] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Bombard Rank II
	[40774] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Bombard Rank III
	[40778] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Bombard Rank IV
	[38702] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Acid Spray Rank I
	[40784] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Acid Spray Rank II
	[40788] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Acid Spray Rank III
	[40792] = [[/esoui/art/icons/ability_debuff_snare.dds]],	-- Acid Spray Rank IV
}

local alteredAuraDuration = { -- used to alter the game's returned duration for selected auras
-- Warden Healing Seed (and morphs) - Game reports incorrect duration (?).
	[85845] = {duration = 6},		-- Healing Seed Lvl 1
	[93808] = {duration = 6},		-- Healing Seed Lvl 2
	[93809] = {duration = 6},		-- Healing Seed Lvl 3
	[93810] = {duration = 6},		-- Healing Seed Lvl 4
	[85840] = {duration = 6},		-- Budding Seeds Lvl 1
	[93805] = {duration = 6},		-- Budding Seeds Lvl 2
	[93806] = {duration = 6},		-- Budding Seeds Lvl 3
	[93807] = {duration = 6},		-- Budding Seeds Lvl 4
	[85845] = {duration = 6},		-- Corrupting Pollen Lvl 1
	[93808] = {duration = 6},		-- Corrupting Pollen Lvl 2
	[93809] = {duration = 6},		-- Corrupting Pollen Lvl 3
	[93810] = {duration = 6},		-- Corrupting Pollen Lvl 4
-- Alliance War Caltrops (and morphs)
	[33376] = {duration = GetAbilityDuration(33376) / 1000 + 1},	-- Caltrops Lvl 1
	[46363] = {duration = GetAbilityDuration(46363) / 1000 + 1},	-- Caltrops Lvl 2
	[46374] = {duration = GetAbilityDuration(46374) / 1000 + 1},	-- Caltrops Lvl 3
	[46385] = {duration = GetAbilityDuration(46385) / 1000 + 1},	-- Caltrops Lvl 4
	[40255] = {duration = GetAbilityDuration(40255) / 1000 + 1},	-- Anti-Cavalry Caltrops Lvl 1
	[46396] = {duration = GetAbilityDuration(46396) / 1000 + 1},	-- Anti-Cavalry Caltrops Lvl 2
	[46408] = {duration = GetAbilityDuration(46408) / 1000 + 1},	-- Anti-Cavalry Caltrops Lvl 3
	[46420] = {duration = GetAbilityDuration(46420) / 1000 + 1},	-- Anti-Cavalry Caltrops Lvl 4
	[40242] = {duration = GetAbilityDuration(40242) / 1000 + 1},	-- Razor Caltrops Lvl 1
	[46440] = {duration = GetAbilityDuration(46440) / 1000 + 1},	-- Razor Caltrops Lvl 2
	[46453] = {duration = GetAbilityDuration(46453) / 1000 + 1},	-- Razor Caltrops Lvl 3
	[46466] = {duration = GetAbilityDuration(46466) / 1000 + 1},	-- Razor Caltrops Lvl 4
}

local catchTriggers = { -- used for certain morphs of abilities that send the wrong ID for stack building
	[61905] = 1061902,		-- Grim Focus I
}

local stackingAuras = { -- used to track stacks on auras like Hawk Eye
-- Advancing Yokeda Set
	[1050978]	= {sID = 1050978, start = 1, proc = 0, picon = nil, base = true, rTimer = true},		-- Berserking Warrior
-- Two-Fanged Snake Set
	[1051176]	= {sID = 1051176, start = 1, proc = 0, picon = nil, base = true, rTimer = true},		-- Twice-Fanged Serpent
-- Asylum Destruction Staff
	[1100306]	= {sID = 1100306, start = 1, proc = 0, picon = nil, base = true, rTimer = true},		-- Concentrated Force
	[1099989]	= {sID = 1099989, start = 1, proc = 0, picon = nil, base = true, rTimer = true},		-- Concentrated Force (Perfected)
-- Bow weapon Hawk Eye passive
	[1078854]	= {sID = 1078854, start = 1, proc = 0, picon = nil, base = true, rTimer = true},		-- Hawk Eye Lvl 1
	[1078855]	= {sID = 1078855, start = 1, proc = 0, picon = nil, base = true, rTimer = true},		-- Hawk Eye Lvl 2
-- Nightblade Grim Focus (and morphs)
	[1061902]	= {sID = 1061902, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Grim Focus Lvl 1
	[1062090]	= {sID = 1062090, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Grim Focus Lvl 2
	[1064176]	= {sID = 1064176, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Grim Focus Lvl 3
	[1062096]	= {sID = 1062096, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Grim Focus Lvl 4
	[1061927]	= {sID = 1061927, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Relentless Focus Lvl 1
	[1062099]	= {sID = 1062099, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Relentless Focus Lvl 2
	[1062103]	= {sID = 1062103, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Relentless Focus Lvl 3
	[1062107]	= {sID = 1062107, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Relentless Focus Lvl 4
	[1061919]	= {sID = 1061919, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Merciless Resolve Lvl 1
	[1062111]	= {sID = 1062111, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Merciless Resolve Lvl 2
	[1062114]	= {sID = 1062114, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Merciless Resolve Lvl 3
	[1062117]	= {sID = 1062117, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = true, rTimer = false},	-- Merciless Resolve Lvl 4
	[1061903]	= {sID = 1061902, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 1
	[1062091]	= {sID = 1062090, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 2
	[1064177]	= {sID = 1064176, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 3
	[1062097]	= {sID = 1062096, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Grim Focus Lvl 4
	[1061928]	= {sID = 1061927, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 1
	[1062100]	= {sID = 1062099, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 2
	[1062104]	= {sID = 1062103, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 3
	[1062108]	= {sID = 1062107, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Relentless Focus Lvl 4
	[1061920]	= {sID = 1061919, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 1
	[1062112]	= {sID = 1062111, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 2
	[1062115]	= {sID = 1062114, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 3
	[1062118]	= {sID = 1062117, start = 0, proc = 5, picon = '/esoui/art/icons/ability_rogue_058.dds', base = false, rTimer = false},	-- Merciless Resolve Lvl 4
}

local fakeAuras = { -- used to spawn fake auras to handle mismatch of information provided by the API to what user's want|need
-- Templar Cleansing Ritual AOE (and morphs)
	[GetAbilityName(22265)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(22265) / 1000, abilityID = 4022265},		-- Cleansing Ritual Lvl 1
	[GetAbilityName(27243)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27243) / 1000, abilityID = 4027243},		-- Cleansing Ritual Lvl 2
	[GetAbilityName(27249)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27249) / 1000, abilityID = 4027249},		-- Cleansing Ritual Lvl 3
	[GetAbilityName(27255)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27255) / 1000, abilityID = 4027255},		-- Cleansing Ritual Lvl 4
	[GetAbilityName(22259)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(22259) / 1000, abilityID = 4022259},		-- Ritual of Retribution Lvl 1
	[GetAbilityName(27261)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27261) / 1000, abilityID = 4027261},		-- Ritual of Retribution Lvl 2
	[GetAbilityName(27269)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27269) / 1000, abilityID = 4027269},		-- Ritual of Retribution Lvl 3
	[GetAbilityName(27275)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27275) / 1000, abilityID = 4027275},		-- Ritual of Retribution Lvl 4
	[GetAbilityName(22262)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(22262) / 1000, abilityID = 4022262},		-- Extended Ritual Lvl 1
	[GetAbilityName(27281)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27281) / 1000, abilityID = 4027281},		-- Extended Ritual Lvl 2
	[GetAbilityName(27288)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27288) / 1000, abilityID = 4027288},		-- Extended Ritual Lvl 3
	[GetAbilityName(27295)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27295) / 1000, abilityID = 4027295},		-- Extended Ritual Lvl 4
-- Warden Scorch AOE (and morphs)
	[GetAbilityName(86009)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86009) / 1000, abilityID = 4086009},		-- Scorch
	[GetAbilityName(86012)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86012) / 1000, abilityID = 4086012},		-- Scorch
	[GetAbilityName(86013)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86013) / 1000, abilityID = 4086013},		-- Scorch
	[GetAbilityName(93593)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(93593) / 1000, abilityID = 4093593},		-- Scorch
	[GetAbilityName(86019)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86019) / 1000, abilityID = 4086019},		-- Subterranean Assault
	[GetAbilityName(86020)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86020) / 1000, abilityID = 4086020},		-- Subterranean Assault
	[GetAbilityName(86021)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86021) / 1000, abilityID = 4086021},		-- Subterranean Assault
	[GetAbilityName(93791)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(93791) / 1000, abilityID = 4093791},		-- Subterranean Assault
	[GetAbilityName(86015)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86015) / 1000, abilityID = 4086015},		-- Deep Fissure
	[GetAbilityName(86016)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86016) / 1000, abilityID = 4086016},		-- Deep Fissure
	[GetAbilityName(86017)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(86017) / 1000, abilityID = 4086017},		-- Deep Fissure
	[GetAbilityName(93778)] = {unitTag = 'groundaoe', duration = GetAbilityDuration(93778) / 1000, abilityID = 4093778},		-- Deep Fissure
-- Nightblade Summon Shade (and morphs)
	[GetAbilityName(33211)] = {unitTag = 'player', duration = GetAbilityDuration(33211) / 1000, abilityID = 4033211},		-- Summon Shade Lvl 1
	[GetAbilityName(36267)] = {unitTag = 'player', duration = GetAbilityDuration(36267) / 1000, abilityID = 4036267},		-- Summon Shade Lvl 2
	[GetAbilityName(36271)] = {unitTag = 'player', duration = GetAbilityDuration(36271) / 1000, abilityID = 4036271},		-- Summon Shade Lvl 3
	[GetAbilityName(36313)] = {unitTag = 'player', duration = GetAbilityDuration(36313) / 1000, abilityID = 4036313},		-- Summon Shade Lvl 4
	[GetAbilityName(35434)] = {unitTag = 'player', duration = GetAbilityDuration(35434) / 1000, abilityID = 4035434},		-- Dark Shades Lvl 1
	[GetAbilityName(36273)] = {unitTag = 'player', duration = GetAbilityDuration(36273) / 1000, abilityID = 4036273},		-- Dark Shades Lvl 2
	[GetAbilityName(36278)] = {unitTag = 'player', duration = GetAbilityDuration(36278) / 1000, abilityID = 4036278},		-- Dark Shades Lvl 3
	[GetAbilityName(36283)] = {unitTag = 'player', duration = GetAbilityDuration(36283) / 1000, abilityID = 4036283},		-- Dark Shades Lvl 4
	[GetAbilityName(35441)] = {unitTag = 'player', duration = GetAbilityDuration(35441) / 1000, abilityID = 4035441},		-- Shadow Image Lvl 1
	[GetAbilityName(36288)] = {unitTag = 'player', duration = GetAbilityDuration(36288) / 1000, abilityID = 4036288},		-- Shadow Image Lvl 2
	[GetAbilityName(36293)] = {unitTag = 'player', duration = GetAbilityDuration(36293) / 1000, abilityID = 4036293},		-- Shadow Image Lvl 3
	[GetAbilityName(36298)] = {unitTag = 'player', duration = GetAbilityDuration(36298) / 1000, abilityID = 4036298},		-- Shadow Image Lvl 4	
}

local enchantProcs = { -- used to spawn fake auras to handle enchant procs the game doesn't track
-- Weapon enchant procs
	[21230] = {unitTag = 'player', duration = GetAbilityDuration(21230) / 1000, icon = '/esoui/art/icons/ability_rogue_006.dds'},			-- Weapon/spell power enchant (Berserker)
	[17906] = {unitTag = 'player', duration = GetAbilityDuration(17906) / 1000, icon = '/esoui/art/icons/ability_armor_001.dds'},			-- Reduce spell/physical resist (Crusher)
	[21578] = {unitTag = 'player', duration = GetAbilityDuration(21578) / 1000, icon = '/esoui/art/icons/ability_healer_029.dds'},			-- Damage shield enchant (Hardening)
}

local gearProcs = { -- used to spawn fake auras to handle gear procs the game doesn't track
-- Armor set procs	
	[71067] = {unitTag = 'player', duration = GetAbilityDuration(71067) / 1000, icon = GetAbilityIcon(71067)},		-- Trial By Fire: Shock
	[71058] = {unitTag = 'player', duration = GetAbilityDuration(71058) / 1000, icon = GetAbilityIcon(71058)},		-- Trial By Fire: Fire
	[71019] = {unitTag = 'player', duration = GetAbilityDuration(71019) / 1000, icon = GetAbilityIcon(71019)},		-- Trial By Fire: Frost
	[71069] = {unitTag = 'player', duration = GetAbilityDuration(71069) / 1000, icon = GetAbilityIcon(71069)},		-- Trial By Fire: Disease
	[71072] = {unitTag = 'player', duration = GetAbilityDuration(71072) / 1000, icon = GetAbilityIcon(71072)},		-- Trial By Fire: Poison
	[49236] = {unitTag = 'player', duration = GetAbilityDuration(49236) / 1000, icon = GetAbilityIcon(49236)},		-- Whitestrake's Retribution
	[57170] = {unitTag = 'player', duration = GetAbilityDuration(57170) / 1000, icon = GetAbilityIcon(57170)},		-- Blood Frenzy
	[75726] = {unitTag = 'player', duration = GetAbilityDuration(75726) / 1000, icon = GetAbilityIcon(75726)},		-- Tava's Favor
	[75746] = {unitTag = 'player', duration = GetAbilityDuration(75746) / 1000, icon = GetAbilityIcon(75746)},		-- Clever Alchemist
	[61870] = {unitTag = 'player', duration = GetAbilityDuration(61870) / 1000, icon = GetAbilityIcon(61870)},		-- Armor Master Resistance
	[70352] = {unitTag = 'player', duration = GetAbilityDuration(70352) / 1000, icon = GetAbilityIcon(70352)},		-- Armor Master Spell Resistance
	[34526] = {unitTag = 'player', duration = GetAbilityDuration(34526) / 1000, icon = GetAbilityIcon(34526)},		-- Seventh Legion Brute
}

local fakeTargetDebuffs = { -- used to spawn fake auras to handle invisible debuffs on current target
-- Special case for Fighters Guild Beast Trap (and morph) tracking
	[35754] = {duration = GetAbilityDuration(35754) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast I
	[42712] = {duration = GetAbilityDuration(42712) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast II
	[42719] = {duration = GetAbilityDuration(42719) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast III
	[42726] = {duration = GetAbilityDuration(42726) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004.dds'}, 				-- Trap Beast IV
	[40389] = {duration = GetAbilityDuration(40389) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap I
	[42731] = {duration = GetAbilityDuration(42731) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap II
	[42741] = {duration = GetAbilityDuration(42741) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap III
	[42751] = {duration = GetAbilityDuration(42751) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_a.dds'}, 			-- Rearming Trap IV
	[40376] = {duration = GetAbilityDuration(40376) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap I
	[42761] = {duration = GetAbilityDuration(42761) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap II
	[42768] = {duration = GetAbilityDuration(42768) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap III
	[42775] = {duration = GetAbilityDuration(42775) / 1000, icon = '/esoui/art/icons/ability_fightersguild_004_b.dds'}, 			-- Lightweight Beast Trap IV
-- Wise Mage special case for target vulnerability proc
	[51434] = {duration = GetAbilityDuration(51434) / 1000, icon = '/esoui/art/icons/ability_debuff_minor_vulnerability.dds'},		-- Wise Mage
-- AOE/snare effects
	[69950] = {duration = GetAbilityDuration(69950) / 1000, icon = '/esoui/art/icons/death_recap_magic_aoe.dds'}, 					-- Desecrated Ground (Zombie Snare)
	[60402] = {duration = GetAbilityDuration(60402) / 1000, icon = '/esoui/art/icons/ability_warrior_015.dds'},						-- Ensnare
	[39060] = {duration = GetAbilityDuration(39060) / 1000, icon = '/esoui/art/icons/ability_debuff_root.dds'},						-- Bear Trap
}

local debuffAuras = { -- used to fix game bug where certain debuffs (mostly set procs) are tracked as buffs instead
	[60416] = true,		-- Sunderflame special case to show properly as debuff
}

local specialProcs = { -- special cases requiring hidden EVENT_COMBAT_EVENT ID's to track properly
-- Templar Spear Shards AOE (and morphs)
	[26189] = {unitTag = 'groundaoe', duration = GetAbilityDuration(26189) / 1000,	icon = '/esoui/art/icons/ability_templar_sun_strike.dds'},		-- Spear Shards Lvl 1
	[27072] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27072) / 1000,	icon = '/esoui/art/icons/ability_templar_sun_strike.dds'},		-- Spear Shards Lvl 2
	[27077] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27077) / 1000,	icon = '/esoui/art/icons/ability_templar_sun_strike.dds'},		-- Spear Shards Lvl 3
	[27093] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27093) / 1000,	icon = '/esoui/art/icons/ability_templar_sun_strike.dds'},		-- Spear Shards Lvl 4
	[26861] = {unitTag = 'groundaoe', duration = GetAbilityDuration(26861) / 1000,	icon = '/esoui/art/icons/ability_templar_light_strike.dds'},	-- Luminous Shards Lvl 1
	[27105] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27105) / 1000,	icon = '/esoui/art/icons/ability_templar_light_strike.dds'},	-- Luminous Shards Lvl 2
	[27115] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27115) / 1000,	icon = '/esoui/art/icons/ability_templar_light_strike.dds'},	-- Luminous Shards Lvl 3
	[27125] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27125) / 1000,	icon = '/esoui/art/icons/ability_templar_light_strike.dds'},	-- Luminous Shards Lvl 4
	[26872] = {unitTag = 'groundaoe', duration = GetAbilityDuration(26872) / 1000,	icon = '/esoui/art/icons/ability_templarsun_thrust.dds'},		-- Blazing Spear Lvl 1
	[27148] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27148) / 1000,	icon = '/esoui/art/icons/ability_templarsun_thrust.dds'},		-- Blazing Spear Lvl 2
	[27159] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27159) / 1000,	icon = '/esoui/art/icons/ability_templarsun_thrust.dds'},		-- Blazing Spear Lvl 3
	[27170] = {unitTag = 'groundaoe', duration = GetAbilityDuration(27170) / 1000,	icon = '/esoui/art/icons/ability_templarsun_thrust.dds'},		-- Blazing Spear Lvl 4
-- Aggressive Warhorn Major Force (not tracked by game)
	[46522] = {unitTag = 'player', duration = GetAbilityDuration(46522) / 1000,	icon = '/esoui/art/icons/ability_ava_003_a.dds'},					-- Aggressive Warhorn Major Force Lvl 4
	[46533] = {unitTag = 'player', duration = GetAbilityDuration(46533) / 1000,	icon = '/esoui/art/icons/ability_ava_003_a.dds'},					-- Aggressive Warhorn Major Force Lvl 4
	[46536] = {unitTag = 'player', duration = GetAbilityDuration(46536) / 1000,	icon = '/esoui/art/icons/ability_ava_003_a.dds'},					-- Aggressive Warhorn Major Force Lvl 4
	[46539] = {unitTag = 'player', duration = GetAbilityDuration(46539) / 1000,	icon = '/esoui/art/icons/ability_ava_003_a.dds'},					-- Aggressive Warhorn Major Force Lvl 4
}

local specialNames = { -- special database for name-swapping custom auras the game doesn't track or name correctly
-- Swaps Aggressive Warhorn Major Force to say "Major Force"
	[46522] = {name = GetAbilityName(40225)},
	[46533] = {name = GetAbilityName(40225)},
	[46536] = {name = GetAbilityName(40225)},
	[46539] = {name = GetAbilityName(40225)},
-- Swaps Templar Sun Fire (and morphs) Major Prophecy buff to read as "Major Prophecy"
	[21726] = {name = GetAbilityName(47193)},
	[24160] = {name = GetAbilityName(47193)},
	[24167] = {name = GetAbilityName(47193)},
	[24171] = {name = GetAbilityName(47193)},
	[21729] = {name = GetAbilityName(47193)},
	[24174] = {name = GetAbilityName(47193)},
	[24177] = {name = GetAbilityName(47193)},
	[24180] = {name = GetAbilityName(47193)},
	[21732] = {name = GetAbilityName(47193)},
	[24184] = {name = GetAbilityName(47193)},
	[24187] = {name = GetAbilityName(47193)},
	[24195] = {name = GetAbilityName(47193)},
-- Changes duplicate Arrow Spray (and morph) snare effect to "Snare 40%"
	[31272] = {name = GetAbilityName(48502).." 40%"},	-- Arrow Spray Rank I
	[40760] = {name = GetAbilityName(48502).." 40%"},	-- Arrow Spray Rank II
	[40763] = {name = GetAbilityName(48502).." 40%"},	-- Arrow Spray Rank III
	[40766] = {name = GetAbilityName(48502).." 40%"},	-- Arrow Spray Rank IV
	[38706] = {name = GetAbilityName(48502).." 40%"},	-- Bombard Rank I
	[40770] = {name = GetAbilityName(48502).." 40%"},	-- Bombard Rank II
	[40774] = {name = GetAbilityName(48502).." 40%"},	-- Bombard Rank III
	[40778] = {name = GetAbilityName(48502).." 40%"},	-- Bombard Rank IV
	[38702] = {name = GetAbilityName(48502).." 40%"},	-- Acid Spray Rank I
	[40784] = {name = GetAbilityName(48502).." 40%"},	-- Acid Spray Rank II
	[40788] = {name = GetAbilityName(48502).." 40%"},	-- Acid Spray Rank III
	[40792] = {name = GetAbilityName(48502).." 40%"},	-- Acid Spray Rank IV
}

local releaseTriggers = { -- special case used to detect removal of the defensive rune ability
-- Special case for Defensive Rune release
	[24576] = {release = 24574},	-- Defensive Rune I Release
	[62294] = {release = 30182},	-- Defensive Rune II Release
	[62298] = {release = 30188},	-- Defensive Rune III Release
	[62299] = {release = 30194},	-- Defensive Rune IV Release
-- Nightblade Grim Focus (and morphs)
	[61907] = {release = 61902},	-- Grim Focus Lvl 1
	[62120] = {release = 62090},	-- Grim Focus Lvl 2
	[62122] = {release = 64176},	-- Grim Focus Lvl 3
	[62124] = {release = 62096},	-- Grim Focus Lvl 4
	[61932] = {release = 61927},	-- Relentless Focus Lvl 1
	[62126] = {release = 62099},	-- Relentless Focus Lvl 2
	[62128] = {release = 62103},	-- Relentless Focus Lvl 3
	[62130] = {release = 62107},	-- Relentless Focus Lvl 4
	[61930] = {release = 61919},	-- Merciless Resolve Lvl 1
	[62132] = {release = 62111},	-- Merciless Resolve Lvl 2
	[62135] = {release = 62114},	-- Merciless Resolve Lvl 3
	[62138] = {release = 62117},	-- Merciless Resolve Lvl 4
}

local alternateAura = { -- used by the consolidate multi-aura function
	[26213] = {altName = GetAbilityName(26207), unitTag = 'player'}, -- Display "Restoring Aura" instead of all three auras
	[76420] = {altName = GetAbilityName(34080), unitTag = 'player'}, -- Display "Flames of Oblivion" instead of both auras
}

local procAbilityNames = { -- using names rather than IDs to ease matching multiple IDs to multiple different IDs
	[GetAbilityName(46327)] = false,	-- Crystal Fragments -- special case, controlled by the actual aura
	[GetAbilityName(61907)] = true,		-- Assassin's Will
	[GetAbilityName(62128)] = true,		-- Assassin's Scourge
	[GetAbilityName(23903)] = true,		-- Power Lash
	[GetAbilityName(62549)] = true,		-- Deadly Throw
}

local toggledAuras = { -- there is a seperate abilityID for every rank of a skill
	[23316] = true,			-- Volatile Familiar
	[30664] = true,			-- Volatile Familiar
	[30669] = true,			-- Volatile Familiar
	[30674] = true,			-- Volatile Familiar
	[23304] = true,			-- Unstable Familiar
	[30631] = true,			-- Unstable Familiar
	[30636] = true,			-- Unstable Familiar
	[30641] = true,			-- Unstable Familiar
	[23319] = true,			-- Unstable Clannfear
	[30647] = true,			-- Unstable Clannfear
	[30652] = true,			-- Unstable Clannfear
	[30657] = true,			-- Unstable Clannfear
	[24613] = true,			-- Summon Winged Twilight
	[30581] = true,			-- Summon Winged Twilight
	[30584] = true,			-- Summon Winged Twilight
	[30587] = true,			-- Summon Winged Twilight
	[24639] = true,			-- Summon Twilight Matriarch
	[30618] = true,			-- Summon Twilight Matriarch
	[30622] = true,			-- Summon Twilight Matriarch
	[30626] = true,			-- Summon Twilight Matriarch
	[24636] = true,			-- Summon Twilight Tormentor
	[30592] = true,			-- Summon Twilight Tormentor
	[30595] = true,			-- Summon Twilight Tormentor
	[30598] = true,			-- Summon Twilight Tormentor
	[61529] = true,			-- Stalwart Guard
	[63341] = true,			-- Stalwart Guard
	[63346] = true,			-- Stalwart Guard
	[63351] = true,			-- Stalwart Guard
	[61536] = true,			-- Mystic Guard
	[63323] = true,			-- Mystic Guard
	[63329] = true,			-- Mystic Guard
	[63335] = true,			-- Mystic Guard
	[36908] = true,			-- Leeching Strikes
	[37989] = true,			-- Leeching Strikes
	[38002] = true,			-- Leeching Strikes
	[38015] = true,			-- Leeching Strikes
	[61511] = true,			-- Guard
	[63308] = true,			-- Guard
	[63313] = true,			-- Guard
	[63318] = true,			-- Guard
	[24158] = true,			-- Bound Armor
	[30410] = true,			-- Bound Armor
	[30414] = true,			-- Bound Armor
	[30418] = true,			-- Bound Armor
	[24165] = true,			-- Bound Armaments
	[30422] = true,			-- Bound Armaments
	[30427] = true,			-- Bound Armaments
	[30432] = true,			-- Bound Armaments
	[24163] = true,			-- Bound Aegis
	[30437] = true,			-- Bound Aegis
	[30441] = true,			-- Bound Aegis
	[30445] = true,			-- Bound Aegis
	[116007] = true,		-- Sample Aura (FAKE)
	[116008] = true,		-- Sample Aura (FAKE)
}

local abilityCooldowns = { -- assign cooldown tracker to a display frame to monitor ability cooldowns (beta)
-- Trial Sets
	[51315]		= {cooldown = 10,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'reticleover'},		-- Destructive Mage
	[86907]		= {cooldown = 10,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Defending Warrior
-- Monster Sets
	[59517]		= {cooldown = 6,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Bloodspawn
	[59591]		= {cooldown = 6.2,	hasTimer = true,	altDuration = 6,	altName = nil,		altIcon = '/esoui/art/icons/gear_undaunted_titan_head_a.dds',				unitTag = 'groundaoe'},			-- Bogdan
	[81069]		= {cooldown = 10,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = GetAbilityIcon(81077),											unitTag = 'player'},			-- Chokethorn
	[97900]		= {cooldown = 15,	hasTimer = true,	altDuration = 10,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Domihaus (weapon damage)
	[97896]		= {cooldown = 15,	hasTimer = true,	altDuration = 10,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Domihaus (spell damage)
	[97857]		= {cooldown = 35,	hasTimer = true,	altDuration = 3,	altName = nil,		altIcon = nil,																unitTag = 'groundaoe'},			-- Earthgore
	[84504]		= {cooldown = 10,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Grothdar
	[80562]		= {cooldown = 6,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Iceheart
	[80525]		= {cooldown = 8,	hasTimer = true,	altDuration = 5,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Ilambris (fire)
	[80526]		= {cooldown = 8,	hasTimer = true,	altDuration = 5,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Ilambris (lightning)
	[83405]		= {cooldown = 6,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Infernal Guardian
	[80566]		= {cooldown = 3,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Kra'gh
	[59586]		= {cooldown = 10,	hasTimer = true,	altDuration = 10,	altName = nil,		altIcon = nil,																unitTag = 'groundaoe'},			-- Lord Warden Dusk
	[85658]		= {cooldown = 6,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = GetAbilityIcon(59568),											unitTag = 'player'},			-- Malubeth
	[59508]		= {cooldown = 15,	hasTimer = true,	altDuration = nil,	altName = 60973,	altIcon = '/esoui/art/icons/gear_undaunted_daedroth_head_a.dds',			unitTag = 'player'},			-- Maw of the Infernal
	[80600]		= {cooldown = 4,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = GetAbilityIcon(80606),											unitTag = 'player'},			-- Selene
	[80544]		= {cooldown = 5.5,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Sellistrix
	[81036]		= {cooldown = 15,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/gear_undauntedcenturion_head_a.dds',			unitTag = 'groundaoe'},			-- Sentinel of Rkugamz
	[80954]		= {cooldown = 15,	hasTimer = true,	altDuration = nil,	altName = 80980,	altIcon = GetAbilityIcon(80980),											unitTag = 'player'},			-- Shadowrend
	[59498]		= {cooldown = 10,	hasTimer = true,	altDuration = 10,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Spawn of Mephala
	[80522]		= {cooldown = 8,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Stormfist
	[102094]	= {cooldown = 8,	hasTimer = true,	altDuration = 8,	altName = nil,		altIcon = '/esoui/art/icons/gear_undaunted_fanglair_head_a.dds',			unitTag = 'groundaoe'},			-- Thurvokun
	[80865]		= {cooldown = 4,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Tremorscale
	[59596]		= {cooldown = 5,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Valkyn Skoria
	[80487]		= {cooldown = 9,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = '/esoui/art/icons/gear_undaunted_hoarvordaedra_head_a.dds',		unitTag = 'player'},			-- Velidreth
	[102136]	= {cooldown = 18,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/gear_undaunted_dragonpriest_shoulder_a.dds',	unitTag = 'player'},			-- Zaan
-- Dungeon Sets
	[84277]		= {cooldown = 45,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/gear_mazzatun_heavy_head_a.dds',				unitTag = 'player'},			-- Aspect of Mazzatun
	[66887]		= {cooldown = 15,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Brands of Imperium
	[61459]		= {cooldown = 12,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Burning Spellweave
	[102060]	= {cooldown = 10,	hasTimer = false,	altDuration = nil,	altName = 102033,	altIcon = '/esoui/art/icons/ability_mage_053.dds',							unitTag = 'player'},			-- Caluurion's Legacy
	[67098]		= {cooldown = 6,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Combat Physician
	[102023]	= {cooldown = 7,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Curse of Doylemish
	[97539]		= {cooldown = 10,	hasTimer = true,	altDuration = 10,	altName = nil,		altIcon = nil,																unitTag = 'groundaoe'},			-- Draugr's Rest
	[99144]		= {cooldown = 10,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = '/esoui/art/icons/ability_mage_011.dds',							unitTag = 'player'},			-- Flame Blossom
	[97910]		= {cooldown = 45,	hasTimer = true,	altDuration = 5,	altName = nil,		altIcon = '/esoui/art/icons/ability_mage_038.dds',							unitTag = 'player'},			-- Hagraven's Garden
	[97626]		= {cooldown = 15,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Ironblood
	[34813]		= {cooldown = 30,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/ability_mage_037.dds',							unitTag = 'player'},			-- Magicka Furnace
	[67288]		= {cooldown = 6,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Scathing Mage
	[57164]		= {cooldown = 60,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Shroud of the Lich
	[61200]		= {cooldown = 10,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Undaunted Bastion
	[57163]		= {cooldown = 60,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/ability_mage_044.dds',							unitTag = 'player'},			-- Vestments of the Warlock
	[97716]		= {cooldown = 10,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Pillar of Nirn
	[102106]	= {cooldown = 15,	hasTimer = true,	altDuration = 3.9,	altName = 102113,	altIcon = '/esoui/art/icons/ability_mage_019.dds',							unitTag = 'groundaoe'},			-- Plague Slinger
	[67927]		= {cooldown = 6,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/ability_rogue_030.dds',							unitTag = 'player'},			-- Sheer Venom
	[101970]	= {cooldown = 60,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons\ability_buff_major_endurance.dds',				unitTag = 'player'},			-- Trappings of Invigoration
	[33691]		= {cooldown = 4,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'reticleover'},		-- Viper's Sting
-- Overland Sets
	[85978]		= {cooldown = 5,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/ability_mage_070.dds',							unitTag = 'player'},			-- Barkskin
	[71107]		= {cooldown = 15,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Briarheart
	[93308]		= {cooldown = 5,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = '/esoui/art/icons/quest_head_monster_020.dds',					unitTag = 'player'},			-- Defiler
	[57297]		= {cooldown = 20,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Draugr Heritage
	[57133]		= {cooldown = 20,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Dreamer's Mantle
	[85797]		= {cooldown = 14,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Hatchling's Shell
--	[34508]		= {cooldown = 5,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Hide of the Werewolf
	[99286]		= {cooldown = 8,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Livewire
	[92982]		= {cooldown = 10,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = '/esoui/art/icons/quest_head_monster_007.dds',					unitTag = 'player'},			-- Mad Tinkerer
	[34711]		= {cooldown = 10,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Meridia's Blessed Armor
	[57175]		= {cooldown = 3,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Robes of the Withered Hand
	[57210]		= {cooldown = 6.2,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Storm Knight's Plate
	[76344]		= {cooldown = 6.5,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Syvarra's Scales
	[33497]		= {cooldown = 3,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Thunderbug's Carapace
	[71657]		= {cooldown = 5,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Trinimac's Valor
	[99268]		= {cooldown = 15,	hasTimer = true,	altDuration = 12,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Unfathomable Darkness
	[52705]		= {cooldown = 4,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Way of Martial Knowledge
	[34871]		= {cooldown = 15,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Wyrd Tree's Blessing
-- Crafted Sets
	[34502]		= {cooldown = 4,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Ashen Grip
	[33764]		= {cooldown = 30,	hasTimer = false,	altDuration = 0,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Death's Wind
	[99204]		= {cooldown = 18,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Mechanical Acuity
	[34587]		= {cooldown = 30,	hasTimer = false,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Song of Lamae
	[69685]		= {cooldown = 6,	hasTimer = true,	altDuration = nil,	altName = nil,		altIcon = nil,																unitTag = 'player'},			-- Spectre's Eye

-- /script d(GetAbilityIcon())
-- /script d(GetAbilityDuration())
-- /script d(GetItemLinkIcon(''))
-- /script d(GetAbilityName())
}


-- ------------------------
-- MAIN FILTER TABLES
-- ------------------------
local filterAlwaysIgnored = {
-- Default ignore list
	[29667] = true,		-- Concentration (Light Armour)
	[45569] = true,		-- Medicinal Use (Alchemy)
	[62760] = true,		-- Spell Shield (Champion Point Ability)
	[64160] = true,		-- Crystal Fragments Passive (Not Timed)
	[36603] = true,		-- Soul Siphoner Passive I
	[45155] = true,		-- Soul Siphoner Passive II
	[57472] = true,		-- Rapid Maneuver (Extra Aura)
	[57475] = true,		-- Rapid Maneuver (Extra Aura)
	[57474] = true,		-- Rapid Maneuver (Extra Aura)
	[57476] = true,		-- Rapid Maneuver (Extra Aura)
	[57480]	= true,		-- Rapid Maneuver (Extra Aura)
	[57481]	= true,		-- Rapid Maneuver (Extra Aura)
	[57482]	= true,		-- Rapid Maneuver (Extra Aura)
	[64945] = true,		-- Guard Regen (Guarded Extra)
	[64946] = true,		-- Guard Regen (Guarded Extra)
	[46672] = true,		-- Propelling Shield (Extra Aura)
	[42198] = true,		-- Spinal Surge (Extra Aura)
	[62587] = true,		-- Focused Aim (2s Refreshing Aura)
	[38698] = true,		-- Focused Aim (2s Refreshing Aura)
	[42589] = true,		-- Flawless Dawnbreaker (2s aura on Weaponswap)
-- Consolidated multi-auras
	[26215] = true,	-- Redundant Restoring Aura
	[26216] = true,	-- Redundant Restoring Aura
	[57484] = true,	-- Duplicate Rapid Maneuver on Charging morph
	[76426] = true, -- Redundant Flames of Oblivion
-- Duplicates for Vampire Drain
	[19028] = true,	-- Drain Essence
	[42052] = true,	-- Drain Essence
	[50477] = true,	-- Drain Essence
	[50478] = true,	-- Drain Essence
	[50479] = true,	-- Drain Essence
	[50480] = true,	-- Drain Essence
	[55081] = true,	-- Drain Essence
	[55082] = true,	-- Drain Essence
	[55084] = true,	-- Drain Essence
	[65326] = true,	-- Drain Essence
	[65327] = true,	-- Drain Essence
	[65330] = true,	-- Drain Essence
	[65700] = true,	-- Drain Essence
	[65701] = true,	-- Drain Essence
	[68883] = true,	-- Drain Essence
	[68884] = true,	-- Drain Essence
	[68886] = true,	-- Drain Essence
	[68888] = true,	-- Drain Essence
	[70680] = true,	-- Drain Essence
	[71182] = true,	-- Drain Essence
	[71634] = true,	-- Drain Essence
	[81464] = true,	-- Drain Essence
	[81468] = true,	-- Drain Essence
	[81469] = true,	-- Drain Essence
	[81470] = true,	-- Drain Essence
	[81471] = true,	-- Drain Essence
	[81488] = true,	-- Drain Essence
	[81489] = true,	-- Drain Essence
	[81490] = true,	-- Drain Essence
	[81618] = true,	-- Drain Essence
	[19028] = true,	-- Drain Essence
	[81491] = true, -- Accelerating Drain 		
	[81492] = true, -- Accelerating Drain 		
	[81493] = true, -- Accelerating Drain 		
	[81494] = true, -- Accelerating Drain 		
	[81495] = true, -- Accelerating Drain 		
	[81497] = true, -- Accelerating Drain 		
	[81498] = true, -- Accelerating Drain 		
	[81499] = true, -- Accelerating Drain 		
	[81501] = true, -- Accelerating Drain 		
	[81502] = true, -- Accelerating Drain 		
	[81503] = true, -- Accelerating Drain 		
	[81505] = true, -- Accelerating Drain 	
	[38954] = true, -- Invigorating Drain
	[68892] = true, -- Invigorating Drain
	[81474] = true, -- Invigorating Drain
	[81475] = true, -- Invigorating Drain
	[81476] = true, -- Invigorating Drain
	[81477] = true, -- Invigorating Drain
	[81478] = true, -- Invigorating Drain
	[81479] = true, -- Invigorating Drain
	[81480] = true, -- Invigorating Drain
	[81481] = true, -- Invigorating Drain
	[81482] = true, -- Invigorating Drain
	[81483] = true, -- Invigorating Drain
	[81484] = true, -- Invigorating Drain
	[81485] = true, -- Invigorating Drain
	[81486] = true, -- Invigorating Drain
	[81487] = true, -- Invigorating Drain
-- Special case for Fighters Guild Beast Trap (and morph) tracking
	[35753] = true, -- Redundant Trap Beast I
	[42710] = true, -- Redundant Trap Beast II
	[42717] = true, -- Redundant Trap Beast III
	[42724] = true, -- Redundant Trap Beast IV
	[40384] = true, -- Redundant Rearming Trap I
	[42732] = true, -- Redundant Rearming Trap II
	[42742] = true, -- Redundant Rearming Trap III
	[42752] = true, -- Redundant Rearming Trap IV
	[40374] = true, -- Redundant Lightweight Beast Trap I
	[42759] = true, -- Redundant Lightweight Beast Trap II
	[42766] = true, -- Redundant Lightweight Beast Trap III
	[42773] = true, -- Redundant Lightweight Beast Trap IV
-- Light Armor active ability redundant buffs
	[41503] = true, -- Annulment Dummy
	[39188] = true, -- Dampen Magic
	[41110] = true, -- Dampen Magic
	[41112] = true, -- Dampen Magic
	[41114] = true, -- Dampen Magic
	[44323] = true, -- Dampen Magic
	[39185] = true, -- Harness Magicka
	[41117] = true, -- Harness Magicka
	[41120] = true, -- Harness Magicka
	[41123] = true, -- Harness Magicka
	[42876] = true, -- Harness Magicka
	[42877] = true, -- Harness Magicka
	[42878] = true, -- Harness Magicka
-- Redundant Food Auras
	[84732] = true, -- Witchmother's Potent Brew
	[84733] = true, -- Witchmother's Potent Brew
-- Random blacklisted (thanks Scootworks)
	[29705] = true, -- Whirlpool
	[30455] = true, -- Arachnophobia
	[37136] = true, -- Amulet
	[37342] = true, -- dummy
	[37475] = true, -- Manifestation of Terror
	[43588] = true, -- Killing Blow
	[43594] = true, -- Wait for teleport
	[44912] = true, -- Q4730 Shackle Breakign Shakes
	[45050] = true, -- Executioner
	[47718] = true, -- Death Stun
	[49807] = true, -- Killing Blow Stun
	[55406] = true, -- Resurrect Trigger
	[55915] = true, -- Sucked Under Fall Bonus
	[56739] = true, -- Damage Shield
	[57275] = true, -- Shadow Tracker
	[57360] = true, -- Portal
	[57425] = true, -- Brace For Impact
	[57756] = true, -- Blend into Shadows
	[57771] = true, -- Clone Die Counter
	[58107] = true, -- Teleport
	[58210] = true, -- PORTAL CHARGED
	[58241] = true, -- Shadow Orb - Lord Warden
	[58242] = true, -- Fearpicker
	[58955] = true, -- Death Achieve Check
	[59040] = true, -- Teleport Tracker
	[59911] = true, -- Boss Speed
	[60414] = true, -- Tower Destroyed
	[60947] = true, -- Soul Absorbed
	[60967] = true, -- Summon Adds
	[64132] = true, -- Grapple Immunity
	[66808] = true, -- Molag Kena
	[66813] = true, -- White-Gold Tower Item Set
	[69809] = true, -- Hard Mode
	[70113] = true, -- Shade Despawn
}

local filterAuraGroups = {
	['esoplus'] = {
		[63601]	= true,		-- ESO Plus status
	},

	['block'] = {
		[14890]	= true,		-- Brace (Generic)
	},
	['cyrodiil'] = {
		[11341] = true,		-- Enemy Keep Bonus I
		[11343] = true,		-- Enemy Keep Bonus II
		[11345] = true,		-- Enemy Keep Bonus III
		[11347] = true,		-- Enemy Keep Bonus IV
		[11348] = true,		-- Enemy Keep Bonus V
		[11350] = true,		-- Enemy Keep Bonus VI
		[11352] = true,		-- Enemy Keep Bonus VII
		[11353] = true,		-- Enemy Keep Bonus VIII
		[11356] = true,		-- Enemy Keep Bonus IX
		[12033] = true,		-- Battle Spirit
		[15058]	= true,		-- Offensive Scroll Bonus I
		[15060]	= true,		-- Defensive Scroll Bonus I
		[16348]	= true,		-- Offensive Scroll Bonus II
		[16350]	= true,		-- Defensive Scroll Bonus II
		[39671]	= true,		-- Emperorship Alliance Bonus
	},
	['disguise'] = {
		-- intentionally empty table just so setup can iterate through filters more simply
	},
	['mundusBoon'] = {
		[13940]	= true,		-- Boon: The Warrior
		[13943]	= true,		-- Boon: The Mage
		[13974]	= true,		-- Boon: The Serpent
		[13975]	= true,		-- Boon: The Thief
		[13976]	= true,		-- Boon: The Lady
		[13977]	= true,		-- Boon: The Steed
		[13978]	= true,		-- Boon: The Lord
		[13979]	= true,		-- Boon: The Apprentice
		[13980]	= true,		-- Boon: The Ritual
		[13981]	= true,		-- Boon: The Lover
		[13982]	= true,		-- Boon: The Atronach
		[13984]	= true,		-- Boon: The Shadow
		[13985]	= true,		-- Boon: The Tower
	},
	['soulSummons'] = {
		[39269] = true,		-- Soul Summons (Rank 1)
		[43752] = true,		-- Soul Summons (Rank 2)
		[45590] = true,		-- Soul Summons (Rank 2)
	},
	['vampLycan'] = {
		[35658] = true,		-- Lycanthropy
		[35771]	= true,		-- Stage 1 Vampirism (trivia: has a duration even though others don't)
		[35773]	= true,		-- Stage 2 Vampirism
		[35780]	= true,		-- Stage 3 Vampirism
		[35786]	= true,		-- Stage 4 Vampirism
		[35792]	= true,		-- Stage 4 Vampirism
	},
	['vampLycanBite'] = {
		[40359] = true,		-- Fed On Ally
		[40525] = true,		-- Bit an ally
		[39472] = true,		-- Vampirism
		[40521] = true,		-- Sanies Lupinus
	},
}

local filteredAuras = { -- used to hold the abilityIDs of filtered auras
	['player']		= {},
	['reticleover']	= {},
	['groundaoe']	= {}
}

for id in pairs(filterAlwaysIgnored) do -- populate initial ignored auras to filters
	filteredAuras['player'][id]			= true
	filteredAuras['reticleover'][id]	= true
	filteredAuras['groundaoe'][id]		= true
end	-- run once on init of addon

Srendarr.crystalFragments			= GetAbilityName(46324) -- special case for merging frags procs
Srendarr.crystalFragmentsPassive	= GetAbilityName(46327) -- with the general proc system

-- set external references
Srendarr.alteredAuraIcons		= alteredAuraIcons
Srendarr.alteredAuraDuration	= alteredAuraDuration
Srendarr.stackingAuras			= stackingAuras
Srendarr.catchTriggers			= catchTriggers
Srendarr.fakeAuras				= fakeAuras
Srendarr.enchantProcs			= enchantProcs
Srendarr.gearProcs				= gearProcs
Srendarr.specialProcs			= specialProcs
Srendarr.specialNames			= specialNames
Srendarr.releaseTriggers		= releaseTriggers
Srendarr.fakeTargetDebuffs		= fakeTargetDebuffs
Srendarr.debuffAuras			= debuffAuras
Srendarr.alternateAura 			= alternateAura
Srendarr.filteredAuras			= filteredAuras
Srendarr.procAbilityNames		= procAbilityNames
Srendarr.abilityCooldowns		= abilityCooldowns


-- ------------------------
-- OTHER DATA TABLES
-- ------------------------
Srendarr.auraLookup = {
	['player']				= {},
	['reticleover']			= {},
	['groundaoe']			= {},
	['group1']				= {},
	['group2']				= {},
	['group3']				= {},
	['group4']				= {},
	['group5']				= {},
	['group6']				= {},
	['group7']				= {},
	['group8']				= {},
	['group9']				= {},
	['group10']				= {},
	['group11']				= {},
	['group12']				= {},
	['group13']				= {},
	['group14']				= {},
	['group15']				= {},
	['group16']				= {},
	['group17']				= {},
	['group18']				= {},
	['group19']				= {},
	['group20']				= {},
	['group21']				= {},
	['group22']				= {},
	['group23']				= {},
	['group24']				= {},
}

Srendarr.sampleAuraData = {
	-- player timed
	[116001] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 1),		unitTag = 'player', duration = 10,	icon = [[/esoui/art/icons/ability_destructionstaff_001.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116002] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 2),		unitTag = 'player', duration = 20,	icon = [[/esoui/art/icons/ability_destructionstaff_002.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116003] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 3),		unitTag = 'player', duration = 30,	icon = [[/esoui/art/icons/ability_destructionstaff_003.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116004] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 4),		unitTag = 'player', duration = 60,	icon = [[/esoui/art/icons/ability_destructionstaff_004.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116005] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 5),		unitTag = 'player', duration = 120,	icon = [[/esoui/art/icons/ability_destructionstaff_005.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116006] = {auraName = strformat('%s %d', L.SampleAura_PlayerTimed, 6),		unitTag = 'player', duration = 600,	icon = [[/esoui/art/icons/ability_destructionstaff_006.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- player toggled
	[116007] = {auraName = strformat('%s %d', L.SampleAura_PlayerToggled, 1),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_mageguild_001.dds]],			effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116008] = {auraName = strformat('%s %d', L.SampleAura_PlayerToggled, 2),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_mageguild_002.dds]],			effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- player passive
	[116009] = {auraName = strformat('%s %d', L.SampleAura_PlayerPassive, 1),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_restorationstaff_001.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116010] = {auraName = strformat('%s %d', L.SampleAura_PlayerPassive, 2),	unitTag = 'player', duration = 0,	icon = [[esoui/art/icons/ability_restorationstaff_002.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- player debuff
	[116011] = {auraName = strformat('%s %d', L.SampleAura_PlayerDebuff, 1),	unitTag = 'player', duration = 10,	icon = [[esoui/art/icons/ability_nightblade_001.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
	[116012] = {auraName = strformat('%s %d', L.SampleAura_PlayerDebuff, 2),	unitTag = 'player', duration = 30,	icon = [[esoui/art/icons/ability_nightblade_002.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
	-- player ground
	[116013]  = {auraName = strformat('%s %d', L.SampleAura_PlayerGround, 1),	unitTag = '', 		duration = 10,	icon = [[/esoui/art/icons/ability_destructionstaff_008.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_AREAEFFECT},
	[116014]  = {auraName = strformat('%s %d', L.SampleAura_PlayerGround, 2),	unitTag = '', 		duration = 30,	icon = [[/esoui/art/icons/ability_destructionstaff_011.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_AREAEFFECT},
	-- player major|minor buffs
	[116015] = {auraName = strformat('%s %d', L.SampleAura_PlayerMajor, 1),		unitTag = 'player', duration = 30,	icon = [[/esoui/art/icons/ability_sorcerer_boundless_storm.dds]], effectType = BUFF_EFFECT_TYPE_BUFF,	abilityType = ABILITY_TYPE_BONUS},
	[116016] = {auraName = strformat('%s %d', L.SampleAura_PlayerMinor, 1),		unitTag = 'player', duration = 30,	icon = [[/esoui/art/icons/ability_sorcerer_boundless_storm.dds]], effectType = BUFF_EFFECT_TYPE_BUFF,	abilityType = ABILITY_TYPE_BONUS},
	-- target buff (2 timeds and 1 passive)
	[116017] = {auraName = strformat('%s %d', L.SampleAura_TargetBuff, 1),		unitTag = 'reticleover', duration = 10,	icon = [[esoui/art/icons/ability_restorationstaff_004.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116018] = {auraName = strformat('%s %d', L.SampleAura_TargetBuff, 2),		unitTag = 'reticleover', duration = 30,	icon = [[esoui/art/icons/ability_restorationstaff_005.dds]],	effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	[116019] = {auraName = strformat('%s %d', L.SampleAura_TargetBuff, 3),		unitTag = 'reticleover', duration = 0,	icon = [[/esoui/art/icons/ability_armor_001.dds]],				effectType = BUFF_EFFECT_TYPE_BUFF,		abilityType = ABILITY_TYPE_BONUS},
	-- target debuff
	[116020] = {auraName = strformat('%s %d', L.SampleAura_TargetDebuff, 1),	unitTag = 'reticleover', duration = 10,	icon = [[esoui/art/icons/ability_nightblade_003.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
	[116021] = {auraName = strformat('%s %d', L.SampleAura_TargetDebuff, 2),	unitTag = 'reticleover', duration = 30,	icon = [[esoui/art/icons/ability_nightblade_004.dds]],			effectType = BUFF_EFFECT_TYPE_DEBUFF,	abilityType = ABILITY_TYPE_BONUS},
}

local groupUnit = {
	["group1"]		= true,
	["group2"]		= true,
	["group3"]		= true,
	["group4"]		= true,
	["group5"]		= true,
	["group6"]		= true,
	["group7"]		= true,
	["group8"]		= true,
	["group9"]		= true,
	["group10"]		= true,
	["group11"]		= true,
	["group12"]		= true,
	["group13"]		= true,
	["group14"]		= true,
	["group15"]		= true,
	["group16"]		= true,
	["group17"]		= true,
	["group18"]		= true,
	["group19"]		= true,
	["group20"]		= true,
	["group21"]		= true,
	["group22"]		= true,
	["group23"]		= true,
	["group24"]		= true,
}


-- ------------------------
-- AURA DATA FUNCTIONS
-- ------------------------
function Srendarr.IsToggledAura(abilityID)
	return toggledAuras[abilityID] and true or false
end

function Srendarr.IsMajorEffect(abilityID)
	return majorEffects[abilityID] and true or false
end

function Srendarr.IsMinorEffect(abilityID)
	return minorEffects[abilityID] and true or false
end

function Srendarr.IsEnchantProc(abilityID)
	if enchantProcs[abilityID] ~= nil then return true else return false end
end

function Srendarr.IsGearProc(abilityID)
	if gearProcs[abilityID] ~= nil then return true else return false end
end

function Srendarr.IsAlternateAura(abilityID)
	if alternateAura[abilityID] ~= nil then return true else return false end
end

function Srendarr.IsTrackedCooldown(abilityID)
	if abilityCooldowns[abilityID] ~= nil then return true else return false end
end

function Srendarr.IsGroupUnit(unitTag)
	if groupUnit[unitTag] ~= nil then return true else return false end
end

function Srendarr:PopulateFilteredAuras()
	for _, filterUnitTag in pairs(filteredAuras) do
		for id in pairs(filterUnitTag) do
			if (not filterAlwaysIgnored[id]) then
				filterUnitTag[id] = nil -- clean out existing filters unless always ignored
			end
		end
	end

	-- populate player aura filters
	for filterGroup, doFilter in pairs(self.db.filtersPlayer) do
		if (filterAuraGroups[filterGroup] and doFilter) then -- filtering this group for player
			for id in pairs(filterAuraGroups[filterGroup]) do
				filteredAuras.player[id] = true
			end
		end
	end

	-- populate target aura filters
	for filterGroup, doFilter in pairs(self.db.filtersTarget) do
		if (doFilter) then
			if (filterGroup == 'majorEffects') then			-- special case for majorEffects
				for id in pairs(majorEffects) do
					filteredAuras.reticleover[id] = true
				end
			elseif (filterGroup == 'minorEffects') then		-- special case for minorEffects
				for id in pairs(minorEffects) do
					filteredAuras.reticleover[id] = true
				end
			elseif (filterAuraGroups[filterGroup]) then
				for id in pairs(filterAuraGroups[filterGroup]) do
					filteredAuras.reticleover[id] = true
				end
			end
		end
	end

	-- populate ground aoe filters
	--

	-- add blacklisted auras to all filter tables
	for _, filterForUnitTag in pairs(filteredAuras) do
		for _, abilityIDs in pairs(self.db.blacklist) do
			for id in pairs(abilityIDs) do
				filterForUnitTag[id] = true
			end
		end
	end
end


-- ------------------------
-- MINOR & MAJOR EFFECT DATA
-- ------------------------
minorEffects = {
-- Minor Aegis
	[76618] = EFFECT_AEGIS,
-- Minor Berserk
	[61744] = EFFECT_BERSERK,
	[62636] = EFFECT_BERSERK,
	[62639] = EFFECT_BERSERK,
	[62642] = EFFECT_BERSERK,
	[62645] = EFFECT_BERSERK,
	[64047] = EFFECT_BERSERK,
	[64048] = EFFECT_BERSERK,
	[64050] = EFFECT_BERSERK,
	[64051] = EFFECT_BERSERK,
	[64052] = EFFECT_BERSERK,
	[64053] = EFFECT_BERSERK,
	[64054] = EFFECT_BERSERK,
	[64055] = EFFECT_BERSERK,
	[64056] = EFFECT_BERSERK,
	[64057] = EFFECT_BERSERK,
	[64058] = EFFECT_BERSERK,
	[64178] = EFFECT_BERSERK,
	[80471] = EFFECT_BERSERK,
	[80481] = EFFECT_BERSERK,
	[81508] = EFFECT_BERSERK,
	[81511] = EFFECT_BERSERK,
	[81514] = EFFECT_BERSERK,
	[87864] = EFFECT_BERSERK,
	[93728] = EFFECT_BERSERK,
	[93731] = EFFECT_BERSERK,
	[93734] = EFFECT_BERSERK,
	[96259] = EFFECT_BERSERK,
-- Minor Breach
	[46206] = EFFECT_BREACH,
	[46248] = EFFECT_BREACH,
	[61742] = EFFECT_BREACH,
	[64256] = EFFECT_BREACH,
	[68588] = EFFECT_BREACH,
	[68589] = EFFECT_BREACH,
	[68591] = EFFECT_BREACH,
	[68592] = EFFECT_BREACH,
	[79086] = EFFECT_BREACH,
	[79087] = EFFECT_BREACH,
	[79284] = EFFECT_BREACH,
	[79306] = EFFECT_BREACH,
	[83031] = EFFECT_BREACH,
-- Minor Brutality
	[61662] = EFFECT_BRUTALITY,
	[61798] = EFFECT_BRUTALITY,
	[61799] = EFFECT_BRUTALITY,
	[64259] = EFFECT_BRUTALITY,
	[79281] = EFFECT_BRUTALITY,
	[79283] = EFFECT_BRUTALITY,
-- Minor Cowardice
	[46202] = EFFECT_COWARDICE,
	[46244] = EFFECT_COWARDICE,
	[79069] = EFFECT_COWARDICE,
	[79082] = EFFECT_COWARDICE,
	[79193] = EFFECT_COWARDICE,
	[79278] = EFFECT_COWARDICE,
	[79867] = EFFECT_COWARDICE,
-- Minor Defile
	[61726] = EFFECT_DEFILE,
	[78606] = EFFECT_DEFILE,
	[79851] = EFFECT_DEFILE,
	[79854] = EFFECT_DEFILE,
	[79856] = EFFECT_DEFILE,
	[79857] = EFFECT_DEFILE,
	[79858] = EFFECT_DEFILE,
	[79860] = EFFECT_DEFILE,
	[79861] = EFFECT_DEFILE,
	[79862] = EFFECT_DEFILE,
	[85637] = EFFECT_DEFILE,
	[88470] = EFFECT_DEFILE,
	[102100] = EFFECT_DEFILE,
-- Minor Endurance
	[26215] = EFFECT_ENDURANCE,
	[61704] = EFFECT_ENDURANCE,
	[62056] = EFFECT_ENDURANCE,
	[62102] = EFFECT_ENDURANCE,
	[62106] = EFFECT_ENDURANCE,
	[62110] = EFFECT_ENDURANCE,
	[80271] = EFFECT_ENDURANCE,
	[80272] = EFFECT_ENDURANCE,
	[80274] = EFFECT_ENDURANCE,
	[80275] = EFFECT_ENDURANCE,
	[80276] = EFFECT_ENDURANCE,
	[80278] = EFFECT_ENDURANCE,
	[80279] = EFFECT_ENDURANCE,
	[80280] = EFFECT_ENDURANCE,
	[80284] = EFFECT_ENDURANCE,
	[80285] = EFFECT_ENDURANCE,
	[80286] = EFFECT_ENDURANCE,
	[80287] = EFFECT_ENDURANCE,
	[87019] = EFFECT_ENDURANCE,
	[93784] = EFFECT_ENDURANCE,
	[93786] = EFFECT_ENDURANCE,
	[93788] = EFFECT_ENDURANCE,
-- Minor Evasion
	[61715] = EFFECT_EVASION,
	[87861] = EFFECT_EVASION,
	[93737] = EFFECT_EVASION,
	[93740] = EFFECT_EVASION,
	[93743] = EFFECT_EVASION,
-- Minor Expedition
	[61735] = EFFECT_EXPEDITION,
	[63558] = EFFECT_EXPEDITION,
	[81496] = EFFECT_EXPEDITION,
	[81500] = EFFECT_EXPEDITION,
	[81504] = EFFECT_EXPEDITION,
	[82797] = EFFECT_EXPEDITION,
	[82799] = EFFECT_EXPEDITION,
	[82800] = EFFECT_EXPEDITION,
	[82801] = EFFECT_EXPEDITION,
	[85602] = EFFECT_EXPEDITION,
-- Minor Force
	[61746] = EFFECT_FORCE,
	[68595] = EFFECT_FORCE,
	[68596] = EFFECT_FORCE,
	[68597] = EFFECT_FORCE,
	[68598] = EFFECT_FORCE,
	[68628] = EFFECT_FORCE,
	[68629] = EFFECT_FORCE,
	[68630] = EFFECT_FORCE,
	[68631] = EFFECT_FORCE,
	[68632] = EFFECT_FORCE,
	[68636] = EFFECT_FORCE,
	[68638] = EFFECT_FORCE,
	[68640] = EFFECT_FORCE,
	[76564] = EFFECT_FORCE,
	[80984] = EFFECT_FORCE,
	[80986] = EFFECT_FORCE,
	[80996] = EFFECT_FORCE,
	[80998] = EFFECT_FORCE,
	[81004] = EFFECT_FORCE,
	[81006] = EFFECT_FORCE,
	[81012] = EFFECT_FORCE,
	[81014] = EFFECT_FORCE,
	[85611] = EFFECT_FORCE,
-- Minor Fortitude
	[26213] = EFFECT_FORTITUDE,
	[61697] = EFFECT_FORTITUDE,
-- Minor Fracture
	[38688] = EFFECT_FRACTURE,
	[46208] = EFFECT_FRACTURE,
	[46250] = EFFECT_FRACTURE,
	[61740] = EFFECT_FRACTURE,
	[62582] = EFFECT_FRACTURE,
	[62585] = EFFECT_FRACTURE,
	[62588] = EFFECT_FRACTURE,
	[64144] = EFFECT_FRACTURE,
	[64145] = EFFECT_FRACTURE,
	[64146] = EFFECT_FRACTURE,
	[64147] = EFFECT_FRACTURE,
	[64255] = EFFECT_FRACTURE,
	[79090] = EFFECT_FRACTURE,
	[79091] = EFFECT_FRACTURE,
	[79309] = EFFECT_FRACTURE,
	[79311] = EFFECT_FRACTURE,
	[83032] = EFFECT_FRACTURE,
	[84358] = EFFECT_FRACTURE,
-- Minor Gallop
-- Minor Heroism
	[38746] = EFFECT_HEROISM,
	[61708] = EFFECT_HEROISM,
	[62336] = EFFECT_HEROISM,
	[62337] = EFFECT_HEROISM,
	[62338] = EFFECT_HEROISM,
	[62505] = EFFECT_HEROISM,
	[62508] = EFFECT_HEROISM,
	[62510] = EFFECT_HEROISM,
	[62512] = EFFECT_HEROISM,
	[85593] = EFFECT_HEROISM,
	[85594] = EFFECT_HEROISM,
-- Minor Hindrance
	[79102] = EFFECT_HINDRANCE,
	[79367] = EFFECT_HINDRANCE,
	[79369] = EFFECT_HINDRANCE,
-- Minor Intellect
	[26216] = EFFECT_INTELLECT,
	[36740] = EFFECT_INTELLECT,
	[61706] = EFFECT_INTELLECT,
	[77418] = EFFECT_INTELLECT,
	[77419] = EFFECT_INTELLECT,
	[77420] = EFFECT_INTELLECT,
	[77421] = EFFECT_INTELLECT,
	[86300] = EFFECT_INTELLECT,
	[93783] = EFFECT_INTELLECT,
	[93785] = EFFECT_INTELLECT,
	[93787] = EFFECT_INTELLECT,
-- Minor Lifesteal
	[33541] = EFFECT_LIFESTEAL,
	[40110] = EFFECT_LIFESTEAL,
	[40117] = EFFECT_LIFESTEAL,
	[41200] = EFFECT_LIFESTEAL,
	[41204] = EFFECT_LIFESTEAL,
	[41208] = EFFECT_LIFESTEAL,
	[41219] = EFFECT_LIFESTEAL,
	[41224] = EFFECT_LIFESTEAL,
	[41229] = EFFECT_LIFESTEAL,
	[41231] = EFFECT_LIFESTEAL,
	[41236] = EFFECT_LIFESTEAL,
	[41240] = EFFECT_LIFESTEAL,
	[80015] = EFFECT_LIFESTEAL,
	[80017] = EFFECT_LIFESTEAL,
	[80020] = EFFECT_LIFESTEAL,
	[80021] = EFFECT_LIFESTEAL,
	[86304] = EFFECT_LIFESTEAL,
	[86305] = EFFECT_LIFESTEAL,
	[86306] = EFFECT_LIFESTEAL,
	[86307] = EFFECT_LIFESTEAL,
	[88565] = EFFECT_LIFESTEAL,
	[88568] = EFFECT_LIFESTEAL,
	[88573] = EFFECT_LIFESTEAL,
	[88574] = EFFECT_LIFESTEAL,
	[88575] = EFFECT_LIFESTEAL,
	[88576] = EFFECT_LIFESTEAL,
	[88584] = EFFECT_LIFESTEAL,
	[88585] = EFFECT_LIFESTEAL,
	[88587] = EFFECT_LIFESTEAL,
	[88588] = EFFECT_LIFESTEAL,
	[88604] = EFFECT_LIFESTEAL,
	[88605] = EFFECT_LIFESTEAL,
	[88606] = EFFECT_LIFESTEAL,
	[88625] = EFFECT_LIFESTEAL,
	[88628] = EFFECT_LIFESTEAL,
	[88634] = EFFECT_LIFESTEAL,
	[93888] = EFFECT_LIFESTEAL,
	[93890] = EFFECT_LIFESTEAL,
	[93892] = EFFECT_LIFESTEAL,
	[93894] = EFFECT_LIFESTEAL,
	[93896] = EFFECT_LIFESTEAL,
	[93898] = EFFECT_LIFESTEAL,
-- Minor Magickasteal
	[26220] = EFFECT_MAGICKASTEAL,
	[26809] = EFFECT_MAGICKASTEAL,
	[26999] = EFFECT_MAGICKASTEAL,
	[27005] = EFFECT_MAGICKASTEAL,
	[27011] = EFFECT_MAGICKASTEAL,
	[27020] = EFFECT_MAGICKASTEAL,
	[27026] = EFFECT_MAGICKASTEAL,
	[27032] = EFFECT_MAGICKASTEAL,
	[39099] = EFFECT_MAGICKASTEAL,
	[39100] = EFFECT_MAGICKASTEAL,
	[40114] = EFFECT_MAGICKASTEAL,
	[41216] = EFFECT_MAGICKASTEAL,
	[41221] = EFFECT_MAGICKASTEAL,
	[41226] = EFFECT_MAGICKASTEAL,
	[62788] = EFFECT_MAGICKASTEAL,
	[62790] = EFFECT_MAGICKASTEAL,
	[62791] = EFFECT_MAGICKASTEAL,
	[62793] = EFFECT_MAGICKASTEAL,
	[62794] = EFFECT_MAGICKASTEAL,
	[62796] = EFFECT_MAGICKASTEAL,
	[88401] = EFFECT_MAGICKASTEAL,
	[88402] = EFFECT_MAGICKASTEAL,
	[88472] = EFFECT_MAGICKASTEAL,
	[88479] = EFFECT_MAGICKASTEAL,
	[88482] = EFFECT_MAGICKASTEAL,
	[88484] = EFFECT_MAGICKASTEAL,
	[88486] = EFFECT_MAGICKASTEAL,
	[88487] = EFFECT_MAGICKASTEAL,
	[88488] = EFFECT_MAGICKASTEAL,
	[88489] = EFFECT_MAGICKASTEAL,
	[88872] = EFFECT_MAGICKASTEAL,
-- Minor Maim
	[29308] = EFFECT_MAIM,
	[31899] = EFFECT_MAIM,
	[33228] = EFFECT_MAIM,
	[33512] = EFFECT_MAIM,
	[37472] = EFFECT_MAIM,
	[38068] = EFFECT_MAIM,
	[38072] = EFFECT_MAIM,
	[38076] = EFFECT_MAIM,
	[44206] = EFFECT_MAIM,
	[46204] = EFFECT_MAIM,
	[46246] = EFFECT_MAIM,
	[61723] = EFFECT_MAIM,
	[61854] = EFFECT_MAIM,
	[61855] = EFFECT_MAIM,
	[61856] = EFFECT_MAIM,
	[62492] = EFFECT_MAIM,
	[62493] = EFFECT_MAIM,
	[62494] = EFFECT_MAIM,
	[62495] = EFFECT_MAIM,
	[62500] = EFFECT_MAIM,
	[62501] = EFFECT_MAIM,
	[62503] = EFFECT_MAIM,
	[62504] = EFFECT_MAIM,
	[62507] = EFFECT_MAIM,
	[62509] = EFFECT_MAIM,
	[62511] = EFFECT_MAIM,
	[68368] = EFFECT_MAIM,
	[79083] = EFFECT_MAIM,
	[79085] = EFFECT_MAIM,
	[79282] = EFFECT_MAIM,
	[80848] = EFFECT_MAIM,
	[80990] = EFFECT_MAIM,
	[81034] = EFFECT_MAIM,
	[88469] = EFFECT_MAIM,
	[89012] = EFFECT_MAIM,
	[91174] = EFFECT_MAIM,
	[92026] = EFFECT_MAIM,
	[92921] = EFFECT_MAIM,
	[102097] = EFFECT_MAIM,
-- Minor Mangle
	[39168] = EFFECT_MANGLE,
	[39180] = EFFECT_MANGLE,
	[39181] = EFFECT_MANGLE,
	[42984] = EFFECT_MANGLE,
	[42986] = EFFECT_MANGLE,
	[42988] = EFFECT_MANGLE,
	[42991] = EFFECT_MANGLE,
	[42993] = EFFECT_MANGLE,
	[42995] = EFFECT_MANGLE,
	[42998] = EFFECT_MANGLE,
	[43000] = EFFECT_MANGLE,
	[43002] = EFFECT_MANGLE,
	[61733] = EFFECT_MANGLE,
	[91334] = EFFECT_MANGLE,
	[91337] = EFFECT_MANGLE,
	[93363] = EFFECT_MANGLE,
-- Minor Mending
	[29096] = EFFECT_MENDING,
	[31759] = EFFECT_MENDING,
	[61710] = EFFECT_MENDING,
	[77082] = EFFECT_MENDING,
	[100311] = EFFECT_MENDING,
-- Minor Pardon
	[78052] = EFFECT_PARDON,
-- Minor Prophecy
	[61688] = EFFECT_PROPHECY,
	[61691] = EFFECT_PROPHECY,
	[62319] = EFFECT_PROPHECY,
	[62320] = EFFECT_PROPHECY,
	[64261] = EFFECT_PROPHECY,
	[79447] = EFFECT_PROPHECY,
	[79449] = EFFECT_PROPHECY,
-- Minor Protection
	[3929] = EFFECT_PROTECTION,
	[3951] = EFFECT_PROTECTION,
	[35739] = EFFECT_PROTECTION,
	[40171] = EFFECT_PROTECTION,
	[40185] = EFFECT_PROTECTION,
	[42503] = EFFECT_PROTECTION,
	[42507] = EFFECT_PROTECTION,
	[42511] = EFFECT_PROTECTION,
	[42517] = EFFECT_PROTECTION,
	[42524] = EFFECT_PROTECTION,
	[42531] = EFFECT_PROTECTION,
	[42538] = EFFECT_PROTECTION,
	[42544] = EFFECT_PROTECTION,
	[42550] = EFFECT_PROTECTION,
	[61721] = EFFECT_PROTECTION,
	[76724] = EFFECT_PROTECTION,
	[76725] = EFFECT_PROTECTION,
	[76726] = EFFECT_PROTECTION,
	[76727] = EFFECT_PROTECTION,
	[77056] = EFFECT_PROTECTION,
	[77057] = EFFECT_PROTECTION,
	[77058] = EFFECT_PROTECTION,
	[77059] = EFFECT_PROTECTION,
	[79711] = EFFECT_PROTECTION,
	[79712] = EFFECT_PROTECTION,
	[79713] = EFFECT_PROTECTION,
	[79714] = EFFECT_PROTECTION,
	[79725] = EFFECT_PROTECTION,
	[79727] = EFFECT_PROTECTION,
	[85551] = EFFECT_PROTECTION,
	[87194] = EFFECT_PROTECTION,
	[94025] = EFFECT_PROTECTION,
	[94028] = EFFECT_PROTECTION,
	[94031] = EFFECT_PROTECTION,
-- Minor Resolve
	[24159] = EFFECT_RESOLVE,
	[31818] = EFFECT_RESOLVE,
	[37247] = EFFECT_RESOLVE,
	[61693] = EFFECT_RESOLVE,
	[61768] = EFFECT_RESOLVE,
	[61769] = EFFECT_RESOLVE,
	[61770] = EFFECT_RESOLVE,
	[61817] = EFFECT_RESOLVE,
	[61818] = EFFECT_RESOLVE,
	[61819] = EFFECT_RESOLVE,
	[61822] = EFFECT_RESOLVE,
	[62206] = EFFECT_RESOLVE,
	[62208] = EFFECT_RESOLVE,
	[62210] = EFFECT_RESOLVE,
	[62213] = EFFECT_RESOLVE,
	[62215] = EFFECT_RESOLVE,
	[62218] = EFFECT_RESOLVE,
	[62221] = EFFECT_RESOLVE,
	[62226] = EFFECT_RESOLVE,
	[62232] = EFFECT_RESOLVE,
	[62235] = EFFECT_RESOLVE,
	[62238] = EFFECT_RESOLVE,
	[62475] = EFFECT_RESOLVE,
	[62477] = EFFECT_RESOLVE,
	[62481] = EFFECT_RESOLVE,
	[62483] = EFFECT_RESOLVE,
	[62620] = EFFECT_RESOLVE,
	[62622] = EFFECT_RESOLVE,
	[62624] = EFFECT_RESOLVE,
	[62626] = EFFECT_RESOLVE,
	[62628] = EFFECT_RESOLVE,
	[62630] = EFFECT_RESOLVE,
	[62632] = EFFECT_RESOLVE,
	[62634] = EFFECT_RESOLVE,
	[62637] = EFFECT_RESOLVE,
	[62640] = EFFECT_RESOLVE,
	[62643] = EFFECT_RESOLVE,
	[63532] = EFFECT_RESOLVE,
	[63599] = EFFECT_RESOLVE,
	[63602] = EFFECT_RESOLVE,
	[63606] = EFFECT_RESOLVE,
	[79310] = EFFECT_RESOLVE,
	[79312] = EFFECT_RESOLVE,
-- Minor Savagery
	[61666] = EFFECT_SAVAGERY,
	[61882] = EFFECT_SAVAGERY,
	[61898] = EFFECT_SAVAGERY,
	[64260] = EFFECT_SAVAGERY,
	[79453] = EFFECT_SAVAGERY,
	[79455] = EFFECT_SAVAGERY,
-- Minor Slayer
	[76617] = EFFECT_SLAYER,
	[98102] = EFFECT_SLAYER,
	[98103] = EFFECT_SLAYER,
-- Minor Sorcery
	[61685] = EFFECT_SORCERY,
	[62799] = EFFECT_SORCERY,
	[62800] = EFFECT_SORCERY,
	[64258] = EFFECT_SORCERY,
	[79221] = EFFECT_SORCERY,
	[79279] = EFFECT_SORCERY,
-- Minor Toughness
	[40222] = EFFECT_TOUGHNESS,
	[46542] = EFFECT_TOUGHNESS,
	[46545] = EFFECT_TOUGHNESS,
	[46548] = EFFECT_TOUGHNESS,
	[63523] = EFFECT_TOUGHNESS,
	[63524] = EFFECT_TOUGHNESS,
	[63525] = EFFECT_TOUGHNESS,
	[63526] = EFFECT_TOUGHNESS,
	[63527] = EFFECT_TOUGHNESS,
	[63528] = EFFECT_TOUGHNESS,
	[63529] = EFFECT_TOUGHNESS,
	[63530] = EFFECT_TOUGHNESS,
	[88490] = EFFECT_TOUGHNESS,
	[88492] = EFFECT_TOUGHNESS,
	[88509] = EFFECT_TOUGHNESS,
	[88890] = EFFECT_TOUGHNESS,
	[92762] = EFFECT_TOUGHNESS,
-- Minor Uncertainty
	[47204] = EFFECT_UNCERTAINTY,
	[47205] = EFFECT_UNCERTAINTY,
	[79117] = EFFECT_UNCERTAINTY,
	[79118] = EFFECT_UNCERTAINTY,
	[79446] = EFFECT_UNCERTAINTY,
	[79448] = EFFECT_UNCERTAINTY,
	[79895] = EFFECT_UNCERTAINTY,
	[79901] = EFFECT_UNCERTAINTY,
	[79903] = EFFECT_UNCERTAINTY,
	[79904] = EFFECT_UNCERTAINTY,
	[79905] = EFFECT_UNCERTAINTY,
	[80213] = EFFECT_UNCERTAINTY,
	[80224] = EFFECT_UNCERTAINTY,
-- Minor Vitality
	[34837] = EFFECT_VITALITY,
	[37027] = EFFECT_VITALITY,
	[37031] = EFFECT_VITALITY,
	[37032] = EFFECT_VITALITY,
	[37033] = EFFECT_VITALITY,
	[61549] = EFFECT_VITALITY,
	[64080] = EFFECT_VITALITY,
	[79852] = EFFECT_VITALITY,
	[79855] = EFFECT_VITALITY,
	[80953] = EFFECT_VITALITY,
	[80959] = EFFECT_VITALITY,
	[80961] = EFFECT_VITALITY,
	[80967] = EFFECT_VITALITY,
	[80969] = EFFECT_VITALITY,
	[80975] = EFFECT_VITALITY,
	[80977] = EFFECT_VITALITY,
	[85565] = EFFECT_VITALITY,
	[91670] = EFFECT_VITALITY,
	[91671] = EFFECT_VITALITY,
	[91672] = EFFECT_VITALITY,
	[91673] = EFFECT_VITALITY,
-- Minor Vulnerability
	[51434] = EFFECT_VULNERABILITY,
	[61782] = EFFECT_VULNERABILITY,
	[68359] = EFFECT_VULNERABILITY,
	[79715] = EFFECT_VULNERABILITY,
	[79717] = EFFECT_VULNERABILITY,
	[79720] = EFFECT_VULNERABILITY,
	[79723] = EFFECT_VULNERABILITY,
	[79726] = EFFECT_VULNERABILITY,
	[79843] = EFFECT_VULNERABILITY,
	[79844] = EFFECT_VULNERABILITY,
	[79845] = EFFECT_VULNERABILITY,
	[79846] = EFFECT_VULNERABILITY,
	[81519] = EFFECT_VULNERABILITY,
	[88895] = EFFECT_VULNERABILITY,
-- Minor Ward
	[32761] = EFFECT_WARD,
	[61695] = EFFECT_WARD,
	[61862] = EFFECT_WARD,
	[61863] = EFFECT_WARD,
	[61864] = EFFECT_WARD,
	[62214] = EFFECT_WARD,
	[62216] = EFFECT_WARD,
	[62219] = EFFECT_WARD,
	[62222] = EFFECT_WARD,
	[62619] = EFFECT_WARD,
	[62621] = EFFECT_WARD,
	[62623] = EFFECT_WARD,
	[62625] = EFFECT_WARD,
	[62627] = EFFECT_WARD,
	[62629] = EFFECT_WARD,
	[62631] = EFFECT_WARD,
	[62633] = EFFECT_WARD,
	[62635] = EFFECT_WARD,
	[62638] = EFFECT_WARD,
	[62641] = EFFECT_WARD,
	[62644] = EFFECT_WARD,
	[63571] = EFFECT_WARD,
	[63600] = EFFECT_WARD,
	[63603] = EFFECT_WARD,
	[63607] = EFFECT_WARD,
	[68512] = EFFECT_WARD,
	[68513] = EFFECT_WARD,
	[68514] = EFFECT_WARD,
	[68515] = EFFECT_WARD,
	[79285] = EFFECT_WARD,
	[79307] = EFFECT_WARD,
-- Minor Wound
	[8443] = EFFECT_WOUND,
	[8444] = EFFECT_WOUND,
	[8445] = EFFECT_WOUND,
	[9605] = EFFECT_WOUND,
	[9606] = EFFECT_WOUND,
	[9607] = EFFECT_WOUND,
	[9611] = EFFECT_WOUND,
	[9612] = EFFECT_WOUND,
	[9727] = EFFECT_WOUND,
	[9728] = EFFECT_WOUND,
	[9729] = EFFECT_WOUND,
	[10601] = EFFECT_WOUND,
	[15630] = EFFECT_WOUND,
	[16442] = EFFECT_WOUND,
	[16443] = EFFECT_WOUND,
	[16444] = EFFECT_WOUND,
	[47726] = EFFECT_WOUND,
	[48346] = EFFECT_WOUND,
	[54126] = EFFECT_WOUND,
	[57962] = EFFECT_WOUND,
	[70619] = EFFECT_WOUND,
-- Sample Auras
	[116016] = SAMPLE_AURA,
}

majorEffects = {
-- Major Aegis
	[93123] = EFFECT_AEGIS,
	[93125] = EFFECT_AEGIS,
	[93444] = EFFECT_AEGIS,
-- Major Berserk
	[36973] = EFFECT_BERSERK,
	[37645] = EFFECT_BERSERK,
	[37654] = EFFECT_BERSERK,
	[37663] = EFFECT_BERSERK,
	[48078] = EFFECT_BERSERK,
	[61745] = EFFECT_BERSERK,
	[62195] = EFFECT_BERSERK,
	[79200] = EFFECT_BERSERK,
	[84310] = EFFECT_BERSERK,
-- Major Breach
	[33363] = EFFECT_BREACH,
	[36972] = EFFECT_BREACH,
	[36980] = EFFECT_BREACH,
	[37591] = EFFECT_BREACH,
	[37599] = EFFECT_BREACH,
	[37607] = EFFECT_BREACH,
	[37618] = EFFECT_BREACH,
	[37627] = EFFECT_BREACH,
	[37636] = EFFECT_BREACH,
	[53881] = EFFECT_BREACH,
	[61743] = EFFECT_BREACH,
	[62485] = EFFECT_BREACH,
	[62486] = EFFECT_BREACH,
	[62489] = EFFECT_BREACH,
	[62491] = EFFECT_BREACH,
	[62772] = EFFECT_BREACH,
	[62773] = EFFECT_BREACH,
	[62774] = EFFECT_BREACH,
	[62775] = EFFECT_BREACH,
	[62780] = EFFECT_BREACH,
	[62783] = EFFECT_BREACH,
	[62786] = EFFECT_BREACH,
	[62787] = EFFECT_BREACH,
	[62789] = EFFECT_BREACH,
	[62792] = EFFECT_BREACH,
	[62795] = EFFECT_BREACH,
	[63921] = EFFECT_BREACH,
	[63923] = EFFECT_BREACH,
	[63925] = EFFECT_BREACH,
	[78609] = EFFECT_BREACH,
	[88865] = EFFECT_BREACH,
	[89054] = EFFECT_BREACH,
	[91200] = EFFECT_BREACH,
	[93452] = EFFECT_BREACH,
	[93796] = EFFECT_BREACH,
	[94443] = EFFECT_BREACH,
	[94449] = EFFECT_BREACH,
	[94455] = EFFECT_BREACH,
-- Major Brutality
	[23673] = EFFECT_BRUTALITY,
	[32735] = EFFECT_BRUTALITY,
	[33317] = EFFECT_BRUTALITY,
	[36894] = EFFECT_BRUTALITY,
	[36903] = EFFECT_BRUTALITY,
	[37924] = EFFECT_BRUTALITY,
	[37927] = EFFECT_BRUTALITY,
	[37930] = EFFECT_BRUTALITY,
	[37933] = EFFECT_BRUTALITY,
	[37936] = EFFECT_BRUTALITY,
	[37939] = EFFECT_BRUTALITY,
	[37942] = EFFECT_BRUTALITY,
	[37947] = EFFECT_BRUTALITY,
	[37952] = EFFECT_BRUTALITY,
	[39124] = EFFECT_BRUTALITY,
	[45228] = EFFECT_BRUTALITY,
	[45393] = EFFECT_BRUTALITY,
	[45866] = EFFECT_BRUTALITY,
	[45870] = EFFECT_BRUTALITY,
	[45874] = EFFECT_BRUTALITY,
	[61665] = EFFECT_BRUTALITY,
	[61670] = EFFECT_BRUTALITY,
	[62057] = EFFECT_BRUTALITY,
	[62058] = EFFECT_BRUTALITY,
	[62059] = EFFECT_BRUTALITY,
	[62060] = EFFECT_BRUTALITY,
	[62063] = EFFECT_BRUTALITY,
	[62065] = EFFECT_BRUTALITY,
	[62067] = EFFECT_BRUTALITY,
	[62147] = EFFECT_BRUTALITY,
	[62150] = EFFECT_BRUTALITY,
	[62153] = EFFECT_BRUTALITY,
	[62156] = EFFECT_BRUTALITY,
	[62344] = EFFECT_BRUTALITY,
	[62347] = EFFECT_BRUTALITY,
	[62350] = EFFECT_BRUTALITY,
	[62387] = EFFECT_BRUTALITY,
	[62392] = EFFECT_BRUTALITY,
	[62396] = EFFECT_BRUTALITY,
	[62400] = EFFECT_BRUTALITY,
	[62415] = EFFECT_BRUTALITY,
	[62425] = EFFECT_BRUTALITY,
	[62441] = EFFECT_BRUTALITY,
	[62448] = EFFECT_BRUTALITY,
	[63768] = EFFECT_BRUTALITY,
	[64554] = EFFECT_BRUTALITY,
	[64555] = EFFECT_BRUTALITY,
	[68804] = EFFECT_BRUTALITY,
	[68805] = EFFECT_BRUTALITY,
	[68806] = EFFECT_BRUTALITY,
	[68807] = EFFECT_BRUTALITY,
	[68814] = EFFECT_BRUTALITY,
	[68815] = EFFECT_BRUTALITY,
	[68816] = EFFECT_BRUTALITY,
	[68817] = EFFECT_BRUTALITY,
	[68843] = EFFECT_BRUTALITY,
	[68845] = EFFECT_BRUTALITY,
	[68852] = EFFECT_BRUTALITY,
	[68859] = EFFECT_BRUTALITY,
	[72936] = EFFECT_BRUTALITY,
	[76518] = EFFECT_BRUTALITY,
	[76519] = EFFECT_BRUTALITY,
	[76520] = EFFECT_BRUTALITY,
	[76521] = EFFECT_BRUTALITY,
	[81516] = EFFECT_BRUTALITY,
	[81517] = EFFECT_BRUTALITY,
	[82777] = EFFECT_BRUTALITY,
	[82792] = EFFECT_BRUTALITY,
	[86695] = EFFECT_BRUTALITY,
	[89110] = EFFECT_BRUTALITY,
	[93705] = EFFECT_BRUTALITY,
	[93710] = EFFECT_BRUTALITY,
	[93715] = EFFECT_BRUTALITY,
	[95419] = EFFECT_BRUTALITY,
-- Major Cowardice
-- Major Defile
	[21927] = EFFECT_DEFILE,
	[24153] = EFFECT_DEFILE,
	[24686] = EFFECT_DEFILE,
	[24702] = EFFECT_DEFILE,
	[24703] = EFFECT_DEFILE,
	[29230] = EFFECT_DEFILE,
	[32949] = EFFECT_DEFILE,
	[32961] = EFFECT_DEFILE,
	[33399] = EFFECT_DEFILE,
	[33957] = EFFECT_DEFILE,
	[33961] = EFFECT_DEFILE,
	[33965] = EFFECT_DEFILE,
	[33969] = EFFECT_DEFILE,
	[33979] = EFFECT_DEFILE,
	[33989] = EFFECT_DEFILE,
	[34011] = EFFECT_DEFILE,
	[34017] = EFFECT_DEFILE,
	[34023] = EFFECT_DEFILE,
	[34527] = EFFECT_DEFILE,
	[34876] = EFFECT_DEFILE,
	[36509] = EFFECT_DEFILE,
	[36515] = EFFECT_DEFILE,
	[37511] = EFFECT_DEFILE,
	[37515] = EFFECT_DEFILE,
	[37519] = EFFECT_DEFILE,
	[37523] = EFFECT_DEFILE,
	[37528] = EFFECT_DEFILE,
	[37533] = EFFECT_DEFILE,
	[37538] = EFFECT_DEFILE,
	[37542] = EFFECT_DEFILE,
	[37546] = EFFECT_DEFILE,
	[38686] = EFFECT_DEFILE,
	[38838] = EFFECT_DEFILE,
	[44229] = EFFECT_DEFILE,
	[58869] = EFFECT_DEFILE,
	[61727] = EFFECT_DEFILE,
	[62513] = EFFECT_DEFILE,
	[62514] = EFFECT_DEFILE,
	[62515] = EFFECT_DEFILE,
	[62578] = EFFECT_DEFILE,
	[62579] = EFFECT_DEFILE,
	[62580] = EFFECT_DEFILE,
	[63148] = EFFECT_DEFILE,
	[68163] = EFFECT_DEFILE,
	[68164] = EFFECT_DEFILE,
	[68165] = EFFECT_DEFILE,
	[80838] = EFFECT_DEFILE,
	[81017] = EFFECT_DEFILE,
	[83955] = EFFECT_DEFILE,
	[85944] = EFFECT_DEFILE,
	[91312] = EFFECT_DEFILE,
	[91332] = EFFECT_DEFILE,
	[93375] = EFFECT_DEFILE,
	[93858] = EFFECT_DEFILE,
	[93864] = EFFECT_DEFILE,
	[93870] = EFFECT_DEFILE,
	[97531] = EFFECT_DEFILE,
	[97715] = EFFECT_DEFILE,
	[97717] = EFFECT_DEFILE,
	[97718] = EFFECT_DEFILE,
	[97719] = EFFECT_DEFILE,
	[97721] = EFFECT_DEFILE,
	[97722] = EFFECT_DEFILE,
	[97723] = EFFECT_DEFILE,
	[97724] = EFFECT_DEFILE,
	[97725] = EFFECT_DEFILE,
	[97726] = EFFECT_DEFILE,
	[97727] = EFFECT_DEFILE,
	[97728] = EFFECT_DEFILE,
	[97731] = EFFECT_DEFILE,
	[97732] = EFFECT_DEFILE,
	[97733] = EFFECT_DEFILE,
	[97734] = EFFECT_DEFILE,
	[97735] = EFFECT_DEFILE,
	[97736] = EFFECT_DEFILE,
	[97737] = EFFECT_DEFILE,
	[97738] = EFFECT_DEFILE,
	[97739] = EFFECT_DEFILE,
	[97740] = EFFECT_DEFILE,
	[97741] = EFFECT_DEFILE,
	[97742] = EFFECT_DEFILE,
	[97744] = EFFECT_DEFILE,
	[97745] = EFFECT_DEFILE,
	[97746] = EFFECT_DEFILE,
	[97747] = EFFECT_DEFILE,
	[97748] = EFFECT_DEFILE,
	[97753] = EFFECT_DEFILE,
	[97754] = EFFECT_DEFILE,
	[97755] = EFFECT_DEFILE,
	[97756] = EFFECT_DEFILE,
	[97757] = EFFECT_DEFILE,
	[97758] = EFFECT_DEFILE,
	[97759] = EFFECT_DEFILE,
	[97761] = EFFECT_DEFILE,
	[97762] = EFFECT_DEFILE,
	[97765] = EFFECT_DEFILE,
	[97766] = EFFECT_DEFILE,
	[97767] = EFFECT_DEFILE,
	[97768] = EFFECT_DEFILE,
	[98096] = EFFECT_DEFILE,
	[99786] = EFFECT_DEFILE,
	[102382] = EFFECT_DEFILE,
-- Major Endurance
	[32748] = EFFECT_ENDURANCE,
	[45226] = EFFECT_ENDURANCE,
	[61705] = EFFECT_ENDURANCE,
	[61886] = EFFECT_ENDURANCE,
	[61888] = EFFECT_ENDURANCE,
	[61889] = EFFECT_ENDURANCE,
	[62575] = EFFECT_ENDURANCE,
	[63681] = EFFECT_ENDURANCE,
	[63683] = EFFECT_ENDURANCE,
	[63766] = EFFECT_ENDURANCE,
	[63789] = EFFECT_ENDURANCE,
	[68361] = EFFECT_ENDURANCE,
	[68408] = EFFECT_ENDURANCE,
	[68797] = EFFECT_ENDURANCE,
	[68799] = EFFECT_ENDURANCE,
	[68800] = EFFECT_ENDURANCE,
	[68801] = EFFECT_ENDURANCE,
	[72935] = EFFECT_ENDURANCE,
	[78054] = EFFECT_ENDURANCE,
	[78080] = EFFECT_ENDURANCE,
	[86268] = EFFECT_ENDURANCE,
	[86693] = EFFECT_ENDURANCE,
	[89077] = EFFECT_ENDURANCE,
	[89079] = EFFECT_ENDURANCE,
	[93720] = EFFECT_ENDURANCE,
	[93722] = EFFECT_ENDURANCE,
	[93724] = EFFECT_ENDURANCE,
	[93727] = EFFECT_ENDURANCE,
	[93730] = EFFECT_ENDURANCE,
	[93733] = EFFECT_ENDURANCE,
	[93736] = EFFECT_ENDURANCE,
	[93739] = EFFECT_ENDURANCE,
	[93742] = EFFECT_ENDURANCE,
-- Major Evasion
	[61716] = EFFECT_EVASION,
	[63015] = EFFECT_EVASION,
	[63016] = EFFECT_EVASION,
	[63017] = EFFECT_EVASION,
	[63018] = EFFECT_EVASION,
	[63019] = EFFECT_EVASION,
	[63023] = EFFECT_EVASION,
	[63026] = EFFECT_EVASION,
	[63028] = EFFECT_EVASION,
	[63030] = EFFECT_EVASION,
	[63036] = EFFECT_EVASION,
	[63040] = EFFECT_EVASION,
	[63042] = EFFECT_EVASION,
	[69685] = EFFECT_EVASION,
	[84341] = EFFECT_EVASION,
	[90587] = EFFECT_EVASION,
	[90588] = EFFECT_EVASION,
	[90589] = EFFECT_EVASION,
	[90592] = EFFECT_EVASION,
	[90593] = EFFECT_EVASION,
	[90594] = EFFECT_EVASION,
	[90595] = EFFECT_EVASION,
	[90596] = EFFECT_EVASION,
	[90620] = EFFECT_EVASION,
	[90621] = EFFECT_EVASION,
	[90622] = EFFECT_EVASION,
	[90623] = EFFECT_EVASION,
-- Major Expedition
	[23216] = EFFECT_EXPEDITION,
	[33210] = EFFECT_EXPEDITION,
	[33328] = EFFECT_EXPEDITION,
	[34511] = EFFECT_EXPEDITION,
	[36050] = EFFECT_EXPEDITION,
	[36946] = EFFECT_EXPEDITION,
	[36959] = EFFECT_EXPEDITION,
	[37789] = EFFECT_EXPEDITION,
	[37793] = EFFECT_EXPEDITION,
	[37797] = EFFECT_EXPEDITION,
	[37852] = EFFECT_EXPEDITION,
	[37859] = EFFECT_EXPEDITION,
	[37866] = EFFECT_EXPEDITION,
	[37873] = EFFECT_EXPEDITION,
	[37881] = EFFECT_EXPEDITION,
	[37889] = EFFECT_EXPEDITION,
	[37897] = EFFECT_EXPEDITION,
	[37906] = EFFECT_EXPEDITION,
	[37915] = EFFECT_EXPEDITION,
	[38967] = EFFECT_EXPEDITION,
	[41817] = EFFECT_EXPEDITION,
	[41819] = EFFECT_EXPEDITION,
	[41821] = EFFECT_EXPEDITION,
	[45235] = EFFECT_EXPEDITION,
	[45399] = EFFECT_EXPEDITION,
	[50997] = EFFECT_EXPEDITION,
	[61736] = EFFECT_EXPEDITION,
	[61833] = EFFECT_EXPEDITION,
	[61838] = EFFECT_EXPEDITION,
	[61839] = EFFECT_EXPEDITION,
	[61840] = EFFECT_EXPEDITION,
	[62181] = EFFECT_EXPEDITION,
	[62186] = EFFECT_EXPEDITION,
	[62191] = EFFECT_EXPEDITION,
	[62531] = EFFECT_EXPEDITION,
	[62537] = EFFECT_EXPEDITION,
	[62540] = EFFECT_EXPEDITION,
	[62543] = EFFECT_EXPEDITION,
	[63987] = EFFECT_EXPEDITION,
	[63993] = EFFECT_EXPEDITION,
	[63999] = EFFECT_EXPEDITION,
	[64005] = EFFECT_EXPEDITION,
	[64012] = EFFECT_EXPEDITION,
	[64019] = EFFECT_EXPEDITION,
	[64026] = EFFECT_EXPEDITION,
	[64566] = EFFECT_EXPEDITION,
	[64567] = EFFECT_EXPEDITION,
	[67708] = EFFECT_EXPEDITION,
	[76498] = EFFECT_EXPEDITION,
	[76499] = EFFECT_EXPEDITION,
	[76500] = EFFECT_EXPEDITION,
	[76501] = EFFECT_EXPEDITION,
	[76502] = EFFECT_EXPEDITION,
	[76503] = EFFECT_EXPEDITION,
	[76504] = EFFECT_EXPEDITION,
	[76505] = EFFECT_EXPEDITION,
	[76506] = EFFECT_EXPEDITION,
	[76507] = EFFECT_EXPEDITION,
	[76509] = EFFECT_EXPEDITION,
	[76510] = EFFECT_EXPEDITION,
	[78081] = EFFECT_EXPEDITION,
	[79368] = EFFECT_EXPEDITION,
	[79370] = EFFECT_EXPEDITION,
	[79623] = EFFECT_EXPEDITION,
	[79624] = EFFECT_EXPEDITION,
	[79625] = EFFECT_EXPEDITION,
	[79780] = EFFECT_EXPEDITION,
	[79877] = EFFECT_EXPEDITION,
	[80392] = EFFECT_EXPEDITION,
	[80394] = EFFECT_EXPEDITION,
	[80396] = EFFECT_EXPEDITION,
	[80398] = EFFECT_EXPEDITION,
	[85592] = EFFECT_EXPEDITION,
	[86267] = EFFECT_EXPEDITION,
	[87116] = EFFECT_EXPEDITION,
	[89076] = EFFECT_EXPEDITION,
	[89078] = EFFECT_EXPEDITION,
	[91193] = EFFECT_EXPEDITION,
	[92418] = EFFECT_EXPEDITION,
	[92771] = EFFECT_EXPEDITION,
	[92908] = EFFECT_EXPEDITION,
	[93719] = EFFECT_EXPEDITION,
	[93721] = EFFECT_EXPEDITION,
	[93723] = EFFECT_EXPEDITION,
	[93726] = EFFECT_EXPEDITION,
	[93729] = EFFECT_EXPEDITION,
	[93732] = EFFECT_EXPEDITION,
	[93735] = EFFECT_EXPEDITION,
	[93738] = EFFECT_EXPEDITION,
	[93741] = EFFECT_EXPEDITION,
	[98489] = EFFECT_EXPEDITION,
	[98490] = EFFECT_EXPEDITION,
	[103321] = EFFECT_EXPEDITION,
-- Major Force
	[46522] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[46533] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[46536] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[46539] = EFFECT_FORCE, -- Aggressive Warhorn Major Force (DO NOT REMOVE!)
	[40225] = EFFECT_FORCE,
	[61747] = EFFECT_FORCE,
	[85154] = EFFECT_FORCE,
	[86468] = EFFECT_FORCE,
	[86472] = EFFECT_FORCE,
	[86476] = EFFECT_FORCE,
	[88891] = EFFECT_FORCE,
-- Major Fortitude
	[29011] = EFFECT_FORTITUDE,
	[45222] = EFFECT_FORTITUDE,
	[61698] = EFFECT_FORTITUDE,
	[61871] = EFFECT_FORTITUDE,
	[61872] = EFFECT_FORTITUDE,
	[61873] = EFFECT_FORTITUDE,
	[61884] = EFFECT_FORTITUDE,
	[61885] = EFFECT_FORTITUDE,
	[61887] = EFFECT_FORTITUDE,
	[61890] = EFFECT_FORTITUDE,
	[61893] = EFFECT_FORTITUDE,
	[61895] = EFFECT_FORTITUDE,
	[61897] = EFFECT_FORTITUDE,
	[62555] = EFFECT_FORTITUDE,
	[63670] = EFFECT_FORTITUDE,
	[63672] = EFFECT_FORTITUDE,
	[63784] = EFFECT_FORTITUDE,
	[66256] = EFFECT_FORTITUDE,
	[68375] = EFFECT_FORTITUDE,
	[68405] = EFFECT_FORTITUDE,
	[72928] = EFFECT_FORTITUDE,
	[86697] = EFFECT_FORTITUDE,
	[91674] = EFFECT_FORTITUDE,
	[92415] = EFFECT_FORTITUDE,
-- Major Fracture
	[28307] = EFFECT_FRACTURE,
	[34734] = EFFECT_FRACTURE,
	[36228] = EFFECT_FRACTURE,
	[36232] = EFFECT_FRACTURE,
	[36236] = EFFECT_FRACTURE,
	[48946] = EFFECT_FRACTURE,
	[61741] = EFFECT_FRACTURE,
	[61909] = EFFECT_FRACTURE,
	[61910] = EFFECT_FRACTURE,
	[61911] = EFFECT_FRACTURE,
	[62470] = EFFECT_FRACTURE,
	[62471] = EFFECT_FRACTURE,
	[62473] = EFFECT_FRACTURE,
	[62474] = EFFECT_FRACTURE,
	[62476] = EFFECT_FRACTURE,
	[62480] = EFFECT_FRACTURE,
	[62482] = EFFECT_FRACTURE,
	[62484] = EFFECT_FRACTURE,
	[62487] = EFFECT_FRACTURE,
	[62488] = EFFECT_FRACTURE,
	[62490] = EFFECT_FRACTURE,
	[63909] = EFFECT_FRACTURE,
	[63912] = EFFECT_FRACTURE,
	[63913] = EFFECT_FRACTURE,
	[63914] = EFFECT_FRACTURE,
	[63915] = EFFECT_FRACTURE,
	[63916] = EFFECT_FRACTURE,
	[63917] = EFFECT_FRACTURE,
	[63918] = EFFECT_FRACTURE,
	[63919] = EFFECT_FRACTURE,
	[63920] = EFFECT_FRACTURE,
	[63922] = EFFECT_FRACTURE,
	[63924] = EFFECT_FRACTURE,
	[64254] = EFFECT_FRACTURE,
	[78608] = EFFECT_FRACTURE,
	[85362] = EFFECT_FRACTURE,
	[89055] = EFFECT_FRACTURE,
	[91175] = EFFECT_FRACTURE,
	[91204] = EFFECT_FRACTURE,
	[93451] = EFFECT_FRACTURE,
	[93797] = EFFECT_FRACTURE,
	[94444] = EFFECT_FRACTURE,
	[94450] = EFFECT_FRACTURE,
	[94456] = EFFECT_FRACTURE,
	[100988] = EFFECT_FRACTURE,
-- Major Gallop
	[57472] = EFFECT_GALLOP,
	[57474] = EFFECT_GALLOP,
	[57475] = EFFECT_GALLOP,
	[57476] = EFFECT_GALLOP,
	[57481] = EFFECT_GALLOP,
	[57482] = EFFECT_GALLOP,
	[57483] = EFFECT_GALLOP,
	[57484] = EFFECT_GALLOP,
	[63569] = EFFECT_GALLOP,
-- Major Heroism
	[61709] = EFFECT_HEROISM,
	[65133] = EFFECT_HEROISM,
	[87234] = EFFECT_HEROISM,
	[92775] = EFFECT_HEROISM,
	[94165] = EFFECT_HEROISM,
	[94172] = EFFECT_HEROISM,
	[94179] = EFFECT_HEROISM,
-- Major Hindrance
-- Major Intellect
	[45224] = EFFECT_INTELLECT,
	[61707] = EFFECT_INTELLECT,
	[62577] = EFFECT_INTELLECT,
	[63676] = EFFECT_INTELLECT,
	[63678] = EFFECT_INTELLECT,
	[63771] = EFFECT_INTELLECT,
	[63785] = EFFECT_INTELLECT,
	[68133] = EFFECT_INTELLECT,
	[68406] = EFFECT_INTELLECT,
	[72932] = EFFECT_INTELLECT,
	[86683] = EFFECT_INTELLECT,
-- Major Lifesteal
-- Major Magickasteal
-- Major Maim
	[61725] = EFFECT_MAIM,
	[78607] = EFFECT_MAIM,
	[92041] = EFFECT_MAIM,
	[93078] = EFFECT_MAIM,
	[94277] = EFFECT_MAIM,
	[94285] = EFFECT_MAIM,
	[94293] = EFFECT_MAIM,
-- Major Mangle
-- Major Mending
	[55033] = EFFECT_MENDING,
	[61711] = EFFECT_MENDING,
	[61758] = EFFECT_MENDING,
	[61759] = EFFECT_MENDING,
	[61760] = EFFECT_MENDING,
	[77918] = EFFECT_MENDING,
	[77922] = EFFECT_MENDING,
	[88525] = EFFECT_MENDING,
	[88528] = EFFECT_MENDING,
	[92774] = EFFECT_MENDING,
	[93364] = EFFECT_MENDING,
-- Major Pardon
-- Major Prophecy
	[21726] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24160] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24167] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24171] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[21729] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24174] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24177] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24180] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[21732] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24184] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24187] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[24195] = EFFECT_PROPHECY, -- Templar Sun Fire (and morphs) Major Prophecy buff (DO NOT REMOVE!)
	[47193] = EFFECT_PROPHECY,
	[47195] = EFFECT_PROPHECY,
	[61689] = EFFECT_PROPHECY,
	[62747] = EFFECT_PROPHECY,
	[62748] = EFFECT_PROPHECY,
	[62749] = EFFECT_PROPHECY,
	[62750] = EFFECT_PROPHECY,
	[62751] = EFFECT_PROPHECY,
	[62752] = EFFECT_PROPHECY,
	[62753] = EFFECT_PROPHECY,
	[62754] = EFFECT_PROPHECY,
	[62755] = EFFECT_PROPHECY,
	[62756] = EFFECT_PROPHECY,
	[62757] = EFFECT_PROPHECY,
	[62758] = EFFECT_PROPHECY,
	[63776] = EFFECT_PROPHECY,
	[64570] = EFFECT_PROPHECY,
	[64572] = EFFECT_PROPHECY,
	[75088] = EFFECT_PROPHECY,
	[76420] = EFFECT_PROPHECY,
	[76433] = EFFECT_PROPHECY,
	[77928] = EFFECT_PROPHECY,
	[77945] = EFFECT_PROPHECY,
	[77949] = EFFECT_PROPHECY,
	[77952] = EFFECT_PROPHECY,
	[77955] = EFFECT_PROPHECY,
	[77958] = EFFECT_PROPHECY,
	[85613] = EFFECT_PROPHECY,
	[86303] = EFFECT_PROPHECY,
	[86684] = EFFECT_PROPHECY,
	[93927] = EFFECT_PROPHECY,
	[93929] = EFFECT_PROPHECY,
	[93931] = EFFECT_PROPHECY,
-- Major Protection
	[22233] = EFFECT_PROTECTION,
	[27405] = EFFECT_PROTECTION,
	[27411] = EFFECT_PROTECTION,
	[27417] = EFFECT_PROTECTION,
	[44854] = EFFECT_PROTECTION,
	[44857] = EFFECT_PROTECTION,
	[44859] = EFFECT_PROTECTION,
	[44860] = EFFECT_PROTECTION,
	[44862] = EFFECT_PROTECTION,
	[44863] = EFFECT_PROTECTION,
	[44864] = EFFECT_PROTECTION,
	[44865] = EFFECT_PROTECTION,
	[44866] = EFFECT_PROTECTION,
	[44867] = EFFECT_PROTECTION,
	[44868] = EFFECT_PROTECTION,
	[44869] = EFFECT_PROTECTION,
	[44871] = EFFECT_PROTECTION,
	[44872] = EFFECT_PROTECTION,
	[44874] = EFFECT_PROTECTION,
	[44876] = EFFECT_PROTECTION,
	[61722] = EFFECT_PROTECTION,
	[63883] = EFFECT_PROTECTION,
	[64070] = EFFECT_PROTECTION,
	[64071] = EFFECT_PROTECTION,
	[64166] = EFFECT_PROTECTION,
	[79068] = EFFECT_PROTECTION,
	[80853] = EFFECT_PROTECTION,
	[85155] = EFFECT_PROTECTION,
	[86249] = EFFECT_PROTECTION,
	[86469] = EFFECT_PROTECTION,
	[86473] = EFFECT_PROTECTION,
	[86477] = EFFECT_PROTECTION,
	[86578] = EFFECT_PROTECTION,
	[88859] = EFFECT_PROTECTION,
	[88862] = EFFECT_PROTECTION,
	[92773] = EFFECT_PROTECTION,
	[92909] = EFFECT_PROTECTION,
	[93079] = EFFECT_PROTECTION,
	[94186] = EFFECT_PROTECTION,
	[94189] = EFFECT_PROTECTION,
	[94192] = EFFECT_PROTECTION,
	[94197] = EFFECT_PROTECTION,
	[94200] = EFFECT_PROTECTION,
	[94203] = EFFECT_PROTECTION,
	[94208] = EFFECT_PROTECTION,
	[94215] = EFFECT_PROTECTION,
	[94222] = EFFECT_PROTECTION,
	[97627] = EFFECT_PROTECTION,
-- Major Resolve
	[22236] = EFFECT_RESOLVE,
	[44822] = EFFECT_RESOLVE,
	[44824] = EFFECT_RESOLVE,
	[44826] = EFFECT_RESOLVE,
	[44828] = EFFECT_RESOLVE,
	[44830] = EFFECT_RESOLVE,
	[44832] = EFFECT_RESOLVE,
	[44834] = EFFECT_RESOLVE,
	[44836] = EFFECT_RESOLVE,
	[44839] = EFFECT_RESOLVE,
	[44841] = EFFECT_RESOLVE,
	[44843] = EFFECT_RESOLVE,
	[45234] = EFFECT_RESOLVE,
	[45397] = EFFECT_RESOLVE,
	[61694] = EFFECT_RESOLVE,
	[61815] = EFFECT_RESOLVE,
	[61820] = EFFECT_RESOLVE,
	[61823] = EFFECT_RESOLVE,
	[61825] = EFFECT_RESOLVE,
	[61827] = EFFECT_RESOLVE,
	[61829] = EFFECT_RESOLVE,
	[61831] = EFFECT_RESOLVE,
	[61835] = EFFECT_RESOLVE,
	[61836] = EFFECT_RESOLVE,
	[61841] = EFFECT_RESOLVE,
	[61844] = EFFECT_RESOLVE,
	[61846] = EFFECT_RESOLVE,
	[62159] = EFFECT_RESOLVE,
	[62161] = EFFECT_RESOLVE,
	[62163] = EFFECT_RESOLVE,
	[62165] = EFFECT_RESOLVE,
	[62168] = EFFECT_RESOLVE,
	[62169] = EFFECT_RESOLVE,
	[62171] = EFFECT_RESOLVE,
	[62173] = EFFECT_RESOLVE,
	[62175] = EFFECT_RESOLVE,
	[62179] = EFFECT_RESOLVE,
	[62184] = EFFECT_RESOLVE,
	[62189] = EFFECT_RESOLVE,
	[63084] = EFFECT_RESOLVE,
	[63088] = EFFECT_RESOLVE,
	[63091] = EFFECT_RESOLVE,
	[63116] = EFFECT_RESOLVE,
	[63119] = EFFECT_RESOLVE,
	[63123] = EFFECT_RESOLVE,
	[63127] = EFFECT_RESOLVE,
	[63131] = EFFECT_RESOLVE,
	[63134] = EFFECT_RESOLVE,
	[63137] = EFFECT_RESOLVE,
	[63140] = EFFECT_RESOLVE,
	[63143] = EFFECT_RESOLVE,
	[64564] = EFFECT_RESOLVE,
	[64565] = EFFECT_RESOLVE,
	[66075] = EFFECT_RESOLVE,
	[66083] = EFFECT_RESOLVE,
	[79777] = EFFECT_RESOLVE,
	[80160] = EFFECT_RESOLVE,
	[80165] = EFFECT_RESOLVE,
	[80166] = EFFECT_RESOLVE,
	[80169] = EFFECT_RESOLVE,
	[86224] = EFFECT_RESOLVE,
	[88758] = EFFECT_RESOLVE,
	[88761] = EFFECT_RESOLVE,
	[91194] = EFFECT_RESOLVE,
	[91983] = EFFECT_RESOLVE,
	[94012] = EFFECT_RESOLVE,
	[94014] = EFFECT_RESOLVE,
	[94016] = EFFECT_RESOLVE,
	[94018] = EFFECT_RESOLVE,
	[94020] = EFFECT_RESOLVE,
	[94022] = EFFECT_RESOLVE,
	[94024] = EFFECT_RESOLVE,
	[94027] = EFFECT_RESOLVE,
	[94030] = EFFECT_RESOLVE,
-- Major Savagery
	[26795] = EFFECT_SAVAGERY,
	[27190] = EFFECT_SAVAGERY,
	[27194] = EFFECT_SAVAGERY,
	[27198] = EFFECT_SAVAGERY,
	[45241] = EFFECT_SAVAGERY,
	[45466] = EFFECT_SAVAGERY,
	[61667] = EFFECT_SAVAGERY,
	[63242] = EFFECT_SAVAGERY,
	[63770] = EFFECT_SAVAGERY,
	[64509] = EFFECT_SAVAGERY,
	[64568] = EFFECT_SAVAGERY,
	[64569] = EFFECT_SAVAGERY,
	[76426] = EFFECT_SAVAGERY,
	[85605] = EFFECT_SAVAGERY,
	[86694] = EFFECT_SAVAGERY,
	[87061] = EFFECT_SAVAGERY,
	[93920] = EFFECT_SAVAGERY,
	[93922] = EFFECT_SAVAGERY,
	[93924] = EFFECT_SAVAGERY,
-- Major Slayer
	[93109] = EFFECT_SLAYER,
	[93120] = EFFECT_SLAYER,
	[93442] = EFFECT_SLAYER,
-- Major Sorcery
	[45227] = EFFECT_SORCERY,
	[45391] = EFFECT_SORCERY,
	[61687] = EFFECT_SORCERY,
	[62062] = EFFECT_SORCERY,
	[62064] = EFFECT_SORCERY,
	[62066] = EFFECT_SORCERY,
	[62068] = EFFECT_SORCERY,
	[62240] = EFFECT_SORCERY,
	[62241] = EFFECT_SORCERY,
	[62242] = EFFECT_SORCERY,
	[62243] = EFFECT_SORCERY,
	[63223] = EFFECT_SORCERY,
	[63224] = EFFECT_SORCERY,
	[63225] = EFFECT_SORCERY,
	[63226] = EFFECT_SORCERY,
	[63227] = EFFECT_SORCERY,
	[63228] = EFFECT_SORCERY,
	[63229] = EFFECT_SORCERY,
	[63230] = EFFECT_SORCERY,
	[63231] = EFFECT_SORCERY,
	[63232] = EFFECT_SORCERY,
	[63233] = EFFECT_SORCERY,
	[63234] = EFFECT_SORCERY,
	[63774] = EFFECT_SORCERY,
	[64558] = EFFECT_SORCERY,
	[64561] = EFFECT_SORCERY,
	[72933] = EFFECT_SORCERY,
	[85623] = EFFECT_SORCERY,
	[86685] = EFFECT_SORCERY,
	[87929] = EFFECT_SORCERY,
	[89107] = EFFECT_SORCERY,
	[90457] = EFFECT_SORCERY,
	[92503] = EFFECT_SORCERY,
	[92504] = EFFECT_SORCERY,
	[92505] = EFFECT_SORCERY,
	[92506] = EFFECT_SORCERY,
	[92507] = EFFECT_SORCERY,
	[92509] = EFFECT_SORCERY,
	[92510] = EFFECT_SORCERY,
	[92511] = EFFECT_SORCERY,
	[92512] = EFFECT_SORCERY,
	[92516] = EFFECT_SORCERY,
	[92517] = EFFECT_SORCERY,
	[92518] = EFFECT_SORCERY,
	[93350] = EFFECT_SORCERY,
	[93658] = EFFECT_SORCERY,
	[93662] = EFFECT_SORCERY,
	[93666] = EFFECT_SORCERY,
	[93676] = EFFECT_SORCERY,
	[93681] = EFFECT_SORCERY,
	[93686] = EFFECT_SORCERY,
	[95125] = EFFECT_SORCERY,
	[95126] = EFFECT_SORCERY,
	[95127] = EFFECT_SORCERY,
	[95128] = EFFECT_SORCERY,
-- Major Toughness
-- Major Uncertainty
-- Major Vitality
	[61275] = EFFECT_VITALITY,
	[61713] = EFFECT_VITALITY,
	[63533] = EFFECT_VITALITY,
	[63534] = EFFECT_VITALITY,
	[63535] = EFFECT_VITALITY,
	[63536] = EFFECT_VITALITY,
	[79847] = EFFECT_VITALITY,
	[79848] = EFFECT_VITALITY,
	[79849] = EFFECT_VITALITY,
	[79850] = EFFECT_VITALITY,
	[92776] = EFFECT_VITALITY,
	[42197] = EFFECT_VITALITY,
-- Major Vulnerability
-- Major Ward
	[18868] = EFFECT_WARD,
	[40443] = EFFECT_WARD,
	[42285] = EFFECT_WARD,
	[42288] = EFFECT_WARD,
	[42291] = EFFECT_WARD,
	[44820] = EFFECT_WARD,
	[44821] = EFFECT_WARD,
	[44823] = EFFECT_WARD,
	[44825] = EFFECT_WARD,
	[44827] = EFFECT_WARD,
	[44829] = EFFECT_WARD,
	[44831] = EFFECT_WARD,
	[44833] = EFFECT_WARD,
	[44835] = EFFECT_WARD,
	[44838] = EFFECT_WARD,
	[44840] = EFFECT_WARD,
	[44842] = EFFECT_WARD,
	[45076] = EFFECT_WARD,
	[45233] = EFFECT_WARD,
	[45395] = EFFECT_WARD,
	[61696] = EFFECT_WARD,
	[61816] = EFFECT_WARD,
	[61821] = EFFECT_WARD,
	[61824] = EFFECT_WARD,
	[61826] = EFFECT_WARD,
	[61828] = EFFECT_WARD,
	[61830] = EFFECT_WARD,
	[61832] = EFFECT_WARD,
	[61834] = EFFECT_WARD,
	[61837] = EFFECT_WARD,
	[61842] = EFFECT_WARD,
	[61843] = EFFECT_WARD,
	[61845] = EFFECT_WARD,
	[62160] = EFFECT_WARD,
	[62162] = EFFECT_WARD,
	[62164] = EFFECT_WARD,
	[62166] = EFFECT_WARD,
	[62167] = EFFECT_WARD,
	[62170] = EFFECT_WARD,
	[62172] = EFFECT_WARD,
	[62174] = EFFECT_WARD,
	[62176] = EFFECT_WARD,
	[62180] = EFFECT_WARD,
	[62185] = EFFECT_WARD,
	[62190] = EFFECT_WARD,
	[63085] = EFFECT_WARD,
	[63089] = EFFECT_WARD,
	[63092] = EFFECT_WARD,
	[63117] = EFFECT_WARD,
	[63120] = EFFECT_WARD,
	[63124] = EFFECT_WARD,
	[63128] = EFFECT_WARD,
	[63132] = EFFECT_WARD,
	[63135] = EFFECT_WARD,
	[63138] = EFFECT_WARD,
	[63141] = EFFECT_WARD,
	[63144] = EFFECT_WARD,
	[64562] = EFFECT_WARD,
	[64563] = EFFECT_WARD,
	[79778] = EFFECT_WARD,
	[80482] = EFFECT_WARD,
	[86225] = EFFECT_WARD,
	[88759] = EFFECT_WARD,
	[88762] = EFFECT_WARD,
	[91195] = EFFECT_WARD,
	[94013] = EFFECT_WARD,
	[94015] = EFFECT_WARD,
	[94017] = EFFECT_WARD,
	[94019] = EFFECT_WARD,
	[94021] = EFFECT_WARD,
	[94023] = EFFECT_WARD,
	[94026] = EFFECT_WARD,
	[94029] = EFFECT_WARD,
	[94032] = EFFECT_WARD,
-- Major Wound
	[46839] = EFFECT_WOUND,
-- Sample Auras
	[116015] = SAMPLE_AURA,
}


--------------------------------------------------------------------------------------------------------------------
-- AURA DATA DEBUG & PATCH FUNCTIONS
-- Used after patches to assist in getting hold of changed abilityIDs (messy, only uncomment when needed to use)
--------------------------------------------------------------------------------------------------------------------

--[[
function GetToggled()
	-- returns all abilityIDs that match the names used as toggledAuras
	-- used to grab ALL the nessecary abilityIDs for the table after a patch changes things
	local data, names, saved = {}, {}, {}

	for k, v in pairs(toggledAuras) do
		names[GetAbilityName(k)] = true
	end

	for x = 1, 100000 do
		if (DoesAbilityExist(x) and names[GetAbilityName(x)] and GetAbilityDuration(x) == 0 and GetAbilityDescription(x) ~= '') then
			table.insert(data, {(GetAbilityName(x)), x, GetAbilityDescription(x)})
		end
	end

	table.sort(data, function(a, b)	return a[1] > b[1] end)

	for k, v in ipairs(data) do
		d(v[2] .. ' ' .. v[1] .. '      ' .. string.sub(v[3], 1, 30))
		table.insert(saved, v[2] .. '|' .. v[1]..'||' ..string.sub(v[3],1,30))
	end

	--SrendarrDB.toggled = saved
end
]]

--[[
function GetAurasByName(name)
	for x = 1, 100000 do
		if (DoesAbilityExist(x) and GetAbilityName(x) == name and GetAbilityDuration(x) > 0) then
			d('['..x ..'] '..GetAbilityName(x) .. '-' .. GetAbilityDuration(x) .. '-' .. GetAbilityDescription(x))
		end
	end
end
]]

--[[
function GetAuraInfo(idA, idB)
	d(string.format('[%d] %s (%ds) - %s', idA, GetAbilityName(idA), GetAbilityDuration(idA), GetAbilityDescription(idA)))
	d(string.format('[%d] %s (%ds) - %s', idB, GetAbilityName(idB), GetAbilityDuration(idB), GetAbilityDescription(idB)))
end
]]


--------------------------------------------------------------------------------------------------------------------
-- New method for updating Major/Minor effect tables by category. -Phinix
-- Useage: /script Srendarr:GetEffects(X,Y)
-- X = 1 for Minor and X = 2 for Major effects.
-- Y = Any number between 1 and 34 to pull the effect from table below. 
--------------------------------------------------------------------------------------------------------------------

local EffectTypes = {
	[1]		= {name = 'Aegis',			effect = 'EFFECT_AEGIS'},
	[2]		= {name = 'Berserk',		effect = 'EFFECT_BERSERK'},
	[3]		= {name = 'Breach',			effect = 'EFFECT_BREACH'},
	[4]		= {name = 'Brutality',		effect = 'EFFECT_BRUTALITY'},
	[5]		= {name = 'Cowardice',		effect = 'EFFECT_COWARDICE'},
	[6]		= {name = 'Defile',			effect = 'EFFECT_DEFILE'},
	[7]		= {name = 'Endurance',		effect = 'EFFECT_ENDURANCE'},
	[8]		= {name = 'Evasion',		effect = 'EFFECT_EVASION'},
	[9]		= {name = 'Expedition',		effect = 'EFFECT_EXPEDITION'},
	[10]	= {name = 'Force',			effect = 'EFFECT_FORCE'},
	[11]	= {name = 'Fortitude',		effect = 'EFFECT_FORTITUDE'},
	[12]	= {name = 'Fracture',		effect = 'EFFECT_FRACTURE'},
	[13]	= {name = 'Gallop',			effect = 'EFFECT_GALLOP'},
	[14]	= {name = 'Heroism',		effect = 'EFFECT_HEROISM'},
	[15]	= {name = 'Hindrance',		effect = 'EFFECT_HINDRANCE'},
	[16]	= {name = 'Intellect',		effect = 'EFFECT_INTELLECT'},
	[17]	= {name = 'Lifesteal',		effect = 'EFFECT_LIFESTEAL'},
	[18]	= {name = 'Magickasteal',	effect = 'EFFECT_MAGICKASTEAL'},
	[19]	= {name = 'Maim',			effect = 'EFFECT_MAIM'},
	[20]	= {name = 'Mangle',			effect = 'EFFECT_MANGLE'},
	[21]	= {name = 'Mending',		effect = 'EFFECT_MENDING'},
	[22]	= {name = 'Pardon',			effect = 'EFFECT_PARDON'},
	[23]	= {name = 'Prophecy',		effect = 'EFFECT_PROPHECY'},
	[24]	= {name = 'Protection',		effect = 'EFFECT_PROTECTION'},
	[25]	= {name = 'Resolve',		effect = 'EFFECT_RESOLVE'},
	[26]	= {name = 'Savagery',		effect = 'EFFECT_SAVAGERY'},
	[27]	= {name = 'Slayer',			effect = 'EFFECT_SLAYER'},
	[28]	= {name = 'Sorcery',		effect = 'EFFECT_SORCERY'},
	[29]	= {name = 'Toughness',		effect = 'EFFECT_TOUGHNESS'},
	[30]	= {name = 'Uncertainty',	effect = 'EFFECT_UNCERTAINTY'},
	[31]	= {name = 'Vitality',		effect = 'EFFECT_VITALITY'},
	[32]	= {name = 'Vulnerability',	effect = 'EFFECT_VULNERABILITY'},
	[33]	= {name = 'Ward',			effect = 'EFFECT_WARD'},
	[34]	= {name = 'Wound',			effect = 'EFFECT_WOUND'},
}

local function UpdateIDTable(sTable, eTable, eID)
	local aTable = {}
	local rTable = {}

	for k,v in pairs(sTable) do
		if eTable[k] == nil then
			aTable[k] = v
		end
	end
	for k,v in pairs(eTable) do
		if sTable[k] == nil and EffectTypes[v].effect == EffectTypes[eID].effect then
			rTable[k] = '[' .. tostring(k) .. '] = ' .. EffectTypes[eID].effect .. ','
		end
	end

	if next(aTable) ~= nil then
		d("New effects added:")
		for k,v in pairs(aTable) do
			d("    "..v)
		end
	else
		d("No new effects added.")
	end
	if next(rTable) ~= nil then
		d("Effects removed:")
		for k,v in pairs(rTable) do
			d("    "..v)
		end
	else
		d("No effects removed.")
	end
end

local function IDByEffect(tier, effect, stage)
	local eID = tonumber(effect)
	local eName
	local eTable = (tier == 1) and minorEffects or majorEffects

	if EffectTypes[eID] == nil then
		return
	else
		if tier == 1 then
			eName = 'Minor ' .. EffectTypes[eID].name
		else
			eName = 'Major ' .. EffectTypes[eID].name
		end

		local tempInt = (stage == 1) and 0 or 1
		local IdLow = (50000 * stage) - 50000
		local IdHigh = 50000 * stage	

		for i = IdLow, IdHigh, 1 do
			local cID = tostring(i+tempInt)
			local linkstring = tostring(GetAbilityName(cID))
			if string.find(linkstring, eName) ~= nil then
				sTable[tonumber(cID)] = '[' .. cID .. '] = ' .. EffectTypes[eID].effect .. ','
				--local output = '[' .. cID .. '] = ' .. EffectTypes[eID].effect .. ','
				--d(output)
			end
			if i == IdHigh then
				if stage == 4 then
					UpdateIDTable(sTable, eTable, eID)
				else
					zo_callLater(function() IDByEffect(tier, effect, stage+1) end, 500)
					return
				end
			end
		end
	end
end

function Srendarr:GetEffects(tier, effect)
	if tier == 1 or tier == 2 then
		newEffects = 0
		sTable = {}
		IDByEffect(tier, effect, 1)
	end
	return
end

