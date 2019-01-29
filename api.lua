mtfs = {}

local planes = {}

local function verify_def(def)
	def.size = def.size or 1
	def.attachment_offset = def.attachment_offset or {x = 0, y = 0, z = 0}

	return def
end

local function on_step(self, dtime)

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
	local def = planes[self.name]

	if not clicker:get_attach() then
		clicker:set_attach(self.object, "", def.attachment_offset, {x = 0, y = 0, z = 0})
		clicker:set_properties({
			visual_size = {
				x = 1 / def.size,
				y = 1 / def.size,
				z = 1 / def.size
			}
		})
	else
		clicker:set_detach()
		clicker:set_properties({ visual_size = {x = 1, y = 1, z = 1} })
	end
end

function mtfs.register_aircraft(name, def)
	assert(not planes[name], "Attempting to register plane with an existing name!")

	def = verify_def(def)

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
