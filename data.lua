for _, font in pairs({
	'big-shoulders',
	'digital',
	'jet-brains',
	'technology-bold',
	'chakra-petch',
	'display',
	'jura',
	'technology',
	'digital-mono',
	'electrolize',
	'smooch-sans',
	'zcool',
}) do
	data:extend({
		{
			type = 'font',
			name = font..'-1',
			from = font,
			size = 24,
		},
		{
			type = 'font',
			name = font..'-2',
			from = font,
			size = 32,
		},
		{
			type = 'font',
			name = font..'-3',
			from = font,
			size = 48,
		},
	})
end
