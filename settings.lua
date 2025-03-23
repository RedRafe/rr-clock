local F = require 'scripts.functions'

data:extend({
    {
		type = 'int-setting',
		name = 'rrc-size',
		setting_type = 'runtime-per-user',
        default_value = 40,
        minimum_value = 24,
        maximum_value = 96,
        order = '1',
	},
    {
		type = 'string-setting',
		name = 'rrc-font',
		setting_type = 'runtime-per-user',
        default_value = 'Default',
        allowed_values = F.to_array(F.font_size_options, true),
        order = '2',
    },
    {
		type = 'string-setting',
		name = 'rrc-font_color',
		setting_type = 'runtime-per-user',
        default_value = 'White',
        allowed_values = F.to_array(F.font_color_options, true),
        order = '3',
	},
    {
		type = 'string-setting',
		name = 'rrc-background',
		setting_type = 'runtime-per-user',
        default_value = 'Dark',
        allowed_values = F.to_array(F.background_options, true),
        order = '4',
	},
})