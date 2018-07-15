local AceConfig = LibStub("AceConfig-3.0")

local options = {
  name = "StableGenius",
  handler = StableGenius,
  type = 'group',
  args = {
      toggle = {
          type = 'execute',
          name = 'Toggle Stable',
          desc = 'Toggles the Stable interface',
          func = 'ToggleStable',
      },
  },
}

options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(LibStub("AceDB-3.0"):New("StableGeniusDB"))

AceConfig:RegisterOptionsTable("StableGenius", options, {"stablegenius"})
