-- mods/DoubleChest/init.lua

-- formspec
--[[
local double_chest_formspec =
	"size[8,9]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_name;main;0,0.3;8,4;]"..
	"list[current_player;main;0,4.85;8,1;]"..
	"list[current_player;main;0,6.08;8,3;8]"..
	"listring[current_name;main]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0,4.85)

local function get_locked_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,9]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[nodemeta:".. spos .. ";main;0,0.3;8,4;]"..
		"list[current_player;main;0,4.85;8,1;]"..
		"list[current_player;main;0,6.08;8,3;8]"..
		"listring[nodemeta:".. spos .. ";main]"..
		"listring[current_player;main]"..
		default.get_hotbar_bg(0,4.85)
 return formspec
end

local function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end
]]--

-- register nodes

minetest.register_node("double_chest:double_chest_right", {
	tiles = {
		"double_chest_top_right.png",
		"double_chest_top_right.png",
		"double_chest_side.png",
		"double_chest_side.png",
		"double_chest_back_right.png",
		"double_chest_front_right.png",
	},
	walkable = false,
	pointable = false,
	diggable = false,
})

minetest.register_node("double_chest:double_chest_left", {
	tiles = {
		"double_chest_top_left.png",
		"double_chest_top_left.png",
		"double_chest_side.png",
		"double_chest_side.png",
		"double_chest_back_left.png",
		"double_chest_front_left.png"
	},
	description = "Double Chest",
	paramtype2 = "facedir",
	drawtype = "normal",
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 1.5, 0.5, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 1.5, 0.5, 0.5},
		},
	},
	groups = {choppy=2,oddly_breakable_by_hand=2},
	is_ground_content = false,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", double_chest_formspec)
		meta:set_string("infotext", "Double Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*8)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})
--[[
minetest.register_node("double_chest:locked_double_chest", {
	description = "Locked Double Chest",
	tiles = {"double_chest_top.png",
			 "double_chest_top.png",
			 "double_chest_side.png",
			 "double_chest_side.png",
			 "double_chest_back.png",
			 "double_chest_lock.png"
			 },
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2},
	is_ground_content = false,
})
]]--

-- register craft

minetest.register_craft({
	output = "double_chest:double_chest",
	recipe = {
		{"", "", ""},
		{"default:chest", "default:chest", "default:chest"},
		{"", "", ""},
	}
})

minetest.register_craft({
	output = "double_chest:double_chest_locked",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"default:chest", "default:chest", "default:chest"},
		{"", "default:steel_ingot", ""},
	}
})
