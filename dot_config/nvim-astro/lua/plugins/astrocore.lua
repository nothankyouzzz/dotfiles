-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = false, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        scrolloff = 4,
        sidescrolloff = 4,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        codecompanion_yolo_mode = true,
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        -- next / previous buffer
        ["[b"] = false,
        ["]b"] = false,
        ["<Leader>bp"] = false,
        ["<S-L>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-H>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        -- buffer only
        ["<Leader>bo"] = {
          function() require("astrocore.buffer").close_all(true) end,
          desc = "Close all buffers except current",
        },
        -- buffer close
        ["<Leader>C"] = false,
        ["<Leader>bc"] = { function() require("astrocore.buffer").close() end, desc = "Close buffer" },
        ["<Leader>bC"] = { function() require("astrocore.buffer").close(0, true) end, desc = "Force close buffer" },
        -- buffer select
        ["<Leader>bs"] = {
          function()
            require("astroui.status.heirline").buffer_picker(function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end)
          end,
          desc = "Select buffer from tabline",
        },
        -- buffer delete
        ["<Leader>bb"] = false,
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        -- buffer sort
        ["<Leader>bse"] = false,
        ["<Leader>bsr"] = false,
        ["<Leader>bsp"] = false,
        ["<Leader>bsi"] = false,
        ["<Leader>bsm"] = false,
        ["<Leader>bS"] = { desc = require("astroui").get_icon("Sort", 1, true) .. "Sort Buffers" },
        ["<Leader>bSe"] = { function() require("astrocore.buffer").sort "extension" end, desc = "By extension" },
        ["<Leader>bSr"] = { function() require("astrocore.buffer").sort "unique_path" end, desc = "By relative path" },
        ["<Leader>bSp"] = { function() require("astrocore.buffer").sort "full_path" end, desc = "By full path" },
        ["<Leader>bSi"] = { function() require("astrocore.buffer").sort "bufnr" end, desc = "By buffer number" },
        ["<Leader>bSm"] = { function() require("astrocore.buffer").sort "modified" end, desc = "By modification" },
      },

      v = {
        -- better indenting
        ["<"] = "<gv",
        [">"] = ">gv",
      },
    },
  },
}
