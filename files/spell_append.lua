local entity_id = GetUpdatedEntityID()
if EntityGetFirstComponentIncludingDisabled(entity_id, "AbilityComponent") then return end

local item_action_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemActionComponent")
if not item_action_comp then return end

local id = ComponentGetValue2(item_action_comp, "action_id")
local spells = dofile_once("mods/gold_is_dust/files/keyed_spell_table.lua")
local spell = spells[id]

local add_cast = function()
	local ability_comp = EntityAddComponent2(entity_id, "AbilityComponent", {
		_tags="enabled_in_hand",
		ui_name=spell.name,
		entity_file="mods/gold_is_dust/files/spells_materialised/fake_cast.xml",
		rotate_hand_amount=0.05,
		throw_as_item=true,
		simulate_throw_as_item=true,
		use_entity_file_as_projectile_info_proxy=true,
	})
	ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", 0)

	EntityAddComponent2(entity_id, "LuaComponent", {
		script_shot = "mods/gold_is_dust/files/spells_materialised/shoot_spell.lua"
	})
end

local add_inert = function()
	local ability_comp = EntityAddComponent2(entity_id, "AbilityComponent", {
		_tags="enabled_in_hand",
		ui_name=spell.name,
		entity_file="",
		rotate_hand_amount=0.05,
		throw_as_item=false,
		simulate_throw_as_item=false,
		use_entity_file_as_projectile_info_proxy=true,
	})
	ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", 0)
end

local type_handler = {
	add_cast,	--ACTION_TYPE_PROJECTILE
	add_cast,	--ACTION_TYPE_STATIC_PROJECTILE
	add_inert,	--ACTION_TYPE_MODIFIER
	add_inert,	--ACTION_TYPE_DRAW_MANY
	add_cast,	--ACTION_TYPE_MATERIAL
	add_cast,	--ACTION_TYPE_OTHER
	add_cast,	--ACTION_TYPE_UTILITY
	add_inert,	--ACTION_TYPE_PASSIVE
}

if spell and type_handler[spell.type+1] then
	type_handler[spell.type+1]()
end