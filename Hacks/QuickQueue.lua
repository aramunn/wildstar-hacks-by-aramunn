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
    bVeteran = true,
    bHasLevels = true,
    tNames = {
      ["Prime: Rage Logic"] = { "RL" },
      ["Prime: Gauntlet"] = { "GLT" },
    }
  },
  [MatchMakingLib.MatchType.Dungeon] = {
    tNames = {
      ["Random Dungeon"] = { "Rnorm" },
    }
  },
}

local tMap = {}

function Hack:OnSlashCommand(strCmd, strParams)
  if not strParams then return end
  local tParams = { arRoles = {} }
  for strParam in string.gmatch(strParams, "[^ ]+") do
    self:ParseParam(tParams, strParam)
  end
  if not tParams.strName then
    self:Print("TODO --help")
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
  if tInfo.bHasLevels and not tParams.nPrime then
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
  Print(matchGame:GetInfo().strName)
  for _, eRole in ipairs(tOptions.arRoles) do
    Print(tostring(eRole))
  end
  Print("FindOthers: "..tostring(tOptions.bFindOthers))
  Print("PrimeLevel: "..tostring(tOptions.nPrimeLevel))
  Print("QueueGroup: "..tostring(bQueueAsGroup))
  if bQueueAsGroup then
    MatchMakingLib.QueueAsGroup({matchGame}, tOptions)
  else
    MatchMakingLib.Queue({matchGame}, tOptions)
  end
  
  -- MatchMakingLib.Queue(
    -- { MatchMakingLib.GetMatchMakingEntries(11, true, true)[7] },
    -- { arRoles={1}, bFindOthers=false, bVeteran=false, nPrimeLevel=15 }
  -- )
  
  --QueueAsGroup
end

function Hack:ParseParam(tParams, strParam)
  if not tParams.strName then
    tParams.strName = strParam
    return
  end
  local strPrime = string.match(strParam, "p([0-9]+)")
  if strPrime then
    tParams.nPrime = tonumber(strPrime)
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
