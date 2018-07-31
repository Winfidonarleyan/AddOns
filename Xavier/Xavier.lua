--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier = {};
Xavier_SavedVars = {};

function Xavier.showGMMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[Xavier]|cff6C8CD5: "..msg);
end

function Xavier.pairsByKeys (t, f)
	local a = {}
	local b = {}
	for n in pairs (t) do
		table.insert (a, n);
	end
	table.sort (a, f);
	for name,value in pairs(a) do
		table.insert (b, t[value]);
	end
	return b;
end

function Xavier.pairsByKeys2 (t, f)
	local a = {}
	local b = {}
	for n in pairs (t) do
		table.insert (a, n);
	end
	table.sort (a, f);
	for name,value in pairs(a) do
		table.insert (b, value);
	end
	return b;
end

function Xavier.onLoad()
    Xavier.loadSettings();
    
    Xavier.Hud.onLoad();
    
    Xavier.Macros.onLoad();
    Xavier.Spawns.onLoad();
    
    UIDropDownMenu_Initialize(Xavier_Spy_InfoWindow_DropdownbuttonsTwo, Xavier.Spy.loadDropdown, "MENU");
    
    Xavier.optionsOnLoad();
    Xavier.Tickets.optionsOnLoad();
    Xavier.Macros.Whispers.optionsOnLoad();
    Xavier.Macros.Mail.optionsOnLoad();
    Xavier.Macros.Tele.optionsOnLoad();
	Xavier.Macros.Discipline.optionsOnLoad()
    Xavier.Spawns.optionsOnLoad();
    
    Xavier.minimap.reposition();
    Xavier.Tickets.onLoad();
    
    -- Please do not remove the copyright notice, it would be a violation of the gpl.
    Xavier.showGMMessage("Аддон Включен. Переработан Каргатом.");
end

local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Xavier" then
        Xavier.onLoad();
    end
end
frame:SetScript("OnEvent", frame.OnEvent);

Xavier.minimap = {};

-- add this to your SavedVariables or as a separate SavedVariable to store its position


-- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function Xavier.minimap.reposition()
	Xavier_Minimap:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(Xavier_SavedVars.minimapPos)),(80*sin(Xavier_SavedVars.minimapPos))-52)
end

-- Only while the button is dragged this is called every frame
function Xavier.minimap.draggingFrame_OnUpdate()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	Xavier_SavedVars.minimapPos = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	Xavier.minimap.reposition() -- move the button
end

function Xavier.loadWindow(window, title, refresh, refreshScript)
    local name = window:GetName();
    window:RegisterForClicks("LeftButtonUp","RightButtonUp");
    getglobal(name.."_Title_Text"):SetText(title);
    if refresh then
        getglobal(name..'_Refresh'):Show();
        getglobal(name..'_Title'):SetWidth(window:GetWidth() - 32);
        if refreshScript then
            getglobal(name..'_Refresh'):SetScript("OnClick", refreshScript);
        end
    else
        getglobal(name..'_Refresh'):Hide();
        getglobal(name..'_Title'):SetWidth(window:GetWidth() - 16);
    end
    
    getglobal(name..'_Main'):SetWidth(window:GetWidth());
    getglobal(name..'_Main'):SetHeight(window:GetHeight() - 14);
end

function Xavier.loadEditBox(window)
    local name = window:GetName();
    
    getglobal(name..'_Frame_Text'):SetTextInsets(5, 5, 5, 5);
    getglobal(name..'_Frame'):SetWidth(window:GetWidth());
    getglobal(name..'_Frame'):SetHeight(window:GetHeight());
    getglobal(name..'_Frame_Text'):SetWidth(getglobal(name..'_Frame'):GetWidth());
    getglobal(name..'_Frame_Text'):SetHeight(getglobal(name..'_Frame'):GetHeight());
end