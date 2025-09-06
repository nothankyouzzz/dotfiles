return {
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
      if vim.g.codecompanion_yolo_mode == true then
        return true
      end
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
}
