--Load Sprites file
local sprite, load_error = SMODS.load_file("sprites.lua")
if load_error then
  sendDebugMessage ("The error is: "..load_error)
else
  sprite()
end

assert(SMODS.load_file("jokers.lua"))()