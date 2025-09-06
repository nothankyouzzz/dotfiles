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
    "linux-cultist/venv-selector.nvim",
    opts = {
      options = {
        debug = true,
      },
      search = {
        miniconda_base = {
          command = "fd 'bin/python$' ~/.miniconda/bin --color never --full-path --follow",
          type = "anaconda",
        },
        miniconda_envs = {
          command = "fd 'bin/python$' ~/.miniconda/envs --color never --full-path --follow",
          type = "anaconda",
        },
        cwd = false,
      },
    },
  },
}
