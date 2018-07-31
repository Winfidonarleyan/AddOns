print "|cFFFF0000[Kargatum Бот]|cff6C8CD5 Бот загружен."

function bot_PARTY_INVITE_REQUEST(...)
AcceptGroup()
end

UnitPopupButtons["ADDCOMMENT"] =  {text = "|cff6C8CD5Мут", dist = 0}
UnitPopupButtons["ADDCOMMENT1"] = {text = "|cff6C8CD5Суммон", dist = 0}
UnitPopupButtons["ADDCOMMENT2"] = {text = "|cff6C8CD5Апп", dist = 0}
UnitPopupButtons["ADDCOMMENT3"] = {text = "|cff6C8CD5Информация", dist = 0}

function ADDCOMMENT(name, value)
	UnitPopupMenus[name][#(UnitPopupMenus[name])-1] = value
end

function ADDCOMMENT1(name, value)
	UnitPopupMenus[name][#(UnitPopupMenus[name])-2] = value
end

function ADDCOMMENT2(name, value)
	UnitPopupMenus[name][#(UnitPopupMenus[name])-3] = value
end

function ADDCOMMENT3(name, value)
	UnitPopupMenus[name][#(UnitPopupMenus[name])-4] = value
end

ADDCOMMENT("FRIEND", "ADDCOMMENT")
ADDCOMMENT1("FRIEND", "ADDCOMMENT1")
ADDCOMMENT2("FRIEND", "ADDCOMMENT2")
ADDCOMMENT3("FRIEND", "ADDCOMMENT3")

hooksecurefunc("UnitPopup_OnClick", function (self)
  local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
	local name1 = dropdownFrame.name;

  if (self.value == "ADDCOMMENT") then
		print('|cFFFF0000[KM]:|cff6C8CD5 Команда |cff14ECCF[.mute '..name1..' 20 Автомут]')
		SendChatMessage('.mute '..name1..' 20 Автомут')

	elseif (self.value == "ADDCOMMENT1") then
		print('|cFFFF0000[KM]:|cff6C8CD5 Команда |cff14ECCF[.sum '..name1..']')
		SendChatMessage('.sum '..name1..'')

	elseif (self.value == "ADDCOMMENT2") then
		print('|cFFFF0000[KM]:|cff6C8CD5 Команда |cff14ECCF[.app '..name1..']')
		SendChatMessage('.app '..name1..'')

 	elseif (self.value == "ADDCOMMENT3") then
		print('|cFFFF0000[KM]:|cff6C8CD5 Команда |cff14ECCF[.pinfo '..name1..']')
		SendChatMessage('.pinfo '..name1..'')

	end
end)

function bot_Init()
	bot_Frame:RegisterEvent("PARTY_INVITE_REQUEST")
end
