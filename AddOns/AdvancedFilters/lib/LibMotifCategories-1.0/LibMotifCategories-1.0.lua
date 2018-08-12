local MAJOR, MINOR = "LibMotifCategories-1.0", 1
local LibMotifCategories, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibMotifCategories then return end

LMC_MOTIF_CATEGORY_NORMAL = 1
LMC_MOTIF_CATEGORY_RARE = 2
LMC_MOTIF_CATEGORY_ALLIANCE = 3
LMC_MOTIF_CATEGORY_EXOTIC = 4
LMC_MOTIF_CATEGORY_DROPPED = 5
LMC_MOTIF_CATEGORY_CROWN = 6

local motifIdToItemStyleLookup = {
    AddRange = function(self, min, max, itemStyle)
        for motifId = min, max do
            self[motifId] = itemStyle
        end
    end,
    GetItemStyle = function(self, itemLink)
        local itemStyle = GetItemLinkItemStyle(itemLink)

        if itemStyle == ITEMSTYLE_NONE and
          GetItemLinkItemType(itemLink) == ITEMTYPE_RACIAL_STYLE_MOTIF then
            local motifId = select(4, ZO_LinkHandler_ParseLink(itemLink))
            itemStyle = self[motifId]
        elseif itemStyle == ITEMSTYLE_NONE and
          GetItemLinkItemType(itemLink) ~= ITEMTYPE_ARMOR then
            itemStyle = -1
        end

        return itemStyle
    end,
    [16424] = ITEMSTYLE_RACIAL_HIGH_ELF,
    [16425] = ITEMSTYLE_RACIAL_BRETON,
    [16426] = ITEMSTYLE_RACIAL_ORC,
    [16427] = ITEMSTYLE_RACIAL_REDGUARD,
    [16428] = ITEMSTYLE_RACIAL_WOOD_ELF,
    [27244] = ITEMSTYLE_RACIAL_NORD,
    [27245] = ITEMSTYLE_RACIAL_DARK_ELF,
    [27246] = ITEMSTYLE_RACIAL_ARGONIAN,
    [44698] = ITEMSTYLE_RACIAL_KHAJIIT,
    [51345] = ITEMSTYLE_ENEMY_PRIMITIVE,
    [51565] = ITEMSTYLE_AREA_REACH,
    [51638] = ITEMSTYLE_AREA_ANCIENT_ELF,
    [51688] = ITEMSTYLE_ENEMY_DAEDRIC,
    [54868] = ITEMSTYLE_RACIAL_IMPERIAL,

    [64540] = ITEMSTYLE_RACIAL_HIGH_ELF,
    [64541] = ITEMSTYLE_RACIAL_BRETON,
    [64542] = ITEMSTYLE_RACIAL_ORC,
    [64543] = ITEMSTYLE_RACIAL_REDGUARD,
    [64544] = ITEMSTYLE_RACIAL_WOOD_ELF,
    [64545] = ITEMSTYLE_RACIAL_NORD,
    [64546] = ITEMSTYLE_RACIAL_DARK_ELF,
    [64547] = ITEMSTYLE_RACIAL_ARGONIAN,
    [64548] = ITEMSTYLE_RACIAL_KHAJIIT,
    [64549] = ITEMSTYLE_ENEMY_PRIMITIVE,
    [64550] = ITEMSTYLE_AREA_REACH,
    [64551] = ITEMSTYLE_AREA_ANCIENT_ELF,
    [64552] = ITEMSTYLE_ENEMY_DAEDRIC,
    [64553] = ITEMSTYLE_AREA_DWEMER,
    [64554] = ITEMSTYLE_AREA_AKAVIRI,
    [64555] = ITEMSTYLE_AREA_YOKUDAN,
    [64556] = ITEMSTYLE_AREA_XIVKYN,
    [64559] = ITEMSTYLE_RACIAL_IMPERIAL,
    [71765] = ITEMSTYLE_AREA_SOUL_SHRIVEN,
}

local categoryLookup = {
    [ITEMSTYLE_RACIAL_ARGONIAN] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_WOOD_ELF] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_BRETON] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_HIGH_ELF] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_DARK_ELF] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_KHAJIIT] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_NORD] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_ORC] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_REDGUARD] = LMC_MOTIF_CATEGORY_NORMAL,

    [ITEMSTYLE_AREA_REACH] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_ENEMY_PRIMITIVE] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_ENEMY_DAEDRIC] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_AREA_ANCIENT_ELF] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_AREA_SOUL_SHRIVEN] = LMC_MOTIF_CATEGORY_RARE,

    [ITEMSTYLE_RACIAL_IMPERIAL] = LMC_MOTIF_CATEGORY_ALLIANCE,
    [ITEMSTYLE_ALLIANCE_ALDMERI] = LMC_MOTIF_CATEGORY_ALLIANCE,
    [ITEMSTYLE_ALLIANCE_EBONHEART] = LMC_MOTIF_CATEGORY_ALLIANCE,
    [ITEMSTYLE_ALLIANCE_DAGGERFALL] = LMC_MOTIF_CATEGORY_ALLIANCE,

    [ITEMSTYLE_AREA_DWEMER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_XIVKYN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_AKAVIRI] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_GLASS] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_UNDAUNTED] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ANCIENT_ORC] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_OUTLAW] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_TRINIMAC] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_MALACATH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_THIEVES_GUILD] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ASSASSINS] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ABAHS_WATCH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_YOKUDAN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_AKATOSH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_MINOTAUR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_DARK_BROTHERHOOD] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_RAIDS_CRAGLORN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_DRAUGR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_EBONY] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_SKINCHANGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_RA_GADA] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_DROMOTHRA] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_FROSTCASTER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_SILKEN_RING] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_MAZZATUN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_GRIM_HARLEQUIN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_HOLLOWJACK] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_MORAG_TONG] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ORDINATOR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ASHLANDER] = LMC_MOTIF_CATEGORY_EXOTIC,

    [ITEMSTYLE_NONE] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ENEMY_BANDIT] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ENEMY_MAORMER] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_AREA_REACH_WINTER] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_AREA_TSAESCI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_REDORAN] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_HLAALU] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_TELVANNI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_WORM_CULT] = LMC_MOTIF_CATEGORY_DROPPED,

    [ITEMSTYLE_UNIVERSAL] = LMC_MOTIF_CATEGORY_CROWN,
}

local newLookup = {
    [ITEMSTYLE_ORG_MORAG_TONG] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ORDINATOR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ASHLANDER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_TSAESCI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_REDORAN] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_HLAALU] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_TELVANNI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_WORM_CULT] = LMC_MOTIF_CATEGORY_DROPPED,
}

--[[
    for styleItemIndex = 1, GetNumSmithingStyleItems() do
        local _, _, _, meetsUsageRequirement = GetSmithingStyleItemInfo(styleItemIndex)
        local itemLink = GetSmithingStyleItemLink(styleItemIndex, LINK_STYLE_DEFAULT)
        if meetsUsageRequirement then
            d(zo_strformat("<<1>> : <<2>>", styleItemIndex, itemLink))
        end
    end
]]
local styleItemIndices = {
    [ITEMSTYLE_RACIAL_BRETON] = 2,
    [ITEMSTYLE_RACIAL_REDGUARD] = 3,
    [ITEMSTYLE_RACIAL_ORC] = 4,
    [ITEMSTYLE_RACIAL_DARK_ELF] = 5,
    [ITEMSTYLE_RACIAL_NORD] = 6,
    [ITEMSTYLE_RACIAL_ARGONIAN] = 7,
    [ITEMSTYLE_RACIAL_HIGH_ELF] = 8,
    [ITEMSTYLE_RACIAL_WOOD_ELF] = 9,
    [ITEMSTYLE_RACIAL_KHAJIIT] = 10,
    [ITEMSTYLE_ORG_THIEVES_GUILD] = 12,
    [ITEMSTYLE_ORG_DARK_BROTHERHOOD] = 13,
    [ITEMSTYLE_DEITY_MALACATH] = 14,
    [ITEMSTYLE_AREA_DWEMER] = 15,
    [ITEMSTYLE_AREA_ANCIENT_ELF] = 16,
    [ITEMSTYLE_DEITY_AKATOSH] = 17,
    [ITEMSTYLE_AREA_REACH] = 18,
    [ITEMSTYLE_ENEMY_PRIMITIVE] = 20,
    [ITEMSTYLE_ENEMY_DAEDRIC] = 21,
    [ITEMSTYLE_DEITY_TRINIMAC] = 22,
    [ITEMSTYLE_AREA_ANCIENT_ORC] = 23,
    [ITEMSTYLE_ALLIANCE_DAGGERFALL] = 24,
    [ITEMSTYLE_ALLIANCE_EBONHEART] = 25,
    [ITEMSTYLE_ALLIANCE_ALDMERI] = 26,
    [ITEMSTYLE_UNDAUNTED] = 27,
    [ITEMSTYLE_RAIDS_CRAGLORN] = 28,
    [ITEMSTYLE_GLASS] = 29,
    [ITEMSTYLE_AREA_XIVKYN] = 30,
    [ITEMSTYLE_AREA_SOUL_SHRIVEN] = 31,
    [ITEMSTYLE_ENEMY_DRAUGR] = 32,
    [ITEMSTYLE_AREA_AKAVIRI] = 34,
    [ITEMSTYLE_RACIAL_IMPERIAL] = 35,
    [ITEMSTYLE_AREA_YOKUDAN] = 36,
    [ITEMSTYLE_UNIVERSAL] = 37,
    [ITEMSTYLE_ENEMY_MINOTAUR] = 40,
    [ITEMSTYLE_EBONY] = 41,
    [ITEMSTYLE_ORG_ABAHS_WATCH] = 42,
    [ITEMSTYLE_HOLIDAY_SKINCHANGER] = 43,
    [ITEMSTYLE_ORG_MORAG_TONG] = 44,
    [ITEMSTYLE_AREA_RA_GADA] = 45,
    [ITEMSTYLE_ENEMY_DROMOTHRA] = 46,
    [ITEMSTYLE_ORG_ASSASSINS] = 47,
    [ITEMSTYLE_ORG_OUTLAW] = 48,
    [ITEMSTYLE_ORG_ORDINATOR] = 51,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER] = 53,
    [ITEMSTYLE_HOLIDAY_FROSTCASTER] = 54,
    [ITEMSTYLE_AREA_ASHLANDER] = 55,
    [ITEMSTYLE_ENEMY_SILKEN_RING] = 57,
    [ITEMSTYLE_ENEMY_MAZZATUN] = 58,
    [ITEMSTYLE_HOLIDAY_GRIM_HARLEQUIN] = 59,
    [ITEMSTYLE_HOLIDAY_HOLLOWJACK] = 60,
}

function LibMotifCategories:GetMotifCategory(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)

    return categoryLookup[itemStyle]
end

function LibMotifCategories:IsNewMotif(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)

    if newLookup[itemStyle] then
        return true
    end

    return false
end

function LibMotifCategories:IsMotifCraftable(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)

    if styleItemIndices[itemStyle] then
        return true
    end

    return false
end

function LibMotifCategories:IsMotifKnown(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)
    local styleItemIndex = styleItemIndices[itemStyle]

    if not styleItemIndex then
        return false
    end

    --if styleItemIndex == 37 then return true end

    for patternIndex = 1, 200 do
        if IsSmithingStyleKnown(styleItemIndex, patternIndex) then
            return true
        end
    end

    return false
end

function LibMotifCategories:IsMotifAvailable(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)

    if categoryLookup[itemStyle] then
        return true
    end

    return false
end

function LibMotifCategories:GetFullMotifInfo(itemLink)
    local motifCategory = self:GetMotifCategory(itemLink)
    local isNew = self:IsNewMotif(itemLink)
    local isCraftable = self:IsMotifCraftable(itemLink)
    local isKnown = self:IsMotifKnown(itemLink)
    local isAvailable = self:IsMotifAvailable(itemLink)

    return motifCategory, isNew, isCraftable, isKnown, isAvailable
end

function LibMotifCategories:GetLocalizedCategoryName(categoryConst)
    return self.strings[categoryConst]
end

function LibMotifCategories:Initialize()
    local strings = {
        ["de"] = {
            "Normal", "Selten", "Allianz", "Exotisch", "Erbeutet", "Kronen",
        },
        ["en"] = {
            "Normal", "Rare", "Alliance", "Exotic", "Dropped", "Crown",
        },
        ["fr"] = {
            "Normal", "Rare", "Alliance", "Exotique", "Looté", "Couronnes",
        },
    }

    local lang = GetCVar("language.2")

    if strings[lang] then
        self.strings = strings[lang]
    else
        self.strings = strings["en"]
    end

    motifIdToItemStyleLookup:AddRange(57572, 57586, ITEMSTYLE_AREA_DWEMER)
    motifIdToItemStyleLookup:AddRange(57590, 57604, ITEMSTYLE_AREA_AKAVIRI)
    motifIdToItemStyleLookup:AddRange(57605, 57619, ITEMSTYLE_AREA_YOKUDAN)
    motifIdToItemStyleLookup:AddRange(57834, 57848, ITEMSTYLE_AREA_XIVKYN)
    motifIdToItemStyleLookup:AddRange(64669, 64684, ITEMSTYLE_GLASS)
    motifIdToItemStyleLookup:AddRange(64715, 64730, ITEMSTYLE_UNDAUNTED)
    motifIdToItemStyleLookup:AddRange(69527, 69542, ITEMSTYLE_AREA_ANCIENT_ORC)
    motifIdToItemStyleLookup:AddRange(71522, 71537, ITEMSTYLE_ORG_OUTLAW)
    motifIdToItemStyleLookup:AddRange(71550, 71565, ITEMSTYLE_DEITY_TRINIMAC)
    motifIdToItemStyleLookup:AddRange(71566, 71581, ITEMSTYLE_DEITY_MALACATH)
    motifIdToItemStyleLookup:AddRange(71672, 71687, ITEMSTYLE_AREA_RA_GADA)
    motifIdToItemStyleLookup:AddRange(71688, 71703, ITEMSTYLE_ALLIANCE_ALDMERI)
    motifIdToItemStyleLookup:AddRange(71704, 71719, ITEMSTYLE_ALLIANCE_DAGGERFALL)
    motifIdToItemStyleLookup:AddRange(71720, 71735, ITEMSTYLE_ALLIANCE_EBONHEART)
    motifIdToItemStyleLookup:AddRange(73838, 73853, ITEMSTYLE_ORG_MORAG_TONG)
    motifIdToItemStyleLookup:AddRange(73854, 73869, ITEMSTYLE_HOLIDAY_SKINCHANGER)
    motifIdToItemStyleLookup:AddRange(74539, 74554, ITEMSTYLE_ORG_ABAHS_WATCH)
    motifIdToItemStyleLookup:AddRange(74555, 74570, ITEMSTYLE_ORG_THIEVES_GUILD)
    motifIdToItemStyleLookup:AddRange(74652, 74667, ITEMSTYLE_ENEMY_DROMOTHRA)
    motifIdToItemStyleLookup:AddRange(75228, 75243, ITEMSTYLE_EBONY)
    motifIdToItemStyleLookup:AddRange(76878, 76893, ITEMSTYLE_ORG_ASSASSINS)
    motifIdToItemStyleLookup:AddRange(76894, 76909, ITEMSTYLE_ENEMY_DRAUGR)
    motifIdToItemStyleLookup:AddRange(82006, 82021, ITEMSTYLE_RAIDS_CRAGLORN)
    motifIdToItemStyleLookup:AddRange(82022, 82037, ITEMSTYLE_HOLIDAY_HOLLOWJACK)
    motifIdToItemStyleLookup:AddRange(82038, 82038, ITEMSTYLE_HOLIDAY_GRIM_HARLEQUIN)
    motifIdToItemStyleLookup:AddRange(82054, 82069, ITEMSTYLE_ORG_DARK_BROTHERHOOD)
    motifIdToItemStyleLookup:AddRange(82071, 82086, ITEMSTYLE_ENEMY_MINOTAUR)
    motifIdToItemStyleLookup:AddRange(82087, 82102, ITEMSTYLE_DEITY_AKATOSH)
    motifIdToItemStyleLookup:AddRange(82103, 82116, ITEMSTYLE_HOLIDAY_HOLLOWJACK)
    motifIdToItemStyleLookup:AddRange(96954, 96954, ITEMSTYLE_HOLIDAY_FROSTCASTER)
    motifIdToItemStyleLookup:AddRange(114951, 114956, ITEMSTYLE_ENEMY_MAZZATUN)
    motifIdToItemStyleLookup:AddRange(114967, 114982, ITEMSTYLE_ENEMY_SILKEN_RING)
    motifIdToItemStyleLookup:AddRange(121316, 121331, ITEMSTYLE_ORG_BUOYANT_ARMIGER)
    motifIdToItemStyleLookup:AddRange(121332, 121347, ITEMSTYLE_ORG_TELVANNI)
    motifIdToItemStyleLookup:AddRange(121348, 121363, ITEMSTYLE_ORG_ORDINATOR)
    motifIdToItemStyleLookup:AddRange(124679, 124694, ITEMSTYLE_AREA_ASHLANDER)
end

LibMotifCategories:Initialize()