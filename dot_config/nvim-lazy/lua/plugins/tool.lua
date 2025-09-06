return {
  {
    "polirritmico/lazy-local-patcher.nvim",
    config = true,
    ft = "lazy", -- for lazy loading
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
    keys = {
      { "<leader>t", desc = "+competitest" },
      { "<leader>ts", "<cmd>CompetiTest show_ui<cr>", desc = "Show Result" },
      { "<leader>tr", "<cmd>CompetiTest run<cr>", desc = "Run Test" },
      { "<leader>ta", "<cmd>CompetiTest add_testcase<cr>", desc = "Add Test" },
      { "<leader>te", "<cmd>CompetiTest edit_testcase<cr>", desc = "Edit Test" },
      { "<leader>td", "<cmd>CompetiTest delete_testcase<cr>", desc = "Delete Test" },
    },
  },
}
