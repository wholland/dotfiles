local M = {}

M.map_keys = function(mode, lhs, rhs, opts) 
  local options = { noremap = true }
  if opts then 
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

M.echo = function(str)
  vim.cmd "redraw"
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

return M
