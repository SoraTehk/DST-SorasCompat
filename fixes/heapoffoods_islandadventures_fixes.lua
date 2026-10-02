--[[
Heap of Foods (workshop-2334209327) + Island Adventures - Core (workshop-3435352667)

1. Ocean seaweed animations. Heap of Foods and IA Core both ship anim/seaweed.zip
   defining the bank and build "seaweed". IA Core's only has the item animations
   (idle, cooked, idle_water, cooked_water) and wins, so Heap of Foods' planted ocean
   seaweed loses its plant animations and is invisible ("Could not find anim
   [idle_plant] in bank [seaweed]"). Heap of Foods' file has those same item
   animations with identical poses and art, plus the plant ones, so IA Core's seaweed
   prefabs stop declaring their copy and both mods use Heap of Foods' file.

2. Typo. Heap of Foods sets TUNING.HOF_IS_IAC_ENABLED, but its IA integration
   (postinit/mods/islandadventures.lua) checks TUNING.HOF_IS_IAc_ENABLED, so it never
   runs and the Lucky Woodcutter buff gives no bonus logs from IA trees or Palm
   Treeguards. Set the misspelled flag the same way Heap of Foods sets the real one.
   That integration only does anything on the server.
]]
local HOF = "workshop-2334209327"
local IA_CORE = "workshop-3435352667"

local G = GLOBAL
local ModManager = G.ModManager
if ModManager:GetMod(HOF) == nil or ModManager:GetMod(IA_CORE) == nil then
    return
end

-- 1. Ocean seaweed animations
if GetModConfigData("heapoffoods_islandadventures_seaweed") then
    local SEAWEED_ANIM = "anim/seaweed.zip"

    -- Asset paths are resolved in place when a prefab registers, and IA Core's
    -- seaweed prefabs share one assets table, so match both forms.
    local function IsSeaweedAnim(asset)
        return asset.type == "ANIM"
            and (asset.file == SEAWEED_ANIM or asset.file:sub(-#SEAWEED_ANIM - 1) == "/" .. SEAWEED_ANIM)
    end

    local RegisterSinglePrefab = G.RegisterSinglePrefab
    G.RegisterSinglePrefab = function(prefab, ...)
        local folder = prefab.search_asset_first_path
        if folder ~= nil and folder:find(IA_CORE, 1, true) and prefab.assets ~= nil then
            local kept, dropped = {}, false
            for _, asset in ipairs(prefab.assets) do
                if IsSeaweedAnim(asset) then
                    dropped = true
                else
                    table.insert(kept, asset)
                end
            end
            if dropped then
                prefab.assets = kept
                print("[Sora's Compat] IA Core " .. prefab.name .. " uses Heap of Foods' anim/seaweed.zip")
            end
        end
        return RegisterSinglePrefab(prefab, ...)
    end
end

-- 2. HOF_IS_IAc_ENABLED typo
if GetModConfigData("heapoffoods_islandadventures_woodcutter") and G.TUNING.HOF_IS_IAc_ENABLED == nil then
    G.TUNING.HOF_IS_IAc_ENABLED = G.KnownModIndex:IsModEnabled(IA_CORE)
end
