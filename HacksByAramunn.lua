local HacksByAramunn = {}

function HacksByAramunn:GenHacks()
  self.tHacks = {
    {
      Name = "Frame Count Deprecation",
      Description = "this is a long description blah blah blah blah blah blah blah blah blah blah blah blah",
      Load = function(ref)
        Apollo.RegisterEventHandler("FrameCount", "OnFrameCount", ref)
      end,
      Unload = function(ref)
        Apollo.RemoveEventHandler("FrameCount", ref)
      end,
      OnFrameCount = function() Event_FireGenericEvent("VarChange_FrameCount") end,
    },
    {
      Name = "Fourth Contract",
      Description = "stuff",
      Load = function(ref)
        ref.addonContracts = Apollo.GetAddon("Contracts")
        if not ref.addonContracts then return end
        ref.funcOriginal = ref.addonContracts.OpenContracts
        ref.addonContracts.OpenContracts = function(...)
          ref.funcOriginal(...)
          local arrContractWindows = {
            ref.addonContracts.tWndRefs.wndPvEContracts,
            ref.addonContracts.tWndRefs.wndPvPContracts,
          }
          for idx, wndContracts in ipairs(arrContractWindows) do
            local wndActiveContracts = wndContracts:FindChild("ActiveContracts")
            wndActiveContracts:SetSprite("")
            local wndActiveContainer = wndActiveContracts:FindChild("ActiveContractContainer")
            wndActiveContainer:SetAnchorOffsets(-220,54,205,194)
            for idx, wndContract in ipairs(wndActiveContainer:GetChildren()) do
              wndContract:SetAnchorOffsets(-62,0,40,129)
              wndContract:FindChild("TypeIcon"):SetAnchorOffsets(-43,-47,51,47)
              wndContract:FindChild("TypeRepeatable"):SetAnchorOffsets(-9,13,16,37)
              wndContract:FindChild("QualityIcon"):SetAnchorOffsets(-9,56,17,82)
              wndContract:FindChild("AchievedGlow"):SetAnchorOffsets(-80,-31,90,39)
            end
            wndActiveContainer:ArrangeChildrenHorz(Window.CodeEnumArrangeOrigin.Middle)
          end
        end
      end,
      Unload = function(ref)
        ref.addonContracts.OpenContracts = ref.funcOriginal
      end,
    },
  }
end

function HacksByAramunn:LoadMainWindow()
  if self.wndMain and self.wndMain:IsValid() then
    self.wndMain:Destroy()
  end
  self.wndMain = Apollo.LoadForm(self.xmlDoc, "Main", nil, self)
  local wndList = self.wndMain:FindChild("List")
  for hackName, hackData in ipairs(self.tHacks) do
    local wndHack = Apollo.LoadForm(self.xmlDoc, "Hack", wndList, self)
    wndHack:FindChild("IsEnabled"):SetData(hackData)
    wndHack:FindChild("IsEnabled"):SetCheck(self.tSave[hackName] == true)
    wndHack:FindChild("Name"):SetText(hackData.Name)
    wndHack:FindChild("Description"):SetText(hackData.Description)
  end
  wndList:ArrangeChildrenVert(Window.CodeEnumArrangeOrigin.LeftOrTop)
end

function HacksByAramunn:OnEnableDisable(wndHandler, wndControl)
  local hackData = wndControl:GetData()
  local hackName = hackData.Name
  self.tSave[hackName] = wndControl:IsChecked() or nil
  if self.tSave[hackName] then
    hackData:Load()
  else
    hackData:Unload()
  end
end

function HacksByAramunn:OnSave(eLevel)
  if eLevel == GameLib.CodeEnumAddonSaveLevel.Account then
    local tSave = {}
    for hackName, hackStatus in pairs(self.tSave) do
      if hackStatus then tSave[hackName] = true end
    end
    return tSave
  end
end

function HacksByAramunn:OnRestore(eLevel, tSave)
  for hackName, hackStatus in pairs(tSave) do
    if hackStatus and self.tHacks[hackName] then
      self.tSave[hackName] = true
      self.tHacks[hackName]:Load()
    end
  end
end

function HacksByAramunn:new(o)
  o = o or { tSave = {} }
  setmetatable(o, self)
  self.__index = self
  return o
end

function HacksByAramunn:Init()
  self:GenHacks()
  Apollo.RegisterAddon(self)
end

function HacksByAramunn:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile("HacksByAramunn.xml")
  self.xmlDoc:RegisterCallback("OnDocumentReady", self)
  Apollo.RegisterSlashCommand("hacksbyaramunn", "LoadMainWindow", self)
  Apollo.RegisterSlashCommand("ahacks", "LoadMainWindow", self)
  Apollo.RegisterSlashCommand("ahax", "LoadMainWindow", self)
end

local HacksByAramunnInst = HacksByAramunn:new()
HacksByAramunnInst:Init()
