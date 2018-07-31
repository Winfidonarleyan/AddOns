--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Macros.Whispers = {};

Xavier.Macros.Whispers.curWhisperMessage = '';


function Xavier.Macros.Whispers.run(name, title)
	Xavier_Macros_Whispers_SubjectPopup:Hide();
	Xavier_Macros_Whispers_SubjectPopup_Subject:SetText('');
	local msg = string.gsub(Xavier_SavedVars.whispers[title], "NAME", name);
	if string.find(msg, "SUBJECT") then
		Xavier.Macros.Whispers.curWhisperMessage = msg;
        Xavier.Macros.Whispers.curName = name;
		Xavier_Macros_Whispers_SubjectPopup:Show();
		Xavier_Macros_Whispers_SubjectPopup_Subject:SetFocus();
	else
		args = {strsplit("\n",msg)};
		for index,text in pairs(args) do
			SendChatMessage(text, "WHISPER", nil, name);
		end
	end
end

function Xavier.Macros.Whispers.runFromSpy(self)
    CloseDropDownMenus();
    if Xavier.Spy.currentRequest["name"] then
        Xavier.Macros.Whispers.run(Xavier.Spy.currentRequest["name"], self.value);
    end
end

function Xavier.Macros.Whispers.sendWithSubject()
	Xavier_Macros_Whispers_SubjectPopup:Hide();
	local subject = Xavier_Macros_Whispers_SubjectPopup_Subject:GetText();
	Xavier_Macros_Whispers_SubjectPopup_Subject:SetText('');
	
	local msg = string.gsub(Xavier.Macros.Whispers.curWhisperMessage, "SUBJECT", subject);
	args = {strsplit("\n",msg)};
	for index,text in pairs(args) do
		SendChatMessage(text, "WHISPER", nil, Xavier.Macros.Whispers.curName);
	end
	
	Xavier.Macros.Whispers.curWhisperMessage = '';
end

function Xavier.Macros.Whispers.addToUnitMenu()
    UnitPopupMenus["Xavier_Whispers"] = {};
    
    local whispersTemp = Xavier.pairsByKeys2(Xavier_SavedVars.whispers);
    for index,name in pairs(whispersTemp) do
        table.insert(UnitPopupMenus["Xavier_Whispers"], "Xavier_Whispers_"..name);
        UnitPopupButtons["Xavier_Whispers_"..name] = { text = name, dist = 0,};
    end
    
    table.insert(UnitPopupMenus["Xavier_Whispers"], "Xavier_WhisperOptions");
	UnitPopupButtons["Xavier_WhisperOptions"] = { text = "Manage macros", dist = 0,};
end

function Xavier.Macros.Whispers.loadDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = "Whisper Macros";
    UIDropDownMenu_AddButton(info, level);
    
    local whispersTemp = Xavier.pairsByKeys2(Xavier_SavedVars.whispers);
    for index,name in pairs(whispersTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Macros.Whispers.runFromSpy;
        info.value = name;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Macros";
    info.func = Xavier.Macros.Whispers.showOptions;
    UIDropDownMenu_AddButton(info, level);
end