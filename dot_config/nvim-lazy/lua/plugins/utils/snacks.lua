return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
      },
    },
  },

  {
    "folke/edgy.nvim",
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        ft = "snacks_layout_box",
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      })
    end,
  },
}
