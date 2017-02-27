local Hack = {
  nId = 20161217,
  strName = "Hide Trackers in Combat",
  strDescription = "Hides all but the Public Event Tracker when you're in combat",
}

function Hack:Initialize()
  self.tSave = {}
  self.strEventTracker = Apollo.GetString("PublicEventTracker_PublicEvents")
  self.addonObjectiveTracker = Apollo.GetAddon("ObjectiveTracker")
  if not self.addonObjectiveTracker then return false end
  return true
end

function Hack:Load()
  if not self.bIsLoaded then
    Apollo.RegisterEventHandler("UnitEnteredCombat", "OnUnitEnteredCombat", self)
    self.bIsLoaded = true
  end
end

function Hack:OnUnitEnteredCombat(unit, bEnteredCombat)
  if not unit:IsThePlayer() then return end
  for strKey, tData in pairs(self.addonObjectiveTracker.tAddons) do
    self:UpdateTracker(tData, bEnteredCombat)
  end
end

function Hack:UpdateTracker(tData, bEnteredCombat)
  if not tData.strEventMouseLeft then return end
  if tData.strAddon == self.strEventTracker then return end
  if bEnteredCombat then
    self.tSave[tData.strAddon] = tData.bChecked
  end
  if self.tSave[tData.strAddon] then
    if bEnteredCombat ~= tData.bChecked then return end
  else
    if not (bEnteredCombat and tData.bChecked) then return end
  end
  Event_FireGenericEvent(tData.strEventMouseLeft)
end

function Hack:Unload()
  if self.bIsLoaded then
    Apollo.RemoveEventHandler("UnitEnteredCombat", self)
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
