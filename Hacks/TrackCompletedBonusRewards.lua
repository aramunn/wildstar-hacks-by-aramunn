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
  Apollo.RegisterSlashCommand("testhack", "TestHack", self)
end

function Hack:TestHack()
  -- for idx, tReward in ipairs(GameLib.GetRewardRotations()) do
    -- table.insert(self.tRewards, tReward)
    -- tReward.nRewardType == GameLib.CodeEnumRewardRotationRewardType.Essence and tReward.nMultiplier < 2
  -- end
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
