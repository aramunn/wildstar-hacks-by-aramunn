local Hack = {
  nId = 20170324,
  strName = "Party Roll",
  strDescription = "Enables the /partyroll (/proll) command",
  strXmlDocName = nil,
  tSave = nil,
}

function Hack:Initialize()
  for idx, channel in ipairs(ChatSystemLib.GetChannels()) do
    local eType = channel:GetType()
    if eType == ChatSystemLib.ChatChannel_Party then
      self.channelParty = channel
    end
  end
  if not self.channelParty then return false end
  return true
end

function Hack:Load()
  Apollo.RegisterSlashCommand("partyroll", "OnPartyRoll", self)
  Apollo.RegisterSlashCommand("proll", "OnPartyRoll", self)
  Apollo.RegisterEventHandler("ChatMessage", "OnChatMessage", self)
end

function Hack:Unload()
  Apollo.RemoveEventHandler("ChatMessage", self)
end

function Hack:OnPartyRoll(strCmd, strParam)
  if not self.bIsLoaded then
    --TODO
  end
  if not GroupLib.InGroup() then
    --TODO
  end
  if self.bIsActive then
    for strPlayer, nRoll in pairs(self.tRolls) do
      Print(strPlayer..": "..tostring(nRoll))
    end
  elseif strParam == "" then
    --TODO
  else
    self.strTitle = strParam:gsub("%s*$", "")
    self.tRolls = {}
    self.bIsActive = true
  end
end

function Hack:OnChatMessage(tChannel, tEventArgs)
  if not self.bIsActive then return end
  if tChannel:GetType() ~= ChatSystemLib.ChatChannel_System then return end
  local message = tEventArgs.arMessageSegments[1].strText
  local nIdx, _, strPlayer, nRoll = message:find("(.+) rolls (%d+) %(1%-100%)")
  if not nIdx then return end
  self:RecordPlayerRoll(strPlayer, nRoll)
  self:CheckForCompleteness()
end

function Hack:RecordPlayerRoll(strPlayer, nRoll)
  if self.tRolls[strPlayer] then return end
  self.tRolls[strPlayer] = nRoll
end

function Hack:CheckForCompleteness()
  self.bIsActive = false
  self:DisplayResults()
end

function Hack:DisplayResults()
  self.channelParty:Send("test party")
  self.util:SysPrint("testing")
end

function Hack:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Hack:Register()
  local addonMain = Apollo.GetAddon("HacksByAramunn")
  addonMain:RegisterHack(self)
end

local HackInst = Hack:new()
HackInst:Register()
