local HacksByAramunn = {
  tHacks = {},
}

function HacksByAramunn:RegisterHack(tHack)
  table.insert(self.tHacks, tHack)
end

function HacksByAramunn:LoadMainWindow()
  if self.wndMain and self.wndMain:IsValid() then
    self.wndMain:Destroy()
  end
  self.wndMain = Apollo.LoadForm(self.xmlDoc, "Main", nil, self)
  local wndList = self.wndMain:FindChild("List")
  for idx, hackData in ipairs(self.tHacks) do
    local wndHack = Apollo.LoadForm(self.xmlDoc, "Hack", wndList, self)
    wndHack:FindChild("IsEnabled"):SetData(hackData)
    wndHack:FindChild("IsEnabled"):SetCheck(hackData.bEnabled)
    wndHack:FindChild("Name"):SetText(hackData.strName)
    wndHack:FindChild("Description"):SetText(hackData.strDescription)
  end
  wndList:ArrangeChildrenVert(Window.CodeEnumArrangeOrigin.LeftOrTop)
end

function HacksByAramunn:OnClose(wndHandler, wndControl)
  if self.wndMain and self.wndMain:IsValid() then
    self.wndMain:Destroy()
  end
end

function HacksByAramunn:OnEnableDisable(wndHandler, wndControl)
  local hackData = wndControl:GetData()
  hackData.bEnabled = wndControl:IsChecked()
  if hackData.bEnabled then
    hackData:Load()
  else
    hackData:Unload()
  end
end

function HacksByAramunn:OnSave(eLevel)
  if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Account then
    return
  end
  local tSave = {}
  for idx, hackData in ipairs(self.tHacks) do
    tSave[hackData.nId] = {
      bEnabled = hackData.bEnabled,
      tSave = hackData.tSave or nil,
    }
  end
  return tSave
end

function HacksByAramunn:OnRestore(eLevel, tSave)
  for idx, hackData in ipairs(self.tHacks) do
    local hackSave = tSave[hackData.nId]
    if hackSave == true then
      hackData.bEnabled = true
    else
      hackData.bEnabled = hackSave and hackSave.bEnabled or false
      hackData.tSave = hackSave and hackSave.tSave or hackData.tSave
    end
    if hackData.bEnabled then hackData:Load() end
  end
end

function HacksByAramunn:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function HacksByAramunn:Init()
  Apollo.RegisterAddon(self)
end

function HacksByAramunn:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile("HacksByAramunn.xml")
  self.xmlDoc:RegisterCallback("OnDocumentReady", self)
end

function HacksByAramunn:OnDocumentReady()
  if not self.xmlDoc then return end
  if not self.xmlDoc:IsLoaded() then return end
  local tHacksTmp = self.tHacks
  self.tHacks = {}
  for idx, hackData in ipairs(tHacksTmp) do
    self:InitializeHack(hackData)
  end
  Apollo.RegisterSlashCommand("hacksbyaramunn", "LoadMainWindow", self)
  Apollo.RegisterSlashCommand("ahacks", "LoadMainWindow", self)
  Apollo.RegisterSlashCommand("ahax", "LoadMainWindow", self)
end

function HacksByAramunn:InitializeHack(hackData)
  if not hackData:Initialize() then return end
  local bNeedsXmlDoc = hackData.strXmlDocName ~= nil
  if bNeedsXmlDoc then
    hackData.xmlDoc = XmlDoc.CreateFromFile("Hacks/"..hackData.strXmlDocName)
  end
  if bNeedsXmlDoc and not hackData.xmlDoc then return end
  table.insert(self.tHacks, hackData)
end

local HacksByAramunnInst = HacksByAramunn:new()
HacksByAramunnInst:Init()
