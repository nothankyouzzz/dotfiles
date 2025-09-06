return {
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
  },
}
