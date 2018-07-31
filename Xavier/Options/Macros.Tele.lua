--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function Xavier.Macros.Tele.optionsOnLoad()
    panel = getglobal("Xavier_Macros_Tele_OptionsWindow");
	panel.name = "Teleport Macros";
	panel.parent = "Xavier";
	
	InterfaceOptions_AddCategory(panel);
	
	getglobal(panel:GetName().."_Title"):SetText("Teleport Macros");
	getglobal(panel:GetName().."_SubText"):SetText("Here you add and update teleport macros, which will be available from the ticket interface and the player context menus.");
    
    Xavier_Macros_Tele_OptionsWindow_Info_Text:SetText("Tip: use RECALL (in full caps) as the location to return a player to wherever they were before they were teleported or summoned by a GM.");
    
    UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Tele_OptionsWindow_Dropdownbuttons"), Xavier.Macros.Tele.loadOptionsDropdown, "MENU");
end

Xavier.Macros.Tele.currentEditing = nil;

function Xavier.Macros.Tele.loadOptionsDropdown()
    local TeleTemp = Xavier.pairsByKeys2(Xavier_SavedVars.tele);
    for index,name in pairs(TeleTemp) do
        info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.value = name;
        info.func = Xavier.Macros.Tele.edit;
        UIDropDownMenu_AddButton(info);
    end
end

function Xavier.Macros.Tele.test()
    if Xavier.Macros.Tele.currentEditing then
        Xavier.Macros.Tele.run(UnitName("player"), Xavier.Macros.Tele.currentEditing);
    end
end

function Xavier.Macros.Tele.edit(self)
	Xavier.Macros.Tele.currentEditing = self.value;
	Xavier_Macros_Tele_OptionsWindow_Name:SetText(self.value);
    Xavier_Macros_Tele_OptionsWindow_Location:SetText(Xavier_SavedVars.tele[self.value]);
	Xavier_Macros_Tele_OptionsWindow_Save:SetText("Save");
	Xavier_Macros_Tele_OptionsWindow_Delete:Enable();
end

function Xavier.Macros.Tele.save()
	local name = Xavier_Macros_Tele_OptionsWindow_Name:GetText();
    local location = Xavier_Macros_Tele_OptionsWindow_Location:GetText();
	
	if name and location then
		Xavier_SavedVars.tele[name] = location;
		
		if Xavier.Macros.Tele.currentEditing then
			if (name ~= Xavier.Macros.Tele.currentEditing) then
				Xavier_SavedVars.tele[Xavier.Macros.Tele.currentEditing] = nil;
				Xavier.Macros.Tele.currentEditing = name;
			end
		else
			Xavier.Macros.Tele.currentEditing = name;
			Xavier_Macros_Tele_OptionsWindow_Save:SetText("Save");
			Xavier_Macros_Tele_OptionsWindow_Delete:Enable();
		end
	end
	Xavier.Macros.Tele.addToUnitMenu();
end

function Xavier.Macros.Tele.delete()
	local name = Xavier_Macros_Tele_OptionsWindow_Name:GetText();
	
	if name and name ~= "" then
		Xavier_SavedVars.tele[name] = nil;
		Xavier.Macros.Tele.cleanForm();
	end
	Xavier.Macros.Tele.addToUnitMenu();
end

function Xavier.Macros.Tele.cleanForm()
	Xavier.Macros.Tele.currentEditing = nil;
	Xavier_Macros_Tele_OptionsWindow_Name:SetText("");
	Xavier_Macros_Tele_OptionsWindow_Location:SetText("");
	Xavier_Macros_Tele_OptionsWindow_Save:SetText("Add");
	Xavier_Macros_Tele_OptionsWindow_Delete:Disable();
end

function Xavier.Macros.Tele.showOptions()
	InterfaceOptionsFrame_OpenToCategory("Teleport Macros");
end