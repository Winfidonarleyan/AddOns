--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

TicketTab = "General";

-- 1d2h3m4s to number in seconds
function Xavier.timeStrToSeconds(timeStr)
    local days = string.match(timeStr, "([0-9]*)d");
    if not days then
        days = 0;
    end
    local hours = string.match(timeStr, "([0-9]*)h");
    if not hours then
        hours = 0;
    end
    local minutes = string.match(timeStr, "([0-9]*)m");
    if not minutes then
        minutes = 0;
    end
    local seconds = string.match(timeStr, "([0-9]*)s");
    if not seconds then
        seconds = 0;
    end
    return (((((tonumber(days)*24)+tonumber(hours))*60)+tonumber(minutes))*60)+tonumber(seconds);
end

-- Read from chat
local ORIG_ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler;
function ChatFrame_MessageEventHandler(self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15 = ...;
	
	local ActionTaken = false;
    
    -- development code to analize chat messages
    --local excapedarg = string.gsub(arg1, "%|", "%%");
    --Xavier.showGMMessage("1: "..excapedarg);
	
    -- check for system messages of interest
	if (event == "CHAT_MSG_SYSTEM") then
        -- Showing list of open tickets whose creator is online.
        if string.find(arg1, "Showing list of open tickets") then
            Chronos.scheduleByName('ticketreupdate', 0.5, Xavier.Tickets.update);
            ActionTaken = true;
        end
        -- ticket list or reading ticket
        local ticketId, name, createStr, lastModifiedStr, rest = string.match(arg1, "^%|cffaaffaaTicket%|r:%|cffaaccff%s([0-9]+).%|r%s%|cff00ff00Created%sby%|r:%|cff00ccff%s(.+)%|r%s%|cff00ff00Created%|r:%|cff00ccff%s([a-zA-Z0-9%s]+)%sago%|r%s%|cff00ff00Last%schange%|r:%|cff00ccff%s([a-zA-Z0-9%s]+)%sago%|r%s(.*)$");
        
        if ticketId and name and createStr and lastModifiedStr then
            ticketId = tonumber(ticketId);
            local createStamp = Xavier.timeStrToSeconds(createStr);
            local lastModifiedStamp = Xavier.timeStrToSeconds(lastModifiedStr);
			if Xavier.Tickets.tempList then
				Xavier.Tickets.listTicket(ticketId, name, createStr, createStamp, lastModifiedStr, lastModifiedStamp);
			end
            
            local assignedTo = string.match(rest, "%|cff00ff00Assigned%sto%|r:%|cff00ccff%s([a-zA-Z]+)%|r%s");
            if assignedTo then
                Xavier.Tickets.setAssigned(ticketId, assignedTo);
            end
            local message = string.match(rest, "%|cff00ff00Ticket%sMessage%|r:%s%[(.-)%]%|r");
            local ticketCorrect = false;
            if message then
                ticketCorrect = Xavier.Tickets.readTicket(ticketId, message);
            else
                local message = string.match(rest, "%|cff00ff00Ticket%sMessage%|r:%s%[(.*)");
                if message then
                    ticketCorrect = Xavier.Tickets.readTicket(ticketId, message);
                    if ticketCorrect then
                        Xavier.Tickets.messageOpen = true;
                    end
                end
            end
            
            local comment = string.match(rest, "%|cff00ff00GM%sComment%|r:%s%[(.*)%]%|r");
            if comment then
                Xavier.Tickets.comment(ticketId, comment);
            end
			
            if ticketCorrect or Xavier.Tickets.tempList then
                ActionTaken = true;
            end
        elseif Xavier.Tickets.messageOpen then
            ActionTaken = true;
            local message, rest = string.match(arg1, "(.-)%]%|r(.*)");
            if message then
                Xavier.Tickets.messageOpen = false;
                Xavier.Tickets.addLine(message);
            else
                if string.find(arg1, "%]%|r") then
                    rest = string.match(arg1, "%]%|r(.*)");
                    Xavier.Tickets.messageOpen = false;
                else
                    Xavier.Tickets.addLine(arg1);
                end
            end
            
            if rest then
                local comment = string.match(rest, "%|cff00ff00GM%sComment%|r:%s%[(.*)%]%|r");
				if comment and Xavier.Tickets.currentTicket['ticketId'] then
					Xavier.Tickets.comment(Xavier.Tickets.currentTicket['ticketId'], comment);
				end
            end
        else
            -- Ticket edited
            local name, ticketId = string.match(arg1, "^%|cff00ff00Character%|r%|cffff00ff%s([a-zA-Z]+)%s%|r%|cff00ff00edited%shis/her%sticket:%|r%|cffff00ff%s([0-9]+).%|r$");
            if name and ticketId then
                if Xavier.Tickets.isOpen() then
                    Xavier.Tickets.refresh();
                end
                ActionTaken = true;
            end
            -- Ticket abandoned
            local name, ticketId = string.match(arg1, "^%|cff00ff00Character%|r%|cffff00ff%s([a-zA-Z]+)%s%|r%|cff00ff00abandoned%sticket%sentry:%|r%|cffff00ff%s([0-9]+).%|r$");
            if name and ticketId then
                if Xavier.Tickets.isOpen() then
                    Xavier.Tickets.refresh();
                end
                ActionTaken = true;
            end
            -- New Ticket
            local name, ticketId = string.match(arg1, "^%|cff00ff00New%sticket%sfrom%|r%|cffff00ff%s([a-zA-Z]+).%|r%s%|cff00ff00Ticket%sentry:%|r%|cffff00ff%s([0-9]+).%|r$");
            if name and ticketId then
                if Xavier.Tickets.isOpen() then
                    Xavier.Tickets.refresh();
                end
                ActionTaken = true;
            end
        end
		
        -- read coords from chat
		if Xavier.Spawns.waitingForGps == 1 then
            if string.find(arg1, "^You are outdoors") or string.find(arg1, "^no VMAP available for area info") then
                ActionTaken = true;
            end
            local map = string.match(arg1, "^Map:%s([0-9]+)%s");
            if map then
                Xavier.Spawns.waitingForGps = 2;
                Xavier.Spawns.setMap(map);
                ActionTaken = true;
            end
        end
        if Xavier.Spawns.waitingForGps == 2 then
            local x, y, z, o = string.match(arg1, "^X:%s([0-9%.%-]+)%sY:%s([0-9%.%-]+)%sZ:%s([0-9%.%-]+)%sOrientation:%s([0-9%.%-]+)$");
            if x and y and z and o then
                Xavier.Spawns.waitingForGps = 3;
                Xavier.Spawns.move(x, y, z, o);
                ActionTaken = true;
            end
		end
        if Xavier.Spawns.waitingForGps == 3 then
            if string.find(arg1, "^grid") or string.find(arg1, "^ ZoneX") then
                ActionTaken = true;
            end
            if string.find(arg1, "^GroundZ") then
                Xavier.Spawns.waitingForGps = 0;
                ActionTaken = true;
            end
        end
        
        if Xavier.Spy.waitingForPin1 or Xavier.Macros.Discipline.IpBan.waitingForPin1 then
            if string.find(arg1, "Player not found!") then
                Xavier.Spy.waitingForPin1 = false;
				Xavier.Macros.Discipline.IpBan.waitingForPin1 = false;
            else
                local offline, name1, name2, guid, account, accountId, email, gmLevel, ip, login, latency = string.match(arg1, "Player(.*) %|cffffffff%|Hplayer:(.*)%|h%[(.*)%]%|h%|r %(guid: (.*)%) Account: (.*) %(id: (.*)%) Email: (.*) GMLevel: (.*) Last IP: (.*) Last login: (.*) Latency: (.*)ms");
                if name1 then
					if Xavier.Spy.waitingForPin1 then
						Xavier.Spy.processPin1(offline, name1, guid, account, accountId, email, gmLevel, ip, login, latency, arg1);
					else
						Xavier.Macros.Discipline.IpBan.processPin1(ip);
					end
                    ActionTaken = true;
                end
            end
       elseif Xavier.Spy.waitingForPin2 or Xavier.Macros.Discipline.IpBan.waitingForPin2 then
            Xavier.Spy.addToCache(arg1);
            local race, class, playedTime, level, money = string.match(arg1, "Race: (.*) Class: (.*) Played time: (.*) Level: (.*) Money: (.*)");
            if race then
				if Xavier.Spy.waitingForPin2 then
					Xavier.Spy.processPin2(race, class, playedTime, level, money);
				else
					Xavier.Macros.Discipline.IpBan.waitingForPin2 = false;
					Xavier.Macros.Discipline.IpBan.waitingForPin3 = true;
				end
                ActionTaken = true;
            end
        elseif Xavier.Spy.waitingForPin3 or Xavier.Macros.Discipline.IpBan.waitingForPin3 then
            Xavier.Spy.addToCache(arg1);
            local map, area = string.match(arg1, "Map: (.*), Area: (.*)");
            if map then
				if Xavier.Spy.waitingForPin3 then
					area2, zone, phase = string.match(area, "(.*), Zone: (.*), Phase: (.*)");
					if area2 then
						Xavier.Spy.processPin3(map, area2, zone, phase);
					else
						Xavier.Spy.processPin3(map, area, "<unknown>", "offline");
					end
				else
					Xavier.Macros.Discipline.IpBan.waitingForPin3 = false;
				end
                ActionTaken = true;
            end
        end
        
        if Xavier.Spawns.waitingForObject then
            local name, guid, id = string.match(arg1, "%|cffffffff%|Hgameobject:.*%|h%[(.*)%]%|h%|r%sGUID:%s(.*)%sID:%s(.*)");
            if name and guid and id then
                Xavier.Spawns.deleteObject(name, guid, id);
                ActionTaken = true;
            elseif string.find(arg1, "X:%s.*%sY:%s.*%sZ:%s.*%sMapId:%s.*") or string.find(arg1, "Orientation:%s.*") or string.find(arg1, "Phasemask%s.*") then
                ActionTaken = true;
            elseif string.find(arg1, "SpawnTime:%sFull:.*%sRemain:.*") then
                ActionTaken = true;
                Xavier.Spawns.waitingForObject = false;
            elseif string.find(arg1, "Nothing found!") then
                Xavier.Spawns.waitingForObject = false;
            end
        end
        
        if Xavier.Spawns.waitingForObjectDelete then
            if string.find(arg1, "Game Object %(GUID: .*%) removed") then
                ActionTaken = true;
                Xavier.Spawns.waitingForObjectDelete = false;
            end
        end
        
        local charName = UnitName("player");
        if string.match(arg1, "%|cffffffff%|Hplayer:".. charName .."%|h%[".. charName .."%]%|h%|r%: режим полета on") then
            Xavier.Hud.flyStatus(true);
        elseif string.match(arg1, "%|cffffffff%|Hplayer:".. charName .."%|h%[".. charName .."%]%|h%|r%: режим полета off") then
            Xavier.Hud.flyStatus(false);
        elseif arg1 == "Accepting Whisper: ON" or arg1 == "Accepting Whisper: on" or arg1 == "|cFFFF0000# |cff6C8CD5Приём сообщений: |cff14ECCFвключено" then
            Xavier.Hud.whisperStatus(true);
        elseif arg1 == "Accepting Whisper: OFF" or arg1 == "Accepting Whisper: off" or arg1 == "|cFFFF0000# |cff6C8CD5Приём сообщений: |cff14ECCFвыключено" then
            Xavier.Hud.whisperStatus(false);
        elseif arg1 == "You are: visible" or arg1 == "|cFFFF0000# |cff6C8CD5Видимость: |cff14ECCF: видимый" then
            Xavier.Hud.visibilityStatus(true);
        elseif arg1 == "You are: invisible" or arg1 == "|cFFFF0000# |cff6C8CD5Видимость: |cff14ECCF: невидимый" then
            Xavier.Hud.visibilityStatus(false);
        end 
		
		local characterName = string.match(arg1, "%|cFFFFBF00%[AntiCheat%]%:%|cFFFFFFFF %[(.*)%] %|cFF00FFFFdetected as possible cheater%.");
		if characterName then
			arg1 = "|cFFFFBF00[AntiCheat]:|r |Hanticheat:"..characterName.."|h["..characterName.."]|h detected as possible cheater.";
		end
    end
	
    -- if nothing was done, just display the message
	if not ActionTaken then
		ORIG_ChatFrame_MessageEventHandler(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
    end
end