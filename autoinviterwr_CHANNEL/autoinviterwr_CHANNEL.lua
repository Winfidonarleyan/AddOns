print "|cFFFF0000[Автоинвайт]: |cff6C8CD5Модуль [Каналы] загружен"

function autoinviter_CHANNEL(...)
	local msg1, user1 = ...
	msg1 = string.lower(msg1)
	if( magics1[msg1] ) then
		print("|cFFFF0000[Автоинвайт] |cff14ECCF[Канал]: |cff6C8CD5Получено ключевое слово |cffff0000["..msg1.."]") 
		print("|cff6C8CD5Приглашение игрока |cff14ECCF["..user1.."]") ;
		SendChatMessage('Я уловил твоё ключевое слово ['..msg1..'] Держи пати :)', "WHISPER", nil,user1)	
		InviteUnit(user1)
	end
	
end

function autoinviter_Init()
	if( not magics1) then
		magics1 = {
			["inv"] = 1,
			["+"] = 1,
			["invite"] = 1,
			["инвайт"] = 1,
			["byd"] = 1,
			["штм"] = 1,
			["инв"] = 1,
			["++"] = 1,
			["+++"] = 1,
			["++++"] = 1,
			["пригласи"] = 1,
			["+++++"] = 1,
			["gfnb"] = 1,
			["пати"] = 1,
			}
	end
	autoinviter_Frame:RegisterEvent("CHAT_MSG_WHISPER")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_CHANNEL")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_GUILD")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_SAY")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_YELL")
	autoinviter_Frame:RegisterEvent("PARTY_INVITE_REQUEST")
end