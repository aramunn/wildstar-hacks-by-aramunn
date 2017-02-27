local Hack = {
  nId = 20170226,
  strName = "AH/CX Save Filters",
  strDescription = "Allows you to save searches/filters",
  strXmlDocName = nil, --"AhCxSaveFilters.xml",
  tSave = nil,
}

function Hack:Initialize()
  self.addonMarketplaceAuction = Apollo.GetAddon("MarketplaceAuction")
  if not self.addonMarketplaceAuction then return false end
  local funcOriginal = self.addonMarketplaceAuction.OnItemAuctionSearchResults
  self.addonMarketplaceAuction.OnItemAuctionSearchResults = function(...)
    funcOriginal(...)
    if self.bIsLoaded then
      self:InsertGoToPage()
    end
  end
  return true
end

function Hack:Load()
  self.bIsLoaded = true
end

	self.wndMain:FindChild("SearchEditBox"):SetText("")
	local strSearchQuery = tostring(self.wndMain:FindChild("SearchEditBox"):GetText())
	self.wndMain:FindChild("SearchClearBtn"):Show(true)  Apollo.StringLength(wndHandler:GetText() or "") > 0)
          
	local nSearchId = self.nSearchId
	local strSearchEnum = self.strSearchEnum
	local arFilters = self:GetBuyFilterOptions()
	local tSortData = self.wndMain:FindChild("SortOptionsBtn"):GetData()
          
          
	local arFilters = self:GetBuyFilterOptions()

	local nSearchId = self.nSearchId
	local strSearchEnum = self.strSearchEnum
	local strSearchQuery = tostring(self.wndMain:FindChild("SearchEditBox"):GetText())

	local tSortData = self.wndMain:FindChild("SortOptionsBtn"):GetData()
	local eAuctionSort = tSortData and tSortData.eAuctionSort or MarketplaceLib.AuctionSort.TimeLeft
	local bReverseSort = tSortData and tSortData.bReverse or false
	local nPropertySort = tSortData and tSortData.nPropertySort or false

function Hack:InsertSaveFiltersAH()
end

function Hack:InsertSaveFiltersCX()
end

-- function Hack:InsertGoToPage()
  if not self.addonMarketplaceAuction.wndMain then return end
  local wndToModify = self.addonMarketplaceAuction.wndMain
  local arrWindows = {
    "BuyContainer",
    "SearchResultList",
    "BuyPageBtnContainer",
  }
  for idx, strWindow in ipairs(arrWindows) do
    wndToModify = wndToModify:FindChild(strWindow)
    if not wndToModify then return end
  end
  local wndGoToPage = Apollo.LoadForm(self.xmlDoc, "GoToPage", wndToModify, self)
  wndGoToPage:FindChild("PageNumber"):SetText(tostring(self.addonMarketplaceAuction.nCurPage + 1))
-- end

-- function Hack:OnGoTo(wndHandler, wndControl)
  local nMaxPage = math.floor(self.addonMarketplaceAuction.nTotalResults / MarketplaceLib.kAuctionSearchPageSize)
  local wndPage = wndControl:GetParent():FindChild("PageNumber")
  local nPage = tonumber(wndPage:GetText()) - 1
  if nPage < 0 then nPage = 0 end
  if nPage > nMaxPage then nPage = nMaxPage end
  self.addonMarketplaceAuction.fnLastSearch(nPage)
-- end

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
