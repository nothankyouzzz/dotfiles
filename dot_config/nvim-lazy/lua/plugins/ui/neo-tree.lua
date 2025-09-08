return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    table.insert(opts.open_files_do_not_replace_types, "codecompanion")
  end
}
