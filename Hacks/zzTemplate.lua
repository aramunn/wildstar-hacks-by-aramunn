local Hack = {
  nId = YYYYMMDD,
  strName = "Name_of_the_Hack",
  strDescription = "Description_of_the_Hack",
  strXmlDocName = nil,
  tSave = nil,
}

function Hack:Initialize()
  -- self.addon = Apollo.GetAddon("Addon")
  -- if not self.addon then return false end
  -- local funcOriginal = self.addon.Func
  -- self.addon.Func = function(...)
    -- funcOriginal(...)
    -- self:NewFunc()
  -- end
  return true
end

function Hack:Load()
  -- Apollo.RegisterEventHandler("event", "func", self)
  -- self:AddSlashCmd("cmd", "OnSlashCommand", self)
end

function Hack:Unload()
  -- Apollo.RemoveEventHandler("event", self)
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
