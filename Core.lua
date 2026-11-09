-- QuickChannels: compact, modern chat channel bar.
-- Works on WoW Forever, Classic Era / Anniversary / MoP Classic and Retail (all APIs guarded).

local ADDON, ns = ...
local L = ns.L

local function G(name, fallback) return _G[name] or fallback end

---------------------------------------------------------------------------
-- Settings
---------------------------------------------------------------------------
local DEFAULTS = {
  point = { "BOTTOMLEFT", "ChatFrame1", "TOPLEFT", -2, 30 },
  locked = false,
  vertical = false,
  scale = 1,
  size = 22,
  spacing = 3,
  fade = false,
  background = true,
  onlyAvailable = true,
  keepText = true,
  latin = false,
  hidden = {},
}

local DB

local function CopyDefaults(src, dst)
  for k, v in pairs(src) do
    if type(v) == "table" then
      if type(dst[k]) ~= "table" then dst[k] = {} end
      if k ~= "hidden" then CopyDefaults(v, dst[k]) end
    elseif dst[k] == nil then
      dst[k] = v
    end
  end
end

---------------------------------------------------------------------------
-- Availability checks
---------------------------------------------------------------------------
local HOME = LE_PARTY_CATEGORY_HOME or 1
local INSTANCE = LE_PARTY_CATEGORY_INSTANCE or 2

local function InParty() return IsInGroup and IsInGroup(HOME) end
local function InInstanceGroup() return IsInGroup and IsInGroup(INSTANCE) end
local function InRaid() return IsInRaid and IsInRaid() end
local function InGuild() return IsInGuild and IsInGuild() end

local function IsOfficer()
  if not InGuild() then return false end
  if C_GuildInfo then
    if C_GuildInfo.IsGuildOfficer then return C_GuildInfo.IsGuildOfficer() end
    if C_GuildInfo.CanEditOfficerNote then return C_GuildInfo.CanEditOfficerNote() end
  end
  if CanEditOfficerNote then return CanEditOfficerNote() end
  return true
end

local function CanRaidWarn()
  return InRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
end

-- type = edit box chatType (for highlight/colour), cmd = slash prefix
local STATIC = {
  { key = "SAY",          label = "S",  type = "SAY",           cmd = "/s ",  name = G("SAY", "Say") },
  { key = "YELL",         label = "Y",  type = "YELL",          cmd = "/y ",  name = G("YELL", "Yell") },
  { key = "EMOTE",        label = "E",  type = "EMOTE",         cmd = "/e ",  name = G("EMOTE", "Emote") },
  -- always = shown even outside a group (dimmed), so the party button is always there
  { key = "PARTY",        label = "P",  type = "PARTY",         cmd = "/p ",  name = G("PARTY", "Party"), cond = InParty, always = true },
  { key = "INSTANCE",     label = "I",  type = "INSTANCE_CHAT", cmd = "/i ",  name = G("INSTANCE_CHAT", "Instance"), cond = InInstanceGroup },
  { key = "RAID",         label = "R",  type = "RAID",          cmd = "/ra ", name = G("RAID", "Raid"), cond = InRaid },
  { key = "RAID_WARNING", label = "RW", type = "RAID_WARNING",  cmd = "/rw ", name = G("RAID_WARNING", "Raid Warning"), cond = CanRaidWarn },
  { key = "GUILD",        label = "G",  type = "GUILD",         cmd = "/g ",  name = G("GUILD", "Guild"), cond = InGuild },
  { key = "OFFICER",      label = "O",  type = "OFFICER",       cmd = "/o ",  name = G("OFFICER", "Officer"), cond = IsOfficer },
  { key = "WHISPER",      label = "W",  type = "WHISPER",       cmd = "/w ",  name = G("WHISPER", "Whisper"), noKeep = true },
  { key = "REPLY",        label = "Re", type = nil, color = "WHISPER", cmd = "/r ", name = L.reply },
}

local function GetColor(chatType)
  local info = chatType and ChatTypeInfo and ChatTypeInfo[chatType]
  if info and info.r then return info.r, info.g, info.b end
  return 0.9, 0.9, 0.9
end

local function BuildEntries()
  local out = {}
  for _, e in ipairs(STATIC) do
    e.available = (not e.cond) or (e.cond() and true or false)
    if not DB.hidden[e.key] and (e.available or e.always or not DB.onlyAvailable) then
      e.colorType = e.color or e.type
      local labels = DB.latin and ns.LabelsLatin or ns.LabelsLocal
      e.label = labels[e.key] or e.label
      out[#out + 1] = e
    end
  end

  -- Numbered custom/world channels
  local list = { GetChannelList() }
  local stride = (list[3] == nil or type(list[3]) == "boolean") and 3 or 2
  for i = 1, #list, stride do
    local id, name, disabled = list[i], list[i + 1], (stride == 3) and list[i + 2] or false
    if type(id) == "number" and name then
      local key = "CH:" .. name
      local available = not disabled
      if not DB.hidden[key] and (available or not DB.onlyAvailable) then
        out[#out + 1] = {
          key = key, label = tostring(id), type = "CHANNEL", chanId = id,
          colorType = "CHANNEL" .. id, cmd = "/" .. id .. " ",
          name = id .. ". " .. name, available = available,
        }
      end
    end
  end
  return out
end

---------------------------------------------------------------------------
-- Talking
---------------------------------------------------------------------------
-- WoW Forever / Retail 12.x moved chat helpers into ChatFrameUtil and left the old
-- ChatEdit_* / ChatFrame_* globals only as optional deprecation aliases. Resolve both.
local CFU = ChatFrameUtil or {}

local function GetActiveEditBox()
  local f = CFU.GetActiveWindow or ChatEdit_GetActiveWindow
  if f then return f() end
  for i = 1, (NUM_CHAT_WINDOWS or 10) do
    local eb = _G["ChatFrame" .. i .. "EditBox"]
    if eb and eb:IsShown() and eb:HasFocus() then return eb end
  end
end

local function RawOpenChat(text, frame)
  local f = CFU.OpenChat or ChatFrame_OpenChat
  if f then
    f(text, frame)
    return
  end
  -- last-resort fallback: activate the edit box by hand
  local eb = frame and frame.editBox or (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox)
  if eb then
    eb:Show()
    eb:SetFocus()
    eb:SetText(text)
  end
end

local function OpenChannel(e)
  local frame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
  local text = e.cmd

  -- If something is already typed, carry it into the new channel.
  -- OpenChat parses a leading slash command itself and keeps the rest of the text.
  local eb = GetActiveEditBox()
  if eb and DB.keepText and not e.noKeep then
    local typed = eb:GetText() or ""
    if typed ~= "" and not typed:find("^/") then text = e.cmd .. typed end
  end

  RawOpenChat(text, frame)
end

---------------------------------------------------------------------------
-- Frame
---------------------------------------------------------------------------
local bar = CreateFrame("Frame", "QuickChannelsBar", UIParent)
bar:SetMovable(true)
bar:SetClampedToScreen(true)
bar:EnableMouse(true)
bar:SetFrameStrata("LOW")
bar:Hide()

local PAD = 4

bar.bg = bar:CreateTexture(nil, "BACKGROUND")
bar.bg:SetAllPoints()
bar.bg:SetColorTexture(0.05, 0.055, 0.07, 0.72)

bar.edges = {}
do
  local function Edge(a1, a2, w, h)
    local t = bar:CreateTexture(nil, "BORDER")
    t:SetColorTexture(1, 1, 1, 0.07)
    t:SetPoint(a1); t:SetPoint(a2)
    if w then t:SetWidth(w) else t:SetHeight(h) end
    bar.edges[#bar.edges + 1] = t
  end
  Edge("TOPLEFT", "TOPRIGHT", nil, 1)
  Edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, 1)
  Edge("TOPLEFT", "BOTTOMLEFT", 1, nil)
  Edge("TOPRIGHT", "BOTTOMRIGHT", 1, nil)
end

local buttons = {}
local activeType, activeChan

local function IsActive(e)
  if not e.type or e.type ~= activeType then return false end
  if e.type == "CHANNEL" then return tonumber(activeChan) == e.chanId end
  return true
end

local function UpdateVisual(b)
  local e = b.entry
  if not e then return end
  local r, g, bl = GetColor(e.colorType)
  local active = IsActive(e)
  b.bg:SetColorTexture(1, 1, 1, b.hover and 0.10 or 0.045)
  b.fill:SetColorTexture(r, g, bl, active and 0.30 or (b.hover and 0.14 or 0))
  b.accent:SetColorTexture(r, g, bl, active and 1 or 0.8)
  b.accent:SetHeight(active and 3 or 2)
  if active or b.hover then
    b.text:SetTextColor(1, 1, 1)
  else
    b.text:SetTextColor(r, g, bl)
  end
  b:SetAlpha(e.available and 1 or 0.35)
end

local function UpdateAll()
  for _, b in ipairs(buttons) do
    if b:IsShown() then UpdateVisual(b) end
  end
end

local function SavePosition()
  local p, _, rp, x, y = bar:GetPoint(1)
  DB.point = { p, "UIParent", rp, x, y }
end

local function ApplyPosition()
  local p = DB.point
  bar:ClearAllPoints()
  bar:SetPoint(p[1], _G[p[2]] or UIParent, p[3], p[4], p[5])
end

local function DragStart()
  if not DB.locked or IsAltKeyDown() then
    bar:StartMoving()
    bar.moving = true
  end
end

local function DragStop()
  if not bar.moving then return end
  bar:StopMovingOrSizing()
  bar.moving = false
  if bar.SetUserPlaced then bar:SetUserPlaced(false) end
  SavePosition()
end

bar:RegisterForDrag("LeftButton")
bar:SetScript("OnDragStart", DragStart)
bar:SetScript("OnDragStop", DragStop)

local Rebuild, ShowMenu -- forward

local function Button_OnEnter(self)
  self.hover = true
  UpdateVisual(self)
  local e = self.entry
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(e.name, GetColor(e.colorType))
  if not e.available then GameTooltip:AddLine(L.unavailable, 1, 0.35, 0.35) end
  GameTooltip:AddLine(L.leftClick, 0.75, 0.75, 0.75)
  GameTooltip:AddLine(L.rightClick, 0.75, 0.75, 0.75)
  GameTooltip:AddLine(DB.locked and L.altDrag or L.drag, 0.55, 0.55, 0.55)
  GameTooltip:Show()
end

local function Button_OnLeave(self)
  self.hover = false
  UpdateVisual(self)
  GameTooltip:Hide()
end

local function Button_OnClick(self, button)
  local e = self.entry
  if not e then return end
  if button == "RightButton" then
    ShowMenu(self)
  elseif e.available then
    OpenChannel(e)
  end
end

local function GetButton(i)
  local b = buttons[i]
  if b then return b end
  b = CreateFrame("Button", nil, bar)
  b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  b:RegisterForDrag("LeftButton")

  b.bg = b:CreateTexture(nil, "BACKGROUND")
  b.bg:SetAllPoints()
  b.fill = b:CreateTexture(nil, "BORDER")
  b.fill:SetAllPoints()
  b.accent = b:CreateTexture(nil, "ARTWORK")
  b.accent:SetPoint("BOTTOMLEFT")
  b.accent:SetPoint("BOTTOMRIGHT")
  b.accent:SetHeight(2)
  b.text = b:CreateFontString(nil, "OVERLAY")
  b.text:SetPoint("CENTER", 0, 1)
  b.text:SetShadowOffset(1, -1)
  b.text:SetShadowColor(0, 0, 0, 0.9)

  b:SetScript("OnEnter", Button_OnEnter)
  b:SetScript("OnLeave", Button_OnLeave)
  b:SetScript("OnClick", Button_OnClick)
  b:SetScript("OnDragStart", DragStart)
  b:SetScript("OnDragStop", DragStop)
  buttons[i] = b
  return b
end

local function Layout()
  local entries = BuildEntries()
  local size, gap = DB.size, DB.spacing
  for i, e in ipairs(entries) do
    local b = GetButton(i)
    b.entry = e
    b:SetSize(size, size)
    b:ClearAllPoints()
    local offset = PAD + (i - 1) * (size + gap)
    if DB.vertical then
      b:SetPoint("TOPLEFT", PAD, -offset)
    else
      b:SetPoint("TOPLEFT", offset, -PAD)
    end
    -- count UTF-8 characters, not bytes (Cyrillic / CJK / Hangul labels)
    local chars = select(2, e.label:gsub("[^\128-\191]", ""))
    local fs = math.floor(size * (chars > 1 and 0.42 or 0.52) + 0.5)
    b.text:SetFont(STANDARD_TEXT_FONT, fs, "")
    b.text:SetText(e.label)
    b:Show()
    UpdateVisual(b)
  end
  for i = #entries + 1, #buttons do
    buttons[i]:Hide()
    buttons[i].entry = nil
  end

  local n = math.max(#entries, 1)
  local long = n * size + (n - 1) * gap + PAD * 2
  local short = size + PAD * 2
  if DB.vertical then bar:SetSize(short, long) else bar:SetSize(long, short) end
  bar:SetScale(DB.scale)

  bar.bg:SetShown(DB.background)
  for _, t in ipairs(bar.edges) do t:SetShown(DB.background) end
  bar:SetShown(#entries > 0)
end

---------------------------------------------------------------------------
-- Active channel highlight
---------------------------------------------------------------------------
local function RefreshActive(eb)
  eb = eb or (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox)
  if not eb or not eb.GetAttribute then return end
  activeType = eb:GetAttribute("chatType")
  activeChan = eb:GetAttribute("channelTarget")
  UpdateAll()
end

---------------------------------------------------------------------------
-- Fade
---------------------------------------------------------------------------
local function FadeOnUpdate(self, elapsed)
  local eb = GetActiveEditBox()
  local target = (self:IsMouseOver(8, -8, -8, 8) or eb) and 1 or 0.2
  local a = self:GetAlpha()
  if math.abs(a - target) > 0.01 then
    self:SetAlpha(a + (target - a) * math.min(1, elapsed * 10))
  end
end

local function ApplyFade()
  if DB.fade then
    bar:SetScript("OnUpdate", FadeOnUpdate)
  else
    bar:SetScript("OnUpdate", nil)
    bar:SetAlpha(1)
  end
end

---------------------------------------------------------------------------
-- Rebuild (debounced)
---------------------------------------------------------------------------
local pending = false
Rebuild = function()
  if pending then return end
  pending = true
  C_Timer.After(0.05, function()
    pending = false
    Layout()
    RefreshActive()
  end)
end

local function ResetAll()
  wipe(DB)
  CopyDefaults(DEFAULTS, DB)
  ApplyPosition()
  ApplyFade()
  Rebuild()
end

---------------------------------------------------------------------------
-- Context menu (modern Menu API; falls back to chat help)
---------------------------------------------------------------------------
local function Toggle(field, after)
  return function() return DB[field] end, function()
    DB[field] = not DB[field]
    if after then after() end
    Rebuild()
  end
end

ShowMenu = function(owner)
  local e = owner.entry
  if not (MenuUtil and MenuUtil.CreateContextMenu) then
    print("|cff66ccffQuickChannels|r /qch " .. L.help)
    return
  end
  MenuUtil.CreateContextMenu(owner, function(_, root)
    root:CreateTitle(e.name)
    root:CreateButton(L.hide, function()
      DB.hidden[e.key] = e.name
      Rebuild()
    end)

    if next(DB.hidden) then
      local sub = root:CreateButton(L.hiddenList)
      for key, name in pairs(DB.hidden) do
        sub:CreateButton(type(name) == "string" and name or key, function()
          DB.hidden[key] = nil
          Rebuild()
        end)
      end
      sub:CreateDivider()
      sub:CreateButton(L.showAll, function() wipe(DB.hidden); Rebuild() end)
    end

    root:CreateDivider()
    root:CreateCheckbox(L.lock, Toggle("locked"))
    root:CreateCheckbox(L.vertical, Toggle("vertical"))
    root:CreateCheckbox(L.onlyAvail, Toggle("onlyAvailable"))
    root:CreateCheckbox(L.background, Toggle("background"))
    root:CreateCheckbox(L.fade, Toggle("fade", ApplyFade))
    root:CreateCheckbox(L.keepText, Toggle("keepText"))
    root:CreateCheckbox(L.latin, Toggle("latin"))
    root:CreateDivider()
    root:CreateButton(L.reset, ResetAll)
  end)
end

---------------------------------------------------------------------------
-- Slash commands
---------------------------------------------------------------------------
SLASH_QUICKCHANNELS1 = "/quickchannels"
SLASH_QUICKCHANNELS2 = "/qch"
SlashCmdList.QUICKCHANNELS = function(msg)
  local cmd, arg = (msg or ""):lower():match("^(%S*)%s*(.-)$")
  local n = tonumber(arg)
  if cmd == "lock" then DB.locked = true
  elseif cmd == "unlock" then DB.locked = false
  elseif cmd == "vertical" then DB.vertical = true
  elseif cmd == "horizontal" then DB.vertical = false
  elseif cmd == "scale" and n then DB.scale = math.max(0.5, math.min(2, n))
  elseif cmd == "size" and n then DB.size = math.max(16, math.min(40, math.floor(n)))
  elseif cmd == "fade" then DB.fade = not DB.fade; ApplyFade()
  elseif cmd == "bg" then DB.background = not DB.background
  elseif cmd == "avail" then DB.onlyAvailable = not DB.onlyAvailable
  elseif cmd == "latin" then DB.latin = not DB.latin
  elseif cmd == "showall" then wipe(DB.hidden)
  elseif cmd == "reset" then ResetAll(); return
  else
    print("|cff66ccffQuickChannels|r " .. L.help)
    return
  end
  Rebuild()
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" then
    if arg1 ~= ADDON then return end
    QuickChannelsDB = QuickChannelsDB or {}
    DB = QuickChannelsDB
    CopyDefaults(DEFAULTS, DB)
    ApplyPosition()
    ApplyFade()

    -- Track the current channel through the edit boxes' attributes: works the same on
    -- every client, without relying on ChatEdit_UpdateHeader (deprecated in 12.x / Forever).
    for i = 1, (NUM_CHAT_WINDOWS or 10) do
      local eb = _G["ChatFrame" .. i .. "EditBox"]
      if eb and eb.HookScript then
        eb:HookScript("OnAttributeChanged", function(box, name)
          if name == "chattype" or name == "channeltarget" or name == "chatType" or name == "channelTarget" then
            RefreshActive(box)
          end
        end)
        eb:HookScript("OnShow", RefreshActive)
      end
    end

    for _, ev in ipairs({
      "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE", "PARTY_LEADER_CHANGED",
      "PLAYER_GUILD_UPDATE", "GUILD_ROSTER_UPDATE", "CHANNEL_UI_UPDATE",
      "CHAT_MSG_CHANNEL_NOTICE", "UPDATE_CHAT_COLOR",
    }) do
      pcall(self.RegisterEvent, self, ev)
    end
    self:UnregisterEvent("ADDON_LOADED")
  end
  Rebuild()
end)
