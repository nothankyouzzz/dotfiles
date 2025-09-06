local prefix = "<Leader>a"

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by completion engine
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              -- set the ai_accept function
              ai_accept = function()
                if require("copilot.suggestion").is_visible() then
                  require("copilot.suggestion").accept()
                  return true
                end
              end,
            },
          },
        },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "User AstroFile",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    opts = {
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
      },
    },
    specs = {
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
            if vim.g.codecompanion_yolo_mode == true then return true end
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
        "rebelot/heirline.nvim",
        optional = true,
        opts = function(_, opts)
          local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          local astroui = require "astroui.status.hl"
          local spinner = {
            static = {
              n_requests = 0,
              spinner_index = 0,
              spinner_symbols = spinner_symbols,
              done_symbol = "✓",
            },
            init = function(self)
              if self._cc_autocmds then return end
              self._cc_autocmds = true
              vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionRequestStarted",
                callback = function()
                  self.n_requests = self.n_requests + 1
                  vim.cmd "redrawstatus"
                end,
              })
              vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionRequestFinished",
                callback = function()
                  self.n_requests = math.max(0, self.n_requests - 1)
                  vim.cmd "redrawstatus"
                end,
              })
            end,
            provider = function(self)
              if not package.loaded["codecompanion"] then return nil end
              local symbol
              if self.n_requests > 0 then
                self.spinner_index = (self.spinner_index % #self.spinner_symbols) + 1
                symbol = self.spinner_symbols[self.spinner_index]
              else
                symbol = self.done_symbol
                self.spinner_index = 0
              end
              return ("  %d %s"):format(self.n_requests, symbol)
            end,
            hl = function() return astroui.filetype_color() end,
          }
          table.insert(opts.statusline, #opts.statusline, spinner)
        end,
      },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          if not opts.mappings then opts.mappings = {} end
          opts.mappings.n = opts.mappings.n or {}
          opts.mappings.v = opts.mappings.v or {}
          opts.mappings.n[prefix] = { desc = require("astroui").get_icon("CodeCompanion", 1, true) .. "CodeCompanion" }
          opts.mappings.v[prefix] = { desc = require("astroui").get_icon("CodeCompanion", 1, true) .. "CodeCompanion" }
          opts.mappings.n[prefix .. "c"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" }
          opts.mappings.v[prefix .. "c"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" }
          opts.mappings.n[prefix .. "p"] = { "<cmd>CodeCompanionActions<cr>", desc = "Open action palette" }
          opts.mappings.v[prefix .. "p"] = { "<cmd>CodeCompanionActions<cr>", desc = "Open action palette" }
          opts.mappings.n[prefix .. "q"] = { "<cmd>CodeCompanion<cr>", desc = "Open inline assistant" }
          opts.mappings.v[prefix .. "q"] = { "<cmd>CodeCompanion<cr>", desc = "Open inline assistant" }
          opts.mappings.v[prefix .. "a"] = { "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to chat" }
        end,
      },
      { "AstroNvim/astroui", opts = { icons = { CodeCompanion = "󱙺" } } },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.file_types then opts.file_types = { "markdown" } end
          opts.file_types = require("astrocore").list_insert_unique(opts.file_types, { "codecompanion" })
        end,
      },
      {
        "OXY2DEV/markview.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.preview then opts.preview = {} end
          if not opts.preview.filetypes then opts.preview.filetypes = { "markdown", "quarto", "rmd" } end
          opts.preview.filetypes = require("astrocore").list_insert_unique(opts.preview.filetypes, { "codecompanion" })
        end,
      },
    },
  },
}
