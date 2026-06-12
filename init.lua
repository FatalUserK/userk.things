local nxml = dofile_once("mods/gold_is_dust/luanxml/nxml.lua") ---@type nxml

local settings = {
	gold_is_dust = false,
	spells_materialised = true,
}


ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/gold_is_dust/files/perks_append.lua")

local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. "\n" .. ModTextFileGetContent("mods/gold_is_dust/files/standard.csv") .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)


if settings.spells_materialised then
	local spell_card_append_targets = {
		["data/entities/misc/custom_cards/action.xml"] = true,
		["data/entities/base_custom_card.xml"] = true,
	}

	dofile_once("data/scripts/gun/gun_actions.lua")
	---@diagnostic disable-next-line:undefined-global
	for _,action in pairs(actions) do
		if action.custom_xml_file then
			spell_card_append_targets[action.custom_xml_file] = true
		end
	end

	for path,_ in pairs(spell_card_append_targets) do
		for xml in nxml.edit_file(path) do
			if xml:first_of("AbilityComponent") then break end

			xml:add_child(nxml.new_element("LuaComponent", {
				_tags = "enabled_in_world,enabled_in_inventory,enabled_in_world",
				script_source_file = "mods/gold_is_dust/files/spells_materialised/spell_append.lua",
				remove_after_executed = "1"
			}))
		end
	end

	for xml in nxml.edit_file("data/entities/player_base.xml") do
		for child in xml:each_of("Entity") do
			if child.attr.name == "arm_r" then
				child:add_child(nxml.new_element("LuaComponent", {
					script_shot = "mods/gold_is_dust/files/spells_materialised/shoot_spell.lua"
				}))
			end
		end
	end
end



if settings.gold_is_dust then
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



	local luacomp = nxml.new_element("LuaComponent", {
		execute_on_added = true,
		remove_after_executed = true,
		script_source_file = "mods/gold_is_dust/files/gold_is_dust/nugget_check.lua"
	})

	for _, path in ipairs(list_of_nuggets) do
		for xml in nxml.edit_file(path) do xml:add_child(luacomp) end
	end
end