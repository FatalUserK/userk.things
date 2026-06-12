local perk_replacements = {
	GOLD_IS_FOREVER = {
		id = "USERK.GOLD_IS_DUST",
		ui_name = "$userk.gold_is_dust.perkname",
		ui_description = "$userk.gold_is_dust.perkdesc",
		ui_icon = "mods/gold_is_dust/files/gold_is_dust/gold_is_dust.png",
		perk_icon = "mods/gold_is_dust/files/gold_is_dust/icon_gold_is_dust.png",
		author = "UserK",
		origin = "UserK's Things",
		stackable = false,
		func = function( entity_perk_item, entity_who_picked, item_name )
			GameAddFlagRun("perk_gold_is_dust")
		end,
		func_remove = function( entity_who_picked )
			GameRemoveFlagRun("perk_gold_is_dust")
		end,
	},
	ABILITY_ACTIONS_MATERIALIZED = {
		id = "USERK.SPELLS_MATERIALISED",
		ui_name = "$userk.spells_materialised.perkname",
		ui_description = "$userk.spells_materialised.perkdesc"
	}
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