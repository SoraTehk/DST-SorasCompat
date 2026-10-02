name = "Sora's Compat"
description = [[Compatibility fixes for mod combinations on Sora's servers. Each fix can be turned off in the mod's settings.

- Raven Team Leader + Island Adventures: joining players no longer get health, hunger and sanity stuck at 100/100.
- Lovely Tallbird Family + Modded Skins: Tallbird skins no longer crash the server.
- Heap of Foods + Island Adventures: ocean seaweed is animated again, and the Lucky Woodcutter buff works on IA trees.]]
author = "SoraTehk"
version = "0.1.0"
api_version = 10

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

-- Mods load from highest priority to lowest. Priorities of the mods fixed here:
--   [API] Modded Skins               2147483647
--   Island Adventures - Core         5
--   Island Adventures - Shipwrecked  4
--   Raven Team Leader                0 (not set)
--   Heap of Foods                    -15
--   Lovely Tallbird Family           -987
-- Modded Skins uses 2147483647 to load first; this is one higher, so Sora's Compat
-- loads before every one of them. That lets fixes capture vanilla functions before
-- those mods replace them (Modded Skins' CreatePrefabSkin) and act before their
-- modmains run (Raven Team Leader's recipes).
priority = 2147483648

local function Toggle(name, label, hover)
    return {
        name = name,
        label = label,
        hover = hover,
        options = {
            { description = "On", data = true },
            { description = "Off", data = false },
        },
        default = true,
    }
end

configuration_options = {
    Toggle("raventeamleader_iacore_recipes", "Raven + IA: recipes",
        "Joining players get Raven Team Leader's two IA recipes, which fixes health, hunger and sanity stuck at 100/100."),
    Toggle("lovelytallbirdfamily_moddedskins_skins", "Tallbird + Modded Skins: skins",
        "Lovely Tallbird Family skins load without Modded Skins rejecting them as official skins."),
    Toggle("heapoffoods_islandadventures_seaweed", "HoF + IA: seaweed animation",
        "IA Core's seaweed uses Heap of Foods' animation file (same item art), so Heap of Foods' ocean seaweed isn't invisible."),
    Toggle("heapoffoods_islandadventures_woodcutter", "HoF + IA: woodcutter on IA trees",
        "Turns on Heap of Foods' Lucky Woodcutter bonus logs for IA trees and Palm Treeguards (a misspelled flag disabled it)."),
}
