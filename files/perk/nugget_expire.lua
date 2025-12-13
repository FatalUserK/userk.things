local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

--do this in case some loser turns off my super cool and awesome better bloody nuggets
local vanilla_bloody

local material = "GID_gold"

local healing = 0
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



local amountx1 = gold
local amountx10 = 0
local amountx100 = 0

while amountx1>1000 do
    amountx1 = amountx1 - 100
    amountx10 = amountx10 + 10
end
while amountx10>1000 do
    amountx10 = amountx10 - 100
    amountx100 = amountx100 + 10
end

GameCreateParticle(material, x, y, amountx1, 0, 0, false)
GameCreateParticle(material .. "x10", x, y, amountx10, 0, 0, false)
GameCreateParticle(material .. "x100", x, y, amountx100, 0, 0, false)

EntityKill(entity_id)