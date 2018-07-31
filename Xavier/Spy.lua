--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Spy = {};
Xavier.Spy.waitingForPin1 = false;
Xavier.Spy.waitingForPin2 = false;
Xavier.Spy.waitingForWho = false;
Xavier.Spy.pinCache = "";

function Xavier.Spy.antiCheat(name)
	Xavier.Spy.spy(name);
	Xavier.Spy.antiCheatPlayer();
	Xavier.Hud.toggleVisibility(false);
	Xavier.Spy.appear();
end

function Xavier.Spy.spy(name)
    if not name or string.len(name) < 1 or name == "%t" then
        name = UnitName("target");
    end
    if name and string.len(name) > 1  then
        Xavier.Spy.waitingForPin1 = true;
        Xavier.Spy.currentRequest = {account = "", accountId = "", class = "", email = "", gmLevel = "", guid = "", guild = "Loading...", ip = "", latency = "", level = "", location = "", login = "", money = "", name = "", phase = "", playedTime = "", race = ""};
        Xavier.Spy.clearCache();
        Xavier.Spy.resetBoxes();
        Xavier.Spy.currentRequest["name"] = name;
        
        SendChatMessage(".pin "..name, "GUILD");
    else
        Xavier.showGMMessage("Please enter a name or make sure you have someone targeted.");
    end
end

function Xavier.Spy.clearCache()
    Xavier.Spy.pinCache = "";
end

function Xavier.Spy.addToCache(pin)
    Xavier.Spy.pinCache = Xavier.Spy.pinCache .. pin .. "\n";
end

function Xavier.Spy.processPin1(offline, name1, guid, account, accountId, email, gmLevel, ip, login, latency, pin)
    if string.lower(name1) == string.lower(Xavier.Spy.currentRequest["name"]) then
        Xavier.Spy.waitingForPin2 = true;
        Xavier.Spy.waitingForPin1 = false;
        
        Xavier.Spy.currentRequest["latency"] = latency;
        if string.len(offline) > 0 then
            Xavier.Spy.currentRequest["guild"] = "Unknown";
            Xavier.Spy.currentRequest["latency"] = "offline";
        else
            Xavier.Spy.openWho(name1);
        end
        
        Xavier.Spy.currentRequest["name"] = name1;
        Xavier.Spy.currentRequest["offline"] = offline;
        Xavier.Spy.currentRequest["guid"] = guid;
        Xavier.Spy.currentRequest["account"] = account;
        Xavier.Spy.currentRequest["accountId"] = accountId;
        Xavier.Spy.currentRequest["gmLevel"] = gmLevel;
        Xavier.Spy.currentRequest["email"] = email;
        Xavier.Spy.currentRequest["ip"] = ip;
        Xavier.Spy.currentRequest["login"] = login;
        
        Xavier.Spy.clearCache();
        Xavier.Spy.addToCache(pin);
    end
end

function Xavier.Spy.processPin2(race, class, playedTime, level, money)
    Xavier.Spy.waitingForPin2 = false;
    Xavier.Spy.waitingForPin3 = true;
    
    Xavier.Spy.currentRequest["race"] = race;
    Xavier.Spy.currentRequest["class"] = class;
    Xavier.Spy.currentRequest["playedTime"] = playedTime;
    Xavier.Spy.currentRequest["level"] = level;
    Xavier.Spy.currentRequest["money"] = money;
end

function Xavier.Spy.processPin3(map, area, zone, phase)
    Xavier.Spy.waitingForPin3 = false;
    
    Xavier.Spy.currentRequest["phase"] = phase;
    
    Xavier.Spy.currentRequest["location"] = map;
    if map ~= area then
        Xavier.Spy.currentRequest["location"] = area..', '..Xavier.Spy.currentRequest["location"];
    end
    if string.upper(zone) ~= '<UNKNOWN>' then
        Xavier.Spy.currentRequest["location"] = zone..', '..Xavier.Spy.currentRequest["location"];
    end
    
    Xavier.Spy.resetBoxes();
    Xavier_Spy_InfoWindow:Show();
end

function Xavier.Spy.processWho()
    local i = 1;
	local max = GetNumWhoResults();
    local found = false;
    
    while i <= max and not found do
        name, guild, level, race, class, zone, filename = GetWhoInfo(i);
        if name == Xavier.Spy.currentRequest["name"] or name == "<GM>"..Xavier.Spy.currentRequest["name"] then
            found = true;
            Xavier.Spy.currentRequest["guild"] = guild;
            Xavier.Spy.closeWho();
        end
        i = i + 1;
    end
    
    if not found then
        FriendsFrame_OnEvent();
    end
end

function Xavier.Spy.resetBoxes()
    Xavier_Spy_InfoWindow_Info_CharInfo:SetText("Level "..Xavier.Spy.currentRequest["level"].." "..Xavier.Spy.currentRequest["race"].." "..Xavier.Spy.currentRequest["class"]);
    Xavier_Spy_InfoWindow_Info_Guild:SetText("<"..Xavier.Spy.currentRequest["guild"]..">");
    Xavier_Spy_InfoWindow_Title_Text:SetText(Xavier.Spy.currentRequest["name"]);
    Xavier_Spy_InfoWindow_Character_Name:SetText(Xavier.Spy.currentRequest["name"]);
    Xavier_Spy_InfoWindow_Character_Id:SetText(Xavier.Spy.currentRequest["guid"]);
    Xavier_Spy_InfoWindow_Account_Name:SetText(Xavier.Spy.currentRequest["account"]);
    Xavier_Spy_InfoWindow_Account_Id:SetText(Xavier.Spy.currentRequest["accountId"]);
    Xavier_Spy_InfoWindow_Email_Email:SetText(Xavier.Spy.currentRequest["email"]);
    Xavier_Spy_InfoWindow_IpLat_Ip:SetText(Xavier.Spy.currentRequest["ip"]);
    if tonumber(Xavier.Spy.currentRequest["latency"]) and tonumber(Xavier.Spy.currentRequest["latency"]) > 1000 then
        Xavier_Spy_InfoWindow_IpLat_Latency:SetFontObject(GenieFontRedSmall);
    else
        Xavier_Spy_InfoWindow_IpLat_Latency:SetFontObject(GenieFontHighlightSmall);
    end
    Xavier_Spy_InfoWindow_IpLat_Latency:SetText(Xavier.Spy.currentRequest["latency"]);
    Xavier_Spy_InfoWindow_LastLogin_LastLogin:SetText(Xavier.Spy.currentRequest["login"]);
    Xavier_Spy_InfoWindow_PlayedGM_PlayedTime:SetText(Xavier.Spy.currentRequest["playedTime"]);
    Xavier_Spy_InfoWindow_PlayedGM_GM:SetText(Xavier.Spy.currentRequest["gmLevel"]);
    Xavier_Spy_InfoWindow_MoneyPhase_Money:SetText(Xavier.Spy.currentRequest["money"]);
    Xavier_Spy_InfoWindow_MoneyPhase_Phase:SetText(Xavier.Spy.currentRequest["phase"]);
    Xavier_Spy_InfoWindow_Location_Location:SetText(Xavier.Spy.currentRequest["location"]);
    Xavier_Spy_InfoWindow_Location_Location:SetCursorPosition(0);
end

function Xavier.Spy.openWho(name)
    FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE");
    Xavier.Spy.captureWho:RegisterEvent("WHO_LIST_UPDATE");
    SetWhoToUI(1);
    SendWho(name);
    Chronos.scheduleByName('closewho', 5, Xavier.Spy.closeWho);
end

function Xavier.Spy.closeWho()
    FriendsFrame:RegisterEvent("WHO_LIST_UPDATE"); 
    Xavier.Spy.captureWho:UnregisterEvent("WHO_LIST_UPDATE");
    SetWhoToUI(0);
    if Xavier.Spy.currentRequest["guild"] == "Loading..." then
        Xavier.Spy.currentRequest["guild"] = "Unknown";
    end
    Xavier.Spy.resetBoxes();
end

function Xavier.Spy.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Ban Info';
    info.func = Xavier.Spy.banInfo;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Lookup Player';
    info.func = Xavier.Spy.lookupPlayer;
    UIDropDownMenu_AddButton(info, level);
end

Xavier.Spy.captureWho = CreateFrame("FRAME", "captureWho");
Xavier.Spy.captureWho:SetScript("OnEvent", Xavier.Spy.processWho);

SLASH_SPY1 = "/spy";
SlashCmdList["SPY"] = Xavier.Spy.spy;

function Xavier.Spy.copyPin()
    Xavier.showGMMessage(Xavier.Spy.pinCache);
end

function Xavier.Spy.whisper()
    ChatFrame_SendTell(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.summon()
	Xavier.Macros.summon(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.appear()
    Xavier.Macros.appear(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.revive()
    Xavier.Macros.revive(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.freeze()
    Xavier.Macros.freeze(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.unfreeze()
    Xavier.Macros.unfreeze(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.rename()
    Xavier.Macros.rename(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.antiCheatPlayer()
    Xavier.Macros.antiCheatPlayer(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.customize()
    Xavier.Macros.customize(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.changefaction()
    Xavier.Macros.changefaction(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.changerace()
    Xavier.Macros.changerace(Xavier.Spy.currentRequest["name"]);
end

function Xavier.Spy.banInfo()
    CloseDropDownMenus()
    SendChatMessage(".baninfo account "..Xavier.Spy.currentRequest["account"], "GUILD");
    SendChatMessage(".baninfo character "..Xavier.Spy.currentRequest["name"], "GUILD");
    SendChatMessage(".baninfo ip "..Xavier.Spy.currentRequest["ip"], "GUILD");
end

function Xavier.Spy.lookupPlayer()
    CloseDropDownMenus()
    SendChatMessage(".lookup player account "..Xavier.Spy.currentRequest["account"], "GUILD");
    SendChatMessage(".lookup player email "..Xavier.Spy.currentRequest["email"], "GUILD");
    SendChatMessage(".lookup player ip "..Xavier.Spy.currentRequest["ip"], "GUILD");
end

local Saved_SetItemRef = SetItemRef;
function SetItemRef(link, text, button, chatFrame)
	if ( strsub(link, 1, 9) == "anticheat" ) then
		local type, name = strsplit(":", link);
		if ( button == "LeftButton" ) then
			Xavier.Spy.antiCheat(name);
		elseif ( button == "RightButton" ) then
			FriendsFrame_ShowDropdown(name, 1);
		end
		return;
	end
	Saved_SetItemRef(link, text, button, chatFrame);
end