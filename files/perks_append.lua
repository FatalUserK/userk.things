local perk_replacements = {
	GOLD_IS_FOREVER = {
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
	},
	ABILITY_ACTIONS_MATERIALIZED = {}
}

---@diagnostic disable-next-line:lowercase-global
perk_list = perk_list
for index, perk in ipairs(perk_list) do
	if perk_replacements[perk.id] then
		for k,v in pairs(perk_replacements[perk.id]) do
			perk_list[index][k] = v
		end
	end
end