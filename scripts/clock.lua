local Functions = require 'scripts.functions'
local Gui = require 'scripts.gui'
local f = string.format

local clock_frame_name = Gui.uid_name('clock_frame')
local settings_frame_name = Gui.uid_name('settings_frame')
local settings_button_name = Gui.uid_name('settings_button')
local settings_size = Gui.uid_name('size')
local settings_font_size = Gui.uid_name('font_size')
local settings_font_color = Gui.uid_name('font_color')
local settings_background = Gui.uid_name('background')

local background_options = Functions.background_options
local font_color_options = Functions.font_color_options
local font_size_options = Functions.font_size_options
local time_updates = Functions.time_updates
local from_index = Functions.from_index
local index_of = Functions.index_of
local to_array = Functions.to_array

local Clock = {}

Clock.draw_clock_frame = function(player)
  if not (player and player.valid) then
    return
  end

  local frame = player.gui.screen[clock_frame_name]
  if frame and frame.valid then
    return
  end

  local data = {
    size = 40,
    background = background_options.Dark,
    font_color = font_color_options.White,
    font = font_size_options.Default,
  }

  frame = player.gui.screen.add {
    type = 'frame',
    name = clock_frame_name,
    direction = 'horizontal',
    style = 'quick_bar_slot_window_frame',
  }
  Gui.set_style(frame, { minimal_width = 24, minimal_height = 24, padding = 2 })

  do -- settings
    local flow = frame.add { type = 'flow', direction = 'vertical' }
    Gui.set_style(flow, { horizontal_align = 'center', padding = 0 })
    flow.drag_target = frame

    local button = flow.add {
      type = 'sprite-button',
      name = settings_button_name,
      style = 'shortcut_bar_expand_button',
      sprite = 'utility/expand_dots',
      tooltip = { 'clock.settings' },
      mouse_button_filter = { 'left' },
    }

    Gui.add_dragger(flow, frame)
  end
  do -- clock
    local flow = frame.add { type = 'flow', direction = 'horizontal' }
    Gui.set_style(flow, { horizontally_stretchable = true })

    local table_frame = flow.add { type = 'frame', direction = 'horizontal', style = 'quick_bar_inner_panel' }
    Gui.set_style(table_frame, { margin = 0 })

    local clock_table = table_frame.add { type = 'flow', direction = 'horizontal' }
    Gui.set_style(clock_table, { horizontal_spacing = 0, padding = 0 })

    for key, _ in pairs(time_updates) do
      local button = clock_table.add { type = 'sprite-button', caption = '---' }
      button.ignored_by_interaction = true
      Gui.set_style(button, { font_color = { 255, 255, 255 } })
      data[key] = button
    end
  end

  storage.data[player.index] = data
end

Clock.update_clock = function(player)
  local data = storage.data[player.index]
  if not data then
    Clock.draw_clock_frame(player)
    return
  end

  local visible = false
  for key, callback in pairs(time_updates) do
    local t = callback(game.tick)
    local button = data[key]
    button.caption = f('%02d', t)
    button.visible = visible or (t > 0)
    visible = button.visible
  end
end

Clock.draw_settings_frame = function(player)
  local frame = player.gui.screen[settings_frame_name]
  if frame and frame.valid then
    return frame
  end

  frame = Gui.add_closable_frame(player, {
    name = settings_frame_name,
    caption = {'clock.settings_title'},
    close_button = settings_button_name
  })

  local canvas = frame
    .add { type = 'frame', style = 'inside_shallow_frame_with_padding' }
    .add { type = 'flow', direction = 'vertical' }
  Gui.set_style(canvas, { minimal_width = 100, minimal_height = 100, vertically_stretchable = true, horizontally_stretchable = true })

  local function add_setting(parent, params)
    local flow = canvas.add { type = 'flow', direction = 'horizontal' }
    Gui.set_style(flow, { vertical_align = 'center', maximal_width = 467 })

    local caption = flow.add { type = 'label', style = 'caption_label', caption = params.caption }
    Gui.set_style(caption, { width = 120 })

    local element = flow.add(params.element)
    Gui.set_style(element, { width = 120 })
    element.tooltip = params.value
  end

  add_setting(canvas, {
    caption = {'clock.settings_size'},
    value = 40,
    element = {
      type = 'slider',
      name = settings_size,
      minimum_value = 24,
      maximum_value = 72,
      value_step = 2,
      value = 40,
    }
  })
  add_setting(canvas, {
    caption = {'clock.settings_font_size'},
    element = {
      type = 'drop-down',
      name = settings_font_size,
      items = to_array(font_size_options, true),
      selected_index = 1,
    }
  })
  add_setting(canvas, {
    caption = {'clock.settings_font_color'},
    element = {
      type = 'drop-down',
      name = settings_font_color,
      items = to_array(font_color_options, true),
      selected_index = 1,
    }
  })
  add_setting(canvas, {
    caption = {'clock.settings_background'},
    element = {
      type = 'drop-down',
      name = settings_background,
      items = to_array(background_options, true),
      selected_index = 1,
    }
  })

  player.opened = frame
end

Clock.toggle_settings_frame = function(player)
  local frame = player.gui.screen[settings_frame_name]
  if frame then
    Gui.destroy(frame)
  else
    Clock.draw_settings_frame(player)
  end
end

Clock.update_settings = function(player)
  local data = storage.data[player.index]
  if not data then
    return
  end
  for key, _ in pairs(time_updates) do
    local element = data[key]
    if element and element.valid then
      element.style = data.background
      Gui.set_style(element, { size = data.size, font_color = data.font_color, font = data.font })
    end
  end
end

Gui.on_closed(settings_frame_name, function(event)
  Clock.toggle_settings_frame(event.player)
end)

Gui.on_click(settings_button_name, function(event)
  Clock.toggle_settings_frame(event.player)
end)

Gui.on_value_changed(settings_size, function(event)
  local element, player = event.element, event.player
  local data = storage.data[player.index]
  local size = element.slider_value
  element.tooltip = size
  data.size = size
  Clock.update_settings(player)
end)

Gui.on_selection_state_changed(settings_font_size, function(event)
  local element, player = event.element, event.player
  local data = storage.data[player.index]
  local font = to_array(font_size_options)[element.selected_index]
  data.font = font
  Clock.update_settings(player)
end)

Gui.on_selection_state_changed(settings_font_color, function(event)
  local element, player = event.element, event.player
  local data = storage.data[player.index]
  local font_color = to_array(font_color_options)[element.selected_index]
  data.font_color = font_color
  Clock.update_settings(player)
end)

Gui.on_selection_state_changed(settings_background, function(event)
  local element, player = event.element, event.player
  local data = storage.data[player.index]
  local style = to_array(background_options)[element.selected_index]
  data.background = style
  Clock.update_settings(player)
end)

return {
  on_init = function()
    storage.data = {}
    for _, player in pairs(game.players) do
      Clock.draw_clock_frame(player)
    end
  end,
  events = {
    [defines.events.on_player_created] = function(event)
      local player = game.get_player(event.player_index)
      Clock.draw_clock_frame(player)
    end,
    [defines.events.on_tick] = function(event)
      for _, player in pairs(game.connected_players) do
        Clock.update_clock(player)
      end
    end
  }
}
