local HacksByAramunn = {}

function HacksByAramunn:GenHacks()
  self.tHacks = {
    
    FrameCountDeprecation = {
      Init = function()
        Apollo.RegisterEventHandler("FrameCount", "OnFrameCount", self.tHacks.FrameCountDeprecation)
      end,
      OnFrameCount = function()
        Event_FireGenericEvent("VarChange_FrameCount")
      end,
    },
    
    FourthContract = {
      Init = function()
        local addonContracts = Apollo.GetAddon("Contracts")
        if not addonContracts then return end
        local originalMethod = addonContracts.OpenContracts
        addonContracts.OpenContracts = function(...)
          originalMethod(...)
          local arrContractWindows = {
            addonContracts.tWndRefs.wndPvEContracts,
            addonContracts.tWndRefs.wndPvPContracts,
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
    },
    
  }
end

function HacksByAramunn:OnSlashCommand()
  Print("Hacks by Aramunn - v@project-version@")
  for hackName, hackData in pairs(self.tHacks) do
    Print("  "..hackName)
    -- Print("  "..hackName..": "..(self.tSave[hackName] and "on" or "off"))
  end
end

-- function HacksByAramunn:OnSlashCommand(strCmd, strParam)
  -- strParam = strParam and string.lower(strParam) or ""
  -- local strOptions = ""
  -- local nSplitIndex = string.find(strParam, " ") or 0
  -- if nSplitIndex > 2 then
    -- strOptions = string.sub(strParam, nSplitIndex + 1)
    -- strParam = string.sub(strParam, 1, nSplitIndex - 1)
  -- end
  -- local funcCmd
  -- for _, tCmdData in pairs(ktCommands) do
    -- if strParam == tCmdData.strCmd then funcCmd = tCmdData.funcCmd end
  -- end
  -- if funcCmd then funcCmd(self, strOptions) else self:PrintHelp() end
-- end

-- function HacksByAramunn:OnSave(eLevel)
  -- if eLevel == GameLib.CodeEnumAddonSaveLevel.Account then
    -- return self.tSave
  -- end
-- end

-- function HacksByAramunn:OnRestore(eLevel, tSave)
  -- for hackName, hackStatus in pairs(tSave) do
    -- if self.tSave[hackName] then self.tSave[hackName] = hackStatus end
  -- end
-- end

function HacksByAramunn:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function HacksByAramunn:Init()
  Apollo.RegisterAddon(self)
end

function HacksByAramunn:OnLoad()
  self:GenHacks()
  for hackName, hackData in pairs(self.tHacks) do hackData.Init() end
  Apollo.RegisterSlashCommand("hacksbyaramunn", "OnSlashCommand", self)
  Apollo.RegisterSlashCommand("ahacks", "OnSlashCommand", self)
  Apollo.RegisterSlashCommand("ahax", "OnSlashCommand", self)
end

local HacksByAramunnInst = HacksByAramunn:new()
HacksByAramunnInst:Init()
