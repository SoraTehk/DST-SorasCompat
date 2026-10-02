--[[
Lovely Tallbird Family (workshop-3708350776) + [API] Modded Skins (workshop-2812783478)

Tallbird Family loads its skin files twice: from its modmain (main/skins.lua calls
LoadPrefabFile just to collect skin names for GlassicAPI) and again through
PrefabFiles. When prefab registration starts, Modded Skins records every skin that
exists as "official", which by then includes Tallbird's skins from the first load.
Its CreatePrefabSkin then asserts on the second load ("Modded Skins WILL NOT allow
official skins to be added"), Tallbird Family is disabled mid-load, and the server
fails to start.

Note the skins Tallbird Family registers while its own modmain runs (the first load,
which Modded Skins doesn't check yet), and send only those through the original
CreatePrefabSkin when they're registered again.
]]
local TALLBIRD = "workshop-3708350776"
local MODDED_SKINS = "workshop-2812783478"

local G = GLOBAL
local ModManager = G.ModManager
if not GetModConfigData("lovelytallbirdfamily_moddedskins_skins")
    or ModManager:GetMod(TALLBIRD) == nil or ModManager:GetMod(MODDED_SKINS) == nil then
    return
end

local CreatePrefabSkin = G.CreatePrefabSkin -- original: captured before Modded Skins replaces it
local first_load = {}

-- Runs before Modded Skins loads, so Modded Skins' version calls this one; it only
-- records the names registered during Tallbird Family's modmain.
G.CreatePrefabSkin = function(name, ...)
    if ModManager.currentlyloadingmod == TALLBIRD then
        first_load[name] = true
    end
    return CreatePrefabSkin(name, ...)
end

-- Modded Skins replaces CreatePrefabSkin in its modmain, so wrap its version once
-- prefab registration starts (when the second load happens).
local installed = false
local RegisterPrefabs = ModManager.RegisterPrefabs
ModManager.RegisterPrefabs = function(self, ...)
    if not installed then
        installed = true
        local ModdedSkinsCreatePrefabSkin = G.CreatePrefabSkin
        G.CreatePrefabSkin = function(name, ...)
            if first_load[name] then
                return CreatePrefabSkin(name, ...)
            end
            return ModdedSkinsCreatePrefabSkin(name, ...)
        end
        local count = 0
        for _ in pairs(first_load) do count = count + 1 end
        print("[Sora's Compat] " .. count .. " Lovely Tallbird Family skins skip Modded Skins' duplicate check")
    end
    return RegisterPrefabs(self, ...)
end
