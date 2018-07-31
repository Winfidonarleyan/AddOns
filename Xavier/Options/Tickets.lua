--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

-- ADD TicketTab = "General";

function Xavier.Tickets.optionsOkay()
	if(Xavier_Tickets_OptionsWindow_swapWindows:GetChecked()) then Xavier_SavedVars.swapTicketWindows = true; else Xavier_SavedVars.swapTicketWindows = false; end
	if(Xavier_Tickets_OptionsWindow_useSpy:GetChecked()) then Xavier_SavedVars.useSpy = true; else Xavier_SavedVars.useSpy = false; end
    
end

function Xavier.Tickets.toggleOfflineTickets()
    if Xavier_SavedVars.showOfflineTickets then
        Xavier_SavedVars.showOfflineTickets = false;
    else
        Xavier_SavedVars.showOfflineTickets = true;
    end
    Xavier.Tickets.optionsUpdate();
    Xavier.Tickets.refresh();
end

function Xavier.Tickets.optionsDefault()
    Xavier.setDefault({"showOfflineTickets", "swapTicketWindows", "useSpy"});
    Xavier.Tickets.optionsUpdate();
end

function Xavier.Tickets.optionsOnLoad()
    panel = getglobal("Xavier_Tickets_OptionsWindow");
	panel.name = "Tickets";
	panel.parent = "Xavier";
	panel.okay = Xavier.Tickets.optionsOkay;
	panel.cancel = Xavier.Tickets.optionsUpdate;
	panel.default = Xavier.Tickets.optionsDefault;
	
	InterfaceOptions_AddCategory(panel);
	
	getglobal("Xavier_Tickets_OptionsWindow_Title"):SetText("Tickets");
	getglobal("Xavier_Tickets_OptionsWindow_SubText"):SetText("Here you can change the settings for the ticket tracker.");
    
    Xavier.Tickets.optionsUpdate();
end

function Xavier.Tickets.optionsUpdate()
    getglobal("Xavier_Tickets_OptionsWindow_showOffline"):SetChecked(Xavier_SavedVars.showOfflineTickets);
    getglobal("Xavier_Tickets_OptionsWindow_swapWindows"):SetChecked(Xavier_SavedVars.swapTicketWindows);
    getglobal("Xavier_Tickets_OptionsWindow_useSpy"):SetChecked(Xavier_SavedVars.useSpy);
end

function Xavier.Tickets.ShowOptions()
	InterfaceOptionsFrame_OpenToCategory("Tickets");
end