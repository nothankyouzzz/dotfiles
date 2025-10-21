return {
  "folke/sidekick.nvim",
  keys = {
    {
      "<leader>asc",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Toggle Codex",
    },
  },
  opts = {
    cli = {
      win = {
        layout = "float",
      },
    },
  },
}
