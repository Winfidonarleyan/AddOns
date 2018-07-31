--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

function Xavier.Macros.Discipline.optionsOnLoad()
    panel = getglobal("Xavier_Macros_Discipline_OptionsFrame");
	panel.name = "Discipline Macros";
	panel.parent = "Xavier";
	InterfaceOptions_AddCategory(panel);
	
	Xavier_Macros_Discipline_OptionsWindow_Title:SetText("Discipline Macros");
	Xavier_Macros_Discipline_OptionsWindow_SubText:SetText("Here you add and update mute and ban macros, which will be available from the playerinfo window and the player context menus.");
    
    UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Discipline_OptionsWindow_Mute_Dropdownbuttons"), Xavier.Macros.Discipline.Mute.loadOptionsDropdown, "MENU");
	UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Discipline_OptionsWindow_CharBan_Dropdownbuttons"), Xavier.Macros.Discipline.CharBan.loadOptionsDropdown, "MENU");
	UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Discipline_OptionsWindow_AccBan_Dropdownbuttons"), Xavier.Macros.Discipline.AccBan.loadOptionsDropdown, "MENU");
	UIDropDownMenu_Initialize(getglobal("Xavier_Macros_Discipline_OptionsWindow_IpBan_Dropdownbuttons"), Xavier.Macros.Discipline.IpBan.loadOptionsDropdown, "MENU");
end

function Xavier.Macros.Discipline.showOptions()
	InterfaceOptionsFrame_OpenToCategory("Discipline Macros");
end


--Mute
	Xavier.Macros.Discipline.Mute.currentEditing = nil;

	function Xavier.Macros.Discipline.Mute.loadOptionsDropdown()
		local MuteTemp = Xavier.pairsByKeys2(Xavier_SavedVars.mute);
		for index,name in pairs(MuteTemp) do
			info = UIDropDownMenu_CreateInfo();
			info.text = name;
			info.value = name;
			info.func = Xavier.Macros.Discipline.Mute.edit;
			UIDropDownMenu_AddButton(info);
		end
	end

	function Xavier.Macros.Discipline.Mute.edit(self)
		Xavier.Macros.Discipline.Mute.currentEditing = self.value;
		Xavier_Macros_Discipline_OptionsWindow_Mute_Name:SetText(self.value);
		Xavier_Macros_Discipline_OptionsWindow_Mute_Duration:SetText(Xavier_SavedVars.mute[self.value]["duration"]);
		Xavier_Macros_Discipline_OptionsWindow_Mute_Reason:SetText(Xavier_SavedVars.mute[self.value]["reason"]);
		Xavier_Macros_Discipline_OptionsWindow_Mute_AnnounceToServer:SetChecked(Xavier_SavedVars.mute[self.value]["announceToServer"]);
		Xavier_Macros_Discipline_OptionsWindow_Mute_Save:SetText("Save");
		Xavier_Macros_Discipline_OptionsWindow_Mute_Delete:Enable();
	end

	function Xavier.Macros.Discipline.Mute.save()
		local name = Xavier_Macros_Discipline_OptionsWindow_Mute_Name:GetText();
		local duration = Xavier_Macros_Discipline_OptionsWindow_Mute_Duration:GetText();
		local reason = Xavier_Macros_Discipline_OptionsWindow_Mute_Reason:GetText();
		local announceToServer = Xavier_Macros_Discipline_OptionsWindow_Mute_AnnounceToServer:GetChecked();
		
		if name and duration and reason then
			Xavier_SavedVars.mute[name] = {duration=duration, reason=reason, announceToServer=announceToServer};
			
			if Xavier.Macros.Discipline.Mute.currentEditing then
				if (name ~= Xavier.Macros.Discipline.Mute.currentEditing) then
					Xavier_SavedVars.mute[Xavier.Macros.Discipline.Mute.currentEditing] = nil;
					Xavier.Macros.Discipline.Mute.currentEditing = name;
				end
			else
				Xavier.Macros.Discipline.Mute.currentEditing = name;
				Xavier_Macros_Discipline_OptionsWindow_Mute_Save:SetText("Save");
				Xavier_Macros_Discipline_OptionsWindow_Mute_Delete:Enable();
			end
		end
		Xavier.Macros.Discipline.Mute.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.Mute.delete()
		local name = Xavier_Macros_Discipline_OptionsWindow_Mute_Name:GetText();
		
		if name and name ~= "" then
			Xavier_SavedVars.mute[name] = nil;
			Xavier.Macros.Discipline.Mute.cleanForm();
		end
		Xavier.Macros.Discipline.Mute.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.Mute.cleanForm()
		Xavier.Macros.Discipline.Mute.currentEditing = nil;
		Xavier_Macros_Discipline_OptionsWindow_Mute_Name:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_Mute_Duration:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_Mute_Reason:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_Mute_AnnounceToServer:SetChecked(false);
		Xavier_Macros_Discipline_OptionsWindow_Mute_Save:SetText("Add");
		Xavier_Macros_Discipline_OptionsWindow_Mute_Delete:Disable();
	end


--CharBan
	Xavier.Macros.Discipline.CharBan.currentEditing = nil;

	function Xavier.Macros.Discipline.CharBan.loadOptionsDropdown()
		local CharBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.charBan);
		for index,name in pairs(CharBanTemp) do
			info = UIDropDownMenu_CreateInfo();
			info.text = name;
			info.value = name;
			info.func = Xavier.Macros.Discipline.CharBan.edit;
			UIDropDownMenu_AddButton(info);
		end
	end

	function Xavier.Macros.Discipline.CharBan.edit(self)
		Xavier.Macros.Discipline.CharBan.currentEditing = self.value;
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Name:SetText(self.value);
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Duration:SetText(Xavier_SavedVars.charBan[self.value]["duration"]);
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Reason:SetText(Xavier_SavedVars.charBan[self.value]["reason"]);
		Xavier_Macros_Discipline_OptionsWindow_CharBan_AnnounceToServer:SetChecked(Xavier_SavedVars.charBan[self.value]["announceToServer"]);
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Save:SetText("Save");
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Delete:Enable();
	end

	function Xavier.Macros.Discipline.CharBan.save()
		local name = Xavier_Macros_Discipline_OptionsWindow_CharBan_Name:GetText();
		local duration = Xavier_Macros_Discipline_OptionsWindow_CharBan_Duration:GetText();
		local reason = Xavier_Macros_Discipline_OptionsWindow_CharBan_Reason:GetText();
		local announceToServer = Xavier_Macros_Discipline_OptionsWindow_CharBan_AnnounceToServer:GetChecked();
		
		if name and duration and reason then
			Xavier_SavedVars.charBan[name] = {duration=duration, reason=reason, announceToServer=announceToServer};
			
			if Xavier.Macros.Discipline.CharBan.currentEditing then
				if (name ~= Xavier.Macros.Discipline.CharBan.currentEditing) then
					Xavier_SavedVars.charBan[Xavier.Macros.Discipline.CharBan.currentEditing] = nil;
					Xavier.Macros.Discipline.CharBan.currentEditing = name;
				end
			else
				Xavier.Macros.Discipline.CharBan.currentEditing = name;
				Xavier_Macros_Discipline_OptionsWindow_CharBan_Save:SetText("Save");
				Xavier_Macros_Discipline_OptionsWindow_CharBan_Delete:Enable();
			end
		end
		Xavier.Macros.Discipline.CharBan.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.CharBan.delete()
		local name = Xavier_Macros_Discipline_OptionsWindow_CharBan_Name:GetText();
		
		if name and name ~= "" then
			Xavier_SavedVars.charBan[name] = nil;
			Xavier.Macros.Discipline.CharBan.cleanForm();
		end
		Xavier.Macros.Discipline.CharBan.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.CharBan.cleanForm()
		Xavier.Macros.Discipline.CharBan.currentEditing = nil;
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Name:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Duration:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Reason:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_CharBan_AnnounceToServer:SetChecked(false);
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Save:SetText("Add");
		Xavier_Macros_Discipline_OptionsWindow_CharBan_Delete:Disable();
	end


--AccBan
	Xavier.Macros.Discipline.AccBan.currentEditing = nil;

	function Xavier.Macros.Discipline.AccBan.loadOptionsDropdown()
		local AccBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.accBan);
		for index,name in pairs(AccBanTemp) do
			info = UIDropDownMenu_CreateInfo();
			info.text = name;
			info.value = name;
			info.func = Xavier.Macros.Discipline.AccBan.edit;
			UIDropDownMenu_AddButton(info);
		end
	end

	function Xavier.Macros.Discipline.AccBan.edit(self)
		Xavier.Macros.Discipline.AccBan.currentEditing = self.value;
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Name:SetText(self.value);
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Duration:SetText(Xavier_SavedVars.accBan[self.value]["duration"]);
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Reason:SetText(Xavier_SavedVars.accBan[self.value]["reason"]);
		Xavier_Macros_Discipline_OptionsWindow_AccBan_AnnounceToServer:SetChecked(Xavier_SavedVars.accBan[self.value]["announceToServer"]);
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Save:SetText("Save");
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Delete:Enable();
	end

	function Xavier.Macros.Discipline.AccBan.save()
		local name = Xavier_Macros_Discipline_OptionsWindow_AccBan_Name:GetText();
		local duration = Xavier_Macros_Discipline_OptionsWindow_AccBan_Duration:GetText();
		local reason = Xavier_Macros_Discipline_OptionsWindow_AccBan_Reason:GetText();
		local announceToServer = Xavier_Macros_Discipline_OptionsWindow_AccBan_AnnounceToServer:GetChecked();
		
		if name and duration and reason then
			Xavier_SavedVars.accBan[name] = {duration=duration, reason=reason, announceToServer=announceToServer};
			
			if Xavier.Macros.Discipline.AccBan.currentEditing then
				if (name ~= Xavier.Macros.Discipline.AccBan.currentEditing) then
					Xavier_SavedVars.accBan[Xavier.Macros.Discipline.AccBan.currentEditing] = nil;
					Xavier.Macros.Discipline.AccBan.currentEditing = name;
				end
			else
				Xavier.Macros.Discipline.AccBan.currentEditing = name;
				Xavier_Macros_Discipline_OptionsWindow_AccBan_Save:SetText("Save");
				Xavier_Macros_Discipline_OptionsWindow_AccBan_Delete:Enable();
			end
		end
		Xavier.Macros.Discipline.AccBan.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.AccBan.delete()
		local name = Xavier_Macros_Discipline_OptionsWindow_AccBan_Name:GetText();
		
		if name and name ~= "" then
			Xavier_SavedVars.accBan[name] = nil;
			Xavier.Macros.Discipline.AccBan.cleanForm();
		end
		Xavier.Macros.Discipline.AccBan.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.AccBan.cleanForm()
		Xavier.Macros.Discipline.AccBan.currentEditing = nil;
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Name:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Duration:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Reason:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_AccBan_AnnounceToServer:SetChecked(false);
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Save:SetText("Add");
		Xavier_Macros_Discipline_OptionsWindow_AccBan_Delete:Disable();
	end


--IpBan
	Xavier.Macros.Discipline.IpBan.currentEditing = nil;

	function Xavier.Macros.Discipline.IpBan.loadOptionsDropdown()
		local IpBanTemp = Xavier.pairsByKeys2(Xavier_SavedVars.ipBan);
		for index,name in pairs(IpBanTemp) do
			info = UIDropDownMenu_CreateInfo();
			info.text = name;
			info.value = name;
			info.func = Xavier.Macros.Discipline.IpBan.edit;
			UIDropDownMenu_AddButton(info);
		end
	end

	function Xavier.Macros.Discipline.IpBan.edit(self)
		Xavier.Macros.Discipline.IpBan.currentEditing = self.value;
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Name:SetText(self.value);
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Duration:SetText(Xavier_SavedVars.ipBan[self.value]["duration"]);
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Reason:SetText(Xavier_SavedVars.ipBan[self.value]["reason"]);
		Xavier_Macros_Discipline_OptionsWindow_IpBan_AnnounceToServer:SetChecked(Xavier_SavedVars.ipBan[self.value]["announceToServer"]);
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Save:SetText("Save");
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Delete:Enable();
	end

	function Xavier.Macros.Discipline.IpBan.save()
		local name = Xavier_Macros_Discipline_OptionsWindow_IpBan_Name:GetText();
		local duration = Xavier_Macros_Discipline_OptionsWindow_IpBan_Duration:GetText();
		local reason = Xavier_Macros_Discipline_OptionsWindow_IpBan_Reason:GetText();
		local announceToServer = Xavier_Macros_Discipline_OptionsWindow_IpBan_AnnounceToServer:GetChecked();
		
		if name and duration and reason then
			Xavier_SavedVars.ipBan[name] = {duration=duration, reason=reason, announceToServer=announceToServer};
			
			if Xavier.Macros.Discipline.IpBan.currentEditing then
				if (name ~= Xavier.Macros.Discipline.IpBan.currentEditing) then
					Xavier_SavedVars.ipBan[Xavier.Macros.Discipline.IpBan.currentEditing] = nil;
					Xavier.Macros.Discipline.IpBan.currentEditing = name;
				end
			else
				Xavier.Macros.Discipline.IpBan.currentEditing = name;
				Xavier_Macros_Discipline_OptionsWindow_IpBan_Save:SetText("Save");
				Xavier_Macros_Discipline_OptionsWindow_IpBan_Delete:Enable();
			end
		end
		Xavier.Macros.Discipline.IpBan.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.IpBan.delete()
		local name = Xavier_Macros_Discipline_OptionsWindow_IpBan_Name:GetText();
		
		if name and name ~= "" then
			Xavier_SavedVars.ipBan[name] = nil;
			Xavier.Macros.Discipline.IpBan.cleanForm();
		end
		Xavier.Macros.Discipline.IpBan.addToUnitMenu();
	end

	function Xavier.Macros.Discipline.IpBan.cleanForm()
		Xavier.Macros.Discipline.IpBan.currentEditing = nil;
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Name:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Duration:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Reason:SetText("");
		Xavier_Macros_Discipline_OptionsWindow_IpBan_AnnounceToServer:SetChecked(false);
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Save:SetText("Add");
		Xavier_Macros_Discipline_OptionsWindow_IpBan_Delete:Disable();
	end