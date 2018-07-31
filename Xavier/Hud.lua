--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Hud = {};

function Xavier.Hud.onLoad()
    Xavier_Hud:RegisterEvent("PLAYER_ENTERING_WORLD");
    Xavier_Hud:RegisterEvent("UI_ERROR_MESSAGE");
    Xavier_Hud:SetScript("OnEvent", Xavier.Hud.readNotice);
    
    Xavier_Hud_Whisper:SetAttribute("macrotext1", "/run Xavier.Hud.toggleWhisper();");
    Xavier_Hud_Fly:SetAttribute("macrotext1", "/target ".. UnitName("player") .." \n/run Xavier.Hud.toggleFly();");
    
    if Xavier_SavedVars.hudClosed then
        Xavier.Hud.toggle();
    end
    
    Chronos.schedule(1, Xavier.Hud.checkStatus);
    Xavier.Hud.flyStatus(false);
end

function Xavier.Hud.toggle()
    if Xavier_Hud:IsVisible() then
        Xavier_Hud:Hide();
        Xavier_SavedVars.hudClosed = true;
    else
        Xavier_Hud:Show();
        Xavier_SavedVars.hudClosed = false;
    end
end

--------------------------------------------------
------------ HUD status functionality ------------
--------------------------------------------------
local LSM = LibStub("LibSharedMedia-3.0")

function Xavier.Hud.checkStatus()
    SendChatMessage(".gm", "GUILD");
    SendChatMessage(".gm chat", "GUILD");
    SendChatMessage(".gm visible", "GUILD");
    SendChatMessage(".whispers", "GUILD");
end

function Xavier.Hud.whisperStatus(status)
    Xavier.Hud.whisper = status;
    if status then
        Xavier_Hud_Whisper:SetText("    |cffffffffЛС |cFFFF0000ON|r");
    else
        Xavier_Hud_Whisper:SetText("    |cffffffffЛС OFF|r");
    end
end

function Xavier.Hud.flyStatus(status)
    Xavier.Hud.fly = status;
    if status then
        Xavier_Hud_Fly:SetText("  |cffffffffРежим полёта |cFFFF0000on|r");
    else
        Xavier_Hud_Fly:SetText("  |cffffffffРежим полёта off|r");
    end
end

function Xavier.Hud.readNotice(self, event, notice)
    if event == "UI_ERROR_MESSAGE" then
        if notice == "Режим ГМ включен" then
            Xavier.Hud.gmStatus(true);
        elseif notice == "Режим ГМ выключен" then
            Xavier.Hud.gmStatus(false);
        elseif notice == "ГМ тэг для чата включен" then 
            Xavier.Hud.chatStatus(true);
        elseif notice == "ГМ тэг для чата выключен" then 
            Xavier.Hud.chatStatus(false);
        elseif notice == "Теперь вы видимы." then 
            Xavier.Hud.visibilityStatus(true);
        elseif notice == "Теперь вы невидимы." then
            Xavier.Hud.visibilityStatus(false);
            Xavier.Hud.toggleWhisper(Xavier.Hud.whisper);
        end
    elseif event =="PLAYER_ENTERING_WORLD" and Xavier.Hud.fly == true then
        Xavier.Hud.toggleFly(Xavier.Hud.fly);
    end
end

function Xavier.Hud.toggleGm()
        SendChatMessage(".gm on", "GUILD");
    end

function Xavier.Hud.toggleGmoff()
        SendChatMessage(".gm off", "GUILD");
    end

function Xavier.Hud.togglechat()
        SendChatMessage(".gm chat on", "GUILD");
    end

function Xavier.Hud.togglegsum()
        SendChatMessage(".groupsum", "GUILD");
    end

function Xavier.Hud.toggledemorph()
        SendChatMessage(".demorph", "GUILD");
    end

function Xavier.Hud.togglechatoff()
        SendChatMessage(".gm chat off", "GUILD");
    end
    
function Xavier.Hud.togglepinfo()
        SendChatMessage(".pinfo", "GUILD");
    end

function Xavier.Hud.togglenpcinfo()
        SendChatMessage(".npc inf", "GUILD");
    end

function Xavier.Hud.togglegmin()
        SendChatMessage(".gm in", "GUILD");
    end

function Xavier.Hud.toggleVisibilityon()
        SendChatMessage(".gm visible on", "GUILD");
    end
    
    function Xavier.Hud.toggleVisibilityoff()
        SendChatMessage(".gm visible off", "GUILD");
end

function Xavier.Hud.toggleWhisper(status)
    if (not Xavier.Hud.whisper and status == nil) or status == true then
        SendChatMessage(".whispers on", "GUILD");
    else
        SendChatMessage(".whispers off", "GUILD");
    end
end

function Xavier.Hud.toggleFly(status)
    if UnitName("target") == UnitName("player") or UnitName("target") == nil then
        if (not Xavier.Hud.fly and status == nil) or status == true then
            SendChatMessage(".gm fly on", "GUILD");
        else
            SendChatMessage(".gm fly off", "GUILD");
        end
    else
        Xavier.showGMMessage("Could not target self to change flight mode.");
    end
end

function Xavier.Hud.setSpeed()
    if UnitName("target") == UnitName("player") or UnitName("target") == nil then
        speed = Xavier_Hud_Speed:GetText();
        Xavier_Hud_Speed:ClearFocus();
        SendChatMessage(".mod aspeed ".. speed, "GUILD");
    else
        Xavier.showGMMessage("Be sure to target yourself before setting the speed.");
    end
end


function Xavier.Hud.setScale()
        scale = Xavier_Hud_Scale:GetText();
        Xavier_Hud_Scale:ClearFocus();
        SendChatMessage(".mod scale ".. scale, "GUILD");
end

function Xavier.Hud.setnpcadd()
        npcadd = Xavier_Hud_npcadd:GetText();
        Xavier_Hud_npcadd:ClearFocus();
        SendChatMessage(".npc add temp ".. npcadd, "GUILD");
end

function Xavier.Hud.setmorphid()
        morphid = Xavier_Hud_morphid:GetText();
        Xavier_Hud_morphid:ClearFocus();
        SendChatMessage(".mod morph ".. morphid, "GUILD");
end

function Xavier.Hud.toggleOthersWindow()
    local frame = Xavier_Hud_Others;
    if frame:IsVisible() then
        frame:Hide();
    else
        frame:Show();
    end
end

function Xavier.Hud.senditem()
        sendname = Xavier_Hud_Others_MessageFrame1_sendname:GetText();
        senditemID = Xavier_Hud_Others_MessageFrame1_senditemID:GetText();
        GM1 = Xavier_Hud_Others_MessageFrame1_GM1:GetText();
        GM2 = Xavier_Hud_Others_MessageFrame1_GM2:GetText();
        SendChatMessage(".send items ".. sendname .. GM1 .. GM2 .. senditemID, "GUILD");
end

function Xavier.Hud.titlesadd()
        titles = Xavier_Hud_Others_MessageFrame2_titles:GetText();
        SendChatMessage(".titles current ".. titles, "GUILD");
end

function Xavier.Hud.titlesdel()
        titles = Xavier_Hud_Others_MessageFrame2_titles:GetText();
        SendChatMessage(".titles remove ".. titles, "GUILD");
end