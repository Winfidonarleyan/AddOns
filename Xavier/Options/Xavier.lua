--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

-- ADD TicketTab = "General";

function Xavier.optionsOkay()
	Xavier_SavedVars.GMSyncChannel = Xavier_OptionsWindow_GMSyncChannel:GetText();
	if(Xavier_OptionsWindow_EnableWIMIntergration:GetChecked()) then Xavier_SavedVars.WIMIntegration = true; else Xavier_SavedVars.WIMIntegration = false; end
end

function Xavier.optionsDefault()
    Xavier.setDefault({"WIMIntegration", "GMSyncChannel"});
    Xavier.Tickets.optionsUpdate();
end

function Xavier.optionsOnLoad()
    panel = getglobal("Xavier_OptionsWindow");
	panel.name = "Xavier";
	panel.parent = nil;
	panel.okay = Xavier.optionsOkay;
	panel.cancel = Xavier.optionsUpdate;
	panel.default = Xavier.optionsDefault;
	
	InterfaceOptions_AddCategory(panel);
	
	getglobal("Xavier_OptionsWindow_Title"):SetText("Xavier");
	getglobal("Xavier_OptionsWindow_SubText"):SetText("Here you can change the settings for Xavier.");
    
    Xavier.optionsUpdate();
end

function Xavier.optionsUpdate()
    Xavier_OptionsWindow_GMSyncChannel:SetText(Xavier_SavedVars.GMSyncChannel);
	Xavier_OptionsWindow_EnableWIMIntergration:SetChecked(Xavier_SavedVars.WIMIntegration);
end

function Xavier.showOptions()
	InterfaceOptionsFrame_OpenToCategory("Xavier");
end