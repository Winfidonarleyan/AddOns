--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Macros.Discipline = {};
Xavier.Macros.Discipline.Mute = {};
Xavier.Macros.Discipline.CharBan = {};
Xavier.Macros.Discipline.AccBan = {};
Xavier.Macros.Discipline.IpBan = {};

function Xavier.Macros.Discipline.Mute.run(name, title)
	if Xavier_SavedVars.mute[title]["announceToServer"] then
		SendChatMessage('.name '..name..' has been muted for '..Xavier_SavedVars.mute[title]["duration"]..' minutes. Reason: '..Xavier_SavedVars.mute[title]["reason"], "GUILD");
	else
		SendChatMessage('.gmname '..name..' has been muted for '..Xavier_SavedVars.mute[title]["duration"]..' minutes. Reason: '..Xavier_SavedVars.mute[title]["reason"], "GUILD");
	end
    SendChatMessage('.mute '..name..' '..Xavier_SavedVars.mute[title]["duration"]..' '..Xavier_SavedVars.mute[title]["reason"], "GUILD");
end

function Xavier.Macros.Discipline.Mute.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Discipline.Mute.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Discipline.Mute.addToUnitMenu()
    UnitPopupMenus["Xavier_Mute"] = {};
    local MuteTemp = Xavier.pairsByKeys2(Xavier_SavedVars.mute);
    for index,name in pairs(MuteTemp) do
        table.insert(UnitPopupMenus["Xavier_Mute"], "Xavier_Mute_"..name);
        UnitPopupButtons["Xavier_Mute_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_Mute"], "Xavier_DisciplineOptions");
	UnitPopupButtons["Xavier_DisciplineOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Discipline.Mute.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Mutes";
    UIDropDownMenu_AddButton(info, level);
    
    local MuteTemp = Xavier.pairsByKeys2(Xavier_SavedVars.mute);
    for index,name in pairs(MuteTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Discipline.Mute.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end



function Xavier.Macros.Discipline.CharBan.run(name, title)
	if Xavier_SavedVars.charBan[title]["announceToServer"] then
		SendChatMessage('.name '..name..' has been banned for '..Xavier_SavedVars.charBan[title]["duration"]..'. Reason: '..Xavier_SavedVars.charBan[title]["reason"], "GUILD");
	else
		SendChatMessage('.gmname '..name..' has been banned for '..Xavier_SavedVars.charBan[title]["duration"]..'. Reason: '..Xavier_SavedVars.charBan[title]["reason"], "GUILD");
	end
    SendChatMessage('.ban char '..name..' '..Xavier_SavedVars.charBan[title]["duration"]..' '..Xavier_SavedVars.charBan[title]["reason"], "GUILD");
end

function Xavier.Macros.Discipline.CharBan.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Discipline.CharBan.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Discipline.CharBan.addToUnitMenu()
    UnitPopupMenus["Xavier_CharBan"] = {};
    local CharBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.charBan);
    for index,name in pairs(CharBanTemp) do
        table.insert(UnitPopupMenus["Xavier_CharBan"], "Xavier_CharBan_"..name);
        UnitPopupButtons["Xavier_CharBan_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_CharBan"], "Xavier_DisciplineOptions");
	UnitPopupButtons["Xavier_DisciplineOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Discipline.CharBan.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Character Bans";
    UIDropDownMenu_AddButton(info, level);
    
    local CharBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.charBan);
    for index,name in pairs(CharBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Discipline.CharBan.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end



function Xavier.Macros.Discipline.AccBan.run(name, title)
	if Xavier_SavedVars.accBan[title]["announceToServer"] then
		SendChatMessage('.name '..name..' has been account banned for '..Xavier_SavedVars.accBan[title]["duration"]..'. Reason: '..Xavier_SavedVars.accBan[title]["reason"], "GUILD");
	else
		SendChatMessage('.gmname '..name..' has been account banned for '..Xavier_SavedVars.accBan[title]["duration"]..'. Reason: '..Xavier_SavedVars.accBan[title]["reason"], "GUILD");
	end
    SendChatMessage('.ban playeraccount '..name..' '..Xavier_SavedVars.accBan[title]["duration"]..' '..Xavier_SavedVars.accBan[title]["reason"], "GUILD");
end

function Xavier.Macros.Discipline.AccBan.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Discipline.AccBan.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Discipline.AccBan.addToUnitMenu()
    UnitPopupMenus["Xavier_AccBan"] = {};
    local AccBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.accBan);
    for index,name in pairs(AccBanTemp) do
        table.insert(UnitPopupMenus["Xavier_AccBan"], "Xavier_AccBan_"..name);
        UnitPopupButtons["Xavier_AccBan_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_AccBan"], "Xavier_DisciplineOptions");
	UnitPopupButtons["Xavier_DisciplineOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Discipline.AccBan.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Account Bans";
    UIDropDownMenu_AddButton(info, level);
    
    local AccBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.accBan);
    for index,name in pairs(AccBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Discipline.AccBan.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end










Xavier.Macros.Discipline.IpBan.name = false;
Xavier.Macros.Discipline.IpBan.duration = false;
Xavier.Macros.Discipline.IpBan.reason = false;
Xavier.Macros.Discipline.IpBan.announceToServer = false;

function Xavier.Macros.Discipline.IpBan.processPin1(ip)
	Xavier.Macros.Discipline.IpBan.waitingForPin1 = false;
	Xavier.Macros.Discipline.IpBan.waitingForPin2 = true;
	
	if Xavier.Macros.Discipline.IpBan.announceToServer then
		SendChatMessage('.name '..Xavier.Macros.Discipline.IpBan.name..' has been ip banned for '..Xavier.Macros.Discipline.IpBan.duration..'. Reason: '..Xavier.Macros.Discipline.IpBan.reason, "GUILD");
	end
	SendChatMessage('.gmname '..Xavier.Macros.Discipline.IpBan.name..' has been ip banned ('..ip..') for '..Xavier.Macros.Discipline.IpBan.duration..'. Reason: '..Xavier.Macros.Discipline.IpBan.reason, "GUILD");
	
	SendChatMessage('.ban ip '..ip.." "..Xavier.Macros.Discipline.IpBan.duration.." "..Xavier.Macros.Discipline.IpBan.reason, "GUILD");
	Chronos.unscheduleByName('ipbanprotection');
end

function Xavier.Macros.Discipline.IpBan.fail()
	Xavier.showGMMessage("IP ban on "..Xavier.Macros.Discipline.IpBan.name.." failed. This could be due to server lag. Please try again.");
end

function Xavier.Macros.Discipline.IpBan.run(name, title)
	Xavier.Macros.Discipline.IpBan.waitingForPin1 = true;
	SendChatMessage('.pin '..name, "GUILD");
	Xavier.Macros.Discipline.IpBan.name = name;
	Xavier.Macros.Discipline.IpBan.duration = Xavier_SavedVars.ipBan[title]["duration"];
	Xavier.Macros.Discipline.IpBan.reason = Xavier_SavedVars.ipBan[title]["reason"];
	Xavier.Macros.Discipline.IpBan.announceToServer = Xavier_SavedVars.ipBan[title]["announceToServer"];
	
	Chronos.scheduleByName('ipbanprotection', 2, Xavier.Macros.Discipline.IpBan.fail);
end

function Xavier.Macros.Discipline.IpBan.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Discipline.IpBan.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Discipline.IpBan.addToUnitMenu()
    UnitPopupMenus["Xavier_IpBan"] = {};
    local IpBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.ipBan);
    for index,name in pairs(IpBanTemp) do
        table.insert(UnitPopupMenus["Xavier_IpBan"], "Xavier_IpBan_"..name);
        UnitPopupButtons["Xavier_IpBan_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_IpBan"], "Xavier_DisciplineOptions");
	UnitPopupButtons["Xavier_DisciplineOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Discipline.IpBan.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Ip Bans";
    UIDropDownMenu_AddButton(info, level);
    
    local IpBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.ipBan);
    for index,name in pairs(IpBanTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Discipline.IpBan.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Discipline.showOptions;
    UIDropDownMenu_AddButton(info, level);
end