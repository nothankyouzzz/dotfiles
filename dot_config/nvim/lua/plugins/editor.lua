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
      animate = { enabled = false },
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = vim.g.neovide and true or false },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-sonnet-4"
    }
  }
}
