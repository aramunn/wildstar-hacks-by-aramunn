local Hack = {
  nId = 20170308,
  strName = "Track Completed Bonus Rewards",
  strDescription = "TODO",
  strXmlDocName = "TrackCompletedBonusRewards.xml",
  tSave = {},
}

function Hack:Initialize()
  self.addonMatchMaker = Apollo.GetAddon("MatchMaker")
  if not self.addonMatchMaker then return false end
  local funcOriginal = self.addonMatchMaker.BuildFeaturedList
  self.addonMatchMaker.BuildFeaturedList = function(...)
    funcOriginal(...)
    if self.bIsLoaded then
      self:PlaceOverlays()
    end
  end
  return true
end

function Hack:Load()
  self.bIsLoaded = true
  Apollo.RegisterEventHandler("ChannelUpdate_Loot", "OnChannelUpdate_Loot", self)
end

function Hack:PlaceOverlays()
  local tCurrentTime = GameLib.GetServerTime()
  local nCurrentSeconds = os.time({
    ["year"]  = tCurrentTime.nYear,
    ["month"] = tCurrentTime.nMonth,
    ["day"]   = tCurrentTime.nDay,
    ["hour"]  = tCurrentTime.nHour,
    ["min"]   = tCurrentTime.nMinute,
    ["sec"]   = tCurrentTime.nSecond,
  })
  local wndList = self.addonMatchMaker.tWndRefs.wndMain:FindChild("TabContent:RewardContent")
  for idx, wndReward in ipairs(wndList:GetChildren()) do
    self:BuildOverlay(wndReward, nCurrentSeconds)
  end
end

function Hack:BuildOverlay(wndReward, nCurrentSeconds)
  local tRewardListEntry = wndReward:FindChild("InfoButton"):GetData()
  local tReward = {
    strContentName = tRewardListEntry.strContentName,
    nEndTime = nCurrentSeconds + tRewardListEntry.nSecondsRemaining,
    nMultiplier = tRewardListEntry.tRewardInfo.nMultiplier,
  }
  local wndOverlay = Apollo.LoadForm(self.xmlDoc, "Overlay", wndReward, self)
  wndOverlay:FindChild("Completed"):SetData(tReward)
  if self:RewardActive(tReward) then
    wndOverlay:FindChild("Shader"):Show(false)
  else
    wndOverlay:FindChild("Completed"):SetCheck(true)
  end
end

function Hack:RewardActive(tReward)
  for idx, tCompletedReward in ipairs(self.tSave) do
    if self:IsSameReward(tReward, tCompletedReward) then return false end
  end
  return true
end

function Hack:IsSameReward(tA, tB)
  if tA.nMultiplier ~= tB.nMultiplier then return false end
  local nEndDiff = math.abs(tA.nEndTime - tB.nEndTime)
  if nEndDiff > 60 then return false end
  if tA.strContentName ~= tB.strContentName then return false end
  return true
end

function Hack:OnCompletedCheck(wndHandler, wndControl)
  table.insert(self.tSave, wndControl:GetData())
  wndControl:GetParent():FindChild("Shader"):Show(true)
end

function Hack:OnCompletedUncheck(wndHandler, wndControl)
  local tReward = wndControl:GetData()
  local tTmpSave = self.tSave
  self.tSave = {}
  for idx, tCompletedReward in ipairs(tTmpSave) do
    if not self:IsSameReward(tReward, tCompletedReward) then
      table.insert(self.tSave, tCompletedReward)
    end
  end
  wndControl:GetParent():FindChild("Shader"):Show(false)
end

function Hack:OnChannelUpdate_Loot(eType, tEventArgs)
  if eType == GameLib.ChannelUpdateLootType.Currency then
    local eType = tEventArgs.monNew:GetMoneyType()
    local bIsEssence = false
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.RedEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.BlueEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.GreenEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.PurpleEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.GroupCurrency
    if bIsEssence then
      local strType = "blah"
      strType = eType == Money.CodeEnumCurrencyType.RedEssence and "Red" or strType
      strType = eType == Money.CodeEnumCurrencyType.BlueEssence and "Blue" or strType
      strType = eType == Money.CodeEnumCurrencyType.GreenEssence and "Green" or strType
      strType = eType == Money.CodeEnumCurrencyType.PurpleEssence and "Purple" or strType
      strType = eType == Money.CodeEnumCurrencyType.GroupCurrency and "Group" or strType
      Print(strType..": "..tostring(tEventArgs.monNew:GetAmount()).." (+"..tostring(tEventArgs.monSignatureBonus:GetAmount())..") [x"..tostring(tEventArgs.monEssenceBonus:GetAmount()).."] {"..tostring(tEventArgs.monEssenceBonus:GetAltType()).."}")
    end
  end
end

function Hack:Unload()
  Apollo.RemoveEventHandler("ChannelUpdate_Loot", self)
  self.bIsLoaded = false
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
