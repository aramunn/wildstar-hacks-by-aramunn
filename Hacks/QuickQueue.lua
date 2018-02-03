local Hack = {
  nId = 20180203,
  strName = "Quick Queue",
  strDescription = "Enables /qq command (run it for more info)",
  strXmlDocName = nil,
  tSave = nil,
}

function Hack:OnSlashCommand(strCmd, strParams)
  Print("Got: "..strCmd)
  Print("Got: "..strParams)
end

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
  Apollo.RegisterSlashCommand("qq", "OnSlashCommand", self)
end

function Hack:Unload()
  -- Apollo.RemoveEventHandler("event", self)
  -- self:Print("A Reload UI is required to remove the slash command")
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
