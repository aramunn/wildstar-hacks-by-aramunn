local Hack = {
  nId = 20170327,
  strName = "Display Essences in Loot Stack",
  strDescription = "Fakes essence gains as items so they show up in the loot stack",
  strXmlDocName = nil,
  tSave = nil,
}

local karColors = { "Red", "Green", "Blue", "Purple" }

function Hack:Initialize()
  return true
end

function Hack:Load()
  Apollo.RegisterEventHandler("ChannelUpdate_Loot", "OnChannelUpdate_Loot", self)
end

function Hack:Unload()
  Apollo.RemoveEventHandler("ChannelUpdate_Loot", self)
end

function Hack:OnChannelUpdate_Loot(eType, tEventArgs)
  if eType ~= GameLib.ChannelUpdateLootType.Currency then return end
  local tEssence = self:GetEssence(tEventArgs)
  if tEssence then self:FakeLootItem(tEssence) end
end

function Hack:GetEssence(tData)
  if not tData.monNew then return nil end
  local eMoneyType = tData.monNew:GetMoneyType()
  local eACType = tData.monNew:GetAccountCurrencyType()
  for _,v in ipairs(karColors) do
    if eMoneyType == Money.CodeEnumCurrencyType[v.."Essence"]
    or eACType == AccountItemLib.CodeEnumAccountCurrency[v.."Essence"] then
      return self:GetEssenceData(tData, v)
    end
  end
  for _,v in ipairs(karColors) do
  end
  -- if eMoneyType ~= Money.CodeEnumCurrencyType.GroupCurrency then
    -- return false
  -- end
end

function Hack:GetEssenceData(tData, strColor)
  return {
    strColor = strColor,
    nTotal = tData.monNew:GetAmount(),
    nSignature = tData.monSignatureBonus and tData.monSignatureBonus:GetAmount() or 0,
    nBonus = tData.monEssenceBonus and tData.monEssenceBonus:GetAmount() or 0,
  }
end

function Hack:FakeLootItem(tEssence)
  local nS = tEssence.nSignature
  local nB = tEssence.nBonus
  local strName = string.format("%s Essence (%d%%)", tEssence.strColor, 100*tEssence.nTotal/(tEssence.nTotal-nB))
  self:Print(tostring(tEssence.nTotal).." "..strName)
  Event_FireGenericEvent("ChannelUpdate_Loot", GameLib.ChannelUpdateLootType.Item, {
    nCount = tEssence.nTotal,
    itemNew = {
      CanAutoSalvage                  = function() return false end,
      CanDelete                       = function() return false end,
      CanEquip                        = function() return false end,
      CanMoveToSupplySatchel          = function() return false end,
      CanSalvage                      = function() return false end,
      CanTakeFromSupplySatchel        = function() return false end,
      DoesSalvageRequireKey           = function() return false end,
      GetAdditiveInfo                 = function() return nil end,
      GetAvailableDyeChannel          = function() return nil end,
      GetBackpackCount                = function() return nil end,
      GetBagSlots                     = function() return nil end,
      GetBankCount                    = function() return nil end,
      GetBuyPrice                     = function() return nil end,
      GetCharges                      = function() return nil end,
      GetChatLinkString               = function() return strName end,
      GetCostumeUnlockInfo            = function() return nil end,
      GetDetailedInfo                 = function() return { tPrimary = {} } end,
      GetDurability                   = function() return nil end,
      GetDurationRemaining            = function() return nil end,
      GetDurationTotal                = function() return nil end,
      GetEffectiveLevel               = function() return nil end,
      GetEquippedCount                = function() return nil end,
      GetEquippedItemForItemType      = function() return nil end,
      GetGivenQuest                   = function() return nil end,
      GetGlobalCatalystInfo           = function() return nil end,
      GetHousingDecorInfoId           = function() return nil end,
      GetIcon                         = function() return "IconSprites:Icon_Windows_UI_Coin_Essence_"..tEssence.strColor end,
      GetInventoryId                  = function() return nil end,
      GetItemCategory                 = function() return nil end,
      GetItemCategoryName             = function() return nil end,
      GetItemFamily                   = function() return nil end,
      GetItemFamilyName               = function() return nil end,
      GetItemFlavor                   = function() return nil end,
      GetItemId                       = function() return nil end,
      GetItemPower                    = function() return nil end,
      GetItemQuality                  = function() return Item.CodeEnumItemQuality.Average end,
      GetItemType                     = function() return nil end,
      GetItemTypeName                 = function() return nil end,
      GetMaxCharges                   = function() return nil end,
      GetMaxDurability                = function() return nil end,
      GetMaxStackCount                = function() return nil end,
      GetMaxSupplySatchelStackCount   = function() return nil end,
      GetName                         = function() return strName end,
      GetPowerLevel                   = function() return nil end,
      GetProficiencyInfo              = function() return nil end,
      GetRepairCost                   = function() return nil end,
      GetRequiredClass                = function() return nil end,
      GetRequiredFaction              = function() return nil end,
      GetRequiredLevel                = function() return nil end,
      GetRequiredRace                 = function() return nil end,
      GetReturnTimeRemaining          = function() return nil end,
      GetRuneSlots                    = function() return nil end,
      GetSellPrice                    = function() return nil end,
      GetSetBonuses                   = function() return nil end,
      GetSlot                         = function() return nil end,
      GetSlotName                     = function() return nil end,
      GetStackCount                   = function() return nil end,
      GetTradeskillSchematicId        = function() return nil end,
      GetUnlocks                      = function() return nil end,
      HasRestockingFee                = function() return false end,
      IsAccountTradeable              = function() return false end,
      IsAlwaysTradeable               = function() return false end,
      IsAuctionable                   = function() return false end,
      IsCommodity                     = function() return false end,
      isData                          = function() return false end,
      IsDeprecated                    = function() return false end,
      IsDestroyOnLogout               = function() return false end,
      IsDestroyOnZone                 = function() return false end,
      IsEquippable                    = function() return false end,
      isInstance                      = function() return false end,
      isModdableData                  = function() return false end,
      isRuneData                      = function() return false end,
      IsSalvagedLootSoulbound         = function() return false end,
      IsSoulbound                     = function() return false end,
      IsTradeableTo                   = function() return false end,
      IsUnique                        = function() return false end,
      MoveToSupplySatchel             = function() end,
      PlayEquipSound                  = function() end,
      TakeFromSupplySatchel           = function() end,
    }
  })
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
