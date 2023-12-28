local plugins = {
  {
    "nvim-tree/nvim-web-devicons",
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function(_, _)
      require("plugins.config.nvimtree")
    end,
  },

  {
    "alexghergh/nvim-tmux-navigation",
    lazy = false,
    config = function(_, _)
      require("plugins.config.tmuxnavigation")
    end,
  },
}

local opts = {

}

require("lazy").setup(plugins, opts)
