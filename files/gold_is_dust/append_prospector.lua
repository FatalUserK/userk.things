local greedy_gold = function(d)
	local wallet = d.pdata.wallet
	local income = d.amount * d.worth * 2^GameGetGameEffectCount(d.pdata.entity_id, "EXTRA_MONEY")
	ComponentSetValue2(wallet, "money", ComponentGetValue2(wallet, "money") + income)
	GameEntityPlaySoundLoop(GetUpdatedEntityID(), "range_gold_sound", 0.1)
	AddMaterialInventoryMaterial(d.pdata.entity_id, d.material_name, 0)
end

local blood_heal = function(d)
	greedy_gold(d)
	local damage_comp = EntityGetFirstComponent(d.pdata.owner, "DamageModelComponent")
	if not damage_comp then return end
	local heal_amount = d.amount * d.worth * 0.004
	EntityInflictDamage(d.pdata.owner, -heal_amount, "DAMAGE_HEALING", "blood money", "NONE", 0, 0)
end

local custom_gold_data = {
	["userk.greedy_gold"] = {
		func = greedy_gold,
	},
	["userk.greedy_gold.10"] = {
		func = greedy_gold,
		worth = 10
	},
	["userk.greedy_gold.100"] = {
		func = greedy_gold,
		worth = 100
	},
	["userk.bloody_gold"] = {
		func = blood_heal,
	},
	["userk.bloody_gold.10"] = {
		func = blood_heal,
		worth = 10,
	},
	["userk.bloody_gold.100"] = {
		func = blood_heal,
		worth = 100,
	},
}

for key, value in pairs(custom_gold_data) do
	---@diagnostic disable-next-line:undefined-global
	ProspectorGoldFuncs[key] = value
end