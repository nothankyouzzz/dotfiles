-- stylua: ignore start
local function leftmost()   return vim.fn.winnr("h") == vim.fn.winnr() end
local function rightmost()  return vim.fn.winnr("l") == vim.fn.winnr() end
local function topmost()    return vim.fn.winnr("k") == vim.fn.winnr() end
local function bottommost() return vim.fn.winnr("j") == vim.fn.winnr() end

local function at_top_edge()    return topmost()    and not bottommost() end
local function at_bottom_edge() return bottommost() and not topmost()    end
local function at_left_edge()   return leftmost()   and not rightmost()  end
local function at_right_edge()  return rightmost()  and not leftmost()   end
-- stylua: ignore end

---@param direction "left" | "right" | "up" | "down"
---@param amount number positive integer
local function resize(win, direction, amount)
  -- stylua: ignore
  local negate = (direction == "up"    and at_top_edge())
              or (direction == "down"  and at_bottom_edge())
              or (direction == "left"  and at_left_edge())
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

    -- stylua: ignore
    opts.keys = {
      ["<c-Right>"] = function(win) resize(win, "right", 2) end,
      ["<c-Left>"]  = function(win) resize(win, "left",  2) end,
      ["<c-Up>"]    = function(win) resize(win, "up",    1) end,
      ["<c-Down>"]  = function(win) resize(win, "down",  1) end,
    }
  end,
}
