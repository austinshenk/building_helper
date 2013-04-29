--------------------------------------
--Build Helper
--Adds a functionality where if you run out of whatever you are placing in your hand
-- it will retrieve a new stack from your inventory if available
--------------------------------------
if minetest.setting_getbool("creative_mode") then return end
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
	if placer == nil then return end
	if itemstack:get_count()-1 <= 0 then
		local name = itemstack:get_name()
		local inv = placer:get_inventory()
		for i=9,32,1 do
			local stack = inv:get_stack("main", i)
			if stack:get_name() == name then
				itemstack:add_item(stack)
				inv:set_stack("main", i, "")
				return
			end
		end
	end
end)
local function removeWarning(name, id)
    local player = minetest.env:get_player_by_name(name)
    if player == nil then return end
    player:hud_remove(id)
end
local node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
    if digger == nil then return end
	local pname = digger:get_player_name()
	local tool = digger:get_wielded_item()
	local name = nil;
	if tool:get_wear() ~= 0 then
		name = tool:get_name()
	end
	node_dig(pos, node, digger)
	digger = minetest.env:get_player_by_name(pname)
	if name and digger:get_wielded_item():get_wear() == 0 then
		local inv = digger:get_inventory()
		for i=9,32,1 do
			local stack = inv:get_stack("main", i)
			if stack:get_name() == name then
				inv:set_stack("main", digger:get_wield_index(), stack)
				inv:set_stack("main", i, "")
				return
			end
		end
	else if digger:get_wielded_item():get_wear()/65535 > .8 then
		--HUD WARNING
		--[[
		local id = digger:hud_add({
			hud_elem_type = "image",
			position = {x=0.5, y=0.6},
			name = "Warning",
			scale = {x=2,y=2},
			text = "building_warning.png",
			alignment = {x=0, y=0},
		})
		minetest.after(1.0, removeWarning, pname, id)
		end--]]
	end
end


