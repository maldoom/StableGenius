StableGenius = LibStub("AceAddon-3.0"):NewAddon("StableGenius", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
-- local AceGUI = LibStub("AceGUI-3.0")

-- 
function StableGenius:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("StableGeniusDB")
end

-- 
function StableGenius:OnEnable()
  -- message('StableGenius#OnEnable')
end

-- 
function StableGenius:OnDisable()
  -- message('StableGenius#OnDisable')
end

-- 
-- Toggles the PetStableFrame.  This is currently triggered by slashcommand.
-- Note that we use PetStable_OnEvent() to trigger this.  Doing it this way allows the various UI
-- setup and tear down functions to trigger and results in a better user experience.
-- 
function StableGenius:ToggleStable()
  if (PetStableFrame:IsShown()) then
    PetStable_OnEvent(PetStableFrame, "PET_STABLE_CLOSED")
  else 
    PetStable_OnEvent(PetStableFrame, "PET_STABLE_SHOW")
  end
end

-- 
-- Returns a table containing strings that are to be appended to various tooltips.
-- 
function StableGenius:getTooltipLines(petFamily)
  local petId = HunterData:getPetIdByFamilyName(petFamily)
  if not petId then return "" end
  
  local petSpells = HunterData:getPetSpellsByPetId(petId)
  if not petSpells then return "" end

  -- For now we're just going to display the pet spell names
  local spellNames = HunterData:getPetSpellAttributeBySpellIds(petSpells, "name")
  table.sort(spellNames)

  -- Very simple for the time being.  @TODO to make this more interesting.
  return spellNames
end

-- 
-- Append tooltip info for the Hunter Stable UI
-- 
function StableGenius:PetStable_UpdateSlot(button, petSlot)
  local petIcon, petName, petLevel, petFamily, petLoyalty = GetStablePetInfo(petSlot)
  if not petFamily or petFamily == "" then return end
  -- 
  button.tooltipSubtext = button.tooltipSubtext .. table.concat(self:getTooltipLines(petFamily), "\n")
  if GameTooltip:IsOwned(button) then button:GetScript("OnEnter")(button) end
end

-- 
-- Append tooltip info for Hunter's "Call Pet" spells
-- 
function StableGenius:OnTooltipSetSpell(tooltip)
  local spellName, spellId = tooltip:GetSpell()
  if not spellName then return end
  
  -- Check HunterData to see if this is one of our "Call Pet" spell slots
  local callPetSpell = HunterData:getCallPetSpells()[spellId]
  if not callPetSpell then return end
  
  -- Make sure the slot actually has an active pet
  local _, _, _, petFamily = GetStablePetInfo(callPetSpell)
  if not petFamily or petFamily == "" then return end

  -- add to spell tooltip
  for _, line in pairs(self:getTooltipLines(petFamily)) do
    tooltip:AddLine(line)
  end
end

-- Register event hooks
StableGenius:SecureHook(nil, "PetStable_UpdateSlot", "PetStable_UpdateSlot")
StableGenius:HookScript(GameTooltip, "OnTooltipSetSpell", "OnTooltipSetSpell")
