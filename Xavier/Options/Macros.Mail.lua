--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function Xavier.Macros.Mail.optionsOnLoad()
    panel = getglobal("Xavier_Macros_Mail_OptionsWindow");
	panel.name = "Mail Macros";
	panel.parent = "Xavier";
	
	InterfaceOptions_AddCategory(panel);
	
	getglobal(panel:GetName().."_Title"):SetText("Mail Macros");
	getglobal(panel:GetName().."_SubText"):SetText("Here you add and update mail macros, which will be available from the ticket interface and the player context menus.");
    Xavier_Macros_Mail_OptionsWindow_Info_Text:SetText("Note: every newline in the mail macro will be a separate mail. It is not possible to have newlines within one mail.\nNote: If the text in the box turns red that means one of the lines (messages) has become too long and might get cut off when sending a mail.\n\nTip: use NAME (in full caps) to use the players' name in the mail text.");
    
    getglobal("Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text"):SetScript("OnTextChanged", Xavier.Macros.Mail.updateMacroText);
    
    UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Mail_OptionsWindow_Dropdownbuttons"), Xavier.Macros.Mail.loadOptionsDropdown, "MENU");
end

function Xavier.Macros.Mail.updateMacroText()
    ScrollingEdit_OnTextChanged(getglobal("Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text"), getglobal("Xavier_Macros_Mail_OptionsWindow_Macro_Frame"));
    Xavier.Macros.Mail.checkMacroLength();
end

function Xavier.Macros.Mail.checkMacroLength()
    local macro = Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text:GetText();
    local macro = string.gsub(macro, "NAME", "abcdefghijkl");
    local lines = {strsplit("\n",macro)};
    
    local maxlength = 226 - string.len(Xavier_Macros_Mail_OptionsWindow_Subject:GetText());
    if #lines > 1 then
        maxlength = maxlength - 4;
    end
    for index,line in pairs(lines) do
        if string.len(line) > maxlength then
            Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 0, 0);
        else
            Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 255, 255);
        end
    end
end

Xavier.Macros.Mail.currentEditing = nil;

function Xavier.Macros.Mail.loadOptionsDropdown()
    local MailTemp = Xavier.pairsByKeys2(Xavier_SavedVars.mail);
    for index,name in pairs(MailTemp) do
        info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = Xavier.Macros.Mail.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function Xavier.Macros.Mail.test()
    if Xavier.Macros.Mail.currentEditing then
        Xavier.Macros.Mail.run(UnitName("player"), Xavier.Macros.Mail.currentEditing);
    end
end

function Xavier.Macros.Mail.edit(self)
	Xavier.Macros.Mail.currentEditing = self.value;
	Xavier_Macros_Mail_OptionsWindow_Name:SetText(self.value);
    Xavier_Macros_Mail_OptionsWindow_Subject:SetText(Xavier_SavedVars.mail[self.value]["subject"]);
	Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetText(Xavier_SavedVars.mail[self.value]["macro"]);
	Xavier_Macros_Mail_OptionsWindow_Save:SetText("Save");
	Xavier_Macros_Mail_OptionsWindow_Delete:Enable();
end

function Xavier.Macros.Mail.save()
	local name = Xavier_Macros_Mail_OptionsWindow_Name:GetText();
    local subject = Xavier_Macros_Mail_OptionsWindow_Subject:GetText();
	local macro = Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text:GetText();
	
	if name and macro and subject and name ~= "" then
		Xavier_SavedVars.mail[name] = {macro=macro, subject=subject};
		
		if Xavier.Macros.Mail.currentEditing then
			if (name ~= Xavier.Macros.Mail.currentEditing) then
				Xavier_SavedVars.mail[Xavier.Macros.Mail.currentEditing] = nil;
				Xavier.Macros.Mail.currentEditing = name;
			end
		else
			Xavier.Macros.Mail.currentEditing = name;
			Xavier_Macros_Mail_OptionsWindow_Save:SetText("Save");
			Xavier_Macros_Mail_OptionsWindow_Delete:Enable();
		end
	end
	Xavier.Macros.Mail.addToUnitMenu();
end

function Xavier.Macros.Mail.delete()
	local name = Xavier_Macros_Mail_OptionsWindow_Name:GetText();
	
	if name and name ~= "" then
		Xavier_SavedVars.mail[name] = nil;
		Xavier.Macros.Mail.cleanForm();
	end
	Xavier.Macros.Mail.addToUnitMenu();
end

function Xavier.Macros.Mail.cleanForm()
	Xavier.Macros.Mail.currentEditing = nil;
	Xavier_Macros_Mail_OptionsWindow_Name:SetText("");
	Xavier_Macros_Mail_OptionsWindow_Subject:SetText("");
	Xavier_Macros_Mail_OptionsWindow_Macro_Frame_Text:SetText("");
	Xavier_Macros_Mail_OptionsWindow_Save:SetText("Add");
	Xavier_Macros_Mail_OptionsWindow_Delete:Disable();
end

function Xavier.Macros.Mail.showOptions()
	InterfaceOptionsFrame_OpenToCategory("Mail Macros");
end