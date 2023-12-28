local M = {}

local util = require("util")

local function shell_call(args)
  local output = vim.fn.system(args)
  assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
end

M.lazy = function()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  local repo = "https://github.com/folke/lazy.nvim.git"

  --------- lazy.nvim ---------------
  if not vim.loop.fs_stat(lazypath) then
    util.echo "  Installing lazy.nvim & plugins ..."
    shell_call { "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath }
  end

  vim.opt.rtp:prepend(lazypath)
end

return M
