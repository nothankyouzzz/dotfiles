return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(highlights, colors)
        highlights["@lsp.type.variable"] = { link = "@variable" }
        highlights["@lsp.type.enumMember.haskell"] = { link = "@constructor" }
      end,
    },
  },

  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    cmd = "CompetiTest",
    opts = {
      testcases_use_single_file = true,
      compile_command = {
        cpp = { exec = "clang++", args = { "-Wall", "-g", "-std=c++20", "$(FNAME)", "-o", "$(FNOEXT)" } },
      },
    },
  },

  {
    "folke/edgy.nvim",
    opts = {
      right = {
        {
          title = "AI Chat",
          ft = "codecompanion",
          size = { width = 0.35 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
      },
      animate = { enabled = false },
    },
  },

  -- idk why it fixes the issue with neo-tree not opening files in the right window
  -- logically speaking, lazyextra ui.edgy has included this configuration.
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.open_files_do_not_replace_types, "edgy")
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = vim.g.neovide and true or false },
    },
  },
}
