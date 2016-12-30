local HacksByAramunn = {}

function HacksByAramunn:GenHacks()
  self.tHacks = {
    {
      Id = 201612111,
      Name = "Frame Count Deprecation",
      Description = "Fixes addons that use the VarChange_FrameCount event",
      Load = function(ref)
        Apollo.RegisterEventHandler("FrameCount", "OnFrameCount", ref)
      end,
      Unload = function(ref)
        Apollo.RemoveEventHandler("FrameCount", ref)
      end,
      OnFrameCount = function() Event_FireGenericEvent("VarChange_FrameCount") end,
    },
    {
      Id = 201612112,
      Name = "Fourth Contract",
      Description = "Allows four accepted contracts to be shown on the contract board",
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
    {
      Id = 20161217,
      Name = "Hide Trackers in Combat",
      Description = "Hides all but the Public Event Tracker when you're in combat",
      Load = function(ref)
        Apollo.RegisterEventHandler("UnitEnteredCombat", "OnUnitEnteredCombat", ref)
      end,
      Unload = function(ref)
        Apollo.RemoveEventHandler("UnitEnteredCombat", ref)
      end,
      tSave = {},
      strEventTracker = Apollo.GetString("PublicEventTracker_PublicEvents"),
      OnUnitEnteredCombat = function(ref, unit, bEnteredCombat)
        if not unit:IsThePlayer() then return end
        local addonTracker = Apollo.GetAddon("ObjectiveTracker")
        if not addonTracker then return end
        for strKey, tData in pairs(addonTracker.tAddons) do
          ref:UpdateTracker(tData, bEnteredCombat)
        end
      end,
      UpdateTracker = function(ref, tData, bEnteredCombat)
        if not tData.strEventMouseLeft then return end
        if tData.strAddon == ref.strEventTracker then return end
        if bEnteredCombat then
          ref.tSave[tData.strAddon] = tData.bChecked
        end
        if ref.tSave[tData.strAddon] then
          if bEnteredCombat ~= tData.bChecked then return end
        else
          if not (bEnteredCombat and tData.bChecked) then return end
        end
        Event_FireGenericEvent(tData.strEventMouseLeft)
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
  for idx, hackData in ipairs(self.tHacks) do
    local wndHack = Apollo.LoadForm(self.xmlDoc, "Hack", wndList, self)
    wndHack:FindChild("IsEnabled"):SetData(hackData)
    wndHack:FindChild("IsEnabled"):SetCheck(hackData.bEnabled)
    wndHack:FindChild("Name"):SetText(hackData.Name)
    wndHack:FindChild("Description"):SetText(hackData.Description)
  end
  wndList:ArrangeChildrenVert(Window.CodeEnumArrangeOrigin.LeftOrTop)
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
    tSave[hackData.Id] = {
      bEnabled = hackData.bEnabled,
      tSave = hackData.tSave or nil,
    }
  end
  return tSave
end

function HacksByAramunn:OnRestore(eLevel, tSave)
  for idx, hackData in ipairs(self.tHacks) do
    local hackSave = tSave[hackData.Id]
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
  self:GenHacks()
  Apollo.RegisterAddon(self)
end

function HacksByAramunn:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile("HacksByAramunn.xml")
  -- self.xmlDoc:RegisterCallback("OnDocumentReady", self)
  Apollo.RegisterSlashCommand("hacksbyaramunn", "LoadMainWindow", self)
  Apollo.RegisterSlashCommand("ahacks", "LoadMainWindow", self)
  Apollo.RegisterSlashCommand("ahax", "LoadMainWindow", self)
end

local HacksByAramunnInst = HacksByAramunn:new()
HacksByAramunnInst:Init()
