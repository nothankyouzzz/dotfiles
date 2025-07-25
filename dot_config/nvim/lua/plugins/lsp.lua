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
}
