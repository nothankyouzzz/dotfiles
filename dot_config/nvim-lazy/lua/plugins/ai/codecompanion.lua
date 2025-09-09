return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
    "Davidyz/VectorCode",
    "franco-ruggeri/codecompanion-spinner.nvim",
    "ravitemer/codecompanion-history.nvim",
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
  opts = function() -- wrap opts as required in vectorcode setup doc
    return {
      strategies = {
        chat = {
          roles = {
            llm = function(adapter)
              return "  " .. adapter.formatted_name .. "(" .. adapter.schema.model.default .. ")"
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
                context_size = 128000, -- max tokens that the model supports
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
                default_num = { chunk = 5, document = 1 },
                include_stderr = false,
                use_lsp = false,
                no_duplicate = true,
                chunk_mode = false,
                summarise = {
                  enabled = false,
                  adapter = {
                    name = "copilot",
                    model = "gpt-4o",
                  },
                  query_augmented = true,
                },
              },
              files_ls = {},
              files_rm = {},
            },
          },
        },
      },
    }
  end,
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
      function()
        vim.ui.input({ prompt = "Inline Assistance" }, function(input)
          if input ~= "" then
            vim.cmd("'<,'>CodeCompanion " .. input)
          end
        end)
      end,
      desc = "Inline Assistant",
      mode = "v",
    },
  },
}
