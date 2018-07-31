print "|cFFFF0000[Автоинвайт]:|cff6C8CD5 Ядро аддона загружено. |cff14ECCFВерсия аддона 5.0"
print "|cFFFF0000[Автоинвайт]:|cff6C8CD5 Все вопросы задавать мне в вк [vk.com/ns_azz]"

function autoinviter_Handler(msg1, box)
	msg1 = string.lower(msg1)

	if( not msg1 or msg1 == "" or msg1 == "help" ) then
		print ("|cFFFF0000[Автоинвайт]|cff6C8CD5: Список команд:")
		print ("    |cFFFF0000/ki [слово]|cff6C8CD5 - добавляет или убирает слово для автоинвайта")
		print ("    |cFFFF0000/ki help|cff6C8CD5 - помощь")
		print ("    |cFFFF0000/ki list|cff6C8CD5 - список слов для автоинвайта")
	elseif( msg1 == "list" ) then
		print ("Список слов:");
		for i, _ in pairs (magics1) do
			print( "  "..i)
		end
	else
		if( magics1[msg1] ) then
			magics1[msg1] = nil
			print ("|cFFFF0000[Автоинвайт]|cff6C8CD5: Слово |cFFFF0000'"..msg1.."'|cff6C8CD5 для автоприглашения удалено из списка")
		else
			magics1[msg1] = 1
			print ("|cFFFF0000[Автоинвайт]|cff6C8CD5: Теперь вы можете приглашать по слову |cFFFF0000'"..msg1.."'")
			
		end
	end
end


function autoinviter_Whisper(...)
	local msg1, user1 = ...
	msg1 = string.lower(msg1)
	if( magics1[msg1] ) then
		print("|cFFFF0000[Автоинвайт] |cff14ECCF[Шёпот]: |cff6C8CD5Получено ключевое слово |cffff0000["..msg1.."]")
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
	
	SLASH_ACMI1 = '/ki';
	SLASH_ACMI2 = '/kai';
	
	SlashCmdList["ACMI"] = autoinviter_Handler
	autoinviter_Frame:RegisterEvent("CHAT_MSG_WHISPER")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_CHANNEL")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_GUILD")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_SAY")
	autoinviter_Frame:RegisterEvent("CHAT_MSG_YELL")
	autoinviter_Frame:RegisterEvent("PARTY_INVITE_REQUEST")
end
