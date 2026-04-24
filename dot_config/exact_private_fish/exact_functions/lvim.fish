function lvim --wraps='NVIM_APPNAME=lvim nvim' --description 'alias lvim=NVIM_APPNAME=lvim nvim'
    NVIM_APPNAME=lvim nvim $argv
end
