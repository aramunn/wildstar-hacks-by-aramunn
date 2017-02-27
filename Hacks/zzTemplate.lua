local Hack = {
  nId = YYYYMMDD,
  strName = "Name_of_the_Hack",
  strDescription = "Description_of_the_Hack",
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
  if not self:Initialize() then return end
  local addonMain = Apollo.GetAddon("HacksByAramunn")
  addonMain:RegisterHack(self)
end

local HackInst = Hack:new()
HackInst:Register()
