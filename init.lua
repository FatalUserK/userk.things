--ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/gold_is_dust/files/perks_append.lua")

--ModMaterialsFileAdd("mods/gold_is_dust/files/materials.xml")

local list_of_nuggets = {
    "data/entities/items/pickup/goldnugget.xml",
    "data/entities/items/pickup/goldnugget_10.xml",
    "data/entities/items/pickup/goldnugget_50.xml",
    "data/entities/items/pickup/goldnugget_200.xml",
    "data/entities/items/pickup/goldnugget_1000.xml",
    "data/entities/items/pickup/goldnugget_10000.xml",
    "data/entities/items/pickup/goldnugget_200000.xml",
    "data/entities/items/pickup/goldnugget_x.xml",
}

for _, path in ipairs(list_of_nuggets) do
    
end