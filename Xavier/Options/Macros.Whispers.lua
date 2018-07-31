--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function Xavier.Macros.Whispers.optionsOnLoad()
    panel = getglobal("Xavier_Macros_Whispers_OptionsWindow");
	panel.name = "Whisper Macros";
	panel.parent = "Xavier";
	
	InterfaceOptions_AddCategory(panel);
	
	getglobal(panel:GetName().."_Title"):SetText("Whisper Macros");
	getglobal(panel:GetName().."_SubText"):SetText("Here you add and update whisper macros, which will be available from the ticket interface and the player context menus.");
    Xavier_Macros_Whispers_OptionsWindow_Info_Text:SetText("Note: every newline in the whisper macro will be a separate whisper. It is not possible to have newlines within one whisper.\nNote: If the text in the box turns red that means one of the lines (messages) has become too long and might get cut off when sending a whisper.\n\nTip: use NAME (in full caps) to use the players' name in the whisper text. Use SUBJECT (also in full caps), to get a pop up box where you can enter a subject for the message. SUBJECT in your macro will be replaced by this.");
    
    getglobal("Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text"):SetScript("OnTextChanged", Xavier.Macros.Whispers.updateMacroText);
    
    UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Whispers_OptionsWindow_Dropdownbuttons"), Xavier.Macros.Whispers.loadOptionsDropdown, "MENU");
end

function Xavier.Macros.Whispers.updateMacroText()
    ScrollingEdit_OnTextChanged(getglobal("Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text"), getglobal("Xavier_Macros_Whispers_OptionsWindow_Macro_Frame"));
    Xavier.Macros.Whispers.checkMacroLength();
end

function Xavier.Macros.Whispers.checkMacroLength()
    local macro = Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text:GetText();
    local macro = string.gsub(macro, "NAME", "abcdefghijkl");
    local lines = {strsplit("\n",macro)};
    
    for index,line in pairs(lines) do
        if string.len(line) > 255 then
            Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 0, 0);
        else
            Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetTextColor(255, 255, 255);
        end
    end
end


Xavier.Macros.Whispers.currentEditing = nil;

function Xavier.Macros.Whispers.loadOptionsDropdown()
    local whispersTemp = Xavier.pairsByKeys2(Xavier_SavedVars.whispers);
    for index,name in pairs(whispersTemp) do
        info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = Xavier.Macros.Whispers.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function Xavier.Macros.Whispers.edit(self)
	Xavier.Macros.Whispers.currentEditing = self.value;
	Xavier_Macros_Whispers_OptionsWindow_Name:SetText(self.value);
	Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetText(Xavier_SavedVars.whispers[self.value]);
	Xavier_Macros_Whispers_OptionsWindow_Save:SetText("Save");
	Xavier_Macros_Whispers_OptionsWindow_Delete:Enable();
end

function Xavier.Macros.Whispers.save()
	local name = Xavier_Macros_Whispers_OptionsWindow_Name:GetText();
	local macro = Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text:GetText();
	
	if name and macro and name ~= "" then
		Xavier_SavedVars.whispers[name] = macro;
		
		if Xavier.Macros.Whispers.currentEditing then
			if (name ~= Xavier.Macros.Whispers.currentEditing) then
				Xavier_SavedVars.whispers[Xavier.Macros.Whispers.currentEditing] = nil;
				Xavier.Macros.Whispers.currentEditing = name;
			end
		else
			Xavier.Macros.Whispers.currentEditing = name;
			Xavier_Macros_Whispers_OptionsWindow_Save:SetText("Save");
			Xavier_Macros_Whispers_OptionsWindow_Delete:Enable();
		end
	end
	Xavier.Macros.Whispers.addToUnitMenu();
end

function Xavier.Macros.Whispers.delete()
	local name = Xavier_Macros_Whispers_OptionsWindow_Name:GetText();
	
	if name and name ~= "" then
		Xavier_SavedVars.whispers[name] = nil;
		Xavier.Macros.Whispers.cleanForm();
	end
	Xavier.Macros.Whispers.addToUnitMenu();
end

function Xavier.Macros.Whispers.cleanForm()
	Xavier.Macros.Whispers.currentEditing = nil;
	Xavier_Macros_Whispers_OptionsWindow_Name:SetText("");
	Xavier_Macros_Whispers_OptionsWindow_Macro_Frame_Text:SetText("");
	Xavier_Macros_Whispers_OptionsWindow_Save:SetText("Add");
	Xavier_Macros_Whispers_OptionsWindow_Delete:Disable();
end

function Xavier.Macros.Whispers.showOptions()
	InterfaceOptionsFrame_OpenToCategory("Whisper Macros");
end

function Xavier.Macros.Whispers.test()
    if Xavier.Macros.Whispers.currentEditing then
        Xavier.Macros.Whispers.run(UnitName("player"), Xavier.Macros.Whispers.currentEditing);
    end
end