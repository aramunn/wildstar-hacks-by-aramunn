local Hack = {
  nId = 20170327,
  strName = "Display Essences in Loot Stack",
  strDescription = "Fakes essence gains as items so they show up in the loot stack",
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
