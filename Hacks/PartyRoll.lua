local Hack = {
  nId = 20170324,
  strName = "Party Roll",
  strDescription = "TODO",
  strXmlDocName = nil,
  tSave = nil,
}

function Hack:Initialize()
  return true
end

function Hack:Load()
end

function Hack:Unload()
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
