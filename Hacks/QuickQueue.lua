local Hack = {
  nId = 20180203,
  strName = "Quick Queue",
  strDescription = "Enables /qq command (run it for more info)",
  strXmlDocName = nil,
  tSave = nil,
}

--event: none
--world story: false
--shiphand, false (non vet?)
--ScaledPrimeLevelExpedition, true (Random only)
--prime exp: true
--adv: both, true has rand
--scaled prime adv: none
--prime adv: none
--dung: false
--scaled prime dung, true (rand only)
--prime dung: true
--bg: false
--rated bg, false
--openarena, both? also duplicated (2 of each in each true and false)
--arena: both? no dups
--warplot both?

local ktInfo = {
  [MatchMakingLib.MatchType.PrimeLevelExpedition] = {
    strDescription = "Prime Expeditions",
    bVeteran = true,
    bHasLevels = true,
    tNames = {
      ["Prime: Evil from the Ether"] = { "EftE" },
      ["Prime: Outpost M-13"] = { "M13" },
      ["Prime: Infestation"] = { "Infestation", "Inf" },
      ["Prime: Deep Space Exploration"] = { "DSE" },
      ["Prime: Rage Logic"] = { "RL" },
      ["Prime: Gauntlet"] = { "Gauntlet", "Gaunt" },
      ["Prime: Space Madness"] = { "SM" },
      ["Prime: Fragment Zero"] = { "FZ" },
    }
  },
  [MatchMakingLib.MatchType.Dungeon] = {
    strDescription = "Normal Dungeons",
    tNames = {
      ["Random Dungeon"] = { "Rnorm" },
    }
  },
  [MatchMakingLib.MatchType.RatedBattleground] = {
    strDescription = "Battlegrounds",
    tNames = {
      ["Random"] = { "RBG" },
      ["Walatiki Temple"] = { "Tiki" },
      ["Daggerstone Pass"] = { "Daggerstone", "Dagger" },
      ["Halls of the Bloodsworn: Reloaded"] = { "Halls" },
    }
  },
}

local ktRoles = {
  [MatchMakingLib.Roles.DPS] = "DPS",
  [MatchMakingLib.Roles.Healer] = "Heals",
  [MatchMakingLib.Roles.Tank] = "Tank",
}

local tMap = {}

function Hack:OnSlashCommand(strCmd, strParams)
  if not strParams then return end
  local tParams = { arRoles = {} }
  for strParam in string.gmatch(strParams, "[^ ]+") do
    self:ParseParam(tParams, strParam)
  end
  if not tParams.strName then
    self:PrintHelp()
    return
  end
  if string.lower(tParams.strName) == "names" then
    self:PrintNames()
    return
  end
  local tInfo = tMap[string.lower(tParams.strName)]
  if not tMap then
    self:Print("Unknown name: "..tParams.strName)
    return
  end
  if #tParams.arRoles == 0 then
    self:Print("Specify one or more roles (d, h, or t)")
    return
  end
  if tInfo.bHasLevels and not tParams.nPrimeLevel then
    self:Print("Specify prime level (p#)")
    return
  end
  local matchGame = self:FindMatchGame(tInfo)
  if not matchGame then
    self:Print("Failed to find match")
    return
  end
  local bQueueAsGroup = tParams.bQueueAsGroup or false
  local bCanQueueSolo = matchGame:CanQueue() == MatchMakingLib.MatchQueueResult.Success
  local bCanQueueGroup = matchGame:CanQueueAsGroup() == MatchMakingLib.MatchQueueResult.Success
  if not bCanQueueSolo and not bCanQueueGroup then
    self:Print("Unable to queue")
    return
  elseif bCanQueueSolo and bCanQueueGroup then
    bQueueAsGroup = bCanQueueGroup
  end
  local tOptions = {
    arRoles = tParams.arRoles,
    bFindOthers = tParams.bFindOthers or false,
    bVeteran = false,
    nPrimeLevel = tParams.nPrimeLevel or 0,
  }
  local strInfo = "Queuing "..matchGame:GetInfo().strName
  strInfo = strInfo..(bQueueAsGroup and " grouped" or " solo").." as "
  for idx, eRole in ipairs(tOptions.arRoles) do
    if idx > 1 then strInfo = strInfo.." and " end
    strInfo = strInfo..ktRoles[eRole]
  end
  if tOptions.bFindOthers then
    strInfo = strInfo.." finding others"
  end
  if tOptions.nPrimeLevel > 0 then
    strInfo = strInfo.." at P"..tostring(tOptions.nPrimeLevel)
  end
  self:Print(strInfo)
  if bQueueAsGroup then
    MatchMakingLib.QueueAsGroup({matchGame}, tOptions)
  else
    MatchMakingLib.Queue({matchGame}, tOptions)
  end
end

function Hack:ParseParam(tParams, strParam)
  if not tParams.strName then
    tParams.strName = strParam
    return
  end
  local strPrime = string.match(strParam, "p([0-9]+)")
  if strPrime then
    tParams.nPrimeLevel = tonumber(strPrime)
    return
  end
  if strParam == "g" then
    tParams.bQueueAsGroup = true
    return
  end
  if strParam == "f" then
    tParams.bFindOthers = true
    return
  end
  if strParam == "d" then
    table.insert(tParams.arRoles, MatchMakingLib.Roles.DPS)
    return
  end
  if strParam == "h" then
    table.insert(tParams.arRoles, MatchMakingLib.Roles.Healer)
    return
  end
  if strParam == "t" then
    table.insert(tParams.arRoles, MatchMakingLib.Roles.Tank)
    return
  end
end

function Hack:FindMatchGame(tInfo)
  for _, matchGame in ipairs(MatchMakingLib.GetMatchMakingEntries(tInfo.eMatchType, tInfo.bVeteran, true)) do
    if matchGame:GetInfo().strName == tInfo.strLong then return matchGame end
  end
end

function Hack:PrintHelp()
  self:Print("/qq NAME [p#] [d|h|t] [g] [f]")
  self:Print(" -p#: prime level")
  self:Print(" -d|h|t: dps|heals|tank (include one or two)")
  self:Print(" -g: queue as group")
  self:Print(" -f: find others")
  self:Print("e.g. /qq FZ p13 d h")
  self:Print("use '/qq names' to see available names")
end

function Hack:PrintNames()
  for _, tInfo in pairs(ktInfo) do
    self:Print(tInfo.strDescription..":")
    for strLong, arShorts in pairs(tInfo.tNames) do
      local strOpts = ""
      for idx, strShort in ipairs(arShorts) do
        if idx > 1 then strOpts = strOpts.."|" end
        strOpts = strOpts..strShort
      end
      self:Print("  - "..strLong.." ("..strOpts..")")
    end
  end
end

function Hack:Initialize()
  for eMatchType, tInfo in pairs(ktInfo) do
    for strLong, arShorts in pairs(tInfo.tNames) do
      for _, strShort in ipairs(arShorts) do
        tMap[string.lower(strShort)] = {
          strLong = strLong,
          eMatchType = eMatchType,
          bVeteran = tInfo.bVeteran or false,
          bHasLevels = tInfo.bHasLevels or false,
        }
      end
    end
  end
  return true
end

function Hack:Load()
  self:AddSlashCmd("qq", "OnSlashCommand", self)
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
