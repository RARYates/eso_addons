local Srendarr = _G['Srendarr']
local L = {}

------------------------------------------------------------------------------------------------------------------
-- Japanese (jp) - Thanks to ESOUI.com user k0ta0uchi for the translations.
-- Indented or commented lines still require human translation and may not make sense!
------------------------------------------------------------------------------------------------------------------

L.Srendarr									= '|c67b1e9S|c4779ce\'rendarr|r'
L.Srendarr_Basic							= 'S\'rendarr'
L.Usage										= '|c67b1e9S|c4779ce\'rendarr|r - 使用方法: /srendarr 表示されているウィンドウの移動のロック|アンロックを切り替えます。'
L.CastBar									= 'Cast Bar'
L.Sound_DefaultProc 						= 'Srendarr (Default Proc)'

-- time format						
L.Time_Tenths								= '%.1fs'
L.Time_Seconds								= '%ds'
L.Time_Minutes								= '%dm'
L.Time_Hours								= '%dh'
L.Time_Days									= '%dd'

-- aura grouping
L.Group_Displayed_Here						= '表示されたグループ'
L.Group_Displayed_None						= '無し'
L.Group_Player_Short						= 'ショートバフ'
L.Group_Player_Long							= 'ロングバフ'
L.Group_Player_Major						= 'メジャーバフ'
L.Group_Player_Minor						= 'マイナーバフ'
L.Group_Player_Toggled						= 'トグルバフ'
L.Group_Player_Ground						= 'グランドターゲット'
L.Group_Player_Enchant						= 'エンチャント & ギア Procs'
--L.Group_Player_Gear						= 'Your Gear Procs'
--L.Group_Player_Cooldowns					= 'Your Proc Cooldowns'
L.Group_Player_Passive						= 'パッシブ'
L.Group_Player_Debuff						= 'デバフ'
L.Group_Target_Buff							= 'ターゲットバフ'
L.Group_Target_Debuff						= 'ターゲットデバフ'

--L.Group_Prominent							= 'Aura Whitelist 1'
--L.Group_Prominent2						= 'Aura Whitelist 2'
--L.Group_Debuffs							= 'Debuff Whitelist 1'
--L.Group_Debuffs2							= 'Debuff Whitelist 2'
--L.Group_Group								= 'Group Frames'
--L.Group_Raid								= 'Raid Frames'

-- whitelist & blacklist control
L.Prominent_AuraAddSuccess					= 'は、重要なオーラのホワイトリストに追加されました。'
L.Prominent_AuraAddSuccess2					= 'は、重要なオーラのホワイトリストに追加されました。'
L.Prominent_AuraAddFail						= 'は、見つからないため追加されませんでした。'
L.Prominent_AuraAddFailByID					= 'は、有効なabilityIDではないか、時限的なオーラのIDではないため追加されませんでした。'
L.Prominent_AuraRemoved						= 'は、重要なオーラホワイトリストから外されました。'
L.Prominent_AuraRemoved2					= 'は、重要なオーラホワイトリストから外されました。'
L.Blacklist_AuraAddSuccess					= 'は、ブラックリストに追加され、表示されることはありません。'
L.Blacklist_AuraAddFail						= 'は、見つからなかったためブラックリストには追加されませんでした。'
L.Blacklist_AuraAddFailByID					= 'は、有効なabilityIDではなく、ブラックリストに追加されませんでした。'
L.Blacklist_AuraRemoved						= 'は、ブラックリストから外されました。'
--L.Group_AuraAddSuccess					= 'has been added to the Group Whitelist.'
--L.Group_AuraRemoved						= 'has been removed from the Group Whitelist.'
--L.Debuff_AuraAddSuccess					= 'has been added to Debuff Whitelist 1.'
--L.Debuff_AuraAddSuccess2					= 'has been added to Debuff Whitelist 2.'
--L.Debuff_AuraRemoved						= 'has been removed from Debuff Whitelist 1.'
--L.Debuff_AuraRemoved2						= 'has been removed from Debuff Whitelist 2.'

-- settings: base
L.Show_Example_Auras						= 'オーラ例'
L.Show_Example_Castbar						= 'キャストバー例'

L.SampleAura_PlayerTimed					= '時限プレイヤー'
L.SampleAura_PlayerToggled					= 'トグルプレイヤー'
L.SampleAura_PlayerPassive					= 'パッシブプレイヤー'
L.SampleAura_PlayerDebuff					= 'デバフプレイヤー'
L.SampleAura_PlayerGround					= '地上エフェクト'
L.SampleAura_PlayerMajor					= 'メジャーエフェクト'
L.SampleAura_PlayerMinor					= 'マイナーエフェクト'
L.SampleAura_TargetBuff						= 'ターゲットバフ'
L.SampleAura_TargetDebuff					= 'ターゲットデバフ'

L.TabButton1								= '一般'
L.TabButton2								= 'フィルター'
L.TabButton3								= 'キャストバー'
L.TabButton4								= 'オーラ表示'
L.TabButton5								= 'プロファイル'
				
L.TabHeader1								= '一般設定'
L.TabHeader2								= 'フィルター設定'
L.TabHeader3								= 'キャストバー設定'
L.TabHeader5								= 'プロファイル設定'
L.TabHeaderDisplay							= 'ウィンドウ表示設定'

-- settings: generic
L.GenericSetting_ClickToViewAuras			= '|cffd100オーラを見るにはクリック|r'
L.GenericSetting_NameFont					= '名前テキストフォント'
L.GenericSetting_NameStyle					= '名前テキストフォントカラー & スタイル'
L.GenericSetting_NameSize					= '名前テキストサイズ'
L.GenericSetting_TimerFont					= 'タイマーテキストフォント'
L.GenericSetting_TimerStyle					= 'タイマーテキストフォントカラー & スタイル'
L.GenericSetting_TimerSize					= 'タイマーテキストサイズ'
L.GenericSetting_BarWidth					= 'バー幅'
L.GenericSetting_BarWidthTip				= 'キャストタイマーバー表示の幅を設定します。\n\nポジションによっては、幅を変更した後調整する必要がある場合があります。'


-- ----------------------------
-- SETTINGS: DROPDOWN ENTRIES
-- ----------------------------
L.DropGroup_1								= '表示ウィンドウ [|cffd1001|r]'
L.DropGroup_2								= '表示ウィンドウ [|cffd1002|r]'
L.DropGroup_3								= '表示ウィンドウ [|cffd1003|r]'
L.DropGroup_4								= '表示ウィンドウ [|cffd1004|r]'
L.DropGroup_5								= '表示ウィンドウ [|cffd1005|r]'
L.DropGroup_6								= '表示ウィンドウ [|cffd1006|r]'
L.DropGroup_7								= '表示ウィンドウ [|cffd1007|r]'
L.DropGroup_8								= '表示ウィンドウ [|cffd1008|r]'
L.DropGroup_9								= '表示ウィンドウ [|cffd1009|r]'
L.DropGroup_10								= '表示ウィンドウ [|cffd10010|r]'
L.DropGroup_None							= '表示しない'

L.DropStyle_Full							= 'フル表示'
L.DropStyle_Icon							= 'アイコンのみ'
L.DropStyle_Mini							= '最小表示'

L.DropGrowth_Up								= '上'
L.DropGrowth_Down							= '下'
L.DropGrowth_Left							= '左'
L.DropGrowth_Right							= '右'
L.DropGrowth_CenterLeft						= '中央揃え (左)'
L.DropGrowth_CenterRight					= '中央揃え (右)'

L.DropSort_NameAsc							= 'アビリティ名 (上昇）'
L.DropSort_TimeAsc							= '残り時間 (上昇）'
L.DropSort_CastAsc							= 'キャスティングオーダー (上昇）'
L.DropSort_NameDesc							= 'アビリティ名 (下降)'
L.DropSort_TimeDesc							= '残り時間 (下降)'
L.DropSort_CastDesc							= 'キャスティングオーダー (下降)'
				
L.DropTimer_Above							= '上アイコン'
L.DropTimer_Below							= '下アイコン'
L.DropTimer_Over							= 'オーバーアイコン'
L.DropTimer_Hidden							= '隠す'

--L.DropAuraClassBuff						= 'Buff'
--L.DropAuraClassDebuff						= 'Debuff'
--L.DropAuraClassDefault					= 'No Override'


-- ------------------------
-- SETTINGS: GENERAL
-- ------------------------
-- general (general options)
--L.General_GeneralOptions					= 'General Options'
--L.General_GeneralOptionsDesc				= 'Various general options that control the addon\'s behavior.'
L.General_UnlockDesc						= 'アンロックすることでオーラ表示をマウスでドラッグすることができます。リセットボタンを押すと全てのウィンドウをデフォルトポジションに戻します。'
L.General_UnlockLock						= 'ロック'
L.General_UnlockUnlock						= 'アンロック'
L.General_UnlockReset						= 'リセット'
L.General_UnlockResetAgain					= 'リセットするにはもう一度クリックしてください。'
L.General_CombatOnly						= '戦闘中のみ表示'
L.General_CombatOnlyTip						= 'オーラウィンドウを戦闘中のみ表示するかを設定します。'
--L.HideOnDeadTargets						= 'Hide On Dead Targets'
--L.HideOnDeadTargetsTip					= 'Set whether to hide all auras on dead targets. (Will hide potentially useful things like Repentance use debuff.)'
--L.General_ConsolidateEnabled				= 'Consolidate Multi-Auras'
--L.General_ConsolidateEnabledTip			= 'Certain abilities like Templar\'s Restoring Aura have multiple buff effects, and these will normally all show in your selected aura window with the same icon, leading to clutter. This option consolidates these into a single aura. W.I.P.'
L.General_PassiveEffectsAsPassive			= 'パッシブメジャー&マイナーバフをパッシブとして扱う'
L.General_PassiveEffectsAsPassiveTip		= 'パッシブなメジャー&マイナーバフは他のパッシブオーラ（あなたのパッシブ設定による）と一緒にグループ化され隠されます。\n\n有効化されている場合、全てのメジャー&マイナーバフは時限かかパッシブでない限りグループ化統合されます。'
L.General_AuraFadeout						= 'オーラフェードアウトタイム'
L.General_AuraFadeoutTip					= '完了したオーラがどれくらい時間をかけてフェードアウトするかを設定します。0に設定した場合、完了したオーラはフェードアウトしないですぐに消えます。\n\nフェードアウトタイマーの単位はミリ秒です。'
L.General_ShortThreshold					= 'ショートバフ閾値'
L.General_ShortThresholdTip					= '\'ロングバフ\'グループとして扱うプレイヤーバフの最小持続時間を設定します。（秒単位）この閾値以下のバフは\'ショートバフ\'グループとして扱われます。'
L.General_ProcEnableAnims					= 'Procアニメーションを有効にする'
L.General_ProcEnableAnimsTip				= 'Procされ、発動できる特殊アクションを持つアビリティでアクションバーにアニメーションを表示するか設定します。以下のProcを持つアビリティを含む:\n   Crystal Fragments\n   Grim Focus & It\'s Morphs\n   Flame Lash\n   Deadly Cloak'
L.General_ProcEnableAnimsWarn				= 'デフォルトのアクションバーを修正するか隠すかするmodを使用している場合アニメーションが表示されない場合があります。'
L.General_ProcPlaySound						= 'Proc発動時サウンドを再生する'
L.General_ProcPlaySoundTip					= 'アビリティのProc発動時サウンドを再生するかを設定します。「無し」に設定した場合Proc発動音声アラートが再生されません。'

-- general (display groups)
L.General_ControlHeader						= 'オーラコントロール - ディスプレイグループ'
L.General_ControlBaseTip					= 'このオーラグループをどのディスプレイウィンドウに表示するか、全体的に隠すかを設定します。'
L.General_ControlShortTip					= 'このオーラグループは、全ての自身にかかっている独自な持続時間が\'ショートバフ閾値\'以下のバフを含みます。'
L.General_ControlLongTip 					= 'このオーラグループは、全ての自身にかかっている独自な持続時間が\'ショートバフ閾値\'より長いバフを含みます。'
L.General_ControlMajorTip					= 'このオーラグループは、全ての自身にかかっている有効な便利なメジャーエフェクトが含まれ、（例：Major Sorcery）有害なメジャーエフェクトはデバフグループの一部となります。'
L.General_ControlMinorTip					= 'このオーラグループは、全ての自身にかかっている有効な便利なマイナーエフェクトが含まれ、（例：Major Sorcery）有害なマイナーエフェクトはデバフグループの一部となります。'
L.General_ControlToggledTip					= 'このオーラグループは、全ての自身にかかっているアクティブなトグルバフを含みます。'
L.General_ControlGroundTip					= 'このオーラグループは、全ての自身でかけた地上エリアのエフェクトを含みます。'
L.General_ControlEnchantTip					= 'このオーラグループは全ての自身にかかっている有効なエンチャントとギアProcエフェクトが含まれます。(例：Hardening, Berserker）'
--L.General_ControlGearTip					= 'This Aura Group contains all normally invisible Gear Procs that are active on yourself (eg. Bloodspawn).'
--L.General_ControlCooldownTip				= 'This Aura Group tracks the internal reuse cooldown of your Gear Procs.'
L.General_ControlPassiveTip					= 'このオーラグループは、フィルタリングされていない全ての自身にかかっているアクティブなパッシブエフェクトを含みます。'
L.General_ControlDebuffTip					= 'このオーラグループは全ての他のモブ、プレイヤー、環境にかけられた自身にかかっているアクティブな敵対デバフを含みます。'
L.General_ControlTargetBuffTip				= 'このオーラグループは、フィルターされていない全てのターゲットにかかっている時限的、パッシブもしくはトグルのバフが含まれます。'
L.General_ControlTargetDebuffTip 			= 'このオーラグループは、全てのターゲットにかかっているデバフが含まれます。ゲーム上の制限により、レアな例外以外、自分のデバフのみが表示されます。'
L.General_ControlProminentTip				= 'このスペシャルオーラグループは、全ての自身にかかっているバフ、地上エリアのエフェクト、ホワイトリストがオリジナルのグループの代わりに表示されます。'
--L.General_ControlProminentDebuffTip		= 'This special Aura Group contains target debuffs whitelisted to display here instead of their original group.'

-- general (debug)
L.General_DebugOptions						= 'デバッグオプション'
L.General_DebugOptionsDesc					= '表示されない、誤ったオーラをトラッキングするのを助けてください！'
L.General_DisplayAbilityID					= 'オーラAbilityIDの表示を有効にする'
L.General_DisplayAbilityIDTip				= '全ての内部的なオーラabilityIDを表示するかを設定します。これはブラックリストに追加する際や重要表示グループに追加する際に正確なオーラIDを探すのに使います。\n\nこのオプションは不正確なオーラ表示を直すため、誤ったIDをaddon作者に報告する助けになります。'
L.General_ShowCombatEvents					= '戦闘イベントを表示'
L.General_ShowCombatEventsTip				= 'この設定が有効な場合、プレイヤーが取得した全てのエフェクトのAbilityIDと名前がチャットに表示されます。「かなりの量」の情報になります。'
--L.General_AllowManualDebug				= 'Allow Manual Debug Edit'
--L.General_AllowManualDebugTip				= 'When enabled you can type /sdbadd XXXXXX or /sdbremove XXXXXX to add/remove a single ID from the flood filter. Typing /sdbclear will still reset the filter completely.'
--L.General_DisableSpamControl				= 'Disable Flood Control'
--L.General_DisableSpamControlTip			= 'When enabled the combat event filter will print the same event every time it occurs without having to type /sdbclear or reload to clear the database.'
--L.General_VerboseDebug					= 'Show Verbose Debug'
--L.General_VerboseDebugTip					= 'Show the entire data block received from EVENT_COMBAT_EVENT and the ability icon path for every ID that passes the above filters in a (mostly) human readable format (this will quickly fill your chat log).'
--L.General_ShowNoNames						= 'Show Nameless Events'
--L.General_ShowNoNamesTip					= 'When enabled the combat event filter shows event ID\'s even when they have no name text (generally not needed).'


-- ------------------------
-- SETTINGS: FILTERS
-- ------------------------
--L.FilterHeader							= 'Filter Lists and Toggles'
--L.Filter_Desc								= 'Here you can blacklist auras, whitelist buffs or debuffs to appear as prominent and assign them to a custom window, or toggle filters for showing or hiding different types of effects.'
--L.Filter_RemoveSelected					= 'Remove Selected'
L.Filter_ListAddWarn						= 'オーラを名前で追加する場合、全てのオーラをスキャンし、アビリティの内部的なIDを取得する必要があります。これは検索中ゲームをハングアップする可能性があります。'
L.FilterToggle_Desc							= '特定のオーラをブラックリスト（名前による）か、特定のオーラカテゴリーのフィルターを通してコントロールします。フィルターは一つ有効にするとそのカテゴリーを表示しません。'

L.Filter_PlayerHeader						= 'プレイヤー用オーラフィルター'
L.Filter_TargetHeader						= 'ターゲット用オーラフィルター'
--L.Filter_OnlyPlayerDebuffs				= 'Only Player Debuffs'
--L.Filter_OnlyPlayerDebuffsTip				= 'Prevent the display of debuff auras on the target that were not created by the player.'

-- filters (blacklist auras)
L.Filter_BlacklistHeader					= 'オーラブラックリスト'
--L.Filter_BlacklistDesc					= 'Specific auras can be Blacklisted here to never appear in any aura tracking window.'
L.Filter_BlacklistAdd						= 'オーラをブラックリストに追加する'
L.Filter_BlacklistAddTip					= 'ブラックリストに追加したいオーラはゲーム内に表示されている名前を正確に入力するか、内部的なAbilityID（わかれば）を入力することにより、特定のオーラをブロックすることができます。\n\nエンターキーを押すことにより、ブラックリストに追加することができます。'
L.Filter_BlacklistList						= '現在ブラックリストに登録されているオーラ'
L.Filter_BlacklistListTip					= 'ブラックリストに設定されている全てのオーラのリストです。設定されているオーラを外したい場合はリストから選択し、「ブラックリストから外す」ボタンを押してください。'

-- filters (prominent auras)
L.Filter_ProminentHeader					= '重要なオーラ'
L.Filter_ProminentDesc						= '自分自身もしくは地上ターゲットにかかっているバフは重要なオーラとしてホワイトリストに入れることができます。重要なオーラは別のウィンドウに分けられ、クリティカルなエフェクトを簡単にモニタできるようになります。'
L.Filter_ProminentAdd						= '重要なオーラを追加する'
L.Filter_ProminentAddTip					= '重要としたいバフもしくは地上ターゲットエフェクトはゲーム内に表示されている名前を正確に入力するか、内部的なAbilityID（わかれば）を入力することにより、特定のオーラをホワイトリストに追加することができます。\n\nエンターキーを押すと、入力したオーラを重要ホワイトリストに追加します。持続時間を持つオーラのみ設定することができ、パッシブやトグルアビリティは無視されます。'
--L.Filter_ProminentList1					= 'Current Whitelist 1 Auras'
--L.Filter_ProminentList2					= 'Current Whitelist 2 Auras'
L.Filter_ProminentListTip					= '重要として設定されている全てのオーラのリストです。設定されているオーラを外したい場合は、リストから選択し、「重要なオーラを外す」ボタンを押してください。'

-- filters (prominent debuffs)
--L.Filter_DebuffHeader						= 'Prominent Debuff Assignments'
--L.Filter_DebuffDesc						= 'Debuffs can be whitelisted to appear as prominent. This allows them to be seperated into one of two assigned prominent frames for easier monitoring of critical effects.'
--L.Filter_DebuffAdd						= 'Add Whitelist Debuff'
--L.Filter_DebuffAddTip						= 'NOTE: Non-debuffs added here will do nothing. Use the Aura Whitelists for those.\n\nThe debuff you want to make prominent must have its name entered exactly as it appears ingame, or you may enter the numerical abilityID (if known).\n\nPress enter to add the input debuff to the whitelist.'
--L.Filter_DebuffList1						= 'Current Whitelist 1 Debuffs'
--L.Filter_DebuffList2						= 'Current Whitelist 2 Debuffs'
--L.Filter_DebuffListTip					= 'List of all debuff set to appear in this prominent frame. To remove a debuff select it from the list and use the Remove button below.'
--L.Filter_OnlyPlayerProminentDebuffs1		= 'Only Player Prominent 1 Debuffs'
--L.Filter_OnlyPlayerProminentDebuffs2		= 'Only Player Prominent 2 Debuffs'
--L.Filter_OnlyPlayerProminentDebuffsTip	= 'Prevent the display of debuff auras on this prominent debuff frame that were not created by the player. Works independently of the similar option under \'Aura Filters For Target\' below.'
--L.Filter_DuplicateDebuffs					= 'Allow Duplicate Debuffs'
--L.Filter_DuplicateDebuffsTip				= 'When enabled, target debuffs assigned to the Prominent Debuff frame will also show in the standard debuff frame (if assigned)'

-- filters (group frame auras)
--L.Filter_GroupAuraHeader					= 'Group Buff Assignments'
--L.Filter_GroupAuraDesc					= 'This list determines what buffs will show next to each player\'s group or raid frame.'
--L.Filter_GroupAuraAdd						= 'Add Whitelist Group Buff'
--L.Filter_GroupAuraAddTip					= 'To add an aura to track on group frames you must enter its name exactly as it appears ingame, or you may enter the numerical abilityID (if known).\n\nPress enter to add the input aura to the list.'
--L.Filter_GroupList						= 'Current Group Whitelist'
--L.Filter_GroupListTip						= 'List of all auras set to appear on group frames. To remove existing auras, select it from the list and use the Remove button below.'
--L.Filter_GroupByDuration					= 'Exclude by Duration'
--L.Filter_GroupByDurationTip				= 'Only show group buffs with a duration shorter than selected below (in seconds).'
--L.Filter_GroupThreshold					= 'Duration Threshold'
--L.Filter_GroupWhitelistOff				= 'Use as Blacklist'
--L.Filter_GroupWhitelistOffTip				= 'Turn the Group Whitelist into a Blacklist and display ALL auras with a duration EXCEPT those input here.'

-- filters (unit options)
--L.Filter_ESOPlus							= 'Filter ESO Plus'
--L.Filter_ESOPlusPlayerTip					= 'Set whether to prevent the display of ESO Plus status on youself.'
--L.Filter_ESOPlusTargetTip					= 'Set whether to prevent the display of ESO Plus status on your target.'
L.Filter_Block								= 'ブロックフィルター'
L.Filter_BlockPlayerTip						= 'ブロックしている状態で\'Brace\'トグルを表示するかを設定します。'
L.Filter_BlockTargetTip						= 'ブロックされている状態で\'Brace\'トグルを表示するかを設定します。'
L.Filter_MundusBoon							= 'ムンダスブーンフィルター'
L.Filter_MundusBoonPlayerTip				= '自身にかかっているムンダスストーンによる恩恵を表示するかを設定します。'
L.Filter_MundusBoonTargetTip				= 'ターゲットにかかっているムンダスストーンによる恩恵を表示するかを設定します。'
L.Filter_Cyrodiil							= 'シロディールボーナスフィルター'
L.Filter_CyrodiilPlayerTip					= 'シロディールAvA時、自身にかかっているバフを表示するかを設定します。'
L.Filter_CyrodiilTargetTip					= 'シロディールAvA時、ターゲットにかかっているバフを表示するかを設定します。'
L.Filter_Disguise							= 'ディスガイズフィルター'
L.Filter_DisguisePlayerTip					= '自身にかかっている有効なディスガイズを表示するかを設定します。'
L.Filter_DisguiseTargeTtip					= 'ターゲットにかかっている有効なディスガイズを表示するかを設定します。'
L.Filter_MajorEffects						= 'メジャーエフェクトフィルター'
L.Filter_MajorEffectsTargetTip				= 'ターゲットにかかっているメジャーエフェクトを表示するかを設定します。（例：Major Maim, Major Sorcery）'
L.Filter_MinorEffects						= 'マイナーエフェクトフィルター'
L.Filter_MinorEffectsTargetTip				= 'ターゲットにかかっているマイナーエフェクトを表示するかを設定します。（例：Minor Maim, Minor Sorcery）'
L.Filter_SoulSummons						= 'ソウル召喚クールダウンフィルター'
L.Filter_SoulSummonsPlayerTip				= '自身にかかっているクールダウン\'オーラ\'を表示するかを設定します。'
L.Filter_SoulSummonsTargetTip				= 'ターゲットにかかっているソウル召喚クールダウン\'オーラ\'を表示するかを設定します。'
L.Filter_VampLycan							= 'ヴァンパイア&ウェアウルフエフェクトフィルター'
L.Filter_VampLycanPlayerTip					= '自身にかかっているヴァンパイア化とウェアウルフ化バフを表示するかを設定します。'
L.Filter_VampLycanTargetTip					= 'ターゲットにかかっているヴァンパイア化とウェアウルフ化バフを表示するかを設定します。'
L.Filter_VampLycanBite						= 'ヴァンパイア & ウェアウルフ噛みつきタイマーフィルター'
L.Filter_VampLycanBitePlayerTip				= '自身にかかっているヴァンパイア & ウェアウルフ噛みつきクールダウンタイマーを表示するかを設定します。'
L.Filter_VampLycanBiteTargetTip				= 'ターゲットにかかっているヴァンパイア & ウェアウルフ噛みつきクールダウンタイマーを表示するかを設定します。'


-- ------------------------
-- SETTINGS: CAST BAR
-- ------------------------
L.CastBar_Enable							= 'キャストとチャネルバーを有効にする'
L.CastBar_EnableTip							= 'キャストがあるもしくは有効前にチャネルタイムがあるアビリティに、進捗状況を表示する移動可能なキャスティングバーを表示するかを設定します。'
L.CastBar_Alpha								= '透明度'
L.CastBar_AlphaTip							= 'キャストバーが表示されている際の透明度を設定します。100に設定すると完全に透明になります。'
L.CastBar_Scale								= 'スケール'
L.CastBar_ScaleTip							= 'キャストバーのサイズをパーセンテージで設定します。100がデフォルトサイズです。'

-- cast bar (name)
L.CastBar_NameHeader						= '発動アビリティ名テキスト'
L.CastBar_NameShow							= 'アビリティ名テキストを表示'

-- cast bar (timer)
L.CastBar_TimerHeader						= 'キャストタイマーテキスト'
L.CastBar_TimerShow							= 'キャスタータイマーテキストを表示'

-- cast bar (bar)
L.CastBar_BarHeader							= 'キャストタイマーバー'
L.CastBar_BarReverse						= 'カウントダウン方向を逆にする'
L.CastBar_BarReverseTip						= 'キャストバーがタイマーが減少すると右に移動するようカウントダウン方向を逆にするかを設定します。どちらのケースでもチャネルアビリティは反対方向に増加します。'
L.CastBar_BarGloss							= 'グロスバー'
L.CastBar_BarGlossTip						= 'キャストタイマーバー表示をグロス表示にするかを設定します。'
L.CastBar_BarColor							= 'バーカラー'
L.CastBar_BarColorTip						= 'キャストタイマーバーの色を設定します。左側はバーの最初を最初から（カウントダウンする場合）2番目のバーの終わりを意味します。（もうすぐ終わる場合）'


-- ------------------------
-- SETTINGS: DISPLAY FRAMES
-- ------------------------
L.DisplayFrame_Alpha						= 'ウィンドウ透明度'
L.DisplayFrame_AlphaTip						= 'このオーラウィンドウ表示時の透明度を設定します。100に設定するとウィンドウが全て透明化されます。'
L.DisplayFrame_Scale						= 'ウィンドウスケール'
L.DisplayFrame_ScaleTip						= 'このオーラウィンドウのサイズをパーセンテージで設定します。デフォルトサイズは100です。'

-- display frames (aura)
L.DisplayFrame_AuraHeader					= 'オーラディスプレイ'
L.DisplayFrame_Style						= 'オーラスタイル'
L.DisplayFrame_StyleTip						= 'このオーラウィンドウのスタイルを設定します。\n\n|cffd100フル表示|r - アビリティ名とアイコン、タイマーバーとテキストを表示します。\n\n|cffd100アイコンのみ|r - アビリティアイコンとタイマーテキストのみ表示します。このスタイルは他のスタイルよりもオーラ拡張方向オプションをより多く提供します。\n\n|cffd100最小表示|r - アビリティ名と小さめのタイマーバーのみを表示します。'
--L.DisplayFrame_AuraCooldown				= 'Show Timer Animation'
--L.DisplayFrame_AuraCooldownTip			= 'Display a timer animation around aura icons. This also makes auras easier to see than the old display mode. Customize using the color settings below.'
--L.DisplayFrame_CooldownTimed				= 'Color: Timed Buffs & Debuffs'
--L.DisplayFrame_CooldownTimedTip			= 'Set the icon timer animation color for auras with a set duration.\n\nLEFT = BUFFS\nRIGHT = DEBUFFS.'
L.DisplayFrame_Growth						= 'オーラ拡張方向'
L.DisplayFrame_GrowthTip					= '新しいオーラがアンカーポイントよりどちらの方向に拡張するかを設定します。中央揃え設定の場合、オーラはどちらのサイドにも拡張していき、左|右プリフィックスで決定されます。\n\nオーラは|cffd100フル表示|rもしくは|cffd100最小表示|rの場合、上か下かにしか拡張しません。'
L.DisplayFrame_Padding						= 'オーラ拡張パディング'
L.DisplayFrame_PaddingTip					= 'それぞれの表示されたオーラの間のスペースを設定します。'
L.DisplayFrame_Sort							= 'オーラソーティング順序'
L.DisplayFrame_SortTip						= 'オーラがソーティングされる順序を設定します。名前アルファベット順、残り持続時間か、キャストした順に設定できます。 また、昇順か降順かも設定することができます。\n\n持続時間でソートする場合は、パッシブかトグルアビリティは名前と一番近いアンカー（昇順）、もしくは一番遠いアンカー（降順）でソートされ、時限アビリティはその前もしくは後ろに行きます。'
L.DisplayFrame_Highlight					= 'トグルオーラアイコンハイライト'
L.DisplayFrame_HighlightTip					= 'トグルオーラをハイライトしてパッシブオーラとの区別をするよう設定します。\n\n|cffd100最小表示|r では表示されずアイコンも表示されません。'
L.DisplayFrame_Tooltips						= 'オーラ名のツールチップを表示'
L.DisplayFrame_TooltipsTip					= '|cffd100アイコンのみ|r の場合オーラ名をマウスオーバーツールチップで表示するかを設定します。'
L.DisplayFrame_TooltipsWarn					= 'ディスプレイウィンドウを移動する際はツールチップは一時的に無効にする必要があります。有効な場合、ツールチップが移動を妨害する場合があります。'
--L.DisplayFrame_AuraClassOverride			= 'Aura Class Override'
--L.DisplayFrame_AuraClassOverrideTip		= 'Allows you to make Srendarr treat all timed auras (toggles and passives ignored) in this bar as either buffs or debuffs, regardless of their actual class.\n\nUseful when adding both debuffs and AOE to a window to make both use the same bar and icon animation colors.'

-- display frames (group)
--L.DisplayFrame_GRX						= 'Horizontal Offset'
--L.DisplayFrame_GRXTip						= 'Adjust the position of the group/raid frame buff icons left and right.'
--L.DisplayFrame_GRY						= 'Vertical Offset'
--L.DisplayFrame_GRYTip						= 'Adjust the position of the group/raid frame buff icons up and down.'

-- display frames (name)
L.DisplayFrame_NameHeader					= 'アビリティ名テキスト'

-- display frames (timer)
L.DisplayFrame_TimerHeader					= 'タイマーテキスト'
L.DisplayFrame_TimerLocation				= 'タイマーテキストポジション'
L.DisplayFrame_TimerLocationTip				= 'オーラアイコンに対応した各オーラタイマーのポジションを設定します。「隠す」設定は全てのオーラでタイマーラベルを表示しないようにします。\n\n現在のスタイルによって特定の設置オプションのみ利用できます。'
--L.DisplayFrame_TimerHMS					= 'Show Minutes for Timers > 1 Hour'
--L.DisplayFrame_TimerHMSTip				= 'Set whether to also show minutes remaining when a timer is greater than 1 hour.'

-- display frames (bar)
L.DisplayFrame_BarHeader					= 'タイマーバー'
--L.DisplayFrame_HideFullBar				= 'Hide Timer Bar'
--L.DisplayFrame_HideFullBarTip				= 'Hide the bar completely and only display the aura name text next to the icon when in full display mode.'
L.DisplayFrame_BarReverse					= 'リバースカウントダウン方向'
L.DisplayFrame_BarReverseTip				= 'タイマーバーのカウントダウン方向を逆にしタイマーが減少すると右に拡張するか設定します。|cffd100フル表示|r ではオーラアイコンをバーの右に表示することもできます。'
L.DisplayFrame_BarGloss						= 'グロスバー'
L.DisplayFrame_BarGlossTip					= 'タイマーバーをグロス表示するかどうかを設定します。'
L.DisplayFrame_BarBuffTimed					= 'カラー: 時限オーラ'
L.DisplayFrame_BarBuffTimedTip				= '持続時間がセットされたオーラタイマーバーカラーを設定します。左側はバーの最初を最初から（カウントダウンする場合）2番目のバーの終わりを意味します。（もうすぐ終わる場合）'
L.DisplayFrame_BarBuffPassive				= 'カラー: パッシブオーラ'
L.DisplayFrame_BarBuffPassiveTip			= '持続時間がセットされていないパッシブオーラタイマーバーカラーを設定します。左側はバーの最初を最初から（アイコンから一番遠い側）2番目のバーの終わりを意味します。（アイコンに近い側）.'
--L.DisplayFrame_BarDebuffTimed				= 'Color: Timed Debuffs'
--L.DisplayFrame_BarDebuffTimedTip			= 'Set the timer bar colors for debuff auras with a set duration. The left color choice determines the start of the bar (when it begins counting down) and the second the finish of the bar (when it has almost expired).'
--L.DisplayFrame_BarDebuffPassive			= 'Color: Passive Debuffs'
--L.DisplayFrame_BarDebuffPassiveTip		= 'Set the timer bar colors for passive debuff auras with no set duration. The left color choice determines the start of the bar (the furthest side from the icon) and the second the finish of the bar (nearest the icon).'
L.DisplayFrame_BarToggled					= 'カラー: トグルオーラ'
L.DisplayFrame_BarToggledTip				= '持続時間がセットされていないトグルオーラタイマーバーカラーを設定します。左側はバーの最初を最初から（アイコンから一番遠い側）2番目のバーの終わりを意味します。（アイコンに近い側）'


-- ------------------------
-- SETTINGS: PROFILES
-- ------------------------
L.Profile_Desc								= 'プロファイルを設定することができます。このアカウントの「全て」のキャラクターに同じ設定が適用されるアカウントプロファイルもここで有効することができます。これらのオプションはその永続性により、マネージャは最初にこのパネルの一番下にあるチェックボックスに有効にする必要があります。'
L.Profile_UseGlobal							= 'アカウントプロファイルを使用する'
L.Profile_UseGlobalWarn						= 'キャラ毎のプロファイルとアカウントプロファイルを切り替える場合、UIがリロードされます。'
L.Profile_Copy								= 'コピーするプロファイルを選択'
L.Profile_CopyTip							= '現在有効なプロファイルにコピーしたいプロファイルを選択します。有効なプロファイルはログインしているキャラクターのものか、設定が有効になっていればアカウントプロファイルになります。現在のプロファイルは永久に上書きされます。\n\nこの操作は元に戻すことはできません！'
L.Profile_CopyButton						= 'プロファイルをコピー'
L.Profile_CopyButtonWarn					= 'プロファイルをコピーするとUIがリロードされます。'
L.Profile_CopyCannotCopy					= '選択されたプロファイルをコピーできませんでした。もう一度試すかほかのプロファイルを選択してください。'
L.Profile_Delete							= 'プロファイルを選択して削除'
L.Profile_DeleteTip							= 'プロファイルを選択するとそのプロファイルの設定をデータベースから削除されます。もしそのキャラクターが後にログインし、アカウントプロファイルを使用していない場合は、新しくデフォルトの設定が生成されます。\n\nプロファイルは永久に削除されます！'
L.Profile_DeleteButton						= 'プロファイルを削除'
L.Profile_Guard								= 'プロファイルマネージャを有効にする'


if (GetCVar('language.2') == 'jp') then -- overwrite GetLocale for new language
    for k, v in pairs(Srendarr:GetLocale()) do
        if (not L[k]) then -- no translation for this string, use default
            L[k] = v
        end
    end

    function Srendarr:GetLocale() -- set new locale return
        return L
    end
end
