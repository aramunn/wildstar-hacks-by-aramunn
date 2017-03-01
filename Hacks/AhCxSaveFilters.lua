local Hack = {
  nId = 20170226,
  strName = "AH/CX Save Filters",
  strDescription = "Allows you to save searches/filters",
  strXmlDocName = "AhCxSaveFilters.xml",
  tSave = {
    AH = {},
    CX = {},
  },
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
  local addonAH = self.addonMarketplaceAuction
  if not addonAH.wndMain then return end
  local wndParent = addonAH.wndMain:FindChild("MainCategoryContainer")
  local wndTop = Apollo.LoadForm(addonAH.xmlDoc, "CategoryTopItem", wndParent, self)
  wndTop:FindChild("CategoryTopBtn"):SetData(wndTop)
  wndTop:FindChild("CategoryTopBtn"):SetCheck(false)
  wndTop:FindChild("CategoryTopBtn"):SetText("Saved Filters")
  local wndSaveButton = Apollo.LoadForm(self.xmlDoc, "SaveFiltersAH", wndTop, self)
  
  for idx, tFilter in ipairs(self.tSave.AH) do
    local wndCurr = Apollo.LoadForm(addonAH.xmlDoc, "CategoryMidItem", wndTop:FindChild("CategoryTopList"), self)
    wndCurr:FindChild("CategoryMidBtn"):SetText(tFilter.strName)
    wndCurr:FindChild("CategoryMidBtn"):SetData(tFilter.tData)
  end
  
  -- self.nSearchId = wndHandler:GetData()[1]
  -- self.strSearchEnum = wndHandler:GetData()[2]
end

function Hack:OnSaveCurrentAH(wndHandler, wndControl)
  local addonAH = self.addonMarketplaceAuction
  local strSearchQuery = tostring(addonAH.wndMain:FindChild("SearchEditBox"):GetText())
  local nSearchId = addonAH.nSearchId
  local strSearchEnum = addonAH.strSearchEnum
  local arFilters = addonAH:GetBuyFilterOptions()
  local tSortData = addonAH.wndMain:FindChild("SortOptionsBtn"):GetData()
  local eAuctionSort = tSortData and tSortData.eAuctionSort or MarketplaceLib.AuctionSort.TimeLeft
  local bReverseSort = tSortData and tSortData.bReverse or false
  local nPropertySort = tSortData and tSortData.nPropertySort or false
  
  Print("strSearchQuery = "..tostring(strSearchQuery))
  Print("nSearchId = "..tostring(nSearchId))
  Print("strSearchEnum = "..tostring(strSearchEnum))
  Print("arFilters = "..tostring(arFilters))
  Print("tSortData = "..tostring(tSortData))
  Print("eAuctionSort = "..tostring(eAuctionSort))
  Print("bReverseSort = "..tostring(bReverseSort))
  Print("nPropertySort = "..tostring(nPropertySort))
  
  table.insert(self.tSave.AH, {
    strName = "Temp name",
    tData = {
      strSearchQuery = tostring(addonAH.wndMain:FindChild("SearchEditBox"):GetText()),
      nSearchId = addonAH.nSearchId,
      strSearchEnum = addonAH.strSearchEnum,
      arFilters = addonAH:GetBuyFilterOptions(),
      tSortData = addonAH.wndMain:FindChild("SortOptionsBtn"):GetData(),
      eAuctionSort = tSortData and tSortData.eAuctionSort or MarketplaceLib.AuctionSort.TimeLeft,
      bReverseSort = tSortData and tSortData.bReverse or false,
      nPropertySort = tSortData and tSortData.nPropertySort or false,
    },
  })
end

function Hack:OnCategoryTopBtnCheck(wndHandler, wndControl) -- CategoryTopBtn
  Print("OnCategoryTopBtnCheck")
	-- self.wndMain:SetGlobalRadioSel("MarketplaceAuction_CategoryMidBtn_GlobalRadioGroup", -1)

	-- self.nSearchId = nil
	-- self.strSearchEnum = nil

	-- local wndParent = wndHandler:GetData()
	-- if wndHandler:IsChecked() and wndParent then
		-- local wndAllBtn = wndParent:FindChild("CategoryTopList") and wndParent:FindChild("CategoryTopList"):FindChild("CategoryMidItem_All") or nil
		-- if wndAllBtn then
			-- wndAllBtn:FindChild("CategoryMidBtn"):SetCheck(true)

			-- TODO Refactor these out if possible
			-- self.nSearchId = wndAllBtn:FindChild("CategoryMidBtn"):GetData()[1]
			-- self.strSearchEnum = wndAllBtn:FindChild("CategoryMidBtn"):GetData()[2]
		-- end
	-- end

	-- self:OnRefreshBtn()
	-- self:OnResizeCategories()
end

function Hack:OnCategoryTopBtnUncheck(wndHandler, wndControl) -- CategoryTopBtn
  Print("OnCategoryTopBtnUncheck")
	-- self.wndMain:SetGlobalRadioSel("MarketplaceAuction_CategoryMidBtn_GlobalRadioGroup", -1)

	-- self.nSearchId = nil
	-- self.strSearchEnum = nil

	-- self:OnResizeCategories()
end

function Hack:OnCategoryMidBtnCheck(wndHandler, wndControl)
  Print("OnCategoryMidBtnCheck")

	-- TODO refactor these variables
	-- self.nSearchId = wndHandler:GetData()[1]
	-- self.strSearchEnum = wndHandler:GetData()[2]
	-- self:OnRefreshBtn()
end

function Hack:OnCategoryMidBtnUncheck(wndHandler, wndControl)
  Print("OnCategoryMidBtnUncheck")
end

function Hack:RestoreFilters()

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

end

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
