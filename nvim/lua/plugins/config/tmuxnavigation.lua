local util = require("util")
local plugin = require('nvim-tmux-navigation')

util.map_keys('n', "<C-h>", plugin.NvimTmuxNavigateLeft)
util.map_keys('n', "<C-j>", plugin.NvimTmuxNavigateDown)
util.map_keys('n', "<C-k>", plugin.NvimTmuxNavigateUp)
util.map_keys('n', "<C-l>", plugin.NvimTmuxNavigateRight)
util.map_keys('n', "<C-;>", plugin.NvimTmuxNavigateLastActive)
util.map_keys('n', "<C-Space>", plugin.NvimTmuxNavigateNext)

