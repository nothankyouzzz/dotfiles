return {
  {
    "folke/edgy.nvim",
    opts = {
      right = {
        {
          title = "AI Chat",
          ft = "codecompanion",
          size = { width = 0.35 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
      },
      animate = { enabled = false },
    },
  },

  -- extra ui.edgy include configuration for fixing confliction neo-tree and starter
  -- but it did not work, so I just use the efficacious part here.
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.open_files_do_not_replace_types, "edgy")
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = vim.g.neovide and true or false },
    },
  },
}
