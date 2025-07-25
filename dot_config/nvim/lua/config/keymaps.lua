local which_key = require("which-key")

which_key.add({
  { "<leader>t", group = "competitest" },
  { "<leader>ts", "<cmd>CompetiTest show_ui<cr>", desc = "Show Result" },
  { "<leader>tr", "<cmd>CompetiTest run<cr>", desc = "Run Test" },
  { "<leader>ta", "<cmd>CompetiTest add_testcase<cr>", desc = "Add Test" },
  { "<leader>te", "<cmd>CompetiTest edit_testcase<cr>", desc = "Edit Test" },
  { "<leader>td", "<cmd>CompetiTest delete_testcase<cr>", desc = "Delete Test" },
})
