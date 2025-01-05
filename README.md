# session-manager.nvim
A session manager for Neovim

It creates a session file in path `<Neovim Data Directory>/session-manager/<session name>.vim` when quit Nvim.

When open Nvim, it checks the branch name and find the corresponding session file to load. If such a session file doesn't exist, this plugin will create an empty one.
