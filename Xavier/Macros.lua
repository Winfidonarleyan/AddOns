--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Macros = {};

function Xavier.Macros.onLoad()
    Xavier.Macros.menuItems = {};
    UnitPopupButtons["Xavier_Commands"] = { text = "Quick Commands", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "Commands");
    UnitPopupMenus["Xavier_Commands"] = {};
    
    UnitPopupButtons["Xavier_Revive"] = { text = "Revive", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Commands"], "Xavier_Revive");
    UnitPopupButtons["Xavier_Appear"] = { text = "Appear", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Commands"], "Xavier_Appear");
    UnitPopupButtons["Xavier_Summon"] = { text = "Summon", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Commands"], "Xavier_Summon");
    UnitPopupButtons["Xavier_Freeze"] = { text = "Freeze", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Commands"], "Xavier_Freeze");
    UnitPopupButtons["Xavier_Unfreeze"] = { text = "Unfreeze", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Commands"], "Xavier_Unfreeze");
    UnitPopupButtons["Xavier_Spy"] = { text = "Spy", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Commands"], "Xavier_Spy");
    
    UnitPopupButtons["Xavier_Character"] = { text = "Character", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "Character");
    UnitPopupMenus["Xavier_Character"] = {};
    
    UnitPopupButtons["Xavier_Character_Rename"] = { text = "Rename", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Character"], "Xavier_Character_Rename");
    UnitPopupButtons["Xavier_Character_Customize"] = { text = "Customize", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Character"], "Xavier_Character_Customize");
    UnitPopupButtons["Xavier_Character_Changerace"] = { text = "Change Race", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Character"], "Xavier_Character_Changerace");
    UnitPopupButtons["Xavier_Character_Changefaction"] = { text = "Change Faction", dist = 0};
    table.insert(UnitPopupMenus["Xavier_Character"], "Xavier_Character_Changefaction");
    
	UnitPopupButtons["Xavier_Whispers"] = { text = "Whisper Macros", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "Whispers");
    Xavier.Macros.Whispers.addToUnitMenu();
    
	UnitPopupButtons["Xavier_Mail"] = { text = "Mail Macros", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "Mail");
    Xavier.Macros.Mail.addToUnitMenu();
    
	UnitPopupButtons["Xavier_Tele"] = { text = "Teleport Macros", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "Tele");
    Xavier.Macros.Tele.addToUnitMenu();
    
	UnitPopupButtons["Xavier_Mute"] = { text = "Mutes", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "Mute");
    Xavier.Macros.Discipline.Mute.addToUnitMenu();
	
	UnitPopupButtons["Xavier_CharBan"] = { text = "Character Bans", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "CharBan");
    Xavier.Macros.Discipline.CharBan.addToUnitMenu();
	
	UnitPopupButtons["Xavier_AccBan"] = { text = "Account Bans", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "AccBan");
    Xavier.Macros.Discipline.AccBan.addToUnitMenu();
	
	UnitPopupButtons["Xavier_IpBan"] = { text = "Ip Bans", dist = 0, nested = 1};
    table.insert(Xavier.Macros.menuItems, "IpBan");
    Xavier.Macros.Discipline.IpBan.addToUnitMenu();
    
   -- for i, button in ipairs(Xavier.Macros.menuItems) do
        table.insert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"]-1, "Xavier_"..button);
        table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"]-1, "Xavier_"..button);
        table.insert(UnitPopupMenus["PARTY"], #UnitPopupMenus["PARTY"]-1, "Xavier_"..button);
        table.insert(UnitPopupMenus["RAID_PLAYER"], #UnitPopupMenus["RAID_PLAYER"]-1, "Xavier_"..button);
        table.insert(UnitPopupMenus["TEAM"], #UnitPopupMenus["TEAM"]-1, "Xavier_"..button);
        table.insert(UnitPopupMenus["CHAT_ROSTER"], #UnitPopupMenus["CHAT_ROSTER"]-1, "Xavier_"..button);
    -- end

	hooksecurefunc("UnitPopup_OnClick", Xavier.Macros.contextMenuClick);
    UIDropDownMenu_Initialize(Xavier_Spy_InfoWindow_DropdownbuttonsOne, Xavier.Macros.loadDropdown, "MENU");
end

function Xavier.Macros.contextMenuClick(self)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
	local button = self.value;
	local name = dropdownFrame.name;
	local startPos = string.find(button, "Xavier_");
	
	if (startPos == 1) then
        button = string.sub(button, 9);
	    
        if button == "Revive" then
            print('123');
        elseif button == "Appear" then
            Xavier.Macros.appear(name);
        elseif button == "Summon" then
            Xavier.Macros.summon(name);
        elseif button == "Freeze" then
            Xavier.Macros.freeze(name);
        elseif button == "Unfreeze" then
            Xavier.Macros.unfreeze(name);
        elseif button == "Spy" then
            Xavier.Spy.spy(name);
        elseif button == "Character_Rename" then
            Xavier.Macros.rename(name);
        elseif button == "Character_Customize" then
            Xavier.Macros.customize(name);
        elseif button == "Character_Changerace" then
            Xavier.Macros.changerace(name);
        elseif button == "Character_Changefaction" then
            Xavier.Macros.changefaction(name);
        elseif button == "WhisperOptions" then
            Xavier.Macros.Whispers.showOptions();
        elseif button == "MailOptions" then
            Xavier.Macros.Mail.showOptions();
        elseif button == "TeleOptions" then
            Xavier.Macros.Tele.showOptions();
        elseif button == "DisciplineOptions" then
            Xavier.Macros.Discipline.showOptions();
        else
            local isWhisperMacro = string.find(button, "Whispers_");
            local isMailMacro = string.find(button, "Mail_");
            local isTeleMacro = string.find(button, "Tele_");
            local isMuteMacro = string.find(button, "Mute_");
            local isCharBanMacro = string.find(button, "CharBan_");
            local isAccBanMacro = string.find(button, "AccBan_");
            local isIpBanMacro = string.find(button, "IpBan_");
            if isWhisperMacro == 1 then
                Xavier.Macros.Whispers.run(name, string.sub(button, 10));
            elseif isMailMacro == 1 then
                Xavier.Macros.Mail.run(name, string.sub(button, 6));
            elseif isTeleMacro == 1 then
                Xavier.Macros.Tele.run(name, string.sub(button, 6));
            elseif isMuteMacro == 1 then
                Xavier.Macros.Discipline.Mute.run(name, string.sub(button, 6));
            elseif isCharBanMacro == 1 then
                Xavier.Macros.Discipline.CharBan.run(name, string.sub(button, 9));
            elseif isAccBanMacro == 1 then
                Xavier.Macros.Discipline.AccBan.run(name, string.sub(button, 8));
            elseif isIpBanMacro == 1 then
                Xavier.Macros.Discipline.IpBan.run(name, string.sub(button, 7));
            end
        end
	end
    
    CloseDropDownMenus();
end

function Xavier.Macros.loadDropdown(self, level)
    local level = level or 1;
    
    if level == 1 then
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Character";
        info.value = "character";
        UIDropDownMenu_AddButton(info, level);
		
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Whisper Macros";
        info.value = "whispers";
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Mail Macros";
        info.value = "mail";
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Teleport Macros";
        info.value = "tele";
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Mutes";
        info.value = "mute";
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Character Bans";
        info.value = "charBan";
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Account Bans";
        info.value = "accBan";
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = true;
        info.notCheckable = true;
        info.text = "Ip Bans";
        info.value = "ipBan";
        UIDropDownMenu_AddButton(info, level);
        
    elseif level == 2 then
        if UIDROPDOWNMENU_MENU_VALUE == "character" then
			local info = UIDropDownMenu_CreateInfo();
			info.hasArrow = false;
			info.notCheckable = true;
			info.text = "Rename";
			info.func = Xavier.Spy.rename;
			UIDropDownMenu_AddButton(info, level);
            
			local info = UIDropDownMenu_CreateInfo();
			info.hasArrow = false;
			info.notCheckable = true;
			info.text = "Customize";
			info.func = Xavier.Spy.customize;
			UIDropDownMenu_AddButton(info, level);
            
			local info = UIDropDownMenu_CreateInfo();
			info.hasArrow = false;
			info.notCheckable = true;
			info.text = "Change Faction";
			info.func = Xavier.Spy.changefaction;
			UIDropDownMenu_AddButton(info, level);
            
			local info = UIDropDownMenu_CreateInfo();
			info.hasArrow = false;
			info.notCheckable = true;
			info.text = "Change Race";
			info.func = Xavier.Spy.changerace;
			UIDropDownMenu_AddButton(info, level);
			
        elseif UIDROPDOWNMENU_MENU_VALUE == "whispers" then
            Xavier.Macros.Whispers.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "mail" then
            Xavier.Macros.Mail.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "tele" then
            Xavier.Macros.Tele.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "mute" then
            Xavier.Macros.Discipline.Mute.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "charBan" then
            Xavier.Macros.Discipline.CharBan.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "accBan" then
            Xavier.Macros.Discipline.AccBan.loadDropdown(self, level);
        elseif UIDROPDOWNMENU_MENU_VALUE == "ipBan" then
            Xavier.Macros.Discipline.IpBan.loadDropdown(self, level);
        end
    end
end

function Xavier.Macros.revive(name)
    SendChatMessage(".revive "..name, "GUILD");
end

function Xavier.Macros.appear(name)
    SendChatMessage(".appear "..name, "GUILD");
end

function Xavier.Macros.summon(name)
    SendChatMessage(".summon "..name, "GUILD");
end

function Xavier.Macros.freeze(name)
    SendChatMessage(".freeze "..name, "GUILD");
end

function Xavier.Macros.unfreeze(name)
    SendChatMessage(".unfreeze "..name, "GUILD");
end

function Xavier.Macros.antiCheatPlayer(name)
	SendChatMessage(".anticheat player "..name, "GUILD");
end

function Xavier.Macros.rename(name)
	SendChatMessage(".char rename "..name, "GUILD");
end

function Xavier.Macros.customize(name)
	SendChatMessage(".char customize "..name, "GUILD");
end

function Xavier.Macros.changefaction(name)
	SendChatMessage(".char changefaction "..name, "GUILD");
end

function Xavier.Macros.changerace(name)
	SendChatMessage(".char changerace "..name, "GUILD");
end