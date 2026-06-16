---Get held wand or first wand found in the entity tree or nil
---@param entity_id entity_id
---@return entity_id|nil
function GetHeldWand(entity_id)
	local backup_result

	local inventory2_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "Inventory2Component")
	if inventory2_comp ~= nil then
		local active_item = ComponentGetValue2(inventory2_comp, "mActiveItem")
		if EntityHasTag(active_item, "wand") then
			return active_item
		end
	end

	-- if that doesn't work (e.g. player is holding something else than a wand)
	for _,child in ipairs(EntityGetAllChildren(entity_id) or {}) do
		if EntityHasTag(child, "wand") and EntityGetFirstComponent(child, "ItemComponent") then
			return child
		else
			backup_result = GetHeldWand(child)
		end
	end

	return backup_result
end