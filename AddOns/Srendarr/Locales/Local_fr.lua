local Srendarr = _G['Srendarr']
local L = {}

------------------------------------------------------------------------------------------------------------------
-- French (fr) - Thanks to ESOUI.com user Ayantir for the translations.
-- Indented or commented lines still require human translation and may not make sense!
------------------------------------------------------------------------------------------------------------------

L.Srendarr									= '|c67b1e9S|c4779ce\'rendarr|r'
L.Srendarr_Basic							= 'S\'rendarr'
L.Usage										= '|c67b1e9S|c4779ce\'rendarr|r - Usage : /srendarr lock/unlock : Verrouille/Déverrouille les fenêtres pour définir leur positionnement.'
L.CastBar									= 'Barre de cast'
L.Sound_DefaultProc							= 'Srendarr (Procs par défaut)'

-- time format						
L.Time_Tenths								= '%.1fs'
L.Time_Seconds								= '%ds'
L.Time_Minutes								= '%dm'
L.Time_Hours								= '%dh'
L.Time_Days									= '%dj'

-- aura grouping
L.Group_Displayed_Here						= 'Groupes affichés'
L.Group_Displayed_None						= 'Aucun'
L.Group_Player_Short						= 'Vos buffs courts'
L.Group_Player_Long							= 'Vos buffs longs'
L.Group_Player_Major						= 'Vos buffs "Majeurs"'
L.Group_Player_Minor						= 'Vos buffs "Mineurs"'
L.Group_Player_Toggled						= 'Vos buffs continus'
L.Group_Player_Ground						= 'Vos cibles au sol'
L.Group_Player_Enchant						= 'Vos Enchant Procs'
--L.Group_Player_Gear						= 'Your Gear Procs'
--L.Group_Player_Cooldowns					= 'Your Proc Cooldowns'
L.Group_Player_Passive						= 'Vos passifs'
L.Group_Player_Debuff						= 'Vos debuffs'
L.Group_Target_Buff							= 'Les buffs de la cible'
L.Group_Target_Debuff						= 'Les débuffs de la cible'

L.Group_Prominent							= 'Effets principaux groupe personnalisé 1'
L.Group_Prominent2							= 'Effets principaux groupe personnalisé 2'
--L.Group_Debuffs							= 'Debuff Whitelist 1'
--L.Group_Debuffs2							= 'Debuff Whitelist 2'
--L.Group_Group								= 'Group Frames'
--L.Group_Raid								= 'Raid Frames'

-- whitelist & blacklist control
L.Prominent_AuraAddSuccess					= 'a été ajouté à la liste des effets principaux 1.'
L.Prominent_AuraAddSuccess2					= 'a été ajouté à la liste des effets principaux 2.'
L.Prominent_AuraAddFail						= 'n\'a pas été trouvé et ne peut être ajouté.'
L.Prominent_AuraAddFailByID					= 'est pas un abilityID valide ou est pas l\'ID d\'une aura chronométré et ne pouvait pas être ajouté.'
L.Prominent_AuraRemoved						= 'a été supprimé des effets principaux 1.'
L.Prominent_AuraRemoved2					= 'a été supprimé des effets principaux 2.'
L.Blacklist_AuraAddSuccess					= 'a été ajouté à la liste noire et ne sera plus affiché.'
L.Blacklist_AuraAddFail						= 'n\'a pas été trouvé et ne peux être ajouté.'
L.Blacklist_AuraAddFailByID					= 'ne constitue pas une abilityID valide et n\'a pas pu être ajouté à la liste noire.'
L.Blacklist_AuraRemoved						= 'a été supprimé de la liste noire.'
--L.Group_AuraAddSuccess					= 'has been added to the Group Whitelist.'
--L.Group_AuraRemoved						= 'has been removed from the Group Whitelist.'
--L.Debuff_AuraAddSuccess					= 'has been added to Debuff Whitelist 1.'
--L.Debuff_AuraAddSuccess2					= 'has been added to Debuff Whitelist 2.'
--L.Debuff_AuraRemoved						= 'has been removed from Debuff Whitelist 1.'
--L.Debuff_AuraRemoved2						= 'has been removed from Debuff Whitelist 2.'

-- settings: base
L.Show_Example_Auras						= 'Ex. d\'effets'
L.Show_Example_Castbar						= 'Ex. de barre de cast'

L.SampleAura_PlayerTimed					= 'Effets temporaires'
L.SampleAura_PlayerToggled					= 'Effets continus'
L.SampleAura_PlayerPassive					= 'Passifs du joueur'
L.SampleAura_PlayerDebuff					= 'Débuffs du joueur'
L.SampleAura_PlayerGround					= 'Effet au sol'
L.SampleAura_PlayerMajor					= 'Effet "Majeur"'
L.SampleAura_PlayerMinor					= 'Effet "Mineur"'
L.SampleAura_TargetBuff						= 'Buff de la cible'
L.SampleAura_TargetDebuff					= 'Débuff de la cible'

L.TabButton1								= 'Général'
L.TabButton2								= 'Filtres'
L.TabButton3								= 'Barre de cast'
L.TabButton4								= 'Effets'
L.TabButton5								= 'Profils'

L.TabHeader1								= 'Paramètres généraux'
L.TabHeader2								= 'Paramètres de filtres'
L.TabHeader3								= 'Paramètres de la barre de cast'
L.TabHeader5								= 'Paramètres des profils'
L.TabHeaderDisplay							= 'Paramètres de la fenêtre : '

-- settings: generic
L.GenericSetting_ClickToViewAuras			= 'Cliquer pour voir les effets'
L.GenericSetting_NameFont					= 'Police du nom de la compétence'
L.GenericSetting_NameStyle					= 'Couleur & Style du nom de la compétence'
L.GenericSetting_NameSize					= 'Taille de la police du nom de la compétence'
L.GenericSetting_TimerFont					= 'Police du timer'
L.GenericSetting_TimerStyle					= 'Couleur & Style de la police du timer'
L.GenericSetting_TimerSize					= 'Taille de la police du timer'
L.GenericSetting_BarWidth					= 'Largeur de la barre'
L.GenericSetting_BarWidthTip				= 'Définissez la largeur de la barre de cast lorsqu\' elle est affichée.'


-- ----------------------------
-- SETTINGS: DROPDOWN ENTRIES
-- ----------------------------
L.DropGroup_1								= 'Dans la fenêtre [|cffd1001|r]'
L.DropGroup_2								= 'Dans la fenêtre [|cffd1002|r]'
L.DropGroup_3								= 'Dans la fenêtre [|cffd1003|r]'
L.DropGroup_4								= 'Dans la fenêtre [|cffd1004|r]'
L.DropGroup_5								= 'Dans la fenêtre [|cffd1005|r]'
L.DropGroup_6								= 'Dans la fenêtre [|cffd1006|r]'
L.DropGroup_7								= 'Dans la fenêtre [|cffd1007|r]'
L.DropGroup_8								= 'Dans la fenêtre [|cffd1008|r]'
L.DropGroup_9								= 'Dans la fenêtre [|cffd1009|r]'
L.DropGroup_10								= 'Dans la fenêtre [|cffd10010|r]'
L.DropGroup_None							= 'Ne pas afficher'

L.DropStyle_Full							= 'Affichage détaillé'
L.DropStyle_Icon							= 'Icône seulement'
L.DropStyle_Mini							= 'Minimal'

L.DropGrowth_Up								= 'Haut'
L.DropGrowth_Down							= 'Bas'
L.DropGrowth_Left							= 'Gauche'
L.DropGrowth_Right							= 'Droite'
L.DropGrowth_CenterLeft						= 'Centré (Gauche)'
L.DropGrowth_CenterRight					= 'Centré (Droite)'

L.DropSort_NameAsc							= 'Nom de la compétence (Asc)'
L.DropSort_TimeAsc							= 'Temps restant (Asc)'
L.DropSort_CastAsc							= 'Ordre de cast (Asc)'
L.DropSort_NameDesc							= 'Nom de la compétence (Desc)'
L.DropSort_TimeDesc							= 'Temps restant (Desc)'
L.DropSort_CastDesc							= 'Ordre de cast (Desc)'

L.DropTimer_Above							= 'Au dessus de l\'icône'
L.DropTimer_Below							= 'Sous l\'icône'
L.DropTimer_Over							= 'Par dessus l\'icone'
L.DropTimer_Hidden							= 'Masqué'

--L.DropAuraClassBuff						= 'Buff'
--L.DropAuraClassDebuff						= 'Debuff'
--L.DropAuraClassDefault					= 'No Override'


-- ------------------------
-- SETTINGS: GENERAL
-- ------------------------
-- general (general options)
	L.General_GeneralOptions					= 'Options générales'
	L.General_GeneralOptionsDesc				= 'Diverses options générales qui contrôlent le comportement de l\'addon.'
L.General_UnlockDesc						= 'Déverrouiller pour autoriser le positionnement à la souris des fenêtres d\'effets. La bouton Réinitialiser restaurera les fenêtres à leur emplacement par défaut.'
L.General_UnlockLock						= 'Verrouiller'
L.General_UnlockUnlock						= 'Déverrouiller'
L.General_UnlockReset						= 'Réinitialiser'
L.General_UnlockResetAgain					= 'Cliquez une nouvelle fois pour réinitialiser'
L.General_CombatOnly						= 'N\'afficher qu\'en combat'
L.General_CombatOnlyTip						= 'Sélectionnez si les fenêtres d\'aura ne doivent être affichées qu\'en combat.'
	L.HideOnDeadTargets							= 'Masquer les cibles mortes'
	L.HideOnDeadTargetsTip						= 'Définissez si vous souhaitez masquer toutes les auras sur des cibles mortes. (Cachera des choses potentiellement utiles comme Repentance use debuff.)'
	L.ShowSeconds								= 'Afficher les secondes restantes'
	L.ShowSecondsTip							= 'Affiche les secondes restantes à côté des minuteurs qui indiquent les minutes. Les minuteurs qui montrent les heures ne sont pas affectés par cela.'
L.General_ConsolidateEnabled				= 'Consolider Multi-Auras'
L.General_ConsolidateEnabledTip				= 'Certaines capacités comme Restauration Aura des Templiers ont de multiples effets de buff, et ceux-ci seront normalement tous les afficher dans la fenêtre de votre aura sélectionné avec la même icône, conduisant à l\'encombrement. Cette option regroupe celles-ci en une seule aura.'
--L.General_PassiveEffectsAsPassive			= 'Passive Major & Minor Buffs'
--L.General_PassiveEffectsAsPassiveTip		= 'Set whether Major & Minor Buffs that are passive (no duration) are grouped along with other passive auras on the player according to the \'Your Passives\' setting.\n\nIf not enabled, all Major & Minor Buffs will be grouped together regardless of whether they are timed or passive.'
L.General_AuraFadeout						= 'Délai de disparition des effets'
L.General_AuraFadeoutTip					= 'Définissez le temps donné pour la disparition d\'affichage d\'un effet à l\'écran. Un paramètre à 0 fera disparaitre l\'aura sans transition.\n\nLe timer est en millisecondes.'
L.General_ShortThreshold					= 'Seuil des buffs courts'
L.General_ShortThresholdTip					= 'Définissez le seuil en secondes de différence entre les buffs dits "Courts" et les buffs dits "Longs".'
L.General_ProcEnableAnims					= 'Créer une animation lors des procs'
L.General_ProcEnableAnimsTip				= 'Choisissez de créer une animation sur la barre d\'action pour les compétences qui ont proqué et possédant une action spéciale à réaliser. Les compétences possédant un proc sont :\n   Fragments de cristal (Sorc)\n   Déchaînement meurtrier & morphs (NB)\n   Langue de feu (DK)\n   Cape Mortelle (Deux armes)'
L.General_ProcEnableAnimsWarn				= 'Si vous utilisez un addon modifiant ou masquant la barre d\'action, les animations pourront ne pas être affichées.'
L.General_ProcPlaySound						= 'Jouer un son lors d\'un proc'
L.General_ProcPlaySoundTip					= 'Sélectionnez le son à jouer lors d\'un proc d\'une compétence. Sélectionner "None" ne jouera aucun son.'

-- general (display groups)
L.General_ControlHeader						= 'Gestion des effets - Groupes d\'affichage'
L.General_ControlBaseTip					= 'Définissez dans quel groupe de fenêtre afficher vos effets ou les masquer totalement.'
L.General_ControlShortTip					= 'Ce groupe contient tous les buffs lancés sur vous-même avec une durée inférieure au seuil des buffs courts.'
L.General_ControlLongTip 					= 'Ce groupe contient tous les buffs lancés sur vous-même avec une durée supérieure au seuil des buffs courts.'
L.General_ControlMajorTip					= 'Ce groupe contient tous les effets "majeurs" (ex: Intellect majeur) qui sont actifs sur vous même. Les effets majeurs négatifs (ex: Brèche majeure) sont slistés dans les débuffs'
L.General_ControlMinorTip					= 'Ce groupe contient tous les effets "mineurs" (ex: Dynamisation majeure) qui sont actifs sur vous même. Les effets mineurs négatifs (ex: Profanation mineure) sont slistés dans les débuffs'
L.General_ControlToggledTip					= 'Ce groupe contient tous les buffs continus (sans durée définie) qui sont actifs sur vous même.'
L.General_ControlGroundTip					= 'Ce groupe contient tous les effets au sol que vous avez lancé.'
L.General_ControlEnchantTip					= 'Ce groupe Aura contient tous les effets Enchant qui sont actives sur vous-même (par exemple. Hardening, Berserker).'
--L.General_ControlGearTip					= 'This Aura Group contains all normally invisible Gear Procs that are active on yourself (eg. Bloodspawn).'
--L.General_ControlCooldownTip				= 'This Aura Group tracks the internal reuse cooldown of your Gear Procs.'
L.General_ControlPassiveTip					= 'Ce groupe contient tous les effets passifs qui sont actifs sur vous même.'
L.General_ControlDebuffTip					= 'Ce groupe contient tous les effets négatifs qui sont actifs sur vous même.'
L.General_ControlTargetBuffTip				= 'Ce groupe contient tous les effets positifs appliqués à votre cible.'
L.General_ControlTargetDebuffTip 			= 'Ce groupe contient tous les effets négatifs appliqués à votre cible. En raisons de limitation intrinsèques au jeu, seuls vos débuffs apparaitront ici à de très rares exceptions près'
L.General_ControlProminentTip				= 'Ce groupe contient tous les effets que vous avez défini comme principaux.'
--L.General_ControlProminentDebuffTip		= 'This special Aura Group contains target debuffs whitelisted to display here instead of their original group.'

-- general (debug)
L.General_DebugOptions						= 'Options de débogage'
L.General_DebugOptionsDesc					= 'Aide à traquer Auras manquantes ou incorrectes!'
--L.General_DisplayAbilityID				= 'Enable Display Of Aura\'s AbilityID'
--L.General_DisplayAbilityIDTip				= 'Set whether to display the internal abilityID of all auras. This can be used to find the exact ID of auras you may want to Blacklist from display or add to the Aura Whitelist display group.\n\nThis option can also be used to assist in fixing inaccurate aura display by reporting the errant ID\'s to the addon author.'
L.General_ShowCombatEvents					= 'Voir Combat Events'
L.General_ShowCombatEventsTip				= 'Lorsqu\'elle est activée, l\'AbilityID et nom de tous les effets (buffs et debuffs) gagnés ou causés par le joueur va montrer dans le chat, suivi par des informations sur la source et la cible.\n\nPour éviter le chat des inondations et de faciliter l\'examen, chaque capacité n\'affichera une fois jusqu\'à ce rechargement. Cependant, vous pouvez taper /sdbclear à tout moment pour réinitialiser manuellement le cache.'
L.General_AllowManualDebug					= 'Autoriser Manuel Debug Modifier'
L.General_AllowManualDebugTip				= 'Lorsqu\'elle est activée, vous pouvez taper /sdbadd XXXXXX ou /sdbremove XXXXXX pour ajouter/supprimer un seul ID du filtre d\'inondation. Taper /sdbclear sera toujours réinitialiser le filtre.'
L.General_DisableSpamControl				= 'Désactiver le contrôle des inondations'
L.General_DisableSpamControlTip				= 'Lorsqu\'il est activé le filtre d\'événement de combat va imprimer le même événement chaque fois qu\'il se produit sans avoir à taper /sdbclear ou recharger pour effacer la base de données.'
--L.General_VerboseDebug					= 'Show Verbose Debug'
--L.General_VerboseDebugTip					= 'Show the entire data block received from EVENT_COMBAT_EVENT and the ability icon path for every ID that passes the above filters in a (mostly) human readable format (this will quickly fill your chat log).'
L.General_ShowNoNames						= 'Afficher les événements Nameless'
L.General_ShowNoNamesTip					= 'Lorsqu\'il est activé le filtre d\'événement de combat montre l\'événement de même quand ils ont pas de nom ID de texte.'


-- ------------------------
-- SETTINGS: FILTERS
-- ------------------------
--L.FilterHeader							= 'Filter Lists and Toggles'
--L.Filter_Desc								= 'Here you can blacklist auras, whitelist buffs or debuffs to appear as prominent and assign them to a custom window, or toggle filters for showing or hiding different types of effects.'
--L.Filter_RemoveSelected					= 'Remove Selected'
L.Filter_ListAddWarn						= 'Ajouter un effet par son nom requiert de scanner toutes les compétences existantes. Cette opération peut ralentir votre jeu quelques instants le temps de l\'opération.'
L.FilterToggle_Desc							= 'Activer un filtre masquera l\'affichage de l\'effet à l\'écran.'

L.Filter_PlayerHeader						= 'Filtre d\'effets pour vous'
L.Filter_TargetHeader						= 'Filtres d\'effets pour la cible'
--L.Filter_OnlyPlayerDebuffs				= 'Only Player Debuffs'
--L.Filter_OnlyPlayerDebuffsTip				= 'Prevent the display of debuff auras on the target that were not created by the player.'

-- filters (blacklist auras)
L.Filter_BlacklistHeader					= 'Blacklist des effets'
--L.Filter_BlacklistDesc					= 'Specific auras can be Blacklisted here to never appear in any aura tracking window.'
L.Filter_BlacklistAdd						= 'Ajouter un effet à blacklister'
L.Filter_BlacklistAddTip					= 'L\'effet que vous souhaitez blacklister doit être écrit exactement tel qu\'il apparait en jeu. Validez par Entrée pour ajouter l\'effet à la liste des effets blacklistés.'
L.Filter_BlacklistList						= 'Effets actuellement blacklistées'
L.Filter_BlacklistListTip					= 'Liste de tous les effets actuellement blacklistés. Pour supprimer un effet de la blacklis, sélectionnez le et cliquez sur le bouton Supprimer de la liste.'

-- filters (prominent auras)
L.Filter_ProminentHeader					= 'Effets principaux'
L.Filter_ProminentDesc						= 'Les buffs sur vous-même ou les effets au sol peuvent être définis comme principaux. Ils seront affichés dans une fenêtre distincte pour une gestion plus efficace.'
L.Filter_ProminentAdd						= 'Ajouter un buff principal'
L.Filter_ProminentAddTip					= 'Le buff ou l\'effet au sol que vous souhaitez définir comme principal doit être écrit exactement tel qu\'il apparait en jeu, Validez par Entrée pour ajouter l\'effet à la liste des effets principaux et veuillez noter que seuls les effets avec une durée peuvent être définis, les passifs et les compétences continues seront ignorées.'
--L.Filter_ProminentList1					= 'Current Whitelist 1 Auras'
--L.Filter_ProminentList2					= 'Current Whitelist 2 Auras'
L.Filter_ProminentListTip					= 'Liste de tous les effets définis comme principaux. Pour supprimer un effet, sélectionnez le dans la liste et cliquez sur le bouton au dessous.'

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
	L.Filter_ESOPlus							= 'Filtre ESO Plus'
	L.Filter_ESOPlusPlayerTip					= 'Définissez s\'il faut empêcher l\'affichage de l\'état ESO Plus sur vous-même.'
	L.Filter_ESOPlusTargetTip					= 'Définissez s\'il faut empêcher l\'affichage de l\'état ESO Plus sur votre cible.'
L.Filter_Block								= 'Filtrer le blocage'
L.Filter_BlockPlayerTip						= 'Choisissez de masquer l\'affichage du buff de blocage lorsque vous bloquez.'
L.Filter_BlockTargetTip						= 'Choisissez de masquer l\'affichage du buff de blocage lorsque votre cible bloque.'
L.Filter_MundusBoon							= 'Filtrer les pierres de Mundus'
L.Filter_MundusBoonPlayerTip				= 'Choisissez de masquer l\'affichage du bonus de la pierre de Mundus appliqué à vous-même.'
L.Filter_MundusBoonTargetTip				= 'Choisissez de masquer l\'affichagedu bonus de la pierre de Mundus appliqué à votre cible.'
L.Filter_Cyrodiil							= 'Filtrer les bonus de Cyrodiil'
L.Filter_CyrodiilPlayerTip					= 'Choisissez de masquer l\'affichage des buffs AvA de Cyrodiil appliqués à vous-même.'
L.Filter_CyrodiilTargetTip					= 'Choisissez de masquer l\'affichage des buffs AvA de Cyrodiil appliqués à votre cible.'
L.Filter_Disguise							= 'Filtrer les déguisements'
L.Filter_DisguisePlayerTip					= 'Choisissez de masquer l\'affichage du buff de déguisement appliqué à vous-même.'
L.Filter_DisguiseTargeTtip					= 'Choisissez de masquer l\'affichage du buff de déguisement appliqué à votre cible.'
L.Filter_MajorEffects						= 'Filtrer les effets majeurs'
L.Filter_MajorEffectsTargetTip				= 'Choisissez de masquer les effets "Majeurs" (ex. Prophétie Majeure, Brutalité Majeure) appliqué à votre cible.'
L.Filter_MinorEffects						= 'Filtrer les effets mineurs'
L.Filter_MinorEffectsTargetTip				= 'Choisissez de masquer les effets "Majeurs" (ex. Sorcellerie mineure, Evitement mineur) appliqué à votre cible.'
L.Filter_SoulSummons						= 'Filtrer le timer du rez gratuit'
L.Filter_SoulSummonsPlayerTip				= 'Choisissez de masquer l\'affichage du timer de rez gratuit de la ligne Magie des Ames appliqué à vous-même.'
L.Filter_SoulSummonsTargetTip				= 'Choisissez de masquer l\'affichage du timer de rez gratuit de la ligne Magie des Ames appliqué à votre cible.'
L.Filter_VampLycan							= 'Filtrer les buffs Vampire & Loup-Garou'
L.Filter_VampLycanPlayerTip					= 'Choisissez de masquer l\'affichage des buffs de vampirisme et de lycanthropie appliqué à vous-même.'
L.Filter_VampLycanTargetTip					= 'Choisissez de masquer l\'affichage des buffs de vampirisme et de lycanthropie appliqué à votre cible.'
L.Filter_VampLycanBite						= 'Filtrer le timer de morsure Vampire & Loup-Garou'
L.Filter_VampLycanBitePlayerTip				= 'Choisissez de masquer l\'affichage des buffs de morsure vampire et lycanthropique appliqué à vous-même.'
L.Filter_VampLycanBiteTargetTip				= 'Choisissez de masquer l\'affichage des buffs de morsure vampire et lycanthropique appliqué à votre cible.'


-- ------------------------
-- SETTINGS: CAST BAR
-- ------------------------
L.CastBar_Enable							= 'Activer la barre de cast & de canalisation'
L.CastBar_EnableTip							= 'Sélectionnez si vous voulez activer une barre de cast déplaçable pour afficher les temps d\'incantation ou de canalisation de vos compétences.'
L.CastBar_Alpha								= 'Opacité'
L.CastBar_AlphaTip							= 'Définissez la transparence de la barre de cast lorsqu\'elle est visible. Un paramètre à 100 rends la fenêtre totalement opaque.'
L.CastBar_Scale								= 'Echelle'
L.CastBar_ScaleTip							= 'Définissez la taille de la barre de cast en pourcentage'

-- cast bar (name)
L.CastBar_NameHeader						= 'Nom de la compétence castée'
L.CastBar_NameShow							= 'Afficher le nom de la compétence castée'

-- cast bar (timer)
L.CastBar_TimerHeader						= 'Timer de la barre de cast'
L.CastBar_TimerShow							= 'Afficher le timer de la compétence castée'

-- cast bar (bar)
L.CastBar_BarHeader							= 'Barre de timer'
L.CastBar_BarReverse						= 'Inverser les directions du timer'
L.CastBar_BarReverseTip						= 'Définissez si vous souhaitez inverser le timer de la barre de cast.'
L.CastBar_BarGloss							= 'Activer la brillance'
L.CastBar_BarGlossTip						= 'Définissez si vous souhaitez que la barre du timer possède une brillance améliorée'
L.CastBar_BarColor							= 'Couleur de la barre'
L.CastBar_BarColorTip						= 'Définissez les couleurs de la barre de cast. La première couleur est la couleur primaire en début de cast, la seconde sera celle affichée à la fin du timer.'


-- ------------------------
-- SETTINGS: DISPLAY FRAMES
-- ------------------------
L.DisplayFrame_Alpha						= 'Transparence de la fenêtre'
L.DisplayFrame_AlphaTip						= 'Définissez la transparence de la fenêtre des effets lorsqu\'elle est visible. Un paramètre à 100 rends la fenêtre totalement opaque.'
L.DisplayFrame_Scale						= 'Echelle de la fenêtre'
L.DisplayFrame_ScaleTip						= 'Définissez la taille de la fenêtre des effets en pourcentage.'

-- display frames (aura)
L.DisplayFrame_AuraHeader					= 'Affichage'
L.DisplayFrame_Style						= 'Style'
L.DisplayFrame_StyleTip						= 'Définissez le style qui sera appliqué à cette fenêtre d\'effets.\n\n|cffd100Affichage détaillé|r - Affiche le nom de la compétence, son icône, la barre de timer et le texte associé.\n\n|cffd100Icône seulement|r - Affiche l\'icône de la compétence et le texte du timer seulement, ce style permet plus d\'options pour le sens de l\'empilage du temps des effets.\n\n|cffd100Minimal|r - Affiche le nom de la compétence et une barre de timer plus petite.'
--L.DisplayFrame_AuraCooldown				= 'Show Timer Animation'
--L.DisplayFrame_AuraCooldownTip			= 'Display a timer animation around aura icons. This also makes auras easier to see than the old display mode. Customize using the color settings below.'
--L.DisplayFrame_CooldownTimed				= 'Color: Timed Buffs & Debuffs'
--L.DisplayFrame_CooldownTimedTip			= 'Set the icon timer animation color for auras with a set duration.\n\nLEFT = BUFFS\nRIGHT = DEBUFFS.'
L.DisplayFrame_Growth						= 'Sens de l\'empilage du temps des effets'
L.DisplayFrame_GrowthTip					= 'Définissez dans quel sens les nouveaux effets doivent s\'empiler depuis le point d\'origine. Pour les paramètres "centrés", les effets iront dans le sens précisé dans la liste.\n\nLes effets ne peuvent s\'empiler que lorsqu\'ils sont affichés en mode |cffd100Détaillé|r or |cffd100Minimal|r styles.'
L.DisplayFrame_Padding						= 'Espacement entre les piles d\'effets'
L.DisplayFrame_PaddingTip					= 'Définissez l\'espacement entre chaque effet.'
L.DisplayFrame_Sort							= 'Ordre de tri des effets'
L.DisplayFrame_SortTip						= 'Définissez comment les effets sont triés. Soit par ordre alphabétique, soit par durée restante ou dans l\'ordre où ils ont atés castés.\n\nLorsque vous triez par durée, tous les passifs et effets continus seront triés par nom et seront affichés en début ou en fin de pile selon l\'ordre de tri, avec les compétences temporaires listées ensuite ou avant.'
L.DisplayFrame_Highlight					= 'Mise en surbrillance des icones d\'effet continu'
L.DisplayFrame_HighlightTip					= 'Définir si les effets continus doivent être mis en surbrillance pour mieux les distinguer des effets passifs.\n\nNon disponible dans le mode |cffd100Minimal|r.'
--L.DisplayFrame_Tooltips					= 'Enable Aura Name Tooltips'
--L.DisplayFrame_TooltipsTip				= 'Set whether to allow mouseover tooltip display for an aura\'s name when in the |cffd100Icon Only|r style.'
--L.DisplayFrame_TooltipsWarn				= 'Tooltips must be temporarily disabled for movement of the Display Window, or the tooltips will block movement.'
--L.DisplayFrame_AuraClassOverride			= 'Aura Class Override'
--L.DisplayFrame_AuraClassOverrideTip		= 'Allows you to make Srendarr treat all timed auras (toggles and passives ignored) in this bar as either buffs or debuffs, regardless of their actual class.\n\nUseful when adding both debuffs and AOE to a window to make both use the same bar and icon animation colors.'

-- display frames (group)
--L.DisplayFrame_GRX						= 'Horizontal Offset'
--L.DisplayFrame_GRXTip						= 'Adjust the position of the group/raid frame buff icons left and right.'
--L.DisplayFrame_GRY						= 'Vertical Offset'
--L.DisplayFrame_GRYTip						= 'Adjust the position of the group/raid frame buff icons up and down.'

-- display frames (name)
L.DisplayFrame_NameHeader					= 'Nom de la compétence'

-- display frames (timer)
L.DisplayFrame_TimerHeader					= 'Texte du Timer'
L.DisplayFrame_TimerLocation				= 'Emplacement du texte du timer'
L.DisplayFrame_TimerLocationTip				= 'Définir la position des timers pour chaque effet par rapport à son icone.'
L.DisplayFrame_TimerHMS						= 'Afficher Minutes pour les minuteries > 1 heure'
L.DisplayFrame_TimerHMSTip					= 'Définissez si vous souhaitez afficher également minutes lorsque une minuterie est supérieure à 1 heure.'

-- display frames (bar)
L.DisplayFrame_BarHeader					= 'Barre du timer'
--L.DisplayFrame_HideFullBar				= 'Hide Timer Bar'
--L.DisplayFrame_HideFullBarTip				= 'Hide the bar completely and only display the aura name text next to the icon when in full display mode.'
L.DisplayFrame_BarReverse					= 'Inverser les directions du timer'
L.DisplayFrame_BarReverseTip				= 'Définissez si vous souhaitez inverser le timer de l\'effet. Dans le mdoe |cffd100Détaillé|r cela inversera également la position de l\'icône.'
L.DisplayFrame_BarGloss						= 'Activer la brillance'
L.DisplayFrame_BarGlossTip					= 'Définissez si vous souhaitez que la barre du timer possède une brillance améliorée.'
L.DisplayFrame_BarBuffTimed					= 'Couleur: Effets temporaires'
L.DisplayFrame_BarBuffTimedTip				= 'Définir les couleurs des effets temporaires. La première couleur est la couleur primaire en début d\'effet, la seconde sera celle affichée à la fin du timer.'
L.DisplayFrame_BarBuffPassive				= 'Couleur: Effets passives'
L.DisplayFrame_BarBuffPassiveTip			= 'Définir les couleurs des effets temporaires. La première couleur est la couleur primaire en début de barre, la seconde sera celle affichée à la fin de la barre.'
--L.DisplayFrame_BarDebuffTimed				= 'Color: Timed Debuffs'
--L.DisplayFrame_BarDebuffTimedTip			= 'Set the timer bar colors for debuff auras with a set duration. The left color choice determines the start of the bar (when it begins counting down) and the second the finish of the bar (when it has almost expired).'
--L.DisplayFrame_BarDebuffPassive			= 'Color: Passive Debuffs'
--L.DisplayFrame_BarDebuffPassiveTip		= 'Set the timer bar colors for passive debuff auras with no set duration. The left color choice determines the start of the bar (the furthest side from the icon) and the second the finish of the bar (nearest the icon).'
L.DisplayFrame_BarToggled					= 'Couleur: Effets continus'
L.DisplayFrame_BarToggledTip				= 'Définir les couleurs des effets temporaires. La première couleur est la couleur primaire en début de barre, la seconde sera celle affichée à la fin de la barre.'


-- ------------------------
-- SETTINGS: PROFILES
-- ------------------------
L.Profile_Desc								= 'Les profils de préférences peuvent être gérés ici vous permettant de sélectionner entre une configuration par compte ou par personnage. Vous devez d\'abord activer la gestion des profils pour modifier les valeurs ci-dessous.'
L.Profile_UseGlobal							= 'Utiliser une configuration par compte'
L.Profile_UseGlobalWarn						= 'Switcher entre la configuration par personnage et par compte rechargera votre UI.'
L.Profile_Copy								= 'Sélectionnez un profil à copier'
L.Profile_CopyTip							= 'Select a profile to copy its settings to the currently actrive profile. The active profile will be for either the logged in character or the account wide profile if enabled. The existing profile settings will be permanently overwritten.\n\nThis cannot be undone!'
L.Profile_CopyButton						= 'Copier le profil'
L.Profile_CopyButtonWarn					= 'Copier un profil rechargera votre UI.'
L.Profile_CopyCannotCopy					= 'Impossible de copier le profil sélectionné. Veuillez réessayer ou sélectionner un autre profil.'
L.Profile_Delete							= 'Sélectionnez un profil à supprimer'
L.Profile_DeleteTip							= 'Sélectionnez un profil à supprimer de la base des paramètres. Si le personnage concerné est reconnecté par la suite, et que vous n\'utilisez pas une configuration par compte, celui-ci héritera de la configuration par défaut'
L.Profile_DeleteButton						= 'Supprimer le profil'
L.Profile_Guard								= 'Activer la gestion des profils'


if (GetCVar('language.2') == 'fr') then -- overwrite GetLocale for new language
    for k, v in pairs(Srendarr:GetLocale()) do
        if (not L[k]) then -- no translation for this string, use default
            L[k] = v
        end
    end

    function Srendarr:GetLocale() -- set new locale return
        return L
    end
end
