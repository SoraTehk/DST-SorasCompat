--[[
Raven Team Leader (workshop-3492589645) + Island Adventures - Core (workshop-3435352667)

Raven adds two IA recipes only if KnownModIndex:IsModEnabled sees IA Core. On a
joining client the server's mods are only "temporarily enabled", so that check fails
there while it passes on the server. The client is then missing the recipes'
player_classified netvars, can't read its own player data, and shows 100/100 health,
hunger and sanity.

Add the two recipes exactly as Raven defines them wherever IA Core is loaded but
Raven's own check is about to fail. This runs before Raven's modmain (see priority),
and recipe RPC ids are hashes of the recipe name, so crafting matches the server.
]]
local RAVEN = "workshop-3492589645"
local IA_CORE = "workshop-3435352667"

local G = GLOBAL
if not GetModConfigData("raventeamleader_iacore_recipes")
    or G.ModManager:GetMod(RAVEN) == nil or G.ModManager:GetMod(IA_CORE) == nil then
    return
end

local function IsModEnabled(modname)
    return G.KnownModIndex:IsModEnabled(modname)
end

-- Same values Raven derives from its "raventl_rifle_craft" option.
local default_craft = G.GetModConfigData("raventl_rifle_craft", RAVEN) == "default_use"
local tech = default_craft and G.TECH.NONE or G.TECH.SCIENCE_TWO
local filters = default_craft and { "WEAPONS", "CHARACTER" } or { "WEAPONS" }
local builder_tag = default_craft and "raventltag" or nil

-- Raven's own conditions for these recipes (its other mod checks included).
if not (IsModEnabled(IA_CORE) or IsModEnabled("workshop-2736496814") or IsModEnabled("workshop-1342256262")) then
    AddRecipe2("raventl_rifle_obsidian",
        { G.Ingredient("raventl_rifle", 1), G.Ingredient("dragoonheart", 1), G.Ingredient("obsidian", 3) },
        tech, { product = "raventl_rifle_obsidian", builder_tag = builder_tag, numtogive = 1 }, filters)
    print("[Sora's Compat] added Raven Team Leader recipe raventl_rifle_obsidian for IA Core")
end

if not (IsModEnabled(IA_CORE) or IsModEnabled("workshop-3322803908")) then
    AddRecipe2("poison_raventl_bullet",
        { G.Ingredient("raventl_bullet", 6), G.Ingredient("venomgland", 1) },
        tech, { product = "poison_raventl_bullet", builder_tag = builder_tag, numtogive = 6 }, filters)
    print("[Sora's Compat] added Raven Team Leader recipe poison_raventl_bullet for IA Core")
end
