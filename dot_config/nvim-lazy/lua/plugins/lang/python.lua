return {
  "linux-cultist/venv-selector.nvim",
  opts = {
    search = {
      miniconda_base = {
        command = "fd 'bin/python$' ~/.miniconda/bin --color never --full-path --follow",
        type = "anaconda",
      },
      miniconda_envs = {
        command = "fd 'bin/python$' ~/.miniconda/envs --color never --full-path --follow",
        type = "anaconda",
      },
      cwd = false,
    },
  },
}
