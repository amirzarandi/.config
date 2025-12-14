local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])

vim.opt.winborder = "rounded"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.completeopt = "menuone,noselect,popup"

require("lazy").setup({
    { "vague2k/vague.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "chentoast/marks.nvim" },
    { 
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
                columns = { "permissions", "icon" },
                float = { max_width = 0.7, max_height = 0.6, border = "rounded" },
            })
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "python", "rust", "lua", "vim", "vimdoc", "query", "bash" },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
            })
        end
    },

    { 
        "nvim-telescope/telescope.nvim", 
        version = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "LinArcX/telescope-env.nvim" },

    { "aznhe21/actions-preview.nvim" },

    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { 
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip").setup({ enable_autosnippets = true })
        end
    },
})

require("marks").setup { builtin_marks = { "<", ">", "^" } }
require("vague").setup({ transparent = true })
vim.cmd('colorscheme vague')

local telescope = require("telescope")
telescope.setup({
    defaults = {
        preview = { treesitter = false },
        sorting_strategy = "ascending",
        path_displays = { "smart" },
        layout_config = { prompt_position = "top" }
    }
})
telescope.load_extension("ui-select")

require("actions-preview").setup {
    backend = { "telescope" },
    telescope = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {})
}

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "pyright",
        "ruff",
    },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,
        
        ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } }
                }
            })
        end,
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.completionProvider then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

local map = vim.keymap.set
local builtin = require("telescope.builtin")

map({ "n", "v", "x" }, ";", ":", { desc = "Enter Command Mode" })
map({ "n", "v", "x" }, ":", ";", { desc = "Repeat Find" })

map("n", "<leader>w", "<Cmd>update<CR>", { desc = "Save" })
map("n", "<leader>q", "<Cmd>quit<CR>", { desc = "Quit" }) 
map("n", "<leader>Q", "<Cmd>wqa<CR>", { desc = "Save All & Quit" })

map("n", "<leader>f", builtin.find_files, { desc = "Find Files" })
map("n", "<leader>g", function() builtin.live_grep({ additional_args = { "-e" } }) end, { desc = "Grep" })
map("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>sh", builtin.help_tags, { desc = "Help" })

map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open File Browser" })

map("n", "<M-n>", "<cmd>resize +2<CR>")
map("n", "<M-e>", "<cmd>resize -2<CR>")
map("n", "<M-i>", "<cmd>vertical resize +5<CR>")
map("n", "<M-m>", "<cmd>vertical resize -5<CR>")

map({ "n", "x" }, "<leader>y", '"+y')
map({ "n", "x" }, "<leader>d", '"+d')