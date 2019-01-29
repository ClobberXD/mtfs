local modpath = minetest.get_modpath("mtfs")

dofile(modpath .. "/api.lua")
if minetest.settings:get_bool("mtfs.enable_builtin") ~= false then
	dofile(modpath .. "/planes.lua")
end
