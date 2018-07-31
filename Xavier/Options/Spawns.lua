--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function Xavier.Spawns.optionsOnLoad()
    panel = getglobal("Xavier_Spawns_OptionsWindow");
	panel.name = "Builder";
	panel.parent = "Xavier";
	
	InterfaceOptions_AddCategory(panel);
	
	getglobal(panel:GetName().."_Title"):SetText("Builder Presets");
	getglobal(panel:GetName().."_SubText"):SetText("Here you add and update preset NPCs and objects, which will be available from the builder interface.");
    
    UIDropDownMenu_Initialize(getglobal("Xavier_Spawns_OptionsWindow_Objects_Dropdownbuttons"), Xavier.Spawns.Objects.loadOptionsDropdown, "MENU");
    UIDropDownMenu_Initialize(getglobal("Xavier_Spawns_OptionsWindow_Npcs_Dropdownbuttons"), Xavier.Spawns.Npcs.loadOptionsDropdown, "MENU");
end

function Xavier.Spawns.showOptions()
	InterfaceOptionsFrame_OpenToCategory("Builder");
end

Xavier.Spawns.Objects = {};

    function Xavier.Spawns.Objects.loadOptionsDropdown()
        local objectsTemp = Xavier.pairsByKeys2(Xavier_SavedVars.objects);
        for index,name in pairs(objectsTemp) do
            info = UIDropDownMenu_CreateInfo();
            info.text = name;
            info.value = name;
            info.func = Xavier.Spawns.Objects.edit;
            UIDropDownMenu_AddButton(info);
        end
    end

    function Xavier.Spawns.Objects.edit(self)
        Xavier.Spawns.Objects.currentEditing = self.value;
        Xavier_Spawns_OptionsWindow_Objects_Id:SetText(Xavier_SavedVars.objects[self.value]);
        Xavier_Spawns_OptionsWindow_Objects_Name:SetText(self.value);
        Xavier_Spawns_OptionsWindow_Objects_Save:SetText("Save");
        Xavier_Spawns_OptionsWindow_Objects_Delete:Enable();
    end

    function Xavier.Spawns.Objects.save()
        local id = Xavier_Spawns_OptionsWindow_Objects_Id:GetText();
        local name = Xavier_Spawns_OptionsWindow_Objects_Name:GetText();
        
        if id and name then
            Xavier_SavedVars.objects[name] = id;
            
            if Xavier.Spawns.Objects.currentEditing then
                if (id ~= Xavier.Spawns.Objects.currentEditing) then
                    Xavier_SavedVars.objects[Xavier.Spawns.Objects.currentEditing] = nil;
                    Xavier.Spawns.Objects.currentEditing = name;
                end
            else
                Xavier.Spawns.Objects.currentEditing = name;
                Xavier_Spawns_OptionsWindow_Objects_Save:SetText("Save");
                Xavier_Spawns_OptionsWindow_Objects_Delete:Enable();
            end
        end
    end

    function Xavier.Spawns.Objects.delete()
        local name = Xavier_Spawns_OptionsWindow_Objects_Name:GetText();
        
        if name and name ~= "" then
            Xavier_SavedVars.objects[name] = nil;
            Xavier.Spawns.Objects.cleanForm();
        end
    end

    function Xavier.Spawns.Objects.cleanForm()
        Xavier.Spawns.Objects.currentEditing = nil;
        Xavier_Spawns_OptionsWindow_Objects_Id:SetText("");
        Xavier_Spawns_OptionsWindow_Objects_Name:SetText("");
        Xavier_Spawns_OptionsWindow_Objects_Save:SetText("Add");
        Xavier_Spawns_OptionsWindow_Objects_Delete:Disable();
    end

Xavier.Spawns.Npcs = {};
    
    function Xavier.Spawns.Npcs.loadOptionsDropdown()
        local npcsTemp = Xavier.pairsByKeys2(Xavier_SavedVars.npcs);
        for index,name in pairs(npcsTemp) do
            info = UIDropDownMenu_CreateInfo();
            info.text = name;
            info.value = name;
            info.func = Xavier.Spawns.Npcs.edit;
            UIDropDownMenu_AddButton(info);
        end
    end
    
    function Xavier.Spawns.Npcs.edit(self)
        Xavier.Spawns.Npcs.currentEditing = self.value;
        Xavier_Spawns_OptionsWindow_Npcs_Id:SetText(Xavier_SavedVars.npcs[self.value]);
        Xavier_Spawns_OptionsWindow_Npcs_Name:SetText(self.value);
        Xavier_Spawns_OptionsWindow_Npcs_Save:SetText("Save");
        Xavier_Spawns_OptionsWindow_Npcs_Delete:Enable();
    end

    function Xavier.Spawns.Npcs.save()
        local id = Xavier_Spawns_OptionsWindow_Npcs_Id:GetText();
        local name = Xavier_Spawns_OptionsWindow_Npcs_Name:GetText();
        
        if id and name then
            Xavier_SavedVars.npcs[name] = id;
            
            if Xavier.Spawns.Npcs.currentEditing then
                if (id ~= Xavier.Spawns.Npcs.currentEditing) then
                    Xavier_SavedVars.npcs[Xavier.Spawns.Npcs.currentEditing] = nil;
                    Xavier.Spawns.Npcs.currentEditing = name;
                end
            else
                Xavier.Spawns.Npcs.currentEditing = name;
                Xavier_Spawns_OptionsWindow_Npcs_Save:SetText("Save");
                Xavier_Spawns_OptionsWindow_Npcs_Delete:Enable();
            end
        end
    end

    function Xavier.Spawns.Npcs.delete()
        local name = Xavier_Spawns_OptionsWindow_Npcs_Name:GetText();
        
        if name and name ~= "" then
            Xavier_SavedVars.npcs[name] = nil;
            Xavier.Spawns.Npcs.cleanForm();
        end
    end

    function Xavier.Spawns.Npcs.cleanForm()
        Xavier.Spawns.Npcs.currentEditing = nil;
        Xavier_Spawns_OptionsWindow_Npcs_Id:SetText("");
        Xavier_Spawns_OptionsWindow_Npcs_Name:SetText("");
        Xavier_Spawns_OptionsWindow_Npcs_Save:SetText("Add");
        Xavier_Spawns_OptionsWindow_Npcs_Delete:Disable();
    end