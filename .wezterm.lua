local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font_with_fallback {
	'Hack',
	'Cascadia Mono',
	'SF Mono',
}
config.font_size = 14.0
config.color_scheme = 'Oxocarbon Dark (Gogh)'


if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
	config.font_size = 12.0
	config.default_prog = { 'Powershell' }
else
	config.font_size = 14.0
end

config.initial_cols = 140
config.initial_rows = 40

return config
