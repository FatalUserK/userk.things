function normal_cast(caster, spell)
	local fake_cast = EntityLoad("mods/userk.things/files/spells_materialised/fake_cast.xml")
	EntitySetTransform(fake_cast, EntityGetTransform(caster))
	EntityAddChild(caster, fake_cast)

	local inventory_comp = EntityGetAllChildren(fake_cast)[1]
	local gun = EntityGetAllChildren(inventory_comp)[1]

	local plat_shooter = EntityGetFirstComponentIncludingDisabled(fake_cast, "PlatformShooterPlayerComponent")
	if not plat_shooter then return end

	local fake_cast_spell_card = EntityCreateNew()
	EntityAddChild(gun, fake_cast_spell_card)
	EntityAddComponent2(fake_cast_spell_card, "ItemActionComponent", {action_id = spell})

	local fake_cast_item_comp = EntityAddComponent2(fake_cast_spell_card, "ItemComponent")
	ComponentSetValue2(fake_cast_item_comp, "inventory_slot", 1, 1)

	ComponentSetValue2(plat_shooter, "mForceFireOnNextUpdate", true)
end

SPELLS_MATERIALISED_CUSTOM_BEHAVIOUR = {
	CESSATION = function(caster, inventory2_component, held_spell, remaining_uses)
		local platformshooter = EntityGetFirstComponentIncludingDisabled(player, "PlatformShooterPlayerComponent")
		if platformshooter ~= nil then
			ComponentSetValue2( platformshooter, "mCessationDo", true )
			ComponentSetValue2( platformshooter, "mCessationLifetime", 20)
		end
	end,
	ALPHA = function(caster, inventory2_component, held_spell, remaining_uses)
		local children = EntityGetAllChildren(EntityGetParent(caster))
		local spell_inventory
		for _,child in ipairs(children or {}) do
			if EntityGetName(child) == "inventory_full" then
				spell_inventory = child break
			end
		end
		if not spell_inventory then return end

		local spells = EntityGetAllChildren(spell_inventory) or {}
		local spell = spells[1]
		if not spell then return end

		local item_action_comp = EntityGetFirstComponentIncludingDisabled(spell, "ItemActionComponent")
		if not item_action_comp then return end

		normal_cast(caster, ComponentGetValue2(item_action_comp, "action_id"))
	end,
	GAMMA = function(caster, inventory2_component, held_spell, remaining_uses)
		local children = EntityGetAllChildren(EntityGetParent(caster))
		local spell_inventory
		for _,child in ipairs(children or {}) do
			if EntityGetName(child) == "inventory_full" then
				spell_inventory = child break
			end
		end
		if not spell_inventory then return end

		local spells = EntityGetAllChildren(spell_inventory) or {}
		local spell = spells[#spells]
		if not spell then return end

		local item_action_comp = EntityGetFirstComponentIncludingDisabled(spell, "ItemActionComponent")
		if not item_action_comp then return end

		normal_cast(caster, ComponentGetValue2(item_action_comp, "action_id"))
	end,
	TAU = function(caster, inventory2_component, held_spell, remaining_uses)
		local children = EntityGetAllChildren(EntityGetParent(caster))
		local item_inventory
		local spell_inventory
		for _,child in ipairs(children or {}) do
			local child_name = EntityGetName(child)
			if child_name == "inventory_quick" then
				item_inventory = child
			elseif child_name == "inventory_full" then
				spell_inventory = child
			end
			if item_inventory and spell_inventory then break end
		end

		local inventory = {}
		for _,item in ipairs(EntityGetAllChildren(item_inventory) or {}) do
			local item_action_comp = EntityGetFirstComponentIncludingDisabled(item, "ItemActionComponent")
			if item_action_comp then
				inventory[#inventory+1] = {eid = item, aid = EntityGetFirstComponentIncludingDisabled(item, "ItemActionComponent")}
			end
		end
		for _,spell in ipairs(EntityGetAllChildren(spell_inventory) or {}) do
			local item_action_comp = EntityGetFirstComponentIncludingDisabled(spell, "ItemActionComponent")
			if item_action_comp then
				inventory[#inventory+1] = {eid = spell, aid = EntityGetFirstComponentIncludingDisabled(spell, "ItemActionComponent")}
			end
		end

		local held_spell_position
		for index, spell in ipairs(inventory) do
			if spell.eid == held_spell then
				held_spell_position = index
			end
		end
		if inventory[held_spell_position+1] then
			normal_cast(caster, ComponentGetValue2(inventory[held_spell_position+1].aid, "action_id"))
			if inventory[held_spell_position+2] then
				normal_cast(caster, ComponentGetValue2(inventory[held_spell_position+2].aid, "action_id"))
			end
		end
	end,
}

--DONE:
-- ALPHA
-- GAMMA
-- TAU

--TODO:
-- OMEGA
-- PHI
-- SIGMA
-- ZETA