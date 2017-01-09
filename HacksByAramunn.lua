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
        ref.addon = Apollo.GetAddon("Contracts")
        if not ref.addon then return end
        ref.funcOriginal = ref.addon.OpenContracts
        ref.addon.OpenContracts = function(...)
          ref.funcOriginal(...)
          local arrContractWindows = {
            ref.addon.tWndRefs.wndPvEContracts,
            ref.addon.tWndRefs.wndPvPContracts,
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
        if not ref.addon then return end
        ref.addon.OpenContracts = ref.funcOriginal
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
    {
      Id = 20170108,
      Name = "AH Go to Page",
      Description = "Adds a way to go to a specific page in the AH search results",
      Load = function(ref)
        ref.addon = Apollo.GetAddon("MarketplaceAuction")
        if not ref.addon then return end
        ref.funcOriginal = ref.addon.OnItemAuctionSearchResults
        ref.addon.OnItemAuctionSearchResults = function(...)
          ref.funcOriginal(...)
          if not ref.addon.wndMain then return end
          local wndToModify = ref.addon.wndMain
          local arrWindows = {
            "BuyContainer",
            "SearchResultList",
            "BuyPageBtnContainer",
          }
          for idx, strWindow in ipairs(arrWindows) do
            wndToModify = wndToModify:FindChild(strWindow)
            if not wndToModify then return end
          end
          local wndGoToPage = Apollo.LoadForm(self.xmlDoc, "20170108-PageGoTo", wndToModify, ref)
          wndGoToPage:FindChild("PageNumber"):SetText(tostring(ref.addon.nCurPage + 1))
        end
      end,
      Unload = function(ref)
        if not ref.addon then return end
        ref.addon.OnItemAuctionSearchResults = ref.funcOriginal
      end,
      OnGoTo = function(ref, wndHandler, wndControl)
        local nMaxPage = math.floor(ref.addon.nTotalResults / MarketplaceLib.kAuctionSearchPageSize)
        local wndPage = wndControl:GetParent():FindChild("PageNumber")
        local nPage = tonumber(wndPage:GetText()) - 1
        if nPage < 0 then nPage = 0 end
        if nPage > nMaxPage then nPage = nMaxPage end
        ref.addon.fnLastSearch(nPage)
      end
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
