return {

    -- mason : lsp/formatter/linter のインストール管理
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "rust_analyzer", "lua_ls" },
            })
        end,
    },

    -- LSP クライアント設定

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Lua
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            -- 'vim' を未定義扱いしないように
                            globals = { "vim" },
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    -- Luaファイルを保存時に自動フォーマット
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("AutoFormatLua", { clear = true }),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format()
                        end,
                    })
                end,
            })
        end,
    },

    -- nvim-cmp (補完)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "luasnip" },
                },
                mapping = {
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback() -- 補完候補が表示されていないときは通常のTab動作
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback() -- 補完候補が表示されていないときは通常のShift-Tab動作
                        end
                    end, { 'i', 's' }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    -- 他のマッピングも必要に応じて追加
                },
            })
        end,
    },

    -- Treesitter (シンタックスハイライト)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "rust", "lua", "vim" },
                highlight = { enable = true },
            })
        end
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- このプラグインは既に lazy ではありません
        config = function()
            -- rustaceanvim の設定があればここに書く

            -- InsertLeave 時に自動フォーマット
            vim.api.nvim_create_autocmd("InsertLeave", {
                pattern = "*.rs",
                callback = function()
                    -- Neovim 0.8 以降で推奨されるフォーマット手法
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    },
    -- gruvbox (ダークハード)
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000, -- 早めに読み込む
        config = function()
            vim.o.background = "dark"
            vim.g.gruvbox_contrast_dark = "hard"
            vim.cmd("colorscheme gruvbox")
        end,
    },

    -- vim comment
    {
        "tpope/vim-commentary",
        lazy = false,
    },

    -- oil.nvim(ファイラー)
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = {
                    ["<C-h>"] = "actions.parent",
                },
                view_options = {
                    show_hidden = true,
                },
            })
        end
    },

    -- 自動でかっこのペアを作成してくれる
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    -- ターミナルを開ける
    {
        { 'akinsho/toggleterm.nvim', version = "*", config = true }
    },
    -- bracketの対応関係を示してくれる
    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                chunk = { enable = true },
                indent = { enable = true }
            })
        end
    },
}
