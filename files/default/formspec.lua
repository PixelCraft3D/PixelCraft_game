default.ui = {}

default.ui.core = {}

default.ui.core.colors = "listcolors[#00000000;#00000010;#00000000;#68B259;#FFF]"
default.ui.core.bg = "bgcolor[#00000000;false]"

function default.ui.get_itemslot_bg(x, y, w, h)
   local out = ""
   for i = 0, w - 1, 1 do
      for j = 0, h - 1, 1 do
	 out = out .."image["..x+i..","..y+j..";1,1;ui_itemslot.png]"
      end
   end
   return out
end

function default.ui.get_hotbar_itemslot_bg(x, y, w, h)
   local out = ""
   for i = 0, w - 1, 1 do
      for j = 0, h - 1, 1 do
	 out = out .."image["..x+i..","..y+j..";1,1;ui_itemslot.png^ui_itemslot_dark.png]"
      end
   end
   return out
end

function default.ui.image_button(x, y, w, h, name, image)
   local image = minetest.formspec_escape(image)

   return "image_button["..x..","..y..";"..w..","..h..";"..image..";"..name..";;;false;"..image.."]"
end

function default.ui.button(x, y, w, h, name, label, noclip)
   local nc = "false"
   
   if noclip then
      nc = "true"
   end

   if w == 2 then
      return "image_button["..x..","..y..";"..w..","..h..";ui_button_2w_inactive.png;"..name..";"..label..";"..nc..";false;ui_button_2w_active.png]"
   else
      return "image_button["..x..","..y..";"..w..","..h..";ui_button_3w_inactive.png;"..name..";"..label..";"..nc..";false;ui_button_3w_active.png]"
   end
end

function default.ui.button_exit(x, y, w, h, name, label, noclip)
   local nc = "false"
   
   if noclip then
      nc = "true"
   end

   if w == 2 then
      return "image_button_exit["..x..","..y..";"..w..","..h..";ui_button_2w_inactive.png;"..name..";"..label..";"..nc..";false;ui_button_2w_active.png]"
   else
      return "image_button_exit["..x..","..y..";"..w..","..h..";ui_button_3w_inactive.png;"..name..";"..label..";"..nc..";false;ui_button_3w_active.png]"
   end
end

function default.ui.tab(x, y, name, icon, tooltip)
   local tooltip = tooltip or ""
   local shifted_icon = "[combine:16x16:0,0=ui_tab_active.png:0,1="..icon

   local form = ""
   form = form .. "image_button["..x..","..y..";1,1;ui_tab_inactive.png^"..icon..";"..name..";;true;false;"..minetest.formspec_escape(shifted_icon).."]"
   form = form .. "tooltip["..name..";"..tooltip.."]"

   return form
end

local function get_itemdef_field(itemname, fieldname)
   if not minetest.registered_items[itemname] then
      return nil
   end
   return minetest.registered_items[itemname][fieldname]
end

function default.ui.fake_itemstack(x, y, itemstack, name)
   local name = name or "fake_itemstack"

   local itemname = itemstack:get_name()
   local itemamt = itemstack:get_count()

   local itemimage = ""
   if itemname ~= "" then
      local inventory_image = get_itemdef_field(itemname, "inventory_image")
      if inventory_image and inventory_image ~= "" then
	 itemimage = inventory_image
      else
	 local tiles = get_itemdef_field(itemname, "tiles")

	 local t1 = tiles[1]
	 local t2 = tiles[1]
	 local t3 = tiles[1]

	 if #tiles == 3 then
	    t1 = tiles[1]
	    t2 = tiles[3]
	    t3 = tiles[3]
	 elseif #tiles == 6 then
	    t1 = tiles[1]
	    t2 = tiles[5]
	    t3 = tiles[6]
	 end

	 itemimage=minetest.inventorycube(t1, t2, t3)
      end
   end
   itemimage = minetest.formspec_escape(itemimage)

   local itemdesc = ""
   if minetest.registered_items[itemname].description ~= nil then
      itemdesc = minetest.registered_items[itemname].description
   end

   if itemamt <= 1 then itemamt = "" end

   local result = ""
   if itemname ~= "" then
      result = result .. "image_button["..x..","..y..";1,1;"..itemimage..";"..name..";;false;false;"..itemimage.."]"
      result = result .. "label["..(x+0.6)..","..(y+0.5)..";"..itemamt.."]"
      result = result .. "tooltip["..name..";"..itemdesc.."]"
   end

   return result
end

function default.ui.fake_simple_itemstack(x, y, itemname, name)
   local name = name or "fake_simple_itemstack"

   local itemimage = ""
   if itemname ~= "" then
      local inventory_image = get_itemdef_field(itemname, "inventory_image")
      if inventory_image and inventory_image ~= "" then
	 itemimage = inventory_image
      else
	 local tiles = get_itemdef_field(itemname, "tiles")

	 local t1 = tiles[1]
	 local t2 = tiles[1]
	 local t3 = tiles[1]

	 if #tiles == 3 then
	    t1 = tiles[1]
	    t2 = tiles[3]
	    t3 = tiles[3]
	 elseif #tiles == 6 then
	    t1 = tiles[1]
	    t2 = tiles[5]
	    t3 = tiles[6]
	 end

	 itemimage=minetest.inventorycube(t1, t2, t3)
      end
   end
   itemimage = minetest.formspec_escape(itemimage)

   local itemdesc = ""
   if minetest.registered_items[itemname].description ~= nil then
      itemdesc = minetest.registered_items[itemname].description
   end

   local result = ""
   if itemname ~= "" then
      result = result .. "image_button["..x..","..y..";1,1;"..itemimage..";"..name..";;false;false;"..itemimage.."]"
      result = result .. "tooltip["..name..";"..itemdesc.."]"
   end

   return result
end

function default.ui.item_group(x, y, group, name)
   local name = name or "fake_simple_itemstack"

   local itemname = ""

   for itemn, itemdef in pairs(minetest.registered_items) do
      if minetest.get_item_group(itemn, group) ~= 0 and minetest.get_item_group(itemn, "not_in_craftingguide") ~= 1 then
	 itemname = itemn
      end
   end

   local itemimage = ""
   if itemname ~= "" then
      local inventory_image = get_itemdef_field(itemname, "inventory_image")
      if inventory_image and inventory_image ~= "" then
	 itemimage = inventory_image
      else
	 local tiles = get_itemdef_field(itemname, "tiles")

	 local t1 = tiles[1]
	 local t2 = tiles[1]
	 local t3 = tiles[1]

	 if #tiles == 3 then
	    t1 = tiles[1]
	    t2 = tiles[3]
	    t3 = tiles[3]
	 elseif #tiles == 6 then
	    t1 = tiles[1]
	    t2 = tiles[5]
	    t3 = tiles[6]
	 end

	 itemimage=minetest.inventorycube(t1, t2, t3)
      end
   end

   local result = ""
   if itemname ~= "" then
   local itemdesc = ""
      itemimage = minetest.formspec_escape(itemimage)

      if minetest.registered_items[itemname].description ~= nil then
	 itemdesc = minetest.registered_items[itemname].description
      end

      result = result .. "image_button["..x..","..y..";1,1;"..itemimage..";"..name..";;false;false;"..itemimage.."]"
      result = result .. "label["..(x+0.4)..","..(y+0.35)..";G]"
      result = result .. "tooltip["..name..";Group: "..group.."]"
   end

   return result
end

default.ui.registered_pages = {
}

function default.ui.get_page(name)
   local page= default.ui.registered_pages[name]
   
   if page == nil then
      default.log("UI page '" .. name .. "' is not yet registered", "dev")
      page = ""
   end

   return page
end

function default.ui.register_page(name, form)
   default.ui.registered_pages[name] = form
end

local form_core = ""
form_core = form_core .. "size[8.5,9]"
form_core = form_core .. default.ui.core.colors
form_core = form_core .. default.ui.core.bg
form_core = form_core .. default.ui.tab(-0.9, 1, "tab_crafting", "ui_icon_crafting.png", "Crafting")
if minetest.get_modpath("craftingguide") ~= nil then
   form_core = form_core .. default.ui.tab(-0.9, 1.78, "tab_craftingguide", "ui_icon_craftingguide.png", "Crafting Guide")
end
if minetest.get_modpath("armor") ~= nil then
   form_core = form_core .. default.ui.tab(-0.9, 2.56, "tab_armor", "ui_icon_armor.png", "Armor")
end
if minetest.get_modpath("achievements") ~= nil then
   form_core = form_core .. default.ui.tab(-0.9, 3.34, "tab_achievements", "ui_icon_achievements.png", "Achievements")
end
form_core = form_core .. "background[0,0;8.5,9;ui_formspec_bg_tall.png]"
default.ui.register_page("core", form_core)
default.ui.register_page("core_2part", form_core .. "background[0,0;8.5,4.5;ui_formspec_bg_short.png]")

local form_core_notabs = ""
form_core_notabs = form_core_notabs .. "size[8.5,9]"
form_core_notabs = form_core_notabs .. default.ui.core.colors
form_core_notabs = form_core_notabs .. default.ui.core.bg
form_core_notabs = form_core_notabs .. "background[0,0;8.5,9;ui_formspec_bg_tall.png]"
default.ui.register_page("core_notabs", form_core_notabs)
default.ui.register_page("core_notabs_2part", form_core_notabs .. "background[0,0;8.5,4.5;ui_formspec_bg_short.png]")

local form_core_field = ""
form_core_field = form_core_field .. "size[8.5,5]"
form_core_field = form_core_field .. default.ui.core.colors
form_core_field = form_core_field .. default.ui.core.bg
form_core_field = form_core_field .. "background[0,0;8.5,4.5;ui_formspec_bg_short.png]"
form_core_field = form_core_field .. "field[1,1.75;7,0;text;;${text}]"
form_core_field = form_core_field .. default.ui.button_exit(2.75, 3, 3, 1, "", "Write", false)
default.ui.register_page("core_field", form_core_field)

local form_crafting = default.ui.get_page("core_2part")
form_crafting = form_crafting .. "list[current_player;main;0.25,4.75;8,4;]"
form_crafting = form_crafting .. "listring[current_player;main]"
form_crafting = form_crafting .. default.ui.get_hotbar_itemslot_bg(0.25, 4.75, 8, 1)
form_crafting = form_crafting .. default.ui.get_itemslot_bg(0.25, 5.75, 8, 3)

form_crafting = form_crafting .. "list[current_player;craft;2.25,0.75;3,3;]"
form_crafting = form_crafting .. "listring[current_player;craft]"

form_crafting = form_crafting .. "image[5.25,1.75;1,1;ui_arrow.png^[transformR270]"

form_crafting = form_crafting .. "list[current_player;craftpreview;6.25,1.75;1,1;]"
form_crafting = form_crafting .. default.ui.get_itemslot_bg(2.25, 0.75, 3, 3)
form_crafting = form_crafting .. default.ui.get_itemslot_bg(6.25, 1.75, 1, 1)
default.ui.register_page("core_crafting", form_crafting)

local form_bookshelf = default.ui.get_page("core_2part")
form_bookshelf = form_bookshelf .. "list[current_player;main;0.25,4.75;8,4;]"
form_bookshelf = form_bookshelf .. "listring[current_player;main]"
form_bookshelf = form_bookshelf .. default.ui.get_hotbar_itemslot_bg(0.25, 4.75, 8, 1)
form_bookshelf = form_bookshelf .. default.ui.get_itemslot_bg(0.25, 5.75, 8, 3)

form_bookshelf = form_bookshelf .. "list[current_name;main;2.25,1.25;4,2;]"
form_bookshelf = form_bookshelf .. "listring[current_name;main]"
form_bookshelf = form_bookshelf .. default.ui.get_itemslot_bg(2.25, 1.25, 4, 2)
default.ui.register_page("core_bookshelf", form_bookshelf)

function default.ui.receive_fields(player, form_name, fields)
   local name = player:get_player_name()

--   print("Received formspec fields from '"..name.."': "..dump(fields))
   
   if fields.tab_crafting then
      minetest.show_formspec(name, "core_crafting", default.ui.get_page("core_crafting"))
   elseif minetest.get_modpath("craftingguide") ~= nil and fields.tab_craftingguide then
      minetest.show_formspec(name, "core_craftingguide", craftingguide.get_formspec(name))
   elseif minetest.get_modpath("armor") ~= nil and fields.tab_armor then
      minetest.show_formspec(name, "core_armor", default.ui.get_page("core_armor"))
   elseif minetest.get_modpath("achievements") ~= nil and fields.tab_achievements then
      minetest.show_formspec(name, "core_achievements", default.ui.get_page("core_achievements"))
   end
end

minetest.register_on_player_receive_fields(
   function(player, form_name, fields)
      default.ui.receive_fields(player, form_name, fields)
   end)

minetest.register_on_joinplayer(
   function(player)
      local function cb(player)
	 --minetest.chat_send_player(player:get_player_name(), "Welcome!")
      end
      minetest.after(1.0, cb, player)
      player:set_inventory_formspec(default.ui.get_page("core_crafting"))
   end)