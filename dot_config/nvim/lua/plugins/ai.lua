return {
  {
    "ravitemer/mcphub.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- auto install failed, so I mannually install it.
    build = "npm install -g mcp-hub@latest",
    opts = {
      port = 37373,
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },

    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },

      display = {
        action_palette = {
          provider = "default",
        },
        chat = {
          window = {
            opts = {
              number = false,
              relativenumber = false,
              signcolumn = "yes",
            },
          },
        },
      },
    },

    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<CR>",
        desc = "Open the action palette",
        mode = { "n" },
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "Toggle a chat buffer",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          vim.ui.input({
            prompt = "Quick Prompt: ",
          }, function(input)
            if input and input ~= "" then
              vim.cmd("CodeCompanionChat " .. input)
            end
          end)
        end,
        desc = "Quick Prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Add<CR>",
        desc = "Add code to a chat buffer",
        mode = { "v" },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
