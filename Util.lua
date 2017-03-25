local Util = {}

function Util:SysPrint(strMessage, strName)
  Print("blah")
  ChatSystemLib.PostOnChannel(
    ChatSystemLib.ChatChannel_System,
    strMessage,
    strName
  )
end

function Util:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Util:Register()
  local addonMain = Apollo.GetAddon("HacksByAramunn")
  addonMain:RegisterUtil(self)
end

local HackInst = Util:new()
HackInst:Register()
