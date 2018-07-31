--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Macros.Tele = {};

function Xavier.Macros.Tele.run(name, title)
    if Xavier_SavedVars.tele[title] == "RECALL" then
        SendChatMessage('.recall '..name, "GUILD");
    else
        SendChatMessage('.tele name '..name..' '..Xavier_SavedVars.tele[title], "GUILD");
    end
end

function Xavier.Macros.Tele.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Tele.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Tele.addToUnitMenu()
    UnitPopupMenus["Xavier_Tele"] = {};
    local TeleTemp = Xavier.pairsByKeys2(Xavier_SavedVars.tele);
    for index,name in pairs(TeleTemp) do
        table.insert(UnitPopupMenus["Xavier_Tele"], "Xavier_Tele_"..name);
        UnitPopupButtons["Xavier_Tele_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_Tele"], "Xavier_TeleOptions");
	UnitPopupButtons["Xavier_TeleOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Tele.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Teleport Macros";
    UIDropDownMenu_AddButton(info, level);
    
    local TeleTemp = Xavier.pairsByKeys2(Xavier_SavedVars.tele);
    for index,name in pairs(TeleTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Tele.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Tele.showOptions;
    UIDropDownMenu_AddButton(info, level);
end