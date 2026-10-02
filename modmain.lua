local FIXES = {
    "raventeamleader_iacore_fixes",
    "lovelytallbirdfamily_moddedskins_fixes",
    "heapoffoods_islandadventures_fixes",
}

local options = {}
for _, option in ipairs(modinfo.configuration_options) do
    table.insert(options, option.name .. "=" .. (GetModConfigData(option.name) and "on" or "off"))
end
print("[Sora's Compat] " .. table.concat(options, " "))

for _, fix in ipairs(FIXES) do
    modimport("fixes/" .. fix)
end
