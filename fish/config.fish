if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x MYVIMRC ~/.config/nvim/init.lua
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

