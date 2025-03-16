-- lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- キーのセットアップ
-- プラグインのコマンドを対応させるため、セットアップより前に行う必要がある
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- jjをescapeコマンドとして扱う
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- 行番号表示
vim.opt.number = true

-- tabサイズ変更
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Setup lazy.nvim
require("lazy").setup(
    "plugins",
    {
        -- Configure any other settings here. See the documentation for more details.
        -- colorscheme that will be used when installing plugins.
        install = {},
        -- automatically check for plugin updates
        checker = { enabled = true },
    }
)

-- toggleTermのコマンドを設定する
-- ノーマルモード時に Ctrl+T を押したら toggleterm を起動/非表示切り替え
vim.keymap.set("n", "<C-t>", "<Cmd>ToggleTerm<CR>", { noremap = true, silent = true })
-- （オプション）ターミナルモードでも Ctrl+T で隠したい場合
-- ターミナルモードからは <C-\><C-n> でノーマルモードに戻らずに直接トグルしたい場合など
vim.keymap.set("t", "<C-t>", [[<C-\><C-n><Cmd>ToggleTerm<CR>]], { noremap = true, silent = true })

-- oil.nvimのためのショートカット
vim.keymap.set("n", "-", require("oil").open, { desc = "Open Oil file explorer" })

-- ビジュアルモードで Ctrl+C でコピー
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- 挿入モードで Ctrl+V でペースト
vim.api.nvim_set_keymap("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })

-- コマンドモードで Ctrl+V でペースト
vim.api.nvim_set_keymap("c", "<C-v>", "<C-r>+", { noremap = true, silent = true })

-- 挿入モードで Ctrl+L で右に移動
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", { noremap = true, silent = true })

-- neovimがシステムクリップボードへのアクセスを自動化する
vim.opt.clipboard = "unnamedplus"

-- ターミナルの真の色を有効にする
vim.o.termguicolors = true

-- 背景色を透明に設定
vim.cmd [[
  highlight Normal guibg=none
  highlight NormalNC guibg=none
  highlight SignColumn guibg=none
]]
