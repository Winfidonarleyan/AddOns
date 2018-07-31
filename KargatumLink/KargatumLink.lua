-------------------------------------------------------------------------------------------------------------
--
-- TrinityAdmin Version 3.x
-- TrinityAdmin is a derivative of KargatumLink.
--
-- Copyright (C) 2007 Free Software Foundation, Inc.
-- License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
-- This is free software: you are free to change and redistribute it.
-- There is NO WARRANTY, to the extent permitted by law.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
-- Official Forums: http://groups.google.com/group/trinityadmin
-- GoogleCode Website: http://code.google.com/p/trinityadmin/
-- Subversion Repository: http://trinityadmin.googlecode.com/svn/
-- Dev Blog: http://trinityadmin.blogspot.com/
-------------------------------------------------------------------------------------------------------------
print "|cFFFF0000[Kargatum Link]|cff6C8CD5 Аддон загружен"
local genv = getfenv(0)
local Kargatum = genv.Kargatum
GPS = ".gps"
cWorking = 0
fID = 0

KargatumLink =
  AceLibrary("AceAddon-2.0"):new(
  "AceConsole-2.0",
  "AceDB-2.0",
  "AceHook-2.1",
  "FuBarPlugin-2.0",
  "AceDebug-2.0",
  "AceEvent-2.0"
)
Locale = AceLibrary("AceLocale-2.2"):new("KargatumLink")
Strings = AceLibrary("AceLocale-2.2"):new("TEST")
FrameLib = AceLibrary("FrameLib-1.0")

KargatumLink:RegisterDB("KargatumLinkDb", "KargatumLinkDbPerChar")
KargatumLink:RegisterDefaults(
  "char",
  {
    functionQueue = {},
    requests = {
      tpinfo = false,
      ticket = false,
      ticketbody = 0,
      item = false,
      favitem = false,
      itemset = false,
      spell = false,
      skill = false,
      quest = false,
      creature = false,
      object = false,
      tele = false,
      toggle = false
    },
    nextGridWay = "ahead",
    selectedZone = nil,
    newTicketQueue = {},
    instantKillMode = false,
    msgDeltaTime = time(),
  }
)

KargatumLink:RegisterDefaults("account", 
  {
    language = nil,
    localesearchstring = true,
    favorites = {
      items = {},
      itemsets = {},
      spells = {},
      skills = {},
      quests = {},
      creatures = {},
      objects = {},
      teles = {}
    },
    buffer = {
      tickets = {},
      items = {},
      itemsets = {},
      spells = {},
      skills = {},
      quests = {},
      creatures = {},
      objects = {},
      teles = {},
      counter = 0
    },
    tickets = {
      selected = 0,
      count = 0,
      requested = 0,
      playerinfo = {},
      loading = false
    },
    style = {
      updatedelay = "4000",
      showtooltips = true,
      showchat = false,
      showminimenu = true,
      transparency = {
        buttons = 1.0,
        frames = 0.7,
        backgrounds = 0.5
      },
      color = {
        buffer = {},
        buttons = {
          r = 33, 
          g = 164, 
          b = 210
        },
        frames = {
          r = 102,
          g = 102,
          b = 102
        },
        backgrounds = {
          r = 0,
          g = 0,
          b = 0
        },
        linkifier = {
          r = 0.8705882352941177,
          g = 0.3725490196078432,
          b = 0.1411764705882353
        }
      }
    }
  }
)

-- Register Translations
Locale:EnableDynamicLocales(true)
Locale:RegisterTranslations(
  "ruRU",
  function()
    return Return_ruRU()
  end
)
Strings:EnableDynamicLocales(true)
Strings:RegisterTranslations(
  "ruRU",
  function()
    return ReturnStrings_ruRU()
  end
)

KargatumLink.consoleOpts = {
  type = "group",
  args = {
    toggle = {
      name = "toggle",
      desc = Locale["cmd_toggle"],
      type = "execute",
      func = function()
        KargatumLink:OnClick()
      end
    },
    transparency = {
      name = "transparency",
      desc = Locale["cmd_transparency"],
      type = "execute",
      func = function()
        KargatumLink:ToggleTransparency()
      end
    },
    tooltips = {
      name = "tooltips",
      desc = Locale["cmd_tooltip"],
      type = "execute",
      func = function()
        KargatumLink:ToggleTooltips()
      end
    },
    minimenu = {
      name = "tooltips",
      desc = "Toogle the toolbar/minimenu",
      type = "execute",
      func = function()
        KargatumLink:ToggleMinimenu()
      end
    }
  }
}

function KargatumLink:OnInitialize()
  -- initializing KargatumLink
  self:SetLanguage()
  -- those all hook the AddMessage method of the chat frames.
  -- They will be redirected to KargatumLink:AddMessage(...)
  for i = 1, NUM_CHAT_WINDOWS do
    local cf = getglobal("ChatFrame" .. i)
    self:Hook(cf, "AddMessage", true)
  end
  --altering the function setitemref, to make it possible to click links
  KargatumLinkifier_SetItemRef_Original = SetItemRef
  SetItemRef = KargatumLinkifier_SetItemRef
  self.db.char.msgDeltaTime = time()
end

function KargatumLink:AddMessage(frame, text, r, g, b, id)
  -- frame is the object that was hooked (one of the ChatFrames)
  local catchedSth = false
  local output = KargatumLink.db.account.style.showchat
  if id == 1 then --make sure that the message comes from the server, message id = 1
    --Catches if Toggle is still on for some reason, but search frame is not up, and disables it so messages arent caught
    if self.db.char.requests.toggle and not ma_popupframe:IsVisible() then
      self.db.char.requests.toggle = false
    end
    -- Check for possible UrlModification
    if catchedSth then
      if output == false then
        -- don't output anything
      elseif output == true then
        text = KargatumLinkifier_Decompose(text)
        self.hooks[frame].AddMessage(frame, text, r, g, b, id)
      end
    else
      text = KargatumLinkifier_Decompose(text)
      self.hooks[frame].AddMessage(frame, text, r, g, b, id)
    end
  else
    -- message is not from server
    --Linkifier should be used on non server messages as well to catch links suc as items in chat
    text = KargatumLinkifier_Decompose(text)
    -- Returns the message to the client, or else the chat frame never shows it
    self.hooks[frame].AddMessage(frame, text, r, g, b, id)
  end
end

function KargatumLink:SetLanguage()
  if self.db.account.language then
    Locale:SetLocale(self.db.account.language)
    if self.db.account.localesearchstring then
      Strings:SetLocale(self.db.account.language)
    else
      Strings:SetLocale("ruRU")
    end
  else
    self.db.account.language = Locale:GetLocale()
  end
end