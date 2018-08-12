

-- If you are looking to translate this to something else, and run into problems, please contact Dolgubon on ESOUI.
local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

function WritCreater.langWritNames() --Exact!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "Заказ",
	[CRAFTING_TYPE_ENCHANTING] = "зачаровател",
	[CRAFTING_TYPE_BLACKSMITHING] = "кузнец",
	[CRAFTING_TYPE_CLOTHIER] = "портн",
	[CRAFTING_TYPE_PROVISIONING] = "снабжен",
	[CRAFTING_TYPE_WOODWORKING] = "столяр",
	[CRAFTING_TYPE_ALCHEMY] = "алхимик",
	}
	return names
end

function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "искусн",
	["M1"] 							= "мастерски",
	[CRAFTING_TYPE_ALCHEMY]			= "варево",
	[CRAFTING_TYPE_ENCHANTING]		= "глиф",
	[CRAFTING_TYPE_PROVISIONING]	= "пир",
	["plate"]						= "латы",
	["tailoring"]					= "шитье",
	["leatherwear"]					= "изделия из кожи",
	["weapon"]						= "оружие",
	["shield"]						= "щит",
	}
return names

end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Положить предметы в ящик",
	["sign"] = "Подписать декларацию",
	["masterPlace"] = "Я закончил",
	["masterSign"] = "<Закончить работу.>",
	["masterStart"] = "<Принять заказ.>",
	["Rolis Hlaalu"] = "Ролис Хлаалу",
	}
	return strings
end


function WritCreater.languageInfo() --exact!!!

local craftInfo = 
	{
		[ CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "robe",
				[2] = "jerkin",
				[3] = "shoes",
				[4] = "gloves",
				[5] = "hat",
				[6] = "breeches",
				[7] = "epaulet",
				[8] = "sash",
				[9] = "jack",
				[10]= "boots",
				[11]= "bracers",
				[12]= "helmet",
				[13]= "guards",
				[14]= "cops",
				[15]= "belt",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "Homespun", --lvtier one of mats
				[2] = "Linen",	--l
				[3] = "Cotton",
				[4] = "Spidersilk",
				[5] = "Ebonthread",
				[6] = "Kresh",
				[7] = "Ironthread",
				[8] = "Silverweave",
				[9] = "Shadowspun",
				[10]= "Ancestor",
				[11]= "Rawhide",
				[12]= "Hide",
				[13]= "Leather",
				[14]= "Full-Leather",
				[15]= "Fell",
				[16]= "Brigandine",
				[17]= "Ironhide",
				[18]= "Superb",
				[19]= "Shadowhide",
				[20]= "Rubedo",
			},

		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "axe",
				[2] = "mace",
				[3] = "sword",
				[4] = "battle",
				[5] = "maul",
				[6] = "greatsword",
				[7] = "dagger",
				[8] = "cuirass",
				[9] = "sabatons",
				[10] = "gauntlets",
				[11] = "helm",
				[12] = "greaves",
				[13] = "pauldron",
				[14] = "girdle",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "Iron",
				[2] = "Steel",
				[3] = "Orichalc",
				[4] = "Dwarven",
				[5] = "Ebon",
				[6] = "Calcinium",
				[7] = "Galatite",
				[8] = "Quicksilver",
				[9] = "Voidsteel",
				[10]= "Rubedite",
			},

		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "bow",
				[3] = "inferno",
				[4] = "Ice",
				[5] = "lightning",
				[6] = "restoration",
				[2] = "shield",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "Maple",
				[2] = "Oak",
				[3] = "Beech",
				[4] = "Hickory",
				[5] = "Yew",
				[6] = "Birch",
				[7] = "Ash",
				[8] = "Mahogany",
				[9] = "Nightwood",
				[10] = "Ruby",
			},

		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{ --{String Identifier, ItemId, positive or negative}
				{"disease", 45841,2},
				{"foulness", 45841,1},
				{"absorb stamina", 45833,2},
				{"absorb magicka", 45832,2},
				{"absorb health", 45831,2},
				{"frost resist",45839,2},
				{"frost",45839,1},
				{"feat", 45836,2},
				{"stamina recovery", 45836,1},
				{"hardening", 45842,1},
				{"crushing", 45842,2},
				{"onslaught", 68342,2},
				{"defense", 68342,1},
				{"shielding",45849,2},
				{"bashing",45849,1},
				{"poison resist",45837,2},
				{"poison",45837,1},
				{"spell harm",45848,2},
				{"magical",45848,1},
				{"magicka recovery", 45835,1},
				{"spell cost", 45835,2},
				{"shock resist",45840,2},
				{"shock",45840,1},
				{"health recovery",45834,1},
				{"decrease health",45834,2},
				{"weakening",45843,2},
				{"weapon",45843,1},
				{"boost",45846,1},
				{"speed",45846,2},
				{"flame resist",45838,2},
				{"flame",45838,1},
				{"decrease physical", 45847,2},
				{"increase physical", 45847,1},
				{"stamina",45833,1},
				{"health",45831,1},
				{"magicka",45832,1}
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				[1] = {"trifling", 45855},
				[2] = {"inferior",45856},
				[3] = {"petty",45857},
				[4] = {"slight",45806},
				[5] = {"minor",45807},
				[6] = {"lesser",45808},
				[7] = {"moderate",45809},
				[8] = {"average",45810},
				[9] = {"strong",45811},
				[10]= {"major",45812},
				[11]= {"greater",45813},
				[12]= {"grand",45814},
				[13]= {"splendid",45815},
				[14]= {"monumental",45816},
				[15]= {"truly",{68341,68340,},},
				[16]= {"superb",{64509,64508,},},
				
			},
			["quality"] = 
			{
				{"normal",45850},
				{"fine",45851},
				{"superior",45852},
				{"epic",45853},
				{"legendary",45854},
				{"", 45850} -- default, if nothing is mentioned. Default should be Ta.
			}
		},
	}

	return craftInfo

end





function WritCreater.langEssenceNames() --exact!

local essenceNames =  
	{
		[1] = "Око", --health
		[2] = "Дени", --stamina
		[3] = "Макко", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() --exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "Джора", --Lowest potency stone lvl
		[2] = "Пораде",
		[3] = "Джера",
		[4] = "Джеджора",
		[5] = "Одра",
		[6] = "Поджора",
		[7] = "Едора",
		[8] = "Джаера",
		[9] = "Пора",
		[10]= "Денара",
		[11]= "Рера",
		[12]= "Дерадо",
		[13]= "Рекура",
		[14]= "Кура",
		[15]= "Реджера",
		[16]= "Репора", --v16 potency stone
		
	}
	return potencyNames
end


local exceptions = 
{
	[1] = 
	{
		["original"] = "rubedo leather",
		["corrected"] = "rubedo",
	},
	[2] = 
	{
		["original"] = "ancestor silk",
		["corrected"] = "ancestor",
	},
	[3] = 
	{
		["original"] = "ebony",
		["corrected"] = "ebon",
	},
	[4] = 
	{
		["original"] = "orichalcum",
		["corrected"] = "orichalc",
	},
	[5] = 
	{
		["original"] = "ruby ash",
		["corrected"] = "ruby",
	},
	[6] = 
	{
		["original"] = "dwarven pauldrons",
		["corrected"] = "dwarven pauldron",
	},
	[7] = 
	{
		["original"] = "epaulets",
		["corrected"] = "epaulet",
	}
}


local bankExceptions = 
{
	["original"] = {
		
	},
	["corrected"] = {
		
	}
}

function WritCreater.bankExceptions(condition)
	if string.find(condition, "deliver") then
		return ""
	end
	condition = string.gsub(condition, ":", " ")
	for i = 1, #bankExceptions["original"] do
		condition = string.gsub(condition,bankExceptions["original"][i],bankExceptions["corrected"][i])
	end
	return condition
end

function WritCreater.exceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)

	for i = 1, #exceptions do

		if string.find(condition, exceptions[i]["original"]) then
			condition = string.gsub(condition, exceptions[i]["original"],exceptions[i]["corrected"])
		end
	end
	return condition
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end


function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="Вам следует знать ещё несколько вещей.\nПервое, команда /dailyreset подскажет Вам\nсколько времени осталось до сброса ежедневных заданий.",
		[4]="Наконец, Вы также можете выключить или\nвключить этот аддон отдельно для каждой профессии.\nПо умолчанию, он включен для всех профессий.\nЕсли Вы хотите отключить некоторые, загляните в меню настроек.",
		[3]="Далее Вам следует выбрать, хотите ли Вы видеть\nэто окно, когда используете ремесленные станки.\nОкно подскажет Вам, как много материалов потребуется для выполнения заказа, а также, сколько материалов у Вас уже имеется.",
		[2]="Первая настройка определяет\nхотите ли Вы использовать Автосоздание.\nЕсли включено, как только Вы откроете ремесленный станок, аддон начнёт создание нужных предметов.",
		[1]="Добро пожаловать в Dolgubon's Lazy Writ Crafter!\nВ первую очередь Вам нужно сделать несколько настроек.\n Вы можете изменить настройки\n в любое время в меню настроек.",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="По умолчанию",
		[2]="Вкл",
		[3]="Показывать",
		[4]="Продолжить",
		[5]="Завершить",
	}
	local tOff=
	{
		[1]="Продолжить",
		[2]="Выкл",
		[3]="Не показывать",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end



local function dailyResetFunction(till)
	if till["hour"]==0 then
		if till["minute"]==1 then
			d("1 минута до сброса ежедневных заданий!")
		elseif till["minute"]==0 then
			if stamp==1 then
				d("Ежедневные заданий сбросятся через "..stamp.." секунд!")
			else
				d("Серьёзно... Хватит спрашивать. Ты настолько нетерпелив??? Они сбросятся через пару секунд, проклятье. Тупые так называемые ММОшники. *бур-бур-бур*")
			end
		else
			d(till["minute"].." минут до сброса ежедневных заданий!")
		end
	elseif till["hour"]==1 then
		if till["minute"]==1 then
			d(till["hour"].." час и "..till["minute"].." минута до сброса ежедневных заданий")
		else
			d(till["hour"].." час и "..till["minute"].." минут до сброса ежедневных заданий")
		end
	else
		if till["minute"]==1 then
			d(till["hour"].." часов и "..till["minute"].." минута до сброса ежедневных заданий")
		else
			d(till["hour"].." часов и "..till["minute"].." минут до сброса ежедневных заданий")
		end
	end 
end

local function runeMissingFunction (ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|rТа|cf60000"
	end
	if not essence["bag"] then
		missing[#missing + 1] =  "|cffcc66"..essence["slot"].."|cf60000"
	end
	if not potency["bag"] then
		missing[#missing + 1] = "|c0066ff"..potency["slot"].."|r"
	end
	local text = ""
	for i = 1, #missing do
		if i ==1 then
			text = "|cf60000Глиф не может быть создан. У вас нет ни одной руны "..proper(missing[i])
		else
			text = text.." или "..proper(missing[i])
		end
	end
	return text
end


--Various strings 
WritCreater.strings = 
{
	["runeReq"] 					= function (essence, potency) return "|c2dff00Создание требует 1 |rТа|c2dff00, 1 |cffcc66"..essence.."|c2dff00 и 1 |c0066ff"..potency.."|r" end,
	["runeMissing"] 				= runeMissingFunction ,
	["notEnoughSkill"]				= "У вас недостаточно высокий уровень навыка, чтобы создать требуемую экипировку",
	["smithingMissing"] 			= "\n|cf60000У вас недостаточно материалов|r",
	["craftAnyway"] 				= "Создать что можно",
	["smithingEnough"] 				= "\n|c2dff00У вас достаточно материалов|r",
	["craft"] 						= "|c00ff00Создать|r",
	["crafting"] 					= "|c00ff00Создание...|r",
	["craftIncomplete"] 			= "|cf60000Создание не может быть завершено.\nВам нужно больше материалов.|r",
	["moreStyle"] 					= "|cf60000У вас нет ни одного стилевого материала\nдля выранного стиля|r",
	["moreStyleSettings"]			= "|cf60000You do not have any usable style stones.\nYou likely need to allow more in the Settings Menu|r",
	["moreStyleKnowledge"]			= "|cf60000You do not have any usable style stones.\nYou might need to learn to craft more styles|r",
	["dailyreset"] 					= dailyResetFunction,
	["complete"] 					= "|c00FF00Заказ выполнен.|r",
	["craftingstopped"]				= "Создание остановлено. Пожалуйста, проверьте, что аддон создал правильные предметы.",
	["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "Создание потребует <<1>> <<2>> (|cf60000Вам необходимо ещё <<3>>|r)" ,amount, type, more) end,
	["smithingReqM2"] 				= function (amount,type,more)     return zo_strformat( "\nА также <<1>> <<2>> (|cf60000Вам необходимо ещё <<3>>|r)"          ,amount, type, more) end,
	["smithingReq"] 				= function (amount,type, current) return zo_strformat( "Создание потребует <<1>> <<2>> (|c2dff00<<3>> уже имеется|r)"  ,amount, type, current) end,
	["smithingReq2"] 				= function (amount,type, current) return zo_strformat( "\nА также <<1>> <<2>> (|c2dff00<<3>> уже имеется|r)"         ,amount, type, current) end,
	["lootReceived"]				= "Был получен предмет <<1>>",
}
local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() return GetDate()==20170401 end
if shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() then
	WritCreater.strings.smithingReqM = function (amount, _,more) return zo_strformat( "Создание потребует <<1>> Jester Hats (|cf60000Вам необходимо ещё - <<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReqM2 = function (amount, _,more) return zo_strformat( "Создание потребует <<1>> High Elven Heart (|cf60000Вам необходимо ещё - <<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReq = function (amount, _,more) return zo_strformat( "Создание потребует <<1>> Sock Puppet (|cf60000Вам необходимо ещё - <<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReq2 = function (amount, _,more) return zo_strformat( "Создание потребует <<1>> Jolly Bean (|cf60000Вам необходимо ещё - <<3>>|r)" ,amount, type, more) end
end

--Options table Strings
WritCreater.optionStrings = WritCreater.optionStrings or {}
WritCreater.optionStrings["style tooltip"]                            	= function (styleName) return zo_strformat("Разрешить использовать стиль <<1>> для создания предметов",styleName) end 
WritCreater.optionStrings["show craft window"]                        	= "Показать окно аддона"
WritCreater.optionStrings["show craft window tooltip"]                	= "Показывать окно аддона при использовании ремесленных станков"
WritCreater.optionStrings["autocraft"]                                	= "Автосоздание"
WritCreater.optionStrings["autocraft tooltip"]                        	= "Включение этой настройки активизирует автоматическое создание аддоном необходимых для выполнения заказа предметов при использовании ремесленного станка. Если окно аддона выключено, эта настройка будет включена."
WritCreater.optionStrings["blackmithing"]                             	= "Кузнечное дело"
WritCreater.optionStrings["blacksmithing tooltip"]                    	= "Выключить аддон для Кузнечного дела"
WritCreater.optionStrings["clothing"]                                 	= "Портняжное дело"
WritCreater.optionStrings["clothing tooltip"]                         	= "Выключить аддон для Портняжного дела"
WritCreater.optionStrings["enchanting"]                               	= "Зачарование"
WritCreater.optionStrings["enchanting tooltip"]                       	= "Выключить аддон для Зачарования"
WritCreater.optionStrings["alchemy"]                                  	= "Алхимия"
WritCreater.optionStrings["alchemy tooltip"]   	                  	  	= "Выключить аддон для Алхимии"
WritCreater.optionStrings["provisioning"]                             	= "Снабжение"
WritCreater.optionStrings["provisioning tooltip"]                     	= "Выключить аддон для Снабжения"
WritCreater.optionStrings["woodworking"]                              	= "Столярное дело"
WritCreater.optionStrings["woodworking tooltip"]                      	= "Выключить аддон для Столярного дела"
WritCreater.optionStrings["writ grabbing"]                            	= "Забирать предметы для заказов"
WritCreater.optionStrings["writ grabbing tooltip"]                    	= "Забирать предметы, необходимые для выполнения заказов (напр. Корень нирна, Та и т.д. и т.п.), из банка"
WritCreater.optionStrings["delay"]                                    	= "Задержка снятия"
WritCreater.optionStrings["delay tooltip"]                            	= "Устанавливает задержку, с которой предметы будут сниматься из банка (миллисекунды)"
WritCreater.optionStrings["ignore autoloot"]                          	= "Игнорировать Автосбор"
WritCreater.optionStrings["ignore autoloot tooltip"]                  	= "Игнорировать игровые настройки автосбора, и использовать настройки ниже для контейнеров в награду за ремесленные заказы"
WritCreater.optionStrings["autoloot containters"]                     	= "Автосбор контейнеров за заказы"
WritCreater.optionStrings["autoLoot containters tooltip"]             	= "Собирать всё, при открытии контейнеров за ремесленные заказы"
WritCreater.optionStrings["style stone menu"]                         	= "Стилевой материал"
WritCreater.optionStrings["style stone menu tooltip"]                 	= "Выберите, какой стилевой материал использовать"
WritCreater.optionStrings["send data"]                                	= "Отправить данные о награде"
WritCreater.optionStrings["send data tooltip"]                        	= "Отправить данные о награде, полученной из контейнеров за выполнение заказа. Никакая другая информация не будет отправлена."
WritCreater.optionStrings["exit when done"]							  	= "Выход из окна крафта"
WritCreater.optionStrings["exit when done tooltip"]					  	= "Закрыть окно крафта, когда будут сделаны все необходимые предметы"
WritCreater.optionStrings["automatic complete"]						  	= "Авто-квестинг"
WritCreater.optionStrings["automatic complete tooltip"]				  	= "Автоматически принимать и завершать задания, когда имеется всё необходимое"
WritCreater.optionStrings["new container"]							  	= "Сохранить статус нового"
WritCreater.optionStrings["new container tooltip"]					  	= "Сохраняет статус нового для контейнеров в награду за ремесленные заказы"
WritCreater.optionStrings["master"]									  	= "Мастерские заказы"
WritCreater.optionStrings["master tooltip"]							  	= "Выключает модификацию для Мастерских заказов"
WritCreater.optionStrings["right click to craft"]						= "ПКМ, чтобы создать"
WritCreater.optionStrings["right click to craft tooltip"]				= "Если настройка ВКЛЮЧЕНА аддон будет создавать мастерский заказ, который вы ему укажите правым щелчком мыши на запечатанном заказе"
WritCreater.optionStrings["crafting submenu"]						  	= "Различные ремесла"
WritCreater.optionStrings["crafting submenu tooltip"]				  	= "Выключает аддон для определённых видов ремесла"
WritCreater.optionStrings["timesavers submenu"]							= "Экономия времени"
WritCreater.optionStrings["timesavers submenu tooltip"]				 	= "Различные возможности небоельшой экономии времени"
WritCreater.optionStrings["loot container"]							  	= "Открыть контейнер при получении"
WritCreater.optionStrings["loot container tooltip"]					    = "Автоматически открывает контейнеры в награду за ремесленные заказы при получении"
WritCreater.optionStrings["master writ saver"]							= "Сохранять мастерские заказы"
WritCreater.optionStrings["master writ saver tooltip"]					= "Предотвращает принятие Мастерских заказов"
WritCreater.optionStrings["loot output"]								= "Предупреждение о ценной награде"
WritCreater.optionStrings["loot output tooltip"]						= "Предупреждает о получении ценного предмета за заказ"
WritCreater.optionStrings["autoloot behaviour"]							= "Характер автолута"
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "Выберите, когда аддон будет автоматически забирать награду из контейнеров"
WritCreater.optionStrings["autoloot behaviour choices"]					= {"Копировать настройку из настроек игры", "Автолут", "Автолут выключен"}
WritCreater.optionStrings["container delay"]							= "Delay Container Looting"
WritCreater.optionStrings["container delay tooltip"]					= "Delay the autolooting of writ reward containers when you receive them"

function WritCreater.langWritRewardBoxes () return {
	[CRAFTING_TYPE_ALCHEMY] = "Сосуд алхимика",
	[CRAFTING_TYPE_ENCHANTING] = "Кофр зачарователя",
	[CRAFTING_TYPE_PROVISIONING] = "Сумка снабженца",
	[CRAFTING_TYPE_BLACKSMITHING] = "Ящик кузнеца",
	[CRAFTING_TYPE_CLOTHIER] = "Ранец портного",
	[CRAFTING_TYPE_WOODWORKING] = "Футляр столяра",
	[7] = "Партия",
}
end

--dual, lush, rich

function WritCreater.getTaString()
	return "та"
end

WritCreater.lang = "ru"


--[[
SLASH_COMMANDS['/opencontainers'] = function()local a=WritCreater.langWritRewardBoxes() for i=1,200 do for j=1,6 do if a[j]==GetItemName(1,i) then if IsProtectedFunction("endUseItem") then
	CallSecureProtected("endUseItem",1,i)
else
	UseItem(1,i)
end end end end end]]
