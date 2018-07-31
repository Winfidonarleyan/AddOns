--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Macros.Mail = {};

Xavier.Macros.Mail.curMailMessage = '';


function Xavier.Macros.Mail.run(name, title)
	local text = Xavier_SavedVars.mail[title].macro;
    local text = string.gsub(text, "NAME", name);
    local lines = {strsplit("\n",text)};
    local subject = Xavier_SavedVars.mail[title].subject;
    
    for index,line in pairs(lines) do
        local command = '.send mail '..name..' "'..subject;
        if #lines > 1 then
            command = command..' '..index..'/'..(#lines);
        end
        local command = command..'" "'..line..'"';
        SendChatMessage(command, "GUILD");
    end
end

function Xavier.Macros.Mail.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Mail.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Mail.addToUnitMenu()
    UnitPopupMenus["Xavier_Mail"] = {};
    local MailTemp = Xavier.pairsByKeys2(Xavier_SavedVars.mail);
    for index,name in pairs(MailTemp) do
        table.insert(UnitPopupMenus["Xavier_Mail"], "Xavier_Mail_"..name);
        UnitPopupButtons["Xavier_Mail_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_Mail"], "Xavier_MailOptions");
	UnitPopupButtons["Xavier_MailOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Mail.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Mail Macros";
    UIDropDownMenu_AddButton(info, level);
    
    local MailTemp = Xavier.pairsByKeys2(Xavier_SavedVars.mail);
    for index,name in pairs(MailTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Mail.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Mail.showOptions;
    UIDropDownMenu_AddButton(info, level);
end