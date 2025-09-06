return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
    "franco-ruggeri/codecompanion-spinner.nvim",
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
  },

  opts = {
    strategies = {
      chat = {
        roles = {
          llm = function(adapter)
            return "  " .. adapter.formatted_name .. "(" .. adapter.schema.model.default .. ")"
          end,
          user = "  You",
        },
      },
    },
    prompt_library = {
      ["Agent Mode"] = {
        strategy = "chat",
        description = "Agent mode, like in VSCode",
        opts = {
          index = 1,
          short_name = "agent",
          intro_message = "",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            content = "You are a @{full_stack_dev} provided with tool @{neovim} and @{mcp}.",
          },
        },
      },
    },
    display = {
      action_palette = {
        provider = "fzf_lua",
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
          title = "> ",
        },
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
      spinner = {},
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
}
