--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Spawns = {};

Xavier.Spawns.direction = { forwardBackward = 1, leftRight = 1, upDown = 1, rotate = 1};
Xavier.Spawns.waitingForGps = 0;
Xavier.Spawns.waitingForObject = false;
Xavier.Spawns.waitingForObjectDelete = false;
Xavier.Spawns.currentCoords = {};
Xavier.Spawns.macroScheduleTime = 0;

function Xavier.Spawns.onLoad()
    UIDropDownMenu_Initialize(Xavier_Spawns_Main_ForwardBackward_Dropdownbuttons, Xavier.Spawns.loadDropdownForwardBackward, "MENU");
    UIDropDownMenu_Initialize(Xavier_Spawns_Main_LeftRight_Dropdownbuttons, Xavier.Spawns.loadDropdownLeftRight, "MENU");
    UIDropDownMenu_Initialize(Xavier_Spawns_Main_UpDown_Dropdownbuttons, Xavier.Spawns.loadDropdownUpDown, "MENU");
    UIDropDownMenu_Initialize(Xavier_Spawns_Main_Rotate_Dropdownbuttons, Xavier.Spawns.loadDropdownRotate, "MENU");
    UIDropDownMenu_Initialize(Xavier_Spawns_Main_Object_Dropdownbuttons, Xavier.Spawns.loadObjectDropdown, "MENU");
    UIDropDownMenu_Initialize(Xavier_Spawns_Main_Npc_Dropdownbuttons, Xavier.Spawns.loadNpcDropdown, "MENU");
    Xavier.Spawns.Hyperlink.onLoad();
end

function Xavier.Spawns.loadDropdownForwardBackward(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'forward';
    info.func = Xavier.Spawns.setForwardBackward;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'backward';
    info.func = Xavier.Spawns.setForwardBackward;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.setForwardBackward(self)
    CloseDropDownMenus();
    Xavier.Spawns.direction.forwardBackward = self.value;
    Xavier.Spawns.updateView();
end

function Xavier.Spawns.loadDropdownLeftRight(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'left';
    info.func = Xavier.Spawns.setLeftRight;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'right';
    info.func = Xavier.Spawns.setLeftRight;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.setLeftRight(self)
    CloseDropDownMenus();
    Xavier.Spawns.direction.leftRight = self.value;
    Xavier.Spawns.updateView();
end

function Xavier.Spawns.loadDropdownUpDown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'up';
    info.func = Xavier.Spawns.setUpDown;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'down';
    info.func = Xavier.Spawns.setUpDown;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.setUpDown(self)
    CloseDropDownMenus();
    Xavier.Spawns.direction.upDown = self.value;
    Xavier.Spawns.updateView();
end

function Xavier.Spawns.loadDropdownRotate(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Rotate left';
    info.func = Xavier.Spawns.setRotate;
    info.value = 1;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Rotate right';
    info.func = Xavier.Spawns.setRotate;
    info.value = -1;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face north';
    info.func = Xavier.Spawns.setRotate;
    info.value = 0;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face east';
    info.func = Xavier.Spawns.setRotate;
    info.value = 90;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face south';
    info.func = Xavier.Spawns.setRotate;
    info.value = 180;
    UIDropDownMenu_AddButton(info, level);
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Face west';
    info.func = Xavier.Spawns.setRotate;
    info.value = 270;
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.setRotate(self)
    CloseDropDownMenus();
    Xavier.Spawns.direction.rotate = self.value;
    Xavier.Spawns.updateView();
end

function Xavier.Spawns.updateView()
    if Xavier.Spawns.direction.forwardBackward == 1 then
        Xavier_Spawns_Main_ForwardBackward_Direction:SetText('forward');
    else
        Xavier_Spawns_Main_ForwardBackward_Direction:SetText('backward');
    end
    
    if Xavier.Spawns.direction.leftRight == 1 then
        Xavier_Spawns_Main_LeftRight_Direction:SetText('left');
    else
        Xavier_Spawns_Main_LeftRight_Direction:SetText('right');
    end
    
    if Xavier.Spawns.direction.upDown == 1 then
        Xavier_Spawns_Main_UpDown_Direction:SetText('up');
    else
        Xavier_Spawns_Main_UpDown_Direction:SetText('down');
    end
    
    if Xavier.Spawns.direction.rotate == 1 then
        Xavier_Spawns_Main_Rotate_Direction:SetText('Rotate left');
        Xavier_Spawns_Main_Rotate_Amount:Show();
    elseif Xavier.Spawns.direction.rotate == -1 then
        Xavier_Spawns_Main_Rotate_Direction:SetText('Rotate right');
        Xavier_Spawns_Main_Rotate_Amount:Show();
    elseif Xavier.Spawns.direction.rotate == 0 then
        Xavier_Spawns_Main_Rotate_Direction:SetText('Face north');
        Xavier_Spawns_Main_Rotate_Amount:Hide();
    elseif Xavier.Spawns.direction.rotate == 90 then
        Xavier_Spawns_Main_Rotate_Direction:SetText('Face east');
        Xavier_Spawns_Main_Rotate_Amount:Hide();
    elseif Xavier.Spawns.direction.rotate == 180 then
        Xavier_Spawns_Main_Rotate_Direction:SetText('Face south');
        Xavier_Spawns_Main_Rotate_Amount:Hide();
    elseif Xavier.Spawns.direction.rotate == 270 then
        Xavier_Spawns_Main_Rotate_Direction:SetText('Face west');
        Xavier_Spawns_Main_Rotate_Amount:Hide();
    end
    
    if not Xavier.Spawns.currentCoords.x then
        Xavier_Spawns_Main_Coords_X:SetText('X:');
    else
        local x = tostring(Xavier.Spawns.currentCoords.x);
        if string.len(x) > 10 then
            x = string.sub(x, 1, 10);
        end
        Xavier_Spawns_Main_Coords_X:SetText('X: '..x);
    end
    
    if not Xavier.Spawns.currentCoords.y then
        Xavier_Spawns_Main_Coords_Y:SetText('Y:');
    else
        local y = tostring(Xavier.Spawns.currentCoords.y);
        if string.len(y) > 10 then
            y = string.sub(y, 1, 10);
        end
        Xavier_Spawns_Main_Coords_Y:SetText('Y: '..y);
    end
    
    if not Xavier.Spawns.currentCoords.z then
        Xavier_Spawns_Main_Coords_Z:SetText('Z:');
    else
        local z = tostring(Xavier.Spawns.currentCoords.z);
        if string.len(z) > 10 then
            z = string.sub(z, 1, 10);
        end
        Xavier_Spawns_Main_Coords_Z:SetText('Z: '..z);
    end
    
    if not Xavier.Spawns.currentCoords.o then
        Xavier_Spawns_Main_Coords_O:SetText('O:');
    else
        local o = tostring(Xavier.Spawns.currentCoords.o);
        if string.len(o) > 10 then
            o = string.sub(o, 1, 10);
        end
        Xavier_Spawns_Main_Coords_O:SetText('O: '..o);
    end
end

function Xavier.Spawns.clearFocus()
    Xavier_Spawns_Main_ForwardBackward_Amount:ClearFocus();
    Xavier_Spawns_Main_LeftRight_Amount:ClearFocus();
    Xavier_Spawns_Main_UpDown_Amount:ClearFocus();
    Xavier_Spawns_Main_Rotate_Amount:ClearFocus();
    Xavier_Spawns_Main_Npc_Id:ClearFocus();
    Xavier_Spawns_Main_Object_Id:ClearFocus();
    Xavier_Spawns_Macro_Macro_Frame_Text:ClearFocus();
end



function Xavier.Spawns.initiateMove(option)
    Xavier.Spawns.currentSpawnOption = option;
    if not (Xavier.Spawns.currentCoords.x and Xavier.Spawns.currentCoords.y and Xavier.Spawns.currentCoords.z and Xavier.Spawns.currentCoords.o and Xavier.Spawns.currentCoords.map) then
        SendChatMessage(".gps", "GUILD");
        Xavier.Spawns.waitingForGps = 1;
    else
        Xavier.Spawns.move(Xavier.Spawns.currentCoords.x, Xavier.Spawns.currentCoords.y, Xavier.Spawns.currentCoords.z, Xavier.Spawns.currentCoords.o);
    end
    Xavier.Spawns.clearFocus();
end

function Xavier.Spawns.setMap(map)
    Xavier.Spawns.currentCoords.map = map;
end

function Xavier.Spawns.move(x, y, z, o)
    
    local forwardBackward = Xavier_Spawns_Main_ForwardBackward_Amount:GetText();
    if not forwardBackward or forwardBackward == "" then
        forwardBackward = 0;
    end
    local leftRight = Xavier_Spawns_Main_LeftRight_Amount:GetText();
    if not leftRight or leftRight == "" then
        leftRight = 0;
    end
    local upDown = Xavier_Spawns_Main_UpDown_Amount:GetText();
    if not upDown or upDown == "" then
        upDown = 0;
    end
    local rotate = Xavier_Spawns_Main_Rotate_Amount:GetText();
    if not rotate or rotate == "" then
        rotate = 0;
    end
    
    forwardBackward = tonumber(forwardBackward) * Xavier.Spawns.direction.forwardBackward;
    leftRight = tonumber(leftRight) * Xavier.Spawns.direction.leftRight;
    upDown = tonumber(upDown);
    rotate = tonumber(rotate);
    
    x = tonumber(x);
    y = tonumber(y);
    z = tonumber(z);
    o = deg(tonumber(o));
    
    if Xavier.Spawns.currentSpawnOption == -1 then
        forwardBackward = -1 * forwardBackward;
        leftRight = -1 * leftRight;
        upDown = -1 * upDown;
        rotate = -1 * rotate;
    elseif Xavier.Spawns.currentSpawnOption == 1 then
        Chronos.scheduleByName('spawnobject', 0.25, Xavier.Spawns.object, Xavier_Spawns_Main_Object_Id:GetText());
    elseif Xavier.Spawns.currentSpawnOption == 2 then
        Chronos.scheduleByName('spawnnpc', 0.25, Xavier.Spawns.npc, Xavier_Spawns_Main_Npc_Id:GetText());
    end
    
    local tempO = o;
    if Xavier.Spawns.currentSpawnOption == -1 then
        if Xavier.Spawns.direction.rotate == 1 or Xavier.Spawns.direction.rotate == -1 then
            tempO = o + (rotate *Xavier.Spawns.direction.rotate);
        else
            tempO = Xavier.Spawns.direction.rotate;
        end
    end
    
    x = x + ((cos(tempO)*forwardBackward)+(cos(270-tempO)*leftRight));
    y = y + ((sin(tempO)*forwardBackward)-(sin(270-tempO)*leftRight));
    z = z + (upDown * Xavier.Spawns.direction.upDown);
    
    if Xavier.Spawns.direction.rotate == 1 or Xavier.Spawns.direction.rotate == -1 then
        o = o + (rotate * Xavier.Spawns.direction.rotate);
    else
        o = Xavier.Spawns.direction.rotate;
    end
    
    o = rad(o);
    
    Xavier.Spawns.currentCoords.x = x;
    Xavier.Spawns.currentCoords.y = y;
    Xavier.Spawns.currentCoords.z = z;
    Xavier.Spawns.currentCoords.o = o;
    
    SendChatMessage(".go xyz "..x.." "..y.." "..z.." "..Xavier.Spawns.currentCoords.map.." "..o, "GUILD");
    Xavier.Spawns.updateView();
end

function Xavier.Spawns.object(objectId)
    if not objectId or objectId == "" then
        return false;
    end
    objectId = tonumber(objectId);
    
    SendChatMessage(".gobject add "..objectId, "GUILD");
end

function Xavier.Spawns.npc(npcId)
    if not npcId or npcId == "" then
        return false;
    end
    npcId = tonumber(npcId);
    
    SendChatMessage(".npc add temp "..npcId, "GUILD");
end

function Xavier.Spawns.resetCoords()
    Xavier.Spawns.currentCoords = {};
    Xavier.Spawns.updateView();
end

function Xavier.Spawns.targetObject()
    Xavier.Spawns.waitingForObject = true;
    SendChatMessage(".gobject target", "GUILD");
end

function Xavier.Spawns.deleteObject(name, guid, id)
    Xavier.Spawns.waitingForObjectDelete = true;
    SendChatMessage(".gobject del "..guid, "GUILD");
    Xavier.showGMMessage("Deleting object: "..name.." GUID: "..guid.." ID: "..id);
end

function Xavier.Spawns.deleteNpc()
    SendChatMessage(".npc del");
end

function Xavier.Spawns.toggleMacroWindow()
    local frame = Xavier_Spawns_Macro;
    if frame:IsVisible() then
        frame:Hide();
    else
        frame:Show();
    end
end

function Xavier.Spawns.scheduleGo(forwardBackward, leftRight, upDown, rotate, rotateDir, option, id)
    Chronos.schedule(Xavier.Spawns.macroScheduleTime, Xavier.Spawns.go, forwardBackward, leftRight, upDown, rotate, rotateDir, option, id)
    Xavier.Spawns.macroScheduleTime = 1 + Xavier.Spawns.macroScheduleTime;
end

function Xavier.Spawns.go(forwardBackward, leftRight, upDown, rotate, rotateDir, option, id)
    Xavier.Spawns.direction = { forwardBackward = 1, leftRight = 1, upDown = 1, rotate = rotateDir};
    Xavier_Spawns_Main_ForwardBackward_Amount:SetText(forwardBackward);
    Xavier_Spawns_Main_LeftRight_Amount:SetText(leftRight);
    Xavier_Spawns_Main_UpDown_Amount:SetText(upDown);
    Xavier_Spawns_Main_Rotate_Amount:SetText(rotate);
    
    Xavier_Spawns_Main_Object_Id:SetText("");
    Xavier_Spawns_Main_Npc_Id:SetText("");
    if option == 1 then
        Xavier_Spawns_Main_Object_Id:SetText(id);
    elseif option == 2 then
        Xavier_Spawns_Main_Npc_Id:SetText(id);
    end
    
    Xavier.Spawns.updateView();
    Xavier.Spawns.clearFocus();
    
    Xavier.Spawns.initiateMove(option);
    
    Xavier.Spawns.macroScheduleTime = 2 + Xavier.Spawns.macroScheduleTime;
end

function Xavier.Spawns.runMacro()
    Xavier.Spawns.macroScheduleTime = 0;
    local macroText = Xavier_Spawns_Macro_Macro_Frame_Text:GetText();
    macroText = string.gsub(macroText, "go", "Xavier.Spawns.scheduleGo");
    Xavier.showGMMessage("Running spawn macro, do not interfere!");
    RunScript(macroText);
end

function Xavier.Spawns.toggle()
    local frame = Xavier_Spawns_Main;
    if frame:IsVisible() then
        frame:Hide();
    else
        frame:Show();
    end
end

function Xavier.Spawns.loadObjectDropdown(self, level)
    local objectsTemp = Xavier.pairsByKeys2(Xavier_SavedVars.objects);
    for index,name in pairs(objectsTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Spawns.selectObject;
        info.value = Xavier_SavedVars.objects[name];
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Presets";
    info.func = Xavier.Spawns.showOptions;
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.loadNpcDropdown(self, level)
    local npcsTemp = Xavier.pairsByKeys2(Xavier_SavedVars.npcs);
    for index,name in pairs(npcsTemp) do
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = name;
        info.func = Xavier.Spawns.selectNpc;
        info.value = Xavier_SavedVars.npcs[name];
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = "Manage Presets";
    info.func = Xavier.Spawns.showOptions;
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.selectObject(self)
    CloseDropDownMenus();
    Xavier_Spawns_Main_Object_Id:SetText(self.value);
end

function Xavier.Spawns.selectNpc(self)
    CloseDropDownMenus();
    Xavier_Spawns_Main_Npc_Id:SetText(self.value);
end


Xavier.Spawns.Hyperlink = {};
Xavier.Spawns.Hyperlink.name = '';
Xavier.Spawns.Hyperlink.id = '';
Xavier.Spawns.Hyperlink.type = '';

function Xavier.Spawns.Hyperlink.onLoad()
    UIDropDownMenu_Initialize(Xavier_Spawns_Hyperlink_Menu, Xavier.Spawns.Hyperlink.loadMenu, "MENU");
end

function Xavier.Spawns.Hyperlink.loadMenu(self, level)
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.isTitle = true;
    info.text = Xavier.Spawns.Hyperlink.name;
    info.fontObject = GenieFontNormalSmall;
    UIDropDownMenu_AddButton(info, level);
    
    if Xavier.Spawns.Hyperlink.type == "gameobject_entry" or Xavier.Spawns.Hyperlink.type == "creature_entry" then
        if Xavier.Spawns.Hyperlink.type == "gameobject_entry" then
            name = 'gameobject';
        else
            name = 'creature';
        end
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Spawn '.. name ..' here';
        info.func = Xavier.Spawns.Hyperlink.spawnHere;
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Add '.. name ..' to presets';
        info.func = Xavier.Spawns.Hyperlink.addPreset;
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'List spawned '.. name ..'    123s';
        info.func = Xavier.Spawns.Hyperlink.list;
        UIDropDownMenu_AddButton(info, level);
    elseif Xavier.Spawns.Hyperlink.type == "gameobject" or Xavier.Spawns.Hyperlink.type == "creature" then
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Go to '..Xavier.Spawns.Hyperlink.type;
        info.func = Xavier.Spawns.Hyperlink.goTo;
        UIDropDownMenu_AddButton(info, level);
        
        local info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false;
        info.notCheckable = true;
        info.text = 'Remove '..Xavier.Spawns.Hyperlink.type;
        info.func = Xavier.Spawns.Hyperlink.remove;
        UIDropDownMenu_AddButton(info, level);
    end
    
    local info = UIDropDownMenu_CreateInfo();
    info.hasArrow = false;
    info.notCheckable = true;
    info.text = 'Close menu';
    UIDropDownMenu_AddButton(info, level);
end

function Xavier.Spawns.Hyperlink.spawnHere()
    if Xavier.Spawns.Hyperlink.type == "gameobject_entry" then
        SendChatMessage(".gob add "..Xavier.Spawns.Hyperlink.id, "GUILD");
    elseif Xavier.Spawns.Hyperlink.type == "creature_entry" then
        SendChatMessage(".npc add temp "..Xavier.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not spawn link type "..Xavier.Spawns.Hyperlink.type);
    end
end

function Xavier.Spawns.Hyperlink.addPreset()
    if Xavier.Spawns.Hyperlink.type == "gameobject_entry" then
        Xavier_SavedVars.objects[Xavier.Spawns.Hyperlink.name] = Xavier.Spawns.Hyperlink.id;
    elseif Xavier.Spawns.Hyperlink.type == "creature_entry" then
        Xavier_SavedVars.npcs[Xavier.Spawns.Hyperlink.name] = Xavier.Spawns.Hyperlink.id;
    else
        GMGnie.showGMMessage("Could not add preset for link type "..Xavier.Spawns.Hyperlink.type);
    end
end

function Xavier.Spawns.Hyperlink.list()
    if Xavier.Spawns.Hyperlink.type == "gameobject_entry" then
        SendChatMessage(".list object "..Xavier.Spawns.Hyperlink.id, "GUILD");
    elseif Xavier.Spawns.Hyperlink.type == "creature_entry" then
        SendChatMessage(".list creature "..Xavier.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not list link type "..Xavier.Spawns.Hyperlink.type);
    end
end

function Xavier.Spawns.Hyperlink.goTo()
    if Xavier.Spawns.Hyperlink.type == "gameobject" then
        SendChatMessage(".go object "..Xavier.Spawns.Hyperlink.id, "GUILD");
    elseif Xavier.Spawns.Hyperlink.type == "creature" then
        SendChatMessage(".go creature "..Xavier.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not port to link type "..Xavier.Spawns.Hyperlink.type);
    end
end

function Xavier.Spawns.Hyperlink.remove()
    if Xavier.Spawns.Hyperlink.type == "gameobject" then
        SendChatMessage(".gob delete "..Xavier.Spawns.Hyperlink.id, "GUILD");
    elseif Xavier.Spawns.Hyperlink.type == "creature" then
        SendChatMessage(".npc delete "..Xavier.Spawns.Hyperlink.id, "GUILD");
    else
        GMGnie.showGMMessage("Could not remove link type "..Xavier.Spawns.Hyperlink.type);
    end
end

function Xavier.Spawns.Hyperlink.toggle(link, text)
	if not link or link == Xavier.Spawns.Hyperlink.link then
		Xavier.Spawns.Hyperlink.name = '';
		Xavier.Spawns.Hyperlink.id = '';
		Xavier.Spawns.Hyperlink.type = '';
	else
		local type, id = strsplit(":", link);
		Xavier.Spawns.Hyperlink.type = type;
		Xavier.Spawns.Hyperlink.id = id;
		Xavier.Spawns.Hyperlink.name = string.match(text, "%[(.*)%]");
	end
    ToggleDropDownMenu(1, nil, Xavier_Spawns_Hyperlink_Menu, 'cursor', 0, 0);
end

local Saved_SetItemRef = SetItemRef;
function SetItemRef(link, text, button, chatFrame)
	if ( strsub(link, 1, 16) == "gameobject_entry" ) or ( strsub(link, 1, 14) == "creature_entry" ) or  (strsub(link, 1, 10) == "gameobject") or (strsub(link, 1, 8) == "creature") then
		Xavier.Spawns.Hyperlink.toggle(link, text);
		return;
	end
	Saved_SetItemRef(link, text, button, chatFrame);
end

-- add slash command to open/close builder widnow
SLASH_SPAWNS1 = "/builder";
SLASH_SPAWNS2 = "/spawns";
SlashCmdList["SPAWNS"] = Xavier.Spawns.toggle;