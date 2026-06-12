local entity_id = GetUpdatedEntityID()

local item_action_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemActionComponent")
if not item_action_comp then return end

local id = ComponentGetValue2(item_action_comp, "action_id")
function shot(fake_cast)
	EntitySetTransform(fake_cast, EntityGetTransform(entity_id))
	EntityAddChild(entity_id, fake_cast)

	local inventory_comp = EntityGetAllChildren(fake_cast)[1]
	local gun = EntityGetAllChildren(inventory_comp)[1]

	local plat_shooter = EntityGetFirstComponent(fake_cast, "PlatformShooterPlayerComponent")
	if not plat_shooter then return end

	local spell_action = EntityCreateNew()
	EntityAddChild(gun, spell_action)
	EntityAddComponent2(spell_action, "ItemActionComponent", {action_id = id})

	local item_comp = EntityAddComponent2(spell_action, "ItemComponent")
	ComponentSetValue2(item_comp, "inventory_slot", 1, 1)

	ComponentSetValue2(plat_shooter, "mForceFireOnNextUpdate", true)
end