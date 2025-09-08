local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

print("a")
--do this in case some loser turns off my super cool and awesome better bloody buggets
local vanilla_bloody
local healing

local material = "GID_gold"
local gold = 0
for _, varcomp in ipairs(EntityGetComponent(entity_id, "VariableStorageComponent") or {}) do
    local name = ComponentGetValue2(varcomp, "name")
    if name == "gold_value" then
        gold = gold + ComponentGetValue2(varcomp, "value_int")
    elseif name == "hp_value" then
        if ModSettingGet("gid.fix_bloody_gold") then
            material = "GID_bloody_gold"
        else
            healing = (healing + ComponentGetValue2(varcomp, "value_int")) or 0.16
            vanilla_bloody = true
        end
    end
end

local bloody_values = {
    [0.016] = "GID_bloody_gold10",
    [0.008] = "GID_bloody_gold50",
    [0.003] = "GID_bloody_gold200",
    [0.0006] = "GID_bloody_gold1000",
    [0.00006] = "GID_bloody_gold10000",
    [0.000003] = "GID_bloody_gold200000",
}
if vanilla_bloody then material = bloody_values[healing/gold] or "GID_bloody_gold10" end

GameCreateParticle(material, x, y, gold, 0, 0, false)





EntityKill(entity_id)