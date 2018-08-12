local Srendarr = _G['Srendarr']
local L = {}

------------------------------------------------------------------------------------------------------------------
-- English (en)
-- Format and phrasing by Phinix
------------------------------------------------------------------------------------------------------------------

L.Srendarr									= '|c67b1e9S|c4779ce\'rendarr|r'
L.Srendarr_Basic							= 'S\'rendarr'
L.Usage										= '|c67b1e9S|c4779ce\'rendarr|r - Usage: /srendarr lock|unlock to toggle display window movement.'
L.CastBar									= 'Cast Bar'
L.Sound_DefaultProc 						= 'Srendarr (Default Proc)'

-- time format						
L.Time_Tenths								= '%.1fs'
L.Time_Seconds								= '%ds'
L.Time_Minutes								= '%dm'
L.Time_Hours								= '%dh'
L.Time_Days									= '%dd'

-- aura grouping
L.Group_Displayed_Here						= 'Displayed Groups'
L.Group_Displayed_None						= 'None'
L.Group_Player_Short						= 'Your Short Buffs'
L.Group_Player_Long							= 'Your Long Buffs'
L.Group_Player_Major						= 'Your Major Buffs'
L.Group_Player_Minor						= 'Your Minor Buffs'
L.Group_Player_Toggled						= 'Your Toggled Buffs'
L.Group_Player_Ground						= 'Your Ground Targets'
L.Group_Player_Enchant						= 'Your Enchant Procs'
L.Group_Player_Gear							= 'Your Gear Procs'
L.Group_Player_Cooldowns					= 'Your Proc Cooldowns'
L.Group_Player_Passive						= 'Your Passives'
L.Group_Player_Debuff						= 'Your Debuffs'
L.Group_Target_Buff							= 'Target\'s Buffs'
L.Group_Target_Debuff						= 'Target\'s Debuffs'

L.Group_Prominent							= 'Aura Whitelist 1'
L.Group_Prominent2							= 'Aura Whitelist 2'
L.Group_Debuffs								= 'Debuff Whitelist 1'
L.Group_Debuffs2							= 'Debuff Whitelist 2'
L.Group_Group								= 'Group Frames'
L.Group_Raid								= 'Raid Frames'
L.Group_Cooldowns							= 'Cooldown Tracker'
L.Group_Cooldown							= 'Cooldown'

-- whitelist & blacklist control
L.Prominent_AuraAddSuccess					= 'has been added to Aura Whitelist 1.'
L.Prominent_AuraAddSuccess2					= 'has been added to Aura Whitelist 2.'
L.Prominent_AuraAddFail						= 'was not found and could not be added.'
L.Prominent_AuraAddFailByID					= 'is not a valid abilityID.'
L.Prominent_AuraRemoved						= 'has been removed from Aura Whitelist 1.'
L.Prominent_AuraRemoved2					= 'has been removed from Aura Whitelist 2.'
L.Blacklist_AuraAddSuccess					= 'has been added to the Blacklist and will no longer be displayed.'
L.Blacklist_AuraAddFail						= 'was not found and could not be added to the Blacklist.'
L.Blacklist_AuraAddFailByID					= 'is not a valid abilityID and could not be added to the Blacklist.'
L.Blacklist_AuraRemoved						= 'has been removed from the Blacklist.'
L.Group_AuraAddSuccess						= 'has been added to the Group Whitelist.'
L.Group_AuraRemoved							= 'has been removed from the Group Whitelist.'
L.Debuff_AuraAddSuccess						= 'has been added to Debuff Whitelist 1.'
L.Debuff_AuraAddSuccess2					= 'has been added to Debuff Whitelist 2.'
L.Debuff_AuraRemoved						= 'has been removed from Debuff Whitelist 1.'
L.Debuff_AuraRemoved2						= 'has been removed from Debuff Whitelist 2.'

-- settings: base
L.Show_Example_Auras						= 'Example Auras'
L.Show_Example_Castbar						= 'Example Castbar'

L.SampleAura_PlayerTimed					= 'Player Timed'
L.SampleAura_PlayerToggled					= 'Player Toggled'
L.SampleAura_PlayerPassive					= 'Player Passive'
L.SampleAura_PlayerDebuff					= 'Player Debuff'
L.SampleAura_PlayerGround					= 'Ground Effect'
L.SampleAura_PlayerMajor					= 'Major Effect'
L.SampleAura_PlayerMinor					= 'Minor Effect'
L.SampleAura_TargetBuff						= 'Target Buff'
L.SampleAura_TargetDebuff					= 'Target Debuff'

L.TabButton1								= 'General'
L.TabButton2								= 'Filters'
L.TabButton3								= 'Cast Bar'
L.TabButton4								= 'Aura Display'
L.TabButton5								= 'Profiles'

L.TabHeader1								= 'General Settings'
L.TabHeader2								= 'Filter Settings'
L.TabHeader3								= 'Cast Bar Settings'
L.TabHeader5								= 'Profile Settings'
L.TabHeaderDisplay							= 'Display Window Settings'

-- settings: generic
L.GenericSetting_ClickToViewAuras			= '|cffd100Click To View Auras|r'
L.GenericSetting_NameFont					= 'Name Text Font'
L.GenericSetting_NameStyle					= 'Name Text Color & Style'
L.GenericSetting_NameSize					= 'Name Text Size'
L.GenericSetting_TimerFont					= 'Timer Text Font'
L.GenericSetting_TimerStyle					= 'Timer Font Color & Style'
L.GenericSetting_TimerSize					= 'Timer Text Size'
L.GenericSetting_BarWidth					= 'Bar Width'
L.GenericSetting_BarWidthTip				= 'Set how wide timer bars should be when displayed.'


-- ----------------------------
-- SETTINGS: DROPDOWN ENTRIES
-- ----------------------------
L.DropGroup_1								= 'In Display Window [|cffd1001|r]'
L.DropGroup_2								= 'In Display Window [|cffd1002|r]'
L.DropGroup_3								= 'In Display Window [|cffd1003|r]'
L.DropGroup_4								= 'In Display Window [|cffd1004|r]'
L.DropGroup_5								= 'In Display Window [|cffd1005|r]'
L.DropGroup_6								= 'In Display Window [|cffd1006|r]'
L.DropGroup_7								= 'In Display Window [|cffd1007|r]'
L.DropGroup_8								= 'In Display Window [|cffd1008|r]'
L.DropGroup_9								= 'In Display Window [|cffd1009|r]'
L.DropGroup_10								= 'In Display Window [|cffd10010|r]'
L.DropGroup_None							= 'Do Not Display'

L.DropStyle_Full							= 'Full Display'
L.DropStyle_Icon							= 'Icon Only'
L.DropStyle_Mini							= 'Minimal Display'

L.DropGrowth_Up								= 'Up'
L.DropGrowth_Down							= 'Down'
L.DropGrowth_Left							= 'Left'
L.DropGrowth_Right							= 'Right'
L.DropGrowth_CenterLeft						= 'Centered (Left)'
L.DropGrowth_CenterRight					= 'Centered (Right)'

L.DropSort_NameAsc							= 'Ability Name (Asc)'
L.DropSort_TimeAsc							= 'Remaining Time (Asc)'
L.DropSort_CastAsc							= 'Casting Order (Asc)'
L.DropSort_NameDesc							= 'Ability Name (Desc)'
L.DropSort_TimeDesc							= 'Remaining Time (Desc)'
L.DropSort_CastDesc							= 'Casting Order (Desc)'

L.DropTimer_Above							= 'Above Icon'
L.DropTimer_Below							= 'Under Icon'
L.DropTimer_Over							= 'Over Icon'
L.DropTimer_Hidden							= 'Hidden'

L.DropAuraClassBuff							= 'Buff'
L.DropAuraClassDebuff						= 'Debuff'
L.DropAuraClassDefault						= 'No Override'


-- ------------------------
-- SETTINGS: GENERAL
-- ------------------------
-- general (general options)
L.General_GeneralOptions					= 'General Options'
L.General_GeneralOptionsDesc				= 'Various general options that control the addon\'s behavior.'
L.General_UnlockDesc						= 'Unlock to allow aura display windows to be dragged using the mouse. The reset button will return all windows to their default location.'
L.General_UnlockLock						= 'Lock'
L.General_UnlockUnlock						= 'Unlock'
L.General_UnlockReset						= 'Reset'
L.General_UnlockResetAgain					= 'Confirm Reset'
L.General_CombatOnly						= 'Only Show During Combat'
L.General_CombatOnlyTip						= 'Set whether aura windows are only visible when engaged in combat.'
L.HideOnDeadTargets							= 'Hide On Dead Targets'
L.HideOnDeadTargetsTip						= 'Set whether to hide all auras on dead targets. (Will hide potentially useful things like Repentance use debuff.)'
L.ShowSeconds								= 'Show Seconds Remaining'
L.ShowSecondsTip							= 'Show the seconds remaining next to timers that show minutes. Timers that show hours are not effected by this.'
L.General_ConsolidateEnabled				= 'Consolidate Multi-Auras'
L.General_ConsolidateEnabledTip				= 'Certain abilities like Templar\'s Restoring Aura have multiple buff effects, and these will normally all show in your selected aura window with the same icon, leading to clutter. This option consolidates these into a single aura. W.I.P.'
L.General_PassiveEffectsAsPassive			= 'Passive Major & Minor Buffs'
L.General_PassiveEffectsAsPassiveTip		= 'Set whether Major & Minor Buffs that are passive (no duration) are grouped along with other passive auras on the player according to the \'Your Passives\' setting.\n\nIf not enabled, all Major & Minor Buffs will be grouped together regardless of whether they are timed or passive.'
L.General_AuraFadeout						= 'Aura Fadeout Time'
L.General_AuraFadeoutTip					= 'Set how long an expired aura should take to fade out of view. With a setting of 0, Auras will disappear as soon as they expire without any fadeout.\n\nThe fadeout timer is in milliseconds (1000 = 1 second).'
L.General_ShortThreshold					= 'Short Buffs Threshold'
L.General_ShortThresholdTip					= 'Set the minimum duration of player buffs (in seconds) that will be considered part of the \'Long Buffs\' group. Any buffs below this threshold will be part of the \'Short Buffs\' group instead.'
L.General_ProcEnableAnims					= 'Enable Proc Animations'
L.General_ProcEnableAnimsTip				= 'Set whether to show an animation on the ActionBar for abilities that have proc\'d and now have a special action to perform. Abilites that can have procs include:\n   Crystal Fragments\n   Grim Focus & It\'s Morphs\n   Flame Lash\n   Deadly Cloak'
L.General_ProcEnableAnimsWarn				= 'If you are using a mod that modifies or hides the default ActionBar, animations may not display.'
L.General_ProcPlaySound						= 'Play Sound On Proc'
L.General_ProcPlaySoundTip					= 'Set a sound to play when an ability procs. A settings of None will prevent any audio alert of your procs.'

-- general (display groups)
L.General_ControlHeader						= 'Aura Control - Display Groups'
L.General_ControlBaseTip					= 'Set which display window to show each Aura Group in, or hide them from display entirely. Note: Enabling specific Filters or adding an aura to the Blacklist or Whitelists will override these settings.'
L.General_ControlShortTip					= 'This Aura Group contains all buffs on yourself with a duration below the \'Short Buff Threshold\'.'
L.General_ControlLongTip 					= 'This Aura Group contains all buffs on yourself with a duration above the \'Short Buff Threshold\'.'
L.General_ControlMajorTip					= 'This Aura Group contains all beneficial Major Effects that are active on yourself (eg. Major Sorcery). Detrimental Major Effects are part of the Debuffs group.'
L.General_ControlMinorTip					= 'This Aura Group contains all beneficial Minor Effects that are active on yourself (eg. Minor Sorcery). Detrimental Minor Effects are part of the Debuffs group.'
L.General_ControlToggledTip					= 'This Aura Group contains all toggled buffs that are active on yourself.'
L.General_ControlGroundTip					= 'This Aura Group contains all ground Areas Of Effect (AOE) that are cast by yourself.'
L.General_ControlEnchantTip					= 'This Aura Group contains all Enchant Effects that are active on yourself (eg. Hardening, Berserker).'
L.General_ControlGearTip					= 'This Aura Group contains all normally invisible Gear Procs that are active on yourself (eg. Bloodspawn).'
L.General_ControlCooldownTip				= 'This Aura Group tracks the internal reuse cooldown of your Gear Procs.'
L.General_ControlPassiveTip					= 'This Aura Group contains all passive effects that are active on yourself.'
L.General_ControlDebuffTip					= 'This Aura Group contains all hostile debuffs active on yourself cast by other mobs, players, or the enviroment.'
L.General_ControlTargetBuffTip				= 'This Aura Group contains all buffs on your target, whether they are timed, passive or toggled, unless specially filtered.'
L.General_ControlTargetDebuffTip 			= 'This Aura Group contains all debuffs applied to your target.'
L.General_ControlProminentTip				= 'This special Aura Group contains buffs and AOE\'s on yourself whitelisted to display here instead of their original group.'
L.General_ControlProminentDebuffTip			= 'This special Aura Group contains target debuffs whitelisted to display here instead of their original group.'

-- general (debug)
L.General_DebugOptions						= 'Debug Options'
L.General_DebugOptionsDesc					= 'Help track down missing or incorrect auras!'
L.General_DisplayAbilityID					= 'Enable Display Of Aura\'s AbilityID'
L.General_DisplayAbilityIDTip				= 'Set whether to display the internal abilityID of all auras. This can be used to find the exact ID of auras you may want to Blacklist from display or add to the Aura Whitelist display group.\n\nThis option can also be used to assist in fixing inaccurate aura display by reporting the errant ID\'s to the addon author.'
L.General_ShowCombatEvents					= 'Show All Combat Events'
L.General_ShowCombatEventsTip				= 'When enabled the abilityID and Name of all effects (buffs and debuffs) caused and received by the player will show in chat, followed by information about the source and target.\n\nTo prevent chat flooding and ease review, each ability will only display once until reload. HOWEVER, you may type /sdbclear at any time to manually reset the cache.'
L.General_AllowManualDebug					= 'Allow Manual Debug Edit'
L.General_AllowManualDebugTip				= 'When enabled you can type /sdbadd XXXXXX or /sdbremove XXXXXX to add/remove a single ID from the flood filter. Typing /sdbclear will still reset the filter completely.'
L.General_DisableSpamControl				= 'Disable Flood Control'
L.General_DisableSpamControlTip				= 'When enabled the combat event filter will print the same event every time it occurs without having to type /sdbclear or reload to clear the database.'
L.General_VerboseDebug						= 'Show Verbose Debug'
L.General_VerboseDebugTip					= 'Show the entire data block received from EVENT_COMBAT_EVENT and the ability icon path for every ID that passes the above filters in a (mostly) human readable format (this will quickly fill your chat log).'
L.General_ShowNoNames						= 'Show Nameless Events'
L.General_ShowNoNamesTip					= 'When enabled the combat event filter shows event ID\'s even when they have no name text (generally not needed).'


-- ------------------------
-- SETTINGS: FILTERS
-- ------------------------
L.FilterHeader								= 'Filter Lists and Toggles'
L.Filter_Desc								= 'Here you can blacklist auras, whitelist buffs or debuffs to appear as prominent and assign them to a custom window, or toggle filters for showing or hiding different types of effects.'
L.Filter_RemoveSelected						= 'Remove Selected'
L.Filter_ListAddWarn						= 'When adding an aura by name, it requires scanning all auras in the game to find the ability\'s internal ID number(s). This can cause the game to hang for a moment while searching.'
L.FilterToggle_Desc							= 'For these filters, enabling one prevents the display of that category (whitelisted prominent auras ignore these filters).'

L.Filter_PlayerHeader						= 'Aura Filters For Player'
L.Filter_TargetHeader						= 'Aura Filters For Target'
L.Filter_OnlyPlayerDebuffs					= 'Only Player Debuffs'
L.Filter_OnlyPlayerDebuffsTip				= 'Prevent the display of debuff auras on the target that were not created by the player.'

-- filters (blacklist auras)
L.Filter_BlacklistHeader					= 'Global Aura Blacklist'
L.Filter_BlacklistDesc						= 'Specific auras can be Blacklisted here to never appear in any aura tracking window.'
L.Filter_BlacklistAdd						= 'Add Blacklist Aura'
L.Filter_BlacklistAddTip					= 'The aura you want to blacklist must have its name entered exactly as it appears ingame, or you may enter the numerical abilityID (if known) to block a specific aura.\n\nPress enter to add the input aura to the blacklist.'
L.Filter_BlacklistList						= 'Current Blacklisted Auras'
L.Filter_BlacklistListTip					= 'List of all auras currently blacklisted. To remove an aura from the blacklist, select it from the list and click the Remove button.'

-- filters (prominent auras)
L.Filter_ProminentHeader					= 'Prominent Buff & AOE Assignments'
L.Filter_ProminentDesc						= 'Buffs and ground AOE\'s can be whitelisted to appear as prominent. This allows them to be seperated into one of two assigned prominent frames for easier monitoring of critical effects.'
L.Filter_ProminentAdd						= 'Add Whitelist Aura'
L.Filter_ProminentAddTip					= 'Enter the numerical abilityID (if known) or the name of the buff or ground AOE you wish to whitelist exactly as it appears in-game. If the ability applies specific effects you wish to track (ie: Major Sorcery) you may enter that instead of the ability name.\n\nPress enter to add the input aura to the whitelist.'
L.Filter_ProminentList1						= 'Current Whitelist 1 Auras'
L.Filter_ProminentList2						= 'Current Whitelist 2 Auras'
L.Filter_ProminentListTip					= 'List of all auras whitelisted to appear in this prominent frame. To remove an aura from this whitelist, select it from the list and click the Remove button.'

-- filters (prominent debuffs)
L.Filter_DebuffHeader						= 'Prominent Debuff Assignments'
L.Filter_DebuffDesc							= 'Debuffs can be whitelisted to appear as prominent. This allows them to be seperated into one of two assigned prominent frames for easier monitoring of critical effects.'
L.Filter_DebuffAdd							= 'Add Whitelist Debuff'
L.Filter_DebuffAddTip						= 'NOTE: Non-debuffs added here will do nothing. Use the Aura Whitelists for those.\n\nThe debuff you want to make prominent must have its name entered exactly as it appears ingame, or you may enter the numerical abilityID (if known).\n\nPress enter to add the input debuff to the whitelist.'
L.Filter_DebuffList1						= 'Current Whitelist 1 Debuffs'
L.Filter_DebuffList2						= 'Current Whitelist 2 Debuffs'
L.Filter_DebuffListTip						= 'List of all debuff set to appear in this prominent frame. To remove a debuff select it from the list and use the Remove button below.'
L.Filter_OnlyPlayerProminentDebuffs1		= 'Only Player Prominent 1 Debuffs'
L.Filter_OnlyPlayerProminentDebuffs2		= 'Only Player Prominent 2 Debuffs'
L.Filter_OnlyPlayerProminentDebuffsTip		= 'Prevent the display of debuff auras on this prominent debuff frame that were not created by the player. Works independently of the similar option under \'Aura Filters For Target\' below.'
L.Filter_DuplicateDebuffs					= 'Allow Duplicate Debuffs'
L.Filter_DuplicateDebuffsTip				= 'When enabled, target debuffs assigned to the Prominent Debuff frame will also show in the standard debuff frame (if assigned)'

-- filters (group frame auras)
L.Filter_GroupAuraHeader					= 'Group Buff Assignments'
L.Filter_GroupAuraDesc						= 'This list determines what buffs will show next to each player\'s group or raid frame.'
L.Filter_GroupAuraAdd						= 'Add Whitelist Group Buff'
L.Filter_GroupAuraAddTip					= 'To add an aura to track on group frames you must enter its name exactly as it appears ingame, or you may enter the numerical abilityID (if known).\n\nPress enter to add the input aura to the list.'
L.Filter_GroupList							= 'Current Group Whitelist'
L.Filter_GroupListTip						= 'List of all auras set to appear on group frames. To remove existing auras, select it from the list and use the Remove button below.'
L.Filter_GroupByDuration					= 'Exclude by Duration'
L.Filter_GroupByDurationTip					= 'Only show group buffs with a duration shorter than selected below (in seconds).'
L.Filter_GroupThreshold						= 'Duration Threshold'
L.Filter_GroupWhitelistOff					= 'Use as Blacklist'
L.Filter_GroupWhitelistOffTip				= 'Turn the Group Whitelist into a Blacklist and display ALL auras with a duration EXCEPT those input here.'

-- filters (unit options)
L.Filter_ESOPlus							= 'Filter ESO Plus'
L.Filter_ESOPlusPlayerTip					= 'Set whether to prevent the display of ESO Plus status on youself.'
L.Filter_ESOPlusTargetTip					= 'Set whether to prevent the display of ESO Plus status on your target.'

L.Filter_Block								= 'Filter Block'
L.Filter_BlockPlayerTip						= 'Set whether to prevent the display of the \'Brace\' toggle while you are blocking.'
L.Filter_BlockTargetTip						= 'Set whether to prevent the display of the \'Brace\' toggle when your opponent is blocking.'
L.Filter_MundusBoon							= 'Filter Mundus Boons'
L.Filter_MundusBoonPlayerTip				= 'Set whether to prevent the display of Mundus Stone boons on youself.'
L.Filter_MundusBoonTargetTip				= 'Set whether to prevent the display of Mundus Stone boons on your target.'
L.Filter_Cyrodiil							= 'Filter Cyrodiil Bonuses'
L.Filter_CyrodiilPlayerTip					= 'Set whether to prevent the display of buffs provided during Cyrodiil AvA on yourself.'
L.Filter_CyrodiilTargetTip					= 'Set whether to prevent the display of buffs provided during Cyrodiil AvA on your target.'
L.Filter_Disguise							= 'Filter Disguises'
L.Filter_DisguisePlayerTip					= 'Set whether to prevent the display of active disguises on yourself.'
L.Filter_DisguiseTargeTtip					= 'Set whether to prevent the display of active disguises on your target.'
L.Filter_MajorEffects						= 'Filter Major Effects'
L.Filter_MajorEffectsTargetTip				= 'Set whether to prevent the display of Major Effects (eg. Major Maim, Major Sorcery) on your target.'
L.Filter_MinorEffects						= 'Filter Minor Effects'
L.Filter_MinorEffectsTargetTip				= 'Set whether to prevent the display of Minor Effects (eg. Minor Maim, Minor Sorcery) on your target.'
L.Filter_SoulSummons						= 'Filter Soul Summons Cooldown'
L.Filter_SoulSummonsPlayerTip				= 'Set whether to prevent the display of the cooldown \'aura\' for Soul Summons on yourself.'
L.Filter_SoulSummonsTargetTip				= 'Set whether to prevent the display of the cooldown \'aura\' for Soul Summons on your target.'
L.Filter_VampLycan							= 'Filter Vampire & Werewolf Effects'
L.Filter_VampLycanPlayerTip					= 'Set whether to prevent the display of Vampirism and Lycanthropy buffs on yourself.'
L.Filter_VampLycanTargetTip					= 'Set whether to prevent the display of Vampirism and Lycanthropy buffs on your target.'
L.Filter_VampLycanBite						= 'Filter Vampire & Werewolf Bite Timers'
L.Filter_VampLycanBitePlayerTip				= 'Set whether to prevent the display of the Vampire and Werewolf bite cooldown timers on yourself.'
L.Filter_VampLycanBiteTargetTip				= 'Set whether to prevent the display of the Vampire and Werewolf bite cooldown timers on your target.'


-- ------------------------
-- SETTINGS: CAST BAR
-- ------------------------
L.CastBar_Enable							= 'Enable Cast & Channel Bar'
L.CastBar_EnableTip							= 'Set whether to enable a movable casting bar to show progress on abilities that have a cast or channel time before activation.'
L.CastBar_Alpha								= 'Transparency'
L.CastBar_AlphaTip							= 'Set how opaque the cast bar is when visible. A setting of 100 makes the bar fully opaque.'
L.CastBar_Scale								= 'Scale'
L.CastBar_ScaleTip							= 'Set the size of the cast bar as a percentage. A setting of 100 is the default size.'

-- cast bar (name)
L.CastBar_NameHeader						= 'Cast Ability Name Text'
L.CastBar_NameShow							= 'Show Ability Name Text'

-- cast bar (timer)
L.CastBar_TimerHeader						= 'Cast Timer Text'
L.CastBar_TimerShow							= 'Show Cast Timer Text'

-- cast bar (bar)
L.CastBar_BarHeader							= 'Cast Timer Bar'
L.CastBar_BarReverse						= 'Reverse Countdown Direction'
L.CastBar_BarReverseTip						= 'Set whether to reverse the countdown direction of the cast timer bar making the timer decrease towards the right. In either case, channelled abilities will increase in the opposite direction.'
L.CastBar_BarGloss							= 'Glossy Bar'
L.CastBar_BarGlossTip						= 'Set whether the cast timer bar should be glossy when displayed.'
L.CastBar_BarColor							= 'Bar Color'
L.CastBar_BarColorTip						= 'Set the cast timer bar colors. The left color choice determines the start of the bar (when it begins counting down) and the second the finish of the bar (when it has almost expired).'


-- ------------------------
-- SETTINGS: DISPLAY FRAMES
-- ------------------------
L.DisplayFrame_Alpha						= 'Window Transparency'
L.DisplayFrame_AlphaTip						= 'Set how opaque this aura window is when visible. A setting of 100 makes the window fully opaque.'
L.DisplayFrame_Scale						= 'Window Scale'
L.DisplayFrame_ScaleTip						= 'Set the size of this aura window as a percentage. A setting of 100 is the default size.'

-- display frames (aura)
L.DisplayFrame_AuraHeader					= 'Aura Display'
L.DisplayFrame_Style						= 'Aura Style'
L.DisplayFrame_StyleTip						= 'Set the style which this aura window\'s auras will display as.\n\n|cffd100Full Display|r - Show abiltiy name and icon, timer bar (can disable) and text.\n\n|cffd100Icon Only|r - Show ability icon and timer text only, this style provides more options for Aura Growth Direction than the others.\n\n|cffd100Minimal Display|r - Show ability name, and a smaller timer bar only.'
L.DisplayFrame_AuraCooldown					= 'Show Timer Animation'
L.DisplayFrame_AuraCooldownTip				= 'Display a timer animation around aura icons. This also makes auras easier to see than the old display mode. Customize using the color settings below.'
L.DisplayFrame_CooldownTimed				= 'Color: Timed Buffs & Debuffs'
L.DisplayFrame_CooldownTimedTip				= 'Set the icon timer animation color for auras with a set duration.\n\nLEFT = BUFFS\nRIGHT = DEBUFFS.'
L.DisplayFrame_Growth						= 'Aura Growth Direction'
L.DisplayFrame_GrowthTip					= 'Set which direction new auras will grow from the anchor point. For the centered settings, auras will grow either side of the anchor with ordering determined by the left|right prefix.\n\nWhen displaying in the |cffd100Full|r or |cffd100Mini|r styles, auras can only grow up or down.'
L.DisplayFrame_Padding						= 'Aura Growth Padding'
L.DisplayFrame_PaddingTip					= 'Set the spacing between each displayed aura.'
L.DisplayFrame_Sort							= 'Aura Sorting Order'
L.DisplayFrame_SortTip						= 'Set how auras are sorted. Either by alphabetical name, remaining duration or by the order in which they were cast; whether this order is ascending or descending can also be set.\n\nWhen sorting by duration, any passives or toggled abilities will be sorted by name and shown closest to the anchor (ascending), or furthest from the anchor (descending), with timed abilities coming before (or after) them.'
L.DisplayFrame_Highlight					= 'Toggled Aura Icon Highlight'
L.DisplayFrame_HighlightTip					= 'Set whether toggled auras have their icon highlighted to help distinguish from passive auras.\n\nNot available in the |cffd100Mini|r style as no icon is shown.'
L.DisplayFrame_Tooltips						= 'Enable Aura Name Tooltips'
L.DisplayFrame_TooltipsTip					= 'Set whether to allow mouseover tooltip display for an aura\'s name when in the |cffd100Icon Only|r style.'
L.DisplayFrame_TooltipsWarn					= 'Tooltips must be temporarily disabled for movement of the Display Window, or the tooltips will block movement.'
L.DisplayFrame_AuraClassOverride			= 'Aura Class Override'
L.DisplayFrame_AuraClassOverrideTip			= 'Allows you to make Srendarr treat all timed auras (toggles and passives ignored) in this bar as either buffs or debuffs, regardless of their actual class.\n\nUseful when adding both debuffs and AOE to a window to make both use the same bar and icon animation colors.'

-- display frames (group)
L.DisplayFrame_GRX							= 'Horizontal Offset'
L.DisplayFrame_GRXTip						= 'Adjust the position of the group/raid frame buff icons left and right.'
L.DisplayFrame_GRY							= 'Vertical Offset'
L.DisplayFrame_GRYTip						= 'Adjust the position of the group/raid frame buff icons up and down.'

-- display frames (name)
L.DisplayFrame_NameHeader					= 'Ability Name Text'

-- display frames (timer)
L.DisplayFrame_TimerHeader					= 'Timer Text'
L.DisplayFrame_TimerLocation				= 'Timer Text Location'
L.DisplayFrame_TimerLocationTip				= 'Set the timer\'s position for each aura with regards to that aura\'s icon. A setting of hidden will stop the timer label showing for all auras displayer here.\n\nOnly certain placement options are available depending on the current style.'
L.DisplayFrame_TimerHMS						= 'Show Minutes for Timers > 1 Hour'
L.DisplayFrame_TimerHMSTip					= 'Set whether to also show minutes remaining when a timer is greater than 1 hour.'

-- display frames (bar)
L.DisplayFrame_BarHeader					= 'Timer Bar'
L.DisplayFrame_HideFullBar					= 'Hide Timer Bar'
L.DisplayFrame_HideFullBarTip				= 'Hide the bar completely and only display the aura name text next to the icon when in full display mode.'
L.DisplayFrame_BarReverse					= 'Reverse Countdown Direction'
L.DisplayFrame_BarReverseTip				= 'Set whether to reverse the countdown direction of the timer bar making the timer decrease towards the right. In the |cffd100Full|r style this will also position the Aura icon to the right of the bar instead of the left.'
L.DisplayFrame_BarGloss						= 'Glossy Bars'
L.DisplayFrame_BarGlossTip					= 'Set whether the timer bar\'s should be glossy when displayed.'
L.DisplayFrame_BarBuffTimed					= 'Color: Timed Buffs'
L.DisplayFrame_BarBuffTimedTip				= 'Set the timer bar colors for buff auras with a set duration. The left color choice determines the start of the bar (when it begins counting down) and the second the finish of the bar (when it has almost expired).'
L.DisplayFrame_BarBuffPassive				= 'Color: Passive Buffs'
L.DisplayFrame_BarBuffPassiveTip			= 'Set the timer bar colors for passive buff auras with no set duration. The left color choice determines the start of the bar (the furthest side from the icon) and the second the finish of the bar (nearest the icon).'
L.DisplayFrame_BarDebuffTimed				= 'Color: Timed Debuffs'
L.DisplayFrame_BarDebuffTimedTip			= 'Set the timer bar colors for debuff auras with a set duration. The left color choice determines the start of the bar (when it begins counting down) and the second the finish of the bar (when it has almost expired).'
L.DisplayFrame_BarDebuffPassive				= 'Color: Passive Debuffs'
L.DisplayFrame_BarDebuffPassiveTip			= 'Set the timer bar colors for passive debuff auras with no set duration. The left color choice determines the start of the bar (the furthest side from the icon) and the second the finish of the bar (nearest the icon).'
L.DisplayFrame_BarToggled					= 'Color: Toggled Auras'
L.DisplayFrame_BarToggledTip				= 'Set the timer bar colors for toggled auras with no set duration. The left color choice determines the start of the bar (the furthest side from the icon) and the second the finish of the bar (nearest the icon).'


-- ------------------------
-- SETTINGS: PROFILES
-- ------------------------
L.Profile_Desc								= 'Setting profiles can be managed here including the option to enable an account wide profile that will apply the same settings to ALL character\'s on this account. Due to the permanency of these options, management must first be enabled using the checkbox at the bottom of the panel.'
L.Profile_UseGlobal							= 'Use Account Wide Profile'
L.Profile_UseGlobalWarn						= 'Switching between local and global profiles will reload the interface.'
L.Profile_Copy								= 'Select A Profile To Copy'
L.Profile_CopyTip							= 'Select a profile to copy its settings to the currently active profile. The active profile will be for either the logged in character or the account wide profile if enabled. The existing profile settings will be permanently overwritten.\n\nThis cannot be undone!'
L.Profile_CopyButton						= 'Copy Profile'
L.Profile_CopyButtonWarn					= 'Copying a profile will reload the interface.'
L.Profile_CopyCannotCopy					= 'Unable to copy selected profile. Please try again or select another profile.'
L.Profile_Delete							= 'Select A Profile To Delete'
L.Profile_DeleteTip							= 'Select a profile to delete its settings from the database. If that character is logged in later, and you are not using the account wide profile, new default settings will be created.\n\nDeleting a profile is permanent!'
L.Profile_DeleteButton						= 'Delete Profile'
L.Profile_Guard								= 'Enable Profile Management'


function Srendarr:GetLocale() -- default locale, will be the return unless overwritten
	return L
end
