return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(highlights, colors)
        highlights["@lsp.type.variable"] = { link = "@variable" }
        highlights["@lsp.type.enumMember.haskell"] = { link = "@constructor" }
      end,
    },
  },

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

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = vim.g.neovide and true or false },
    },
  },
}
