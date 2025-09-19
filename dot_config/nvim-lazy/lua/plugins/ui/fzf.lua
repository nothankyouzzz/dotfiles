-- Returns the filetype of the buffer in the given window.
local function get_win_filetype(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.bo[buf].filetype
end

-- Finds an appropriate window for fzf-lua actions.
-- Prefers the current window unless it is a codecompanion window.
-- Otherwise, returns the first non-codecompanion, non-winfixbuf window.
local function find_fzf_target_win()
  local cur_win = vim.api.nvim_get_current_win()
  if get_win_filetype(cur_win) ~= "codecompanion" then
    return cur_win
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(wins) do
    if not vim.wo[win].winfixbuf and get_win_filetype(win) ~= "codecompanion" then
      return win
    end
  end

  vim.notify("No appropriate window found for fzf-lua", vim.log.levels.WARN)
  return nil
end

return {
  "ibhagwan/fzf-lua",
  -- dev = true,
  opts = {
    files = {
      actions = {
        ["enter"] = function(selected, opts)
          local target_win = find_fzf_target_win()
          if target_win then
            vim.api.nvim_win_call(target_win, function()
              require("fzf-lua").actions.file_edit_or_qf(selected, opts)
            end)
          end
        end,
      },
    },
  },
}
