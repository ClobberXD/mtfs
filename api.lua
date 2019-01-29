mtfs = {}
mtfs.planes = {}

local function verify_def(def)

end

local function on_lclick(self, puncher)
	if not puncher then
		return
	end
	puncher:set_detach()
	puncher:get_inventory():add_item("main", self.name)
	self.object:remove()
end

local function on_rclick(self, clicker)
	if not clicker:get_attach() then
		clicker:set_attach(self.object, "", attach, {x = 0, y = 0, z = 0})
		clicker:set_properties({ visual_size = {x = 0, y = 0} })
	else
		clicker:set_detach()
		clicker:set_properties({ visual_size = {x = 0, y = 0} })
	end
end

function mtfs.register_aircraft(name, def)
	verify_def(def)
	assert(not planes[name], "Attempting to register plane with an existing name!")

	minetest.register_entity("name", {
		initial_properties = {
			physical    = true,
			visual      = "mesh",
			mesh        = def.mesh,
			textures    = def.textures,
			visual_size = {x = def.size, y = def.size}
		},
		on_step = on_step,
		on_punch = on_lclick,
		on_rightclick = on_rclick,
	})
	planes[name] = def
end

minetest.register_chatcommand("plane", {
	params = "<plane>",
	description = "Spawn a plane",
	privs = {interact = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "You should be online to spawn planes!"
		end

		if not param or param:trim() == "" then
			return false, "Provide a valid aircraft name!"
		end

		param = param:trim()
		if not planes[param] then
			return false, "Provide a valid aircraft name!"
		end

		local pos = vector.add(player:get_pos(), {x = 0, y = 1, z = 0})
		minetest.add_entity(pos, param)
	end
})
