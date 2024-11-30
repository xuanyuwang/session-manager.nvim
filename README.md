# session-manager.nvim
A session manager for Neovim

It creates a session file in path `.tmp/<git branch name>.vim` when quit Nvim.

When open Nvim, it checks the branch name and find the corresponding session file to load.
