--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.defaultSettings = {
	["GMSyncChannel"] = "GM_Sync_Channel",
	["whispers"] = {},
	["mail"] = {},
    ["tele"] = {},
    ['objects'] = {},
    ['npcs'] = {},
	['mute'] = {},
	['charBan'] = {},
	['accBan'] = {},
	['ipBan'] = {},
	["WIMIntegration"] = false,
	["useSpy"] = true,
	["swapTicketWindows"] = false,
	["showOfflineTickets"] = false,
    ["minimapPos"] = 45,
    ['hudClosed'] = true,
}

function Xavier.loadSettings()
    for name, value in pairs (Xavier.defaultSettings) do
        if not Xavier_SavedVars[name] then
            Xavier_SavedVars[name] = value;
        end
    end
end

function Xavier.setDefault(names)
    for i, name in ipairs(names) do
        Xavier_SavedVars[name] = Xavier.defaultSettings[name];
    end
end