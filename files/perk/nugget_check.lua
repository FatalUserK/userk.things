if not GameHasFlagRun("perk_gold_is_dust") then return end

local entity_id = GetUpdatedEntityID()
local lifetimecomp = EntityGetFirstComponent(entity_id, "LifetimeComponent")
if lifetimecomp == nil then return end
local kill_frame = ComponentGetValue2(lifetimecomp, "kill_frame")
print(kill_frame)
do return end
EntityAddComponent2(entity_id, "LuaComponent", {
    script_source_file = "mods/gold_is_dust/files/perk/nugget_expire.lua",
    mNextExecutionTime = kill_frame,
    execute_every_n_frame = -1
})

ComponentSetValue2(lifetimecomp, "lifetime", kill_frame + 1)