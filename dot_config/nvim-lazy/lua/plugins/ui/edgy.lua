---@return boolean
local function at_top_edge()
  return vim.fn.winnr() == vim.fn.winnr("k")
end

---@return boolean
local function at_bottom_edge()
  return vim.fn.winnr() == vim.fn.winnr("j")
end

---@return boolean
local function at_left_edge()
  return vim.fn.winnr() == vim.fn.winnr("h")
end

---@return boolean
local function at_right_edge()
  return vim.fn.winnr() == vim.fn.winnr("l")
end

-- Assumption: a window cannot simultaneously be at
-- all four edges (top, bottom, left, right)
--
---@param direction "left" | "right" | "up" | "down"
---@param amount? number positive integer
local function resize(win, direction, amount)
  amount = amount or 2

  local negate = (direction == "up" and at_top_edge())
    or (direction == "down" and at_bottom_edge())
    or (direction == "left" and at_left_edge())
    or (direction == "right" and at_right_edge())

  if negate then
    amount = -amount
  end

  if direction == "up" or direction == "down" then
    win:resize("height", amount)
  elseif direction == "left" or direction == "right" then
    win:resize("width", amount)
  end
end

return {
  "folke/edgy.nvim",
  opts = function(_, opts)
    opts.animate = { enabled = false }

    table.insert(opts.right, {
      title = "AI Chat",
      ft = "codecompanion",
      size = { width = 0.35 },
      filter = function(_, win)
        return vim.api.nvim_win_get_config(win).relative == ""
      end,
    })

    opts.keys = {
      -- increase width
      ["<c-Right>"] = function(win)
        resize(win, "right")
        -- win:resize("width", 2)
      end,
      -- decrease width
      ["<c-Left>"] = function(win)
        resize(win, "left")
        -- win:resize("width", -2)
      end,
      -- increase height
      ["<c-Up>"] = function(win)
        resize(win, "up", 1)
        -- win:resize("height", 1)
      end,
      -- decrease height
      ["<c-Down>"] = function(win)
        resize(win, "down", 1)
        -- win:resize("height", -1)
      end,
    }

    return opts
  end,
}
