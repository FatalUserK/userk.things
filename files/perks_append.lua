---@diagnostic disable: undefined-global
for index, perk in ipairs(perk_list) do
    if perk.id == "GOLD_IS_FOREVER" then
        perk_list[index] = {
            id = "GOLD_IS_DUST",
            ui_name = "$perk_gold_is_dust",
            ui_description = "$perkdesc_gold_is_dust",
            ui_icon = "mods/gold_is_dust/files/perk/gold_is_dust.png",
            perk_icon = "mods/gold_is_dust/files/perk/icon_gold_is_dust.png",
            stackable = false,
            func = function( entity_perk_item, entity_who_picked, item_name )
                GameAddFlagRun("perk_gold_is_dust")
            end,
            func_remove = function( entity_who_picked )
                GameRemoveFlagRun("perk_gold_is_dust")
            end
        }
    end
end