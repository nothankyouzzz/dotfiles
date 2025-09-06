return {
  {
    "mrcjkb/haskell-tools.nvim",
    config = function()
      vim.g.haskell_tools = {
        hls = {
          on_attach = function(_, _, _)
            require("which-key").add({
              "<leader>ch",
              "<cmd>Telescope hoogle<cr>",
              desc = "Hoogle Search",
              icon = "",
              buffer = true,
            })
          end,

          settings = {
            haskell = {
              plugin = {
                semanticTokens = {
                  globalOn = true,
                },
              },
            },
          },
        },
      }
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(highlights, _)
        highlights["@lsp.type.variable"] = { link = "@variable" }
        highlights["@lsp.type.enumMember.haskell"] = { link = "@constructor" }
      end,
    },
  },
}
