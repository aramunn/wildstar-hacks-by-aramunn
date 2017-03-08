local Hack = {
  nId = 20170307,
  strName = "Hide Player Unit Frame in Group",
  strDescription = "Hides the player's unit frame when in a group/raid",
  strXmlDocName = nil,
  tSave = nil,
}

function Hack:Initialize()
  self.addonTargetFrame = Apollo.GetAddon("TargetFrame")
  if not self.addonTargetFrame then return false end
  return true
end

function Hack:Load()
  if not self.bIsLoaded then
    Apollo.RegisterEventHandler("Group_Join", "OnGroupJoin", self)
    Apollo.RegisterEventHandler("Group_Left", "OnGroupLeft", self)
    self.bIsLoaded = true
  end
end

function Hack:OnGroupJoin()
  local wndFrame = self.addonTargetFrame.luaUnitFrame.wndMainClusterFrame
  if wndFrame then wndFrame:Destroy() end
end

function Hack:OnGroupLeft()
  self.addonTargetFrame:OnUnitFrameOptionsUpdated()
end

function Hack:Unload()
  if self.bIsLoaded then
    Apollo.RemoveEventHandler("Group_Join", self)
    Apollo.RemoveEventHandler("Group_Left", self)
    self.bIsLoaded = false
  end
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
