local function get_appropriate_win()
  local cur_win = vim.api.nvim_get_current_win()
  if not vim.wo[cur_win].winfixbuf then
    return cur_win
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, w in ipairs(wins) do
    if not vim.wo[w].winfixbuf then
      return w
    end
  end

  vim.notify("No appropriate window found for fzf-lua")
end

return {
  "ibhagwan/fzf-lua",
  opts = {
    defaults = {
      actions = {
        ["enter"] = function(selected, opts)
          vim.api.nvim_win_call(get_appropriate_win(), function()
            require("fzf-lua").actions.file_edit_or_qf(selected, opts)
          end)
        end,
      },
    },
  },
}
