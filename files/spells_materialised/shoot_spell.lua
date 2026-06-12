dofile_once("mods/userk.things/files/spells_materialised/custom_spell_behaviour.lua")

function shot(projectile)
	if EntityGetName(projectile) ~= "userk.empty" then return end --so sick of this nonsense script_shot bs.
	--might genuinely replace with just checking mousebuttonjustdown atp

	local entity_id = GetUpdatedEntityID()
	local parent = EntityGetParent(entity_id)
	local inv2 = EntityGetFirstComponentIncludingDisabled(parent, "Inventory2Component")
	if not inv2 then return end

	local held_item = ComponentGetValue2(inv2, "mActualActiveItem")

	local item_action_comp = EntityGetFirstComponentIncludingDisabled(held_item, "ItemActionComponent")
	if not item_action_comp then return end

	local item_comp = EntityGetFirstComponentIncludingDisabled(held_item, "ItemComponent")
	if not item_comp then return end
	local uses_remaining = ComponentGetValue2(item_comp, "uses_remaining")
	if uses_remaining == 0 then return end

	local id = ComponentGetValue2(item_action_comp, "action_id")
	if SPELLS_MATERIALISED_CUSTOM_BEHAVIOUR[id] then
		SPELLS_MATERIALISED_CUSTOM_BEHAVIOUR[id](entity_id, inv2, held_item, uses_remaining)
	else
		normal_cast(entity_id, id)
	end

	if uses_remaining ~= -1 then
		ComponentSetValue2(item_comp, "uses_remaining", uses_remaining - 1)
		if uses_remaining == 1 then
			local x,y = EntityGetTransform(parent)
			GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y)
		end
	end
end