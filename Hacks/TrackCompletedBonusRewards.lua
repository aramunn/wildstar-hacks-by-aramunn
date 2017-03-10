local Hack = {
  nId = 20170308,
  strName = "Track Completed Bonus Rewards",
  strDescription = "TODO",
  strXmlDocName = nil,
  tSave = {},
}

function Hack:Initialize()
  self.addonMatchMaker = Apollo.GetAddon("MatchMaker")
  if not self.addonMatchMaker then return false end
  return true
end

function Hack:Load()
  Apollo.RegisterEventHandler("ChannelUpdate_Loot", "OnChannelUpdate_Loot", self)
end

function Hack:OnChannelUpdate_Loot(eType, tEventArgs)
  if eType == GameLib.ChannelUpdateLootType.Currency then
    local eType = tEventArgs.monNew:GetMoneyType()
    local bIsEssence = false
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.RedEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.BlueEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.GreenEssence
    bIsEssence = bIsEssence or eType == Money.CodeEnumCurrencyType.PurpleEssence
    if bIsEssence then
      local strType = "blah"
      strType = eType == Money.CodeEnumCurrencyType.RedEssence and "Red" or strType
      strType = eType == Money.CodeEnumCurrencyType.BlueEssence and "Blue" or strType
      strType = eType == Money.CodeEnumCurrencyType.GreenEssence and "Green" or strType
      strType = eType == Money.CodeEnumCurrencyType.PurpleEssence and "Purple" or strType
      Print(strType..": "..tostring(tEventArgs.monNew:GetAmount()).." (+"..tostring(tEventArgs.monSignatureBonus:GetAmount())..") [x"..tostring(tEventArgs.monEssenceBonus:GetAmount()).."]")
    end
  end
end

function Hack:Unload()
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
