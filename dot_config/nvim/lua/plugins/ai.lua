return {
  {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub",
    build = "bundled_build.lua",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      port = 37373,
      use_bundled_binary = true,
      auto_approve = function(params)
        -- Respect CodeCompanion's auto tool mode
        if vim.g.codecompanion_auto_tool_mode == true then
          return true
        end
        -- Auto-approve GitHub issue reading
        if params.server_name == "github" and params.tool_name == "get_issue" then
          return true -- Auto approve
        end

        -- Block access to private repos
        if params.arguments.repo == "private" then
          return "You can't access my private repo" -- Error message
        end

        return false -- Show confirmation
      end,
    },
  },
  {
    "olimorris/codecompanion.nvim",
    -- dir = "~/sync/lua/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      {
        "echasnovski/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
    },

    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },

      display = {
        action_palette = {
          provider = "fzf_lua",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
            prompt = "> ",
          },
        },
        diff = {
          provider = "mini_diff",
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
        "<cmd>CodeCompanionActions<cr>",
        desc = "Open the action palette",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Toggle chat buffer",
        mode = "n",
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "Send to chat buffer",
        mode = "v",
      },
      {
        "<leader>ai",
        ":CodeCompanion ",
        desc = "Inline Assistant",
        mode = "v",
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
