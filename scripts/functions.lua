local floor = math.floor
local SECONDS = 60
local MINUTES = 60 * SECONDS
local HOURS   = 60 * MINUTES
local DAYS    = 24 * HOURS

local F = {}

F.time_updates = {
  days    = function(t) return floor(t / DAYS)         end,
  hours   = function(t) return floor(t / HOURS)   % 24 end,
  minutes = function(t) return floor(t / MINUTES) % 60 end,
  seconds = function(t) return floor(t / SECONDS) % 60 end,
}
F.background_options = {
  ['Dark'] = 'slot_button',
  ['Light'] = 'slot_sized_button',
  ['Blue'] = 'slot_sized_button_blue',
  ['Green'] = 'slot_sized_button_green',
  ['Red'] = 'slot_sized_button_red',
  ['Yellow'] = 'yellow_slot_button',
}
F.font_color_options = {
  ['White'] = { r = 255, g = 255, b = 255 },
  ['Yellow'] = { r = 255, g = 255, b = 0 },
  ['Orange'] = { r = 255, g = 165, b = 0 },
  ['Red'] = { r = 255, g = 0, b = 0 },
  ['Green'] = { r = 144, g = 238, b = 144 },
  ['Cyan'] = { r = 0, g = 255, b = 255 },
  ['Blue'] = { r = 0, g = 0, b = 255 },
  ['Purple'] = { r = 128, g = 0, b = 128 },
  ['Black'] = { r = 0, g = 0, b = 0 },
}
F.font_size_options = {
  ['Default'] = 'default',
  ['Huge'] = 'infinite',
  ['Large'] = 'default-large',
  ['Small'] = 'default-small',
  ['Tiny'] = 'default-tiny-bold',
  ['Heading'] = 'heading-1',
  ['Dialog'] = 'default-dialog-button',
}

F.to_array = function(dict, use_keys)
  local res = {}
  for k, v in pairs(dict) do
    res[#res + 1] = use_keys and k or v
  end
  return res
end

F.from_index = function(dict, index, use_keys)
  local i = 1
  for k, v in pairs(dict) do
    if i == index then
      return use_keys and k or v
    end
    i = i + 1
  end
end

F.index_of = function(dict, key)
  local i = 1
  for k, _ in pairs(dict) do
    if k == key then
      return i
    end
    i = i + 1
  end
end

return F
