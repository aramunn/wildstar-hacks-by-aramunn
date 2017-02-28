local Hack = {
  nId = 20170226,
  strName = "AH/CX Save Filters",
  strDescription = "Allows you to save searches/filters",
  strXmlDocName = nil, --"AhCxSaveFilters.xml",
  tSave = {},
}

function Hack:Initialize()
  local bCanUseHack = false
  self.addonMarketplaceAuction = Apollo.GetAddon("MarketplaceAuction")
  if self.addonMarketplaceAuction then
    local funcOriginal = self.addonMarketplaceAuction.InitializeCategories
    self.addonMarketplaceAuction.InitializeCategories = function(...)
      if self.bIsLoaded then
        self:InsertSaveFiltersAH()
      end
      funcOriginal(...)
    end
    bCanUseHack = true
  end
  self.addonMarketplaceCommodity = Apollo.GetAddon("MarketplaceCommodity")
  if self.addonMarketplaceCommodity then
    bCanUseHack = true
  end
  return bCanUseHack
end

function Hack:Load()
  self.bIsLoaded = true
end

function Hack:InsertSaveFiltersAH()
  if not self.addonMarketplaceAuction.wndMain then return end
  local wndParent = self.addonMarketplaceAuction.wndMain:FindChild("MainCategoryContainer")
  local wndTop = Apollo.LoadForm(self.addonMarketplaceAuction.xmlDoc, "CategoryTopItem", wndParent, self.addonMarketplaceAuction)
  wndTop:FindChild("CategoryTopBtn"):SetData(wndTop)
  wndTop:FindChild("CategoryTopBtn"):SetCheck(false) -- Check the first item found
  wndTop:FindChild("CategoryTopBtn"):SetText("Test Top")
  local wndCurr = Apollo.LoadForm(self.addonMarketplaceAuction.xmlDoc, "CategoryMidItem", wndTop:FindChild("CategoryTopList"), self.addonMarketplaceAuction)
  wndCurr:FindChild("CategoryMidBtn"):SetText("Test Mid")
  wndCurr:FindChild("CategoryMidBtn"):SetData({ 123, "Bot" })
  -- self.nSearchId = wndHandler:GetData()[1]
  -- self.strSearchEnum = wndHandler:GetData()[2]
end

-- self.wndMain:FindChild("SearchEditBox"):SetText("")
-- local strSearchQuery = tostring(self.wndMain:FindChild("SearchEditBox"):GetText())
-- self.wndMain:FindChild("SearchClearBtn"):Show(true)  Apollo.StringLength(wndHandler:GetText() or "") > 0)
        
-- local nSearchId = self.nSearchId
-- local strSearchEnum = self.strSearchEnum
-- local arFilters = self:GetBuyFilterOptions()
-- local tSortData = self.wndMain:FindChild("SortOptionsBtn"):GetData()
        
        
-- local arFilters = self:GetBuyFilterOptions()

-- local nSearchId = self.nSearchId
-- local strSearchEnum = self.strSearchEnum
-- local strSearchQuery = tostring(self.wndMain:FindChild("SearchEditBox"):GetText())

-- local tSortData = self.wndMain:FindChild("SortOptionsBtn"):GetData()
-- local eAuctionSort = tSortData and tSortData.eAuctionSort or MarketplaceLib.AuctionSort.TimeLeft
-- local bReverseSort = tSortData and tSortData.bReverse or false
-- local nPropertySort = tSortData and tSortData.nPropertySort or false

function Hack:InsertSaveFiltersCX()
end

function Hack:Unload()
  self.bIsLoaded = false
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
