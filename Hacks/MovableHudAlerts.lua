local Hack = {
  nId = 20170323,
  strName = "Movable HUD Alerts",
  strDescription = "TODO",
  strXmlDocName = nil,
  tSave = nil,
}

function Hack:Initialize()
  self.addonHUDAlerts = Apollo.GetAddon("HUDAlerts")
  if not self.addonHUDAlerts then return false end
  return true
end

function Hack:Load()
  if not self.bIsLoaded then
    Apollo.RegisterEventHandler("WindowManagementReady", "OnWindowManagementReady", self)
    Apollo.RegisterEventHandler("WindowManagementUpdate", "OnWindowManagementUpdate", self)
    self.bIsLoaded = true
  end
  self:OnWindowManagementReady()
end

function Hack:OnWindowManagementReady()
  Event_FireGenericEvent("WindowManagementRegister", {
    strName = "HbA: HUD Alerts",
    nSaveVersion = 1
  })
  Event_FireGenericEvent("WindowManagementAdd", {
    wnd = self.addonHUDAlerts.wndAlertContainer,
    strName = "HbA: HUD Alerts",
    nSaveVersion = 1
  })
end

function Hack:OnWindowManagementUpdate(tSettings)
  local wndAlerts = self.addonHUDAlerts.wndAlertContainer
  if tSettings and tSettings.wnd and tSettings.wnd == wndAlerts then
    local bMoveable = wndAlerts:IsStyleOn("Moveable")
    local bHasMoved = tSettings.bHasMoved
    wndAlerts:SetSprite(bMoveable and "BasicSprites:WhiteFill" or "")
    wndAlerts:SetStyle("IgnoreMouse", not bMoveable)
  end
end

function Hack:Unload()
  if self.bIsLoaded then
    Apollo.RemoveEventHandler("WindowManagementReady", self)
    Apollo.RemoveEventHandler("WindowManagementUpdate", self)
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
  local addonMain = Apollo.GetAddon("HacksByAramunn")
  addonMain:RegisterHack(self)
end

local HackInst = Hack:new()
HackInst:Register()
