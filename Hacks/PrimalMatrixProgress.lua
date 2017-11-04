local Hack = {
  nId = 20171030,
  strName = "Primal Matrix Progress",
  strDescription = "Enables command /pmp to check your essence collection progress",
  strXmlDocName = "PrimalMatrixProgress.xml",
  tSave = nil,
}

function Hack:Initialize()
  return true
end

function Hack:Load()
  Apollo.RegisterSlashCommand("pmp", "OnCheckProgress", self)
end

function Hack:Unload()
  self:PrintMessage("A Reload UI is required to remove the slash command")
end

function Hack:OnCheckProgress()
  local karColors = {
    "Red",
    "Green",
    "Blue",
    "Purple",
  }
  local tCur = {}
  local tMax = {}
  for _,v in ipairs(karColors) do
    tCur[v] = GameLib.GetPlayerCurrency(Money.CodeEnumCurrencyType[v.."Essence"]):GetAmount()
    tMax[v] = 0
  end
  local wndMain = Apollo.LoadForm(self.xmlDoc, "MatrixForm", nil, self)
  local wndMatrix = wndMain:FindChild("Window")
  for x=-13,13 do
    for y=-13,13 do
      local node = wndMatrix:GetNodeAtHexCoord(x, y)
      if node then
        for _,v in ipairs(karColors) do
          local nCost = node.tPrice["mon"..v]:GetAmount()
          tCur[v] = tCur[v] + (nCost * node.nSavedAllocations)
          tMax[v] = tMax[v] + (nCost * node.nMaxAllocations)
        end
      end
    end
  end
  wndMain:Close()
  wndMain:Destroy()
  for _,v in ipairs(karColors) do
    local fPercent = 100 * tCur[v] / tMax[v]
    Print(string.format("%s: %.2f%% (%d/%d)", v:sub(1,1), fPercent, tCur[v], tMax[v]))
  end
end

function Hack:PrintMessage(strMessage)
  ChatSystemLib.PostOnChannel(ChatSystemLib.ChatChannel_System, strMessage, "PMP")
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
