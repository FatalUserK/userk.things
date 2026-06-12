local entity_id = GetUpdatedEntityID()
local parent = EntityGetParent(entity_id)
local inv2 = EntityGetFirstComponentIncludingDisabled(parent, "Inventory2Component")
if not inv2 then return end

function shot(_)
	local held_item = ComponentGetValue2(inv2, "mActualActiveItem")

	local item_action_comp = EntityGetFirstComponentIncludingDisabled(held_item, "ItemActionComponent")
	if not item_action_comp then return end

	local item_comp = EntityGetFirstComponentIncludingDisabled(held_item, "ItemComponent")
	if not item_comp then return end
	local uses_remaining = ComponentGetValue2(item_comp, "uses_remaining")
	if uses_remaining == 0 then return end

	local id = ComponentGetValue2(item_action_comp, "action_id")

	local fake_cast = EntityLoad("mods/gold_is_dust/files/spells_materialised/fake_cast.xml")
	EntitySetTransform(fake_cast, EntityGetTransform(entity_id))
	EntityAddChild(entity_id, fake_cast)

	local inventory_comp = EntityGetAllChildren(fake_cast)[1]
	local gun = EntityGetAllChildren(inventory_comp)[1]

	local plat_shooter = EntityGetFirstComponentIncludingDisabled(fake_cast, "PlatformShooterPlayerComponent")
	if not plat_shooter then return end

	local fake_cast_spell_card = EntityCreateNew()
	EntityAddChild(gun, fake_cast_spell_card)
	EntityAddComponent2(fake_cast_spell_card, "ItemActionComponent", {action_id = id})

	local fake_cast_item_comp = EntityAddComponent2(fake_cast_spell_card, "ItemComponent")
	ComponentSetValue2(fake_cast_item_comp, "inventory_slot", 1, 1)

	ComponentSetValue2(plat_shooter, "mForceFireOnNextUpdate", true)

	if uses_remaining ~= -1 then
		ComponentSetValue2(item_comp, "uses_remaining", uses_remaining - 1)
		if uses_remaining == 1 then
			local x,y = EntityGetTransform(parent)
			GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y)
		end
	end
end