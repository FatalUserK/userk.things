ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/gold_is_dust/files/perks_append.lua")

ModMaterialsFileAdd("mods/gold_is_dust/files/materials/materials.xml")
if ModSettingGet("GID.vanilla_bloody then") then ModMaterialsFileAdd("mods/gold_is_dust/files/materials/materials_extra_bloody.xml") end

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



local nxml = dofile_once("mods/gold_is_dust/luanxml/nxml.lua") ---@type nxml
local luacomp = nxml.new_element("LuaComponent", {
    execute_on_added = true,
    remove_after_executed = true,
    script_source_file = "mods/gold_is_dust/files/perk/nugget_check.lua"
})

for _, path in ipairs(list_of_nuggets) do
    for xml in nxml.edit_file(path) do xml:add_child(luacomp) end
end