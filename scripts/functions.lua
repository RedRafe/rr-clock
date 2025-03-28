local floor = math.floor
local SECONDS = 60
local MINUTES = 60 * SECONDS
local HOURS   = 60 * MINUTES
local DAYS    = 24 * HOURS

local split_string = function (inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^'..sep..']+)') 
  do
    table.insert(t, str)
  end
  return t
end

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

  ['Big Shoulders'] = 'big-shoulders-1',
  ['Big Shoulders Large'] = 'big-shoulders-2',
  ['Big Shoulders Huge'] = 'big-shoulders-3',

  ['Digital'] = 'digital-1',
  ['Digital Large'] = 'digital-2',
  ['Digital Huge'] = 'digital-3',

  ['Jet Brains'] = 'jet-brains-1',
  ['Jet Brains Large'] = 'jet-brains-2',
  ['Jet Brains Huge'] = 'jet-brains-3',

  ['Technology Bold'] = 'technology-bold-1',
  ['Technology Bold Large'] = 'technology-bold-2',
  ['Technology Bold Huge'] = 'technology-bold-3',

  ['Chakra Petch'] = 'chakra-petch-1',
  ['Chakra Petch Large'] = 'chakra-petch-2',
  ['Chakra Petch Huge'] = 'chakra-petch-3',

  ['Display'] = 'display-1',
  ['Display Large'] = 'display-2',
  ['Display Huge'] = 'display-3',

  ['Jura'] = 'jura-1',
  ['Jura Large'] = 'jura-2',
  ['Jura Huge'] = 'jura-3',

  ['Technology'] = 'technology-1',
  ['Technology Large'] = 'technology-2',
  ['Technology Huge'] = 'technology-3',

  ['Digital Mono'] = 'digital-mono-1',
  ['Digital Mono Large'] = 'digital-mono-2',
  ['Digital Mono Huge'] = 'digital-mono-3',

  ['Electrolize'] = 'electrolize-1',
  ['Electrolize Large'] = 'electrolize-2',
  ['Electrolize Huge'] = 'electrolize-3',

  ['Smooch Sans'] = 'smooch-sans-1',
  ['Smooch Sans Large'] = 'smooch-sans-2',
  ['Smooch Sans Huge'] = 'smooch-sans-3',

  ['Zcool'] = 'zcool-1',
  ['Zcool Large'] = 'zcool-2',
  ['Zcool Huge'] = 'zcool-3',
}

F.to_array = function(dict, use_keys)
  local res = {}
  for k, v in pairs(dict) do
    res[#res + 1] = (use_keys and k) or v
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

F.array_index_of = function(array, value)
  for i, v in pairs(array) do
    if v == value then
      return i
    end
  end
end

F.player_data = function(player)
  local data = storage.data[player.index]
  if not data then
    local s = settings.get_player_settings(player)
    data = {
      size = s['rrc-size'].value or 40,
      background = F.background_options[s['rrc-background'].value] or F.background_options.Dark,
      font_color = F.font_color_options[s['rrc-font_color'].value] or F.font_color_options.White,
      font = F.font_size_options[s['rrc-font'].value] or F.font_size_options.Default,
    }
    storage.data[player.index] = data
  end
  return data
end

return F
