local Srendarr = _G['Srendarr']
local L = {}

------------------------------------------------------------------------------------------------------------------
-- German (de) - Thanks to ESOUI.com user Scootworks for the translations.
-- Indented or commented lines still require human translation and may not make sense!
------------------------------------------------------------------------------------------------------------------

L.Srendarr									= '|c67b1e9S|c4779ce\'rendarr|r'
L.Srendarr_Basic							= 'S\'rendarr'
L.Usage										= '|c67b1e9S|c4779ce\'rendarr|r - Verwendung: /srendarr lock|unlock um die Leisten zu Entsperren/Sperren.'
L.CastBar									= 'Zauberleiste'
L.Sound_DefaultProc 						= 'Srendarr Standard'

-- time format						
L.Time_Tenths								= '%.1fs'
L.Time_Seconds								= '%ds'
L.Time_Minutes								= '%dm'
L.Time_Hours								= '%dh'
L.Time_Days									= '%dd'

-- aura grouping
L.Group_Displayed_Here						= 'Angezeigte Leisten'
L.Group_Displayed_None						= 'keine'
L.Group_Player_Short						= 'Deine kurzen Buffs'
L.Group_Player_Long							= 'Deine langen Buffs'
L.Group_Player_Major						= 'Deine grösseren Buffs'
L.Group_Player_Minor						= 'Deine kleineren Buffs'
L.Group_Player_Toggled						= 'Deine umschaltbaren Buffs'
L.Group_Player_Ground						= 'Deine Bodeneffekte'
L.Group_Player_Enchant						= 'Deine Verzauberungsprocs'
L.Group_Player_Gear							= 'Deine Rüstungsprocs'
--L.Group_Player_Cooldowns					= 'Your Proc Cooldowns'
L.Group_Player_Passive						= 'Deine Passiven Effekte'
L.Group_Player_Debuff						= 'Deine Debuffs'
L.Group_Target_Buff							= 'Ziel Buffs'
L.Group_Target_Debuff						= 'Ziel Debuffs'

L.Group_Prominent							= 'Aura Whitelist 1'
L.Group_Prominent2							= 'Aura Whitelist 2'
L.Group_Debuffs								= 'Debuff Whitelist 1'
L.Group_Debuffs2							= 'Debuff Whitelist 2'
L.Group_Group								= 'Gruppenfenster'
L.Group_Raid								= 'Raidfenster'

-- whitelist & blacklist control
L.Prominent_AuraAddSuccess					= 'wurde zur Aura Whitelist 1 hinzugefügt.'
L.Prominent_AuraAddSuccess2					= 'wurde zur Aura Whitelist 2 hinzugefügt.'
L.Prominent_AuraAddFail 					= 'wurde nicht gefunden und konnte nicht hinzugefügt werden.'
L.Prominent_AuraAddFailByID					= 'Das ist keine gültige Effekt-ID! Die ID dieser Aura konnte nicht hinzugefügt werden.'
L.Prominent_AuraRemoved						= 'wurde aus der Aura Whitelist 1 entfernt.'
L.Prominent_AuraRemoved2					= 'wurde aus der Aura Whitelist 2 entfernt.'
L.Blacklist_AuraAddSuccess					= 'wurde zur Blacklist hinzugefügt und wird nicht länger dargestellt.'
L.Blacklist_AuraAddFail 					= 'wurde nicht gefunden und konnte nicht hinzugefügt werden.'
L.Blacklist_AuraAddFailByID					= 'Keine gültige Effekt-ID! Die ID dieser Aura konnte nicht der Blacklist hinzugefügt werden.'
L.Blacklist_AuraRemoved						= 'wurde aus der Blacklist entfernt.'
L.Group_AuraAddSuccess						= 'wurde zur Gruppen Aura Whitelist hinzugefügt.'
L.Group_AuraRemoved							= 'wurde aus der Gruppen Aura Whitelist entfernt.'
L.Debuff_AuraAddSuccess						= 'wurde zur Debuff Whitelist 1 hinzugefügt.'
L.Debuff_AuraAddSuccess2					= 'wurde zur Debuff Whitelist 2 hinzugefügt.'
L.Debuff_AuraRemoved						= 'wurde aus der Debuff Whitelist 1 entfernt.'
L.Debuff_AuraRemoved2						= 'wurde aus der Debuff Whitelist 2 entfernt.'

-- settings: base
L.Show_Example_Auras						= 'Beispiel Auren'
L.Show_Example_Castbar						= 'Beispiel Zauberleiste'

L.SampleAura_PlayerTimed					= 'Spieler Zeitlich'
L.SampleAura_PlayerToggled					= 'Spieler umschaltbare Buffs'
L.SampleAura_PlayerPassive					= 'Spieler Passive'
L.SampleAura_PlayerDebuff					= 'Spieler Debuff'
L.SampleAura_PlayerGround					= 'Spieler Bodenenffekte'
L.SampleAura_PlayerMajor					= 'Grösere Buffs'
L.SampleAura_PlayerMinor					= 'Kleinere Buffs'
L.SampleAura_TargetBuff						= 'Ziel Buff'
L.SampleAura_TargetDebuff					= 'Ziel Debuff'

L.TabButton1								= 'Allgemein'
L.TabButton2								= 'Filter'
L.TabButton3								= 'Zauberleiste'
L.TabButton4								= 'Leisten'
L.TabButton5								= 'Profile'

L.TabHeader1								= 'Allgemein Einstellungen'
L.TabHeader2								= 'Filter Einstellungen'
L.TabHeader3								= 'Zauberleisten Einstellungen'
L.TabHeader5								= 'Profil Einstellungen'
L.TabHeaderDisplay							= 'Leisten Einstellungen'

-- settings: generic
L.GenericSetting_ClickToViewAuras			= 'Klick = Auren anzeigen'
L.GenericSetting_NameFont					= 'Text Schrift'
L.GenericSetting_NameStyle					= 'Text Farbe & Aussehen'
L.GenericSetting_NameSize					= 'Text Grösse'
L.GenericSetting_TimerFont					= 'Zeit Schriftart'
L.GenericSetting_TimerStyle					= 'Zeit Schrift Farbe & Aussehen'
L.GenericSetting_TimerSize					= 'Zeit Grösse'
L.GenericSetting_BarWidth					= 'Leisten Breite'
L.GenericSetting_BarWidthTip				= 'Legt die Breite der Zeitleiste fest.\nMöglicherweise musst du anschliessend die Aura Gruppe verschieben.'


-- ----------------------------
-- SETTINGS: DROPDOWN ENTRIES
-- ----------------------------
L.DropGroup_1								= 'In Leiste [|cffd1001|r]'
L.DropGroup_2								= 'In Leiste [|cffd1002|r]'
L.DropGroup_3								= 'In Leiste [|cffd1003|r]'
L.DropGroup_4								= 'In Leiste [|cffd1004|r]'
L.DropGroup_5								= 'In Leiste [|cffd1005|r]'
L.DropGroup_6								= 'In Leiste [|cffd1006|r]'
L.DropGroup_7								= 'In Leiste [|cffd1007|r]'
L.DropGroup_8								= 'In Leiste [|cffd1008|r]'
L.DropGroup_9								= 'In Leiste [|cffd1009|r]'
L.DropGroup_10								= 'In Leiste [|cffd10010|r]'
L.DropGroup_None							= 'Nicht anzeigen'

L.DropStyle_Full							= 'komplett'
L.DropStyle_Icon							= 'nur Icon'
L.DropStyle_Mini							= 'nur Text & Dauer'

L.DropGrowth_Up								= 'Hoch'
L.DropGrowth_Down							= 'Runter'
L.DropGrowth_Left							= 'Links'
L.DropGrowth_Right							= 'Rechts'
L.DropGrowth_CenterLeft						= 'Zentriert (Links)'
L.DropGrowth_CenterRight					= 'Zentriert (Rechts)'

L.DropSort_NameAsc							= 'Name (auf)'
L.DropSort_TimeAsc							= 'Dauer (auf)'
L.DropSort_CastAsc							= 'Reihenfolge (auf)'
L.DropSort_NameDesc							= 'Name (ab)'
L.DropSort_TimeDesc							= 'Dauer (ab)'
L.DropSort_CastDesc							= 'Reihenfolge (ab)'

L.DropTimer_Above							= 'oberhalb Icon'
L.DropTimer_Below							= 'unterhalb Icon'
L.DropTimer_Over							= 'auf Icon'
L.DropTimer_Hidden							= 'versteckt'

L.DropAuraClassBuff							= 'Buff'
L.DropAuraClassDebuff						= 'Debuff'
L.DropAuraClassDefault						= 'kein Überschreiben'


-- ------------------------
-- SETTINGS: GENERAL
-- ------------------------
-- general (general options)
	L.General_GeneralOptions					= 'Allgemeine Optionen'
	L.General_GeneralOptionsDesc				= 'Verschiedene allgemeine Optionen, die das Verhalten des Addons kontrollieren.'
L.General_UnlockDesc						= 'Entsperren, um das Verschieben der verschiedenen Leisten mit der Maus zu aktivieren. Der Zurücksetzen-Knopf wird alle Fenster wieder auf die Standartposition zurücksetzen.'
L.General_UnlockLock						= 'Sperren'
L.General_UnlockUnlock						= 'Entsperren'
L.General_UnlockReset						= 'Zurücksetzen'
L.General_UnlockResetAgain					= 'Zurücksetzen bestätigen'
L.General_CombatOnly						= 'Nur im Kampf anzeigen'
L.General_CombatOnlyTip						= 'Wenn diese Einstellung aktiviert ist, werden die Leisten nur im Kampf angezeigt.'
L.HideOnDeadTargets							= 'Verstecke Auren bei Toten'
L.HideOnDeadTargetsTip						= 'Verstecke alle Auren bei Toten Zielen.'
	L.ShowSeconds								= 'Zeige verbleibende Sekunden'
	L.ShowSecondsTip							= 'Zeige die verbleibenden Sekunden neben Timern, die Minuten anzeigen. Timer, die Stunden anzeigen, sind davon nicht betroffen.'
L.General_ConsolidateEnabled				= 'Konsolidiere Multi-Auras'
L.General_ConsolidateEnabledTip				= 'Bestimmte Fähigkeiten (z.B. Wiederherstellen Aura vom Templer) haben mehrere Effekte. Diese Effekte werden meistens alle mit dem selben Symbol angezeigt. Diese Option konsolidiert die Effekte zu einer einzigen Aura.'
L.General_PassiveEffectsAsPassive			= 'Passive Auren als passive Effekte'
L.General_PassiveEffectsAsPassiveTip		= 'Legt fest, ob passive kleinere & grössere Buffs gruppiert oder verborgen sind anhand deiner \'Deine Passiven Effekte\' Einstellungen.\n\nFalls diese deaktiviert sind, werden alle kleinen & grossen Buffs separat gruppiert angezeigt, unabhängig ob diese passiv oder zeitlich gesteuert sind.'
L.General_AuraFadeout						= 'Buff/Debuff Ausblendezeit'
L.General_AuraFadeoutTip					= 'Die Ausblendzeit in Millisekunden. Beim Wert \'0\' blendet das Icon direkt bei Ablauf der Zeit aus.'
L.General_ShortThreshold					= 'Kurzer Buff Grenzwert'
L.General_ShortThresholdTip					= 'Alle Werte unter dieser Grenze werden zählen als \'kurze Buffs\', alle oberhalb dieser Grenze als \'lange Buffs\'.'
L.General_ProcEnableAnims					= 'Proc Animationen aktivieren'
L.General_ProcEnableAnimsTip				= 'Aktivieren um die Proc Animationen in der Aktionsleiste anzuzeigen. Proc Fähigkeiten sind:\n- Kristallfragemente (Zauberer)\n- Grimmiger Fokus und deren Morphs (Nachtklinge)\n- Flammenleine (Drachenritter)\n- tödlicher Umhang (Zwei Waffen)'
L.General_ProcEnableAnimsWarn				= 'Wenn du die originale Aktionsleiste ausgeblendet hast, wird die Animation auch nicht angezeigt.'
L.General_ProcPlaySound						= 'Ton bei Proc abspielen'
L.General_ProcPlaySoundTip					= 'Solange aktiviert, wird ein Ton abgespielt wenn eine Fähigkeit proct. Ansonsten ist der Ton bei Procs unterdrückt.'

-- general (display groups)
L.General_ControlHeader						= 'Buff/Debuff Anzeige Einstellungen'
L.General_ControlBaseTip					= 'Hier wird festgelegt, in welchem Anzeigefenster die Aura Gruppen angezeigt werden.'
L.General_ControlShortTip					= 'Diese Gruppe zeigt deine eigenen Effekte unterhalb des \'kurzer Buff Grenzwert\'.'
L.General_ControlLongTip 					= 'Diese Gruppe zeigt deine eigenen Effekte oberhalb des \'kurzer Buff Grenzwert\'.'
L.General_ControlMajorTip					= 'Diese Gruppe zeigt alle positive \'grossen Buffs\'. Negativ auswirkende Effekte werden in der negativen Effekte Gruppe angezeigt.'
L.General_ControlMinorTip					= 'Diese Gruppe zeigt alle positive \'kleinen Buffs\'. Negativ auswirkende Effekte werden in der negativen Effekte Gruppe angezeigt.'
L.General_ControlToggledTip					= 'Diese Gruppe zeigt deine umschaltbaren Effekte.'
L.General_ControlGroundTip					= 'Diese Gruppe zeigt alle Flächeneffekte die von dir benutzt wurden.'
L.General_ControlEnchantTip					= 'Diese Gruppe enthält alle Verzauberungseffekte, die auf dich selber aktiv sind (z.B. Härten, Berserker).'
L.General_ControlGearTip					= 'Diese Gruppe enthält alle Rüstungseffekte, die auf dich selber aktiv sind (z.B. Blutbrut).'
--L.General_ControlCooldownTip				= 'This Aura Group tracks the internal reuse cooldown of your Gear Procs.'
L.General_ControlPassiveTip					= 'Diese Gruppe zeigt alle passiven Effekte die gerade auf dich selbst wirken.'
L.General_ControlDebuffTip					= 'Diese Gruppe zeigt alle negativen Effekte die auf dich von Gegnern, Spieler oder der Umgebung gewirkt wurden.'
L.General_ControlTargetBuffTip				= 'Diese Gruppe zeigt alle positive Effekte von deinem Ziel, unabhängig von umschaltbaren, passiven oder aktiven Effekten.'
L.General_ControlTargetDebuffTip 			= 'Diese Gruppe zeigt alle negativen Effekte von deinem Ziel die du gemacht hast. In seltenen Fällen werden weitere negative Effekte angezeigt, die nicht von dir direkt sind.'
L.General_ControlProminentTip				= 'Diese Gruppe zeigt alle von dir gesetzten Effekte, die du in der \'Aura Whitelist\' Gruppe hinzugefügt hast.'
L.General_ControlProminentDebuffTip			= 'Diese Gruppe zeigt alle Ziel Debuff Effekte, die du in der \'Debuff Whitelist\' Gruppe hinzugefügt hast.'

-- general (debug)
L.General_DebugOptions						= 'Debug Einstellungen'
L.General_DebugOptionsDesc					= 'Eine Hilfe um fehlende oder falsche Auren aufzuspüren!'
L.General_DisplayAbilityID					= 'Effekt-ID der Auren anzeigen'
L.General_DisplayAbilityIDTip				= 'Zeigt die internen Effekt-ID\'s der Auren an. Das wird benötigt, um z.B. die Fähigkeiten der Blacklist oder der Whitelist hinzuzufügen.\nEs kann natürlich auch verwendet werden, um gewisse Auren dem AddOn Author zu melden.'
L.General_ShowCombatEvents					= 'Zeige Kampf Ereignisse'
L.General_ShowCombatEventsTip				= 'Wenn diese Einstellung aktiviert ist, werden alle Effekt-ID\'s & deren Namen im Chat angezeigt. Diese enthalten auch die Effekte, die der Gegner auf dich ausführt.\n\nUm eine Informations-Überflutung zu verhindern, wird eine Fähigkeit nur einmal angezeigt. Mit \'/reloadui\' oder \'/sdbclear\' kann man den Cache manuell leeren um die Effekt-ID\'s erneut anzeigen zu lassen.'
L.General_AllowManualDebug					= 'Erlaube manuellen Debug'
L.General_AllowManualDebugTip				= 'Mit dieser Einstellung kannst du mit /sdbadd XXXXXX oder /sdbremove XXXXXX einzelne Effekt-ID\'s dem Flutfilter hinzufügen/entfernen. Mit dem Befehl /sdbclear kannst du das zurückzusetzen .'
L.General_DisableSpamControl				= 'Deaktiviere Flutfilter'
L.General_DisableSpamControlTip				= 'Wenn diese Einstellung EIN ist, wird ein gleiches Ereignis immer wieder aufgelistet. Ansonsten wird es nur einmal angezeigt.'
L.General_VerboseDebug						= 'Zeige ausführlichen Debug'
L.General_VerboseDebugTip					= 'Zeige den gesamten Datenbaustein von EVENT_COMBAT_EVENT, inkl. Fähigkeitssymbol und dessen Effekt-ID. Das wird deinen Chat schnell ausfüllen!'
L.General_ShowNoNames						= 'Zeige namenslose Ereignisse'
L.General_ShowNoNamesTip					= 'Dieser Filter zeigt dir auch Ereignisse an, die keinen expliziten Namen haben (wird grundsätzlich nicht benötigt).'


-- ------------------------
-- SETTINGS: FILTERS
-- ------------------------
L.FilterHeader								= 'Filter Einstellungen'
L.Filter_Desc								= 'Hier kannst du verschiedene Einstellungen zu Filtern machen. Du kannst Auren zu Black-/Whitelists hinzufügen und diese in speziellen Leisten darstellen.'
L.Filter_RemoveSelected						= 'Aura Löschen'
L.Filter_ListAddWarn						= 'Um eine Aura hinzufügen zu können, wird das ganze Spiel nach der Fähigkeit durchsucht. Das kann zu einer kurzen Verzögerung, respektive Hängenbleiben des Spiels führen.'
L.FilterToggle_Desc             			= 'Das Aktivieren eines Filters verhindert die Anzeige dieser Kategorie.'

L.Filter_PlayerHeader						= 'Buff/Debuff Filter für Spieler'
L.Filter_TargetHeader						= 'Buff/Debuff Filter für Ziel'
L.Filter_OnlyPlayerDebuffs					= 'Nur Spieler Debuffs'
L.Filter_OnlyPlayerDebuffsTip				= 'Unterdrückt Auren von Zielen, die nicht vom Spieler selbst erstellt wurden.'

-- filters (blacklist auras)
L.Filter_BlacklistHeader  					= 'Buff/Debuff Blacklist'
L.Filter_BlacklistDesc						= 'Es können hier spezifische Auren zu einer Blacklist hinzugefügt werden. Diese werden in keinem Fenster mehr erscheinen! Hinweis: Diese Blacklist blockiert \'keine\' Buff Whitelist Auren!'
L.Filter_BlacklistAdd    					= 'Buff/Debuff zur Blacklist hinzufügen'
L.Filter_BlacklistAddTip  					= 'Eine Aura zu einer Blacklist hinzufügen, damit diese nicht mehr angezeigt werden. ID im Feld eingeben und Enter drücken, bis im Chatfenster eine Bestätigung erscheint.'
L.Filter_BlacklistList						= 'Aktuelle Blacklist Buffs/Debuffs:'
L.Filter_BlacklistListTip					= 'Eine Liste mit allen Auras in der Blacklist. Um eine Aura zu löschen, die entsprechende Aura anklicken und auf entfernen klicken.'

-- filters (prominent auras)
L.Filter_ProminentHeader					= 'Aura Whitelist'
L.Filter_ProminentDesc						= 'Auf dich selbst wirkende Effekte oder Bodeneffekte können zur \'Aura Whitelist\' Liste hinzugefügt werden, damit diese in einer extra Gruppe dargestellt werden.'
L.Filter_ProminentAdd						= 'Aura zur Whitelist hinzufügen'
L.Filter_ProminentAddTip					= 'Auf dich selbst wirkende Effekte oder Bodeneffekte mit Hilfe der Effekt-ID der Aura Whitelist Liste hinzufügen. ID im Feld eingeben und Enter drücken, bis im Chatfenster eine Bestätigung erscheint. Passive und umschaltbare Effekte werden ignoriert.'
L.Filter_ProminentList1						= 'Aktuelle Aura Whitelist 1'
L.Filter_ProminentList2						= 'Aktuelle Aura Whitelist 2'
L.Filter_ProminentListTip					= 'Eine Liste mit allen Auras die als spezial gekennzeichnet wurden. Um eine Aura zu löschen, die entsprechende Aura anklicken und auf entfernen klicken.'

-- filters (prominent debuffs)
L.Filter_DebuffHeader						= 'Debuff Whitelist'
L.Filter_DebuffDesc							= 'Debuffs können zur Debuff Whitelist hinzugefügt werden. Das ermöglicht die Nutzung von einem weiteren Fenster, um die kritischen Debuffs besser anzeigen zu lassen.'
L.Filter_DebuffAdd							= 'Debuff zur Whitelist hinzufügen'
L.Filter_DebuffAddTip						= 'INFO: Nicht Debuffs werden dabei nicht angezeigt. Nutze dafür bitte die Buff Whitelist.\n\nID im Feld eingeben und Enter drücken, bis im Chatfenster eine Bestätigung erscheint. Passive und umschaltbare Effekte werden ignoriert.'
L.Filter_DebuffList1						= 'Aktuelle Debuff Whitelist 1'
L.Filter_DebuffList2						= 'Aktuelle Debuff Whitelist 2'
L.Filter_DebuffListTip						= 'Eine Liste mit allen Auras in dieser Liste. Um eine Aura zu löschen, die entsprechende Aura anklicken und auf entfernen klicken.'
L.Filter_OnlyPlayerProminentDebuffs1		= 'Nur Spieler Debuffs von Whitelist 1'
L.Filter_OnlyPlayerProminentDebuffs2		= 'Nur Spieler Debuffs von Whitelist 2'
L.Filter_OnlyPlayerProminentDebuffsTip		= 'Unterdrückt Auren auf der Debuff Whitelist, die nicht vom Spieler selbst erstellt wurden, unabhängig von den Ziel Filter Optionen.'
L.Filter_DuplicateDebuffs					= 'Lassen Sie duplizieren Debuffs'
L.Filter_DuplicateDebuffsTip				= 'Wenn diese Funktion aktiviert, Ziel Debuffs auf den Debuff zugewiesen werden Prominente zeigen auch Rahmen in Standard Debuff den Rahmen (falls zugewiesen)'

-- filters (group frame auras)
L.Filter_GroupAuraHeader					= 'Gruppen Aura Filter'
L.Filter_GroupAuraDesc						= 'Diese Liste zeigt dir die Buff-Effekte beim Gruppen-/Raidfenster des jeweiligen Spielers an. Es können nur Buff-Effekte mit einer Dauer angezeigt werden.'
L.Filter_GroupAuraAdd						= 'Aura Whitelist'
L.Filter_GroupAuraAddTip					= 'Eine Aura zu einer Blacklist hinzufügen, damit diese nicht mehr angezeigt werden. ID im Feld eingeben und Enter drücken, bis im Chatfenster eine Bestätigung erscheint.'
L.Filter_GroupList							= 'Aktuelle Whitelist'
L.Filter_GroupListTip						= 'Eine Liste mit allen Auras im Gruppenfenster. Um eine Aura zu löschen, die entsprechende Aura anklicken und auf \'entferne von Blacklist\' klicken.'
L.Filter_GroupByDuration					= 'Nach Dauer ausblenden'
L.Filter_GroupByDurationTip					= 'Es werden nur Gruppen Buffs angezeigt, welche kürzer sind als dieser eingestellte Wert in Sekunden.'
L.Filter_GroupThreshold						= 'Zeitschwelle'
L.Filter_GroupWhitelistOff					= 'Als Blacklist benutzen'
L.Filter_GroupWhitelistOffTip				= 'Funktioniert die Whitelist zu einer Blacklist um. Es wird dir nun alle Auren im Gruppenfenster aufzeigen\'ausser\' die hier hinzugefügten.'

-- filters (unit options)
	L.Filter_ESOPlus							= 'Filter: ESO Plus'
	L.Filter_ESOPlusPlayerTip					= 'Legen Sie fest, ob die Anzeige des ESO Plus-Status bei Ihnen selbst verhindert werden soll.'
	L.Filter_ESOPlusTargetTip					= 'Legen Sie fest, ob die Anzeige des ESO Plus-Status auf Ihrem Ziel verhindert werden soll.'
L.Filter_Block								= 'Filter: Blocken'
L.Filter_BlockPlayerTip						= 'Deaktiviert deine Aura \'Blocken\' wenn der Filter EIN ist.'
L.Filter_BlockTargetTip						= 'Deaktiviert die Ziel Aura \'Blocken\' wenn der Filter EIN ist.'
L.Filter_MundusBoon							= 'Filter: Mundussteine'
L.Filter_MundusBoonPlayerTip				= 'Deaktiviert deine \'Mundussteine\' Aura/Auren wenn der Filter EIN ist.'
L.Filter_MundusBoonTargetTip				= 'Deaktiviert die Ziel \'Mundussteine\' Aura/Auren wenn der Filter EIN ist.'
L.Filter_Cyrodiil							= 'Filter: Cyrodiil Boni'
L.Filter_CyrodiilPlayerTip					= 'Deaktiviert deine \'Cyrodiil Auren\' wenn der Filter EIN ist.'
L.Filter_CyrodiilTargetTip					= 'Deaktiviert die Ziel \'Cyrodiil Auren\' wenn der Filter EIN ist.'
L.Filter_Disguise							= 'Filter: Verkleidungen'
L.Filter_DisguisePlayerTip					= 'Deaktiviert deine \'Verkleidungs\' Aura wenn der Filter EIN ist.'
L.Filter_DisguiseTargeTtip					= 'Deaktiviert die Ziel \'Verkleidungs\' Aura wenn der FIlter EIN ist.'
L.Filter_MajorEffects						= 'Filter: Grössere Buffs'
L.Filter_MajorEffectsTargetTip				= 'Deaktiviert die \'grossen Buffs\' des Ziels wenn der Filter EIN ist.'
L.Filter_MinorEffects						= 'Filter: Kleinere Buffs'
L.Filter_MinorEffectsTargetTip				= 'Deaktiviert die \'kleinen Buffs\' des Ziels wenn der Filter EIN ist.'
L.Filter_SoulSummons						= 'Filter: Abklingzeit Seelenbeschwörung'
L.Filter_SoulSummonsPlayerTip				= 'Deaktiviert deine \'Abklingzeit Seelenbeschwörung\' Aura wenn der Filter EIN ist.'
L.Filter_SoulSummonsTargetTip				= 'Deaktiviert die Ziel \'Abklingzeit Seelenbeschwörung\' Aura wenn der Filter EIN ist.'
L.Filter_VampLycan							= 'Filter: Vampir & Werwolf Verwandlung'
L.Filter_VampLycanPlayerTip					= 'Deaktiviert deine \'Vampir & Werwolf Verwandlung\' Aura wenn der Filter EIN ist.'
L.Filter_VampLycanTargetTip					= 'Deaktiviert die Ziel \'Vampir & Werwolf Verwandlung\' Aura wenn der Filter EIN ist.'
L.Filter_VampLycanBite						= 'Filter: Vampir & Werwolf Biss Abklingzeit'
L.Filter_VampLycanBitePlayerTip				= 'Deaktiviert deine \'Vampir & Werwolf Biss Abklingzeit\' Aura wenn der Filter EIN ist.'
L.Filter_VampLycanBiteTargetTip				= 'Deaktiviert die Ziel \'Vampir & Werwolf Biss Abklingzeit\' Aura wenn der Filter EIN ist.'


-- ------------------------
-- SETTINGS: CAST BAR
-- ------------------------
L.CastBar_Enable							= 'Aktiviere Zauber- & Kanalisierungs Leiste'
L.CastBar_EnableTip							= 'Wenn diese Leiste aktiviert ist, zeigt es den Fortschritt der Fähigkeit bevor diese ausgelöst wird.'
L.CastBar_Alpha								= 'Transparenz'
L.CastBar_AlphaTip							= 'Die Transparenz der Leiste solange diese aktiv ist.\nEin Wert von 100 = sichtbar, 0 = unsichtbar.'
L.CastBar_Scale								= 'Grösse'
L.CastBar_ScaleTip							= 'Ein Wert von 100 entspricht der Ursprungsgrösse in Prozent.'

-- cast bar (name)
L.CastBar_NameHeader						= 'Fähigkeit Text'
L.CastBar_NameShow							= 'Zeige Fähigkeitsnamen'

-- cast bar (timer)
L.CastBar_TimerHeader						= 'Zauberzeit Text'
L.CastBar_TimerShow							= 'Zeige Zauberzeit Text'

-- cast bar (bar)
L.CastBar_BarHeader							= 'Zauberzeit Leiste'
L.CastBar_BarReverse						= 'Countdown umkehren'
L.CastBar_BarReverseTip						= 'Die Richtung des Countdowns kann seitlich umgekehrt werden.'
L.CastBar_BarGloss							= 'Glänzende Leiste'
L.CastBar_BarGlossTip						= 'Legt fest, ob die Zeitleiste glänzend ist.'
L.CastBar_BarColor							= 'Leisten Farbe'
L.CastBar_BarColorTip						= 'Legt die Farbe der Zeitleiste fest. Die Farbe links definiert den Start (wenn es mit dem herunterzählen beginnt) und die zweite Farbe definiert das Ende (wenn der Buff ausläuft)'


-- ------------------------
-- SETTINGS: DISPLAY FRAMES
-- ------------------------
L.DisplayFrame_Alpha						= 'Fenster Transparenz'
L.DisplayFrame_AlphaTip						= 'Definiert die Transparenz des Fensters./nEin Wert von 100 = sichtbar, 0 = unsichtbar.'
L.DisplayFrame_Scale						= 'Fenster Skalierung'
L.DisplayFrame_ScaleTip						= 'Ein Wert von 100 entspricht dem Standard in Prozent.'

-- display frames (aura)
L.DisplayFrame_AuraHeader					= 'Buff/Debuff Anzeige'
L.DisplayFrame_Style						= 'Buff/Debuff Aussehen'
L.DisplayFrame_StyleTip						= 'Ändert den Stil wie die Auren angezeigt werden.\n\n|cffd100Komplett anzeigen|r - Zeigt den Fähigkeitsnamen, Symbol, Zeittext und Zeitleiste.\n\n|cffd100Nur Icon|r - Zeigt das Symbol und den Zeittext.\n\n|cffd100Nur Text & Timer|r - Zeit den Fähigkeitsname und eine kleinere Zeitleiste.'
L.DisplayFrame_AuraCooldown					= 'Zeit Animationen'
L.DisplayFrame_AuraCooldownTip				= 'Zeige grüne Zeitanimationen über den Auren an. Es dient dazu, die Auren besser hervorzuheben. Passe die Farben anhand den Einstellungen an.'
L.DisplayFrame_CooldownTimed				= 'Farbe: Zeitliche Buffs & Debuffs'
L.DisplayFrame_CooldownTimedTip				= 'Set the icon timer animation color for auras with a set duration. The left color choice determines the buff color and the right choice the debuff color.'
L.DisplayFrame_Growth						= 'Buff/Debuff Erweiterungsrichtung'
L.DisplayFrame_GrowthTip					= 'Zeigt die Richtung wo sich die Aura ausbreiten kann. Bei zentrierter Ausrichtung wächst diese beidseitig mit der gewünschten Sortierreihenfolge.\n\nDie Auren können nur nach oben und unten wachsen beim |cffd100Komplett anzeigen|r oder |cffd100Nur Text & Timer|r Stil.'
L.DisplayFrame_Padding						= 'Buff/Debuff Abstand'
L.DisplayFrame_PaddingTip					= 'Abstand zwischen den Auren definieren.'
L.DisplayFrame_Sort							= 'Buff/Debuff Reihenfolge'
L.DisplayFrame_SortTip						= 'Sortierreihenfolge der Auren festlegen. Falls nach der Dauer sortiert wird, werden die passiven oder die umschaltbaren Auren immer am Anfang angezeigt.'
L.DisplayFrame_Highlight					= 'Umschaltbare Buffs/Debuffs hervorheben'
L.DisplayFrame_HighlightTip					= 'Die umschaltbaren Auren werden beim Symbol hervorgehoben.\n\nDieses Hervorheben funktioniert nicht beim |cffd100Nur Text & Timer|r Stil.'
L.DisplayFrame_Tooltips						= 'Buff/Debuff Tooltips mit Zaubernamen'
L.DisplayFrame_TooltipsTip					= 'Wenn die Aura mit dem Mauszeiger überfahren wird, zeigt es weitere Informationen zur Fähigkeit an. Nur beim Stil |cffd100Nur Icon|r möglich.'
L.DisplayFrame_TooltipsWarn					= 'Die Tooltips müssen ausgeschalten werden, wenn man das Fenster verschieben will. Ansonsten wird das Fenster zum Verschieben geblockt.'
L.DisplayFrame_AuraClassOverride			= 'Aurafarben überschreiben'
L.DisplayFrame_AuraClassOverrideTip			= 'Alle zeitlichen Effekte in dieser Leiste (ausgenommen sind umschaltebare und passive Buffs) können einheitlich dargestellt werden. Unabhängig von Buff, Debuff oder Flächeneffekt.\n\nBeispiel: Debuff und Flächeneffekt teilen sich die selbe Leiste, haben aber unterschiedliche Darstellungen. Hiermit kann die Priorität definiert werden.'

-- display frames (group)
L.DisplayFrame_GRX							= 'Horizontaler Versatz'
L.DisplayFrame_GRXTip						= 'Korrigiere die Symbol Position vom Gruppen-/Raidfenster nach rechts und links.'
L.DisplayFrame_GRY							= 'Vertikaler Versatz'
L.DisplayFrame_GRYTip						= 'Korrigiere die Symbol Position vom Gruppen-/Raidfenster nach oben und unten.'

-- display frames (name)
L.DisplayFrame_NameHeader					= 'Fähigkeitenanzeige'

-- display frames (timer)
L.DisplayFrame_TimerHeader					= 'Zeittext'
L.DisplayFrame_TimerLocation				= 'Position Zeitanzeige'
L.DisplayFrame_TimerLocationTip				= 'Die Position der Zeitanzeige zum Symbol kann hier bestimmt werden. \'Versteckt\' deaktiviert den Zeittext für diese Gruppe.\n\nEs sind nur bestimmte Einstellungen möglich, abhängig vom ausgewählten Stil.'
L.DisplayFrame_TimerHMS						= 'Zeige Minuten für Timer > 1 Stunde'
L.DisplayFrame_TimerHMSTip					= 'Die Minuten werden bei Buffs über eine Stunde auch angezeigt. Alternativ steht: \'1h+\''

-- display frames (bar)
L.DisplayFrame_BarHeader					= 'Zeitleiste'
L.DisplayFrame_HideFullBar					= 'Verstecke die Zeitleisten'
L.DisplayFrame_HideFullBarTip				= 'Verstecke die Zeitleisten, sofern die Darstellung \'Komplett anzeigen\' ausgewählt ist. Somit ist nur der Auraname sichtbar.'
L.DisplayFrame_BarReverse					= 'Countdown Richtung umkehren'
L.DisplayFrame_BarReverseTip				= 'Die Richtung des Countdowns kann seitlich umgekehrt werden. Beim |cffd100Komplett anzeigen|r Stil wird das Aura Symbol auf der anderen Seite angezeigt.'
L.DisplayFrame_BarGloss						= 'Glänzende Leisten'
L.DisplayFrame_BarGlossTip					= 'Legt fest, ob die Zeitleiste glänzend ist. Standard ist EIN'
L.DisplayFrame_BarBuffTimed					= 'Farbe: zeitliche Buffs'
L.DisplayFrame_BarBuffTimedTip				= 'Legt die Farben der zeitlichen Buffs fest. Die Farbe links definiert den Start (wenn es mit dem herunterzählen beginnt) und die zweite Farbe definiert das Ende (wenn der Buff ausläuft)'
L.DisplayFrame_BarBuffPassive				= 'Farbe: passive Buffs'
L.DisplayFrame_BarBuffPassiveTip			= 'Legt die Farben der passiven Buffs fest. Die Farbe links definiert den Start (wenn es mit dem herunterzählen beginnt) und die zweite Farbe definiert das Ende (wenn der Buff ausläuft)'
L.DisplayFrame_BarDebuffTimed				= 'Farbe: zeitliche Debuffs'
L.DisplayFrame_BarDebuffTimedTip			= 'Legt die Farben der zeitlichen Debuffs fest. Die Farbe links definiert den Start (wenn es mit dem herunterzählen beginnt) und die zweite Farbe definiert das Ende (wenn der Buff ausläuft)'
L.DisplayFrame_BarDebuffPassive				= 'Farbe: passive Debuffs'
L.DisplayFrame_BarDebuffPassiveTip			= 'Legt die Farben der passiven Debuffs fest. Die Farbe links definiert den Start (wenn es mit dem herunterzählen beginnt) und die zweite Farbe definiert das Ende (wenn der Buff ausläuft)'
L.DisplayFrame_BarToggled					= 'Farbe: umschaltbare Auren'
L.DisplayFrame_BarToggledTip				= 'Legt die Farben der umschaltbaren Auren fest. Die Farbe links definiert den Start (wenn es mit dem herunterzählen beginnt) und die zweite Farbe definiert das Ende (wenn der Buff ausläuft)'


-- ------------------------
-- SETTINGS: PROFILES
-- ------------------------
L.Profile_Desc								= 'In diesem Bereich können Einstellungen bezüglich den Profilen vorgenommen werden.\n\nDamit man Profile accountweit nutzen kann (für alle Character die selben Einstellungen verwenden), bitte ganz am Schluss die \'Profilverwaltung aktivieren\' und danach \'Auf alle Charakter verwenden\' einschalten.'
L.Profile_UseGlobal							= 'Auf alle Charakter verwenden (accountweit)'
L.Profile_UseGlobalWarn						= 'Beim Umstellen von lokalen zu globalen Einstellungen wird das Interface neu geladen.'
L.Profile_Copy								= 'Profil zum Kopieren auswählen'
L.Profile_CopyTip							= 'Wähle ein Profil das zum aktuellen Charakter kopiert werden soll. Das aktive Profil wird entsprechend ersetzt oder neu als accountweite Einstellung gespeichert. Das aktuelle Profil wird \'unwiederruflich\' überschrieben!'
L.Profile_CopyButton						= 'Profil kopieren'
L.Profile_CopyButtonWarn					= 'Beim Kopieren eines Profils wird das Interface neu geladen.'
L.Profile_CopyCannotCopy					= 'Es ist nicht möglich das ausgewählte Profil zu kopieren. Versuche es erneut oder wähle ein anderes Profil.'
L.Profile_Delete							= 'Profil zum Löschen auswählen'
L.Profile_DeleteTip							= 'Wähle das zu löschende Profil aus. Wenn du dich später mit dem Charakter anmeldest und nicht das accountweite Profil ausgewählt hast, werden die ganzen Einstellung neu gesetzt.\n\nDas Löschen eines Profils kann nicht rückgängig gemacht werden!'
L.Profile_DeleteButton						= 'Profil Löschen'
L.Profile_Guard								= 'Profilverwaltung aktivieren'


if (GetCVar('language.2') == 'de') then -- overwrite GetLocale for new language
	for k, v in pairs(Srendarr:GetLocale()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function Srendarr:GetLocale() -- set new locale return
		return L
	end
end
