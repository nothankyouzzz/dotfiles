local fmt = string.format
local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  "olimorris/codecompanion.nvim",
  dev = true,
  cmd = {
    "CodeCompanion",
    "CodeCompanionCmd",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionHistory",
    "CodeCompanionSummaries",
  },
  dependencies = {
    "fidget.nvim",
    "Davidyz/VectorCode",
    "nvim-lua/plenary.nvim",
    "ravitemer/mcphub.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lalitmee/codecompanion-spinners.nvim",
    "ravitemer/codecompanion-history.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
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
    adapters = {
      acp = {
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
              auth_method = "gemini-api-key",
            },
          })
        end,
      },
    },
    prompt_library = {
      ["Polish"] = {
        strategy = "inline",
        description = "Polish the selected text",
        opts = {
          modes = { "v" },
          short_name = "polish",
          placement = "replace",
        },
        prompts = {
          {
            role = constants.USER_ROLE,
            content = "Polish the selected text for clarity, conciseness, and overall quality",
          },
        },
      },
      ["Review"] = {
        strategy = "chat",
        description = "Review the selected code",
        opts = {
          modes = { "v" },
          short_name = "review",
          auto_submit = true,
        },
        prompt = {
          {
            role = constants.SYSTEM_ROLE,
            content = "You are a code reviewer focused on improving code quality and maintainability.",
          },
          {
            role = constants.USER_ROLE,
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              local prompt = [[Review the following code for potential issues, improvements, and best practices:

```%s
%s
```]]
              return fmt(prompt, context.filetype, code)
            end,
            opts = {
              contains_code = true, -- used for global opt `send_code`
            },
          },
        },
      },
      ["Optimize"] = {
        strategy = "inline",
        description = "Optimize the selected code",
        opts = {
          modes = { "v" },
          short_name = "optimize",
          placement = "replace",
        },
        prompts = {
          {
            role = constants.SYSTEM_ROLE,
            content = "Ensure the optimized code maintains the same functionality as the original",
          },
          {
            role = constants.USER_ROLE,
            content = "Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.",
          },
        },
      },
      ["Comment"] = {
        strategy = "inline",
        description = "Generate comments for the selected code",
        opts = {
          modes = { "v" },
          short_name = "comment",
          placement = "replace",
        },
        prompts = {
          {
            role = constants.USER_ROLE,
            content = "Generate clear and concise comments for the selected code, explaining its purpose and functionality.",
          },
        },
      },
    },
    strategies = {
      chat = {
        roles = {
          llm = function(adapter)
            local model_name = adapter.schema and adapter.schema.model and adapter.schema.model.default
            if model_name then
              return " " .. adapter.formatted_name .. "(" .. model_name .. ")"
            else
              return " " .. adapter.formatted_name
            end
          end,
          user = "  You",
        },
        tools = {
          opts = {
            default_tools = {
              "full_stack_dev",
            },
          },
        },
        slash_commands = {
          buffer = { opts = { provider = "fzf_lua" } }, -- telescope|fzf_lua|mini_pick|snacks|default
          file = { opts = { provider = "fzf_lua" } },
          symbols = { opts = { provider = "fzf_lua" } },
          fetch = { opts = { provider = "fzf_lua" } },

          -- These have different valid choices:
          help = { opts = { provider = "snacks" } }, -- telescope|fzf_lua|mini_pick|snacks
          image = { opts = { provider = "snacks" } }, -- telescope|snacks|default
        },
      },
      inline = {
        keymaps = {
          accept_change = {
            modes = { n = "<C-a>" },
          },
          reject_change = {
            modes = { n = "<C-r>" },
          },
          always_accept = {
            modes = { n = "<C-y>" },
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
        },
      },
      chat = {
        window = {
          opts = {
            number = false,
            relativenumber = false,
            signcolumn = "yes",
            winfixbuf = true,
            scrolloff = 3,
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
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc",
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0,
          -- Picker interface (auto resolved to a valid picker)
          picker = "fzf-lua", --- ("telescope", "snacks", "fzf-lua", or "default")
          ---Optional filter function to control which chats are shown when browsing
          chat_filter = nil, -- function(chat_data) return boolean end
          -- Customize picker keymaps (optional)
          picker_keymaps = {
            rename = { n = "r", i = "<M-r>" },
            delete = { n = "d", i = "<M-d>" },
            duplicate = { n = "<C-y>", i = "<C-y>" },
          },
          ---Automatically generate titles for new chats
          auto_generate_title = true,
          title_generation_opts = {
            -- prevents using premium models for title generation
            adapter = "copilot",
            model = "gpt-4o",
            ---Number of user prompts after which to refresh the title (0 to disable)
            refresh_every_n_prompts = 3, -- e.g., 3 to refresh after every 3rd user prompt
            ---Maximum number of times to refresh the title (default: 3)
            max_refreshes = 3,
            format_title = function(original_title)
              -- this can be a custom function that applies some custom
              -- formatting to the title.
              return original_title
            end,
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = true,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          ---Enable detailed logging for history extension
          enable_logging = false,

          -- Summary system
          summary = {
            -- Keymap to generate summary for current chat (default: "gcs")
            create_summary_keymap = "gcs",
            -- Keymap to browse summaries (default: "gbs")
            browse_summaries_keymap = "gbs",

            generation_opts = {
              -- prevents using premium models for title generation
              adapter = "copilot", -- defaults to current chat adapter
              model = "gpt-4o", -- defaults to current chat model
              context_size = 64000, -- max tokens that the model supports
              include_references = true, -- include slash command content
              include_tool_outputs = true, -- include tool execution results
              system_prompt = nil, -- custom system prompt (string or function)
              format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
            },
          },

          -- Memory system (requires VectorCode CLI)
          memory = {
            -- Automatically index summaries when they are generated
            auto_create_memories_on_summary_generation = true,
            -- Path to the VectorCode executable
            vectorcode_exe = "vectorcode",
            -- Tool configuration
            tool_opts = {
              -- Default number of memories to retrieve
              default_num = 10,
            },
            -- Enable notifications for indexing progress
            notify = true,
            -- Index all existing memories on startup
            -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
            index_on_startup = false,
          },
        },
      },
      vectorcode = {
        opts = {
          tool_group = {
            -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
            enabled = true,
            -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
            -- if you use @vectorcode_vectorise, it'll be very handy to include
            -- `file_search` here.
            extras = {},
            collapse = false, -- whether the individual tools should be shown in the chat
          },
          tool_opts = {
            ["*"] = {},
            ls = {},
            vectorise = {},
            query = {
              max_num = { chunk = -1, document = -1 },
              default_num = { chunk = 10, document = 3 },
              include_stderr = false,
              use_lsp = true,
              no_duplicate = true,
              chunk_mode = true,
              summarise = {
                enabled = true,
                adapter = {
                  name = "copilot",
                  model = "gpt-4.1", -- for larger context
                },
                query_augmented = true,
              },
            },
            files_ls = {},
            files_rm = {},
          },
        },
      },
      spinner = {
        opts = {
          style = "fidget",
        },
      },
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
  keys = {
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>ap",
      "<cmd>CodeCompanionActions<cr>",
      desc = "Open action palette",
      mode = { "n", "v" },
    },
    {
      "<leader>at",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle chat window",
      mode = "n",
    },
    {
      "<leader>an",
      "<cmd>CodeCompanionChat<cr>",
      desc = "New Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>aa",
      "<cmd>CodeCompanionChat Add<cr>",
      desc = "Add to chat",
      mode = { "v" },
    },
    {
      "<leader>ah",
      "<cmd>CodeCompanionHistory<cr>",
      desc = "Chat History",
      mode = "n",
    },
    {
      "<leader>as",
      "<cmd>CodeCompanionSummaries<cr>",
      desc = "Chat Summaries",
      mode = "n",
    },
    {
      "<leader>ai",
      ":CodeCompanion ",
      desc = "Inline Assistant",
      mode = "v",
    },
  },
}
