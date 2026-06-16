local nxml = dofile_once("mods/userk.things/luanxml/nxml.lua") ---@type nxml

local settings = {
	gold_is_dust = true,
	spells_materialised = true,
}


local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. "\n" .. ModTextFileGetContent("mods/userk.things/files/standard.csv") .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)

ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/userk.things/files/perks_append.lua")
ModMagicNumbersFileAdd("mods/userk.things/files/magic_numbers.xml")



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
				script_source_file = "mods/userk.things/files/spells_materialised/spell_append.lua",
				remove_after_executed = "1"
			}))
		end
	end

	for xml in nxml.edit_file("data/entities/player_base.xml") do
		for child in xml:each_of("Entity") do
			if child.attr.name == "arm_r" then
				child:add_child(nxml.new_element("LuaComponent", {
					script_shot = "mods/userk.things/files/spells_materialised/shoot_spell.lua"
				}))
			end
		end
	end
end


if settings.gold_is_dust then
	ModMaterialsFileAdd("mods/userk.things/files/materials/materials.xml")
	--if ModSettingGet("GID.vanilla_bloody then") then ModMaterialsFileAdd("mods/userk.things/files/materials/materials_extra_bloody.xml") end

	if ModIsEnabled("prospector-perk") then
		ModLuaFileAppend("mods/prospector-perk/files/perk/prospector.lua", "mods/userk.things/files/gold_is_dust/append_prospector.lua")
	end

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
		script_source_file = "mods/userk.things/files/gold_is_dust/nugget_expire.lua",
		execute_every_n_frame = -1,
		execute_on_removed = true
	})

	for _, path in ipairs(list_of_nuggets) do
		for xml in nxml.edit_file(path) do xml:add_child(luacomp) end
	end


	for xml in nxml.edit_file("data/entities/player_base.xml") do
		xml:add_child(nxml.new_element("Entity", {name="userk.gold_collect"}, {
			nxml.new_element("InheritTransformComponent", {}, {
				nxml.new_element("Transform", {
					["position.y"]="6"
				})
			}),
			nxml.new_element("MaterialSuckerComponent", {
				material_type = "1",
				suck_tag = "[userk.gold]",
				barrel_size="100",
				num_cells_sucked_per_frame="50",
				["randomized_position.min_x"]="-5",
				["randomized_position.max_x"]="5",
				["randomized_position.min_y"]="-4",
				["randomized_position.max_y"]="-1",
			}),
			nxml.new_element("MaterialInventoryComponent"),
			nxml.new_element("LuaComponent", {
				script_source_file="mods/userk.things/files/gold_is_dust/collect_gold.lua"
			})
		}))
	end
end