-- Enable fast loader
vim.loader.enable()


require("paq")(
    {
        "savq/paq-nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim", -- required by package info
        "nvim-tree/nvim-web-devicons", -- required by neo-tree
        "nvim-neo-tree/neo-tree.nvim",
        "MunifTanjim/prettier.nvim",
        "lewis6991/gitsigns.nvim",
        "nvim-lualine/lualine.nvim",
        "nvim-telescope/telescope.nvim",
        "m4xshen/autoclose.nvim",
        "windwp/nvim-ts-autotag",
        "kylechui/nvim-surround",
        "nvimtools/none-ls.nvim", -- none-ls (as null_ls)
        "neovim/nvim-lspconfig",
        "navarasu/onedark.nvim",
        "vuki656/package-info.nvim",
        "hrsh7th/vim-vsnip",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "brenoprata10/nvim-highlight-colors",
        "nvim-treesitter/nvim-treesitter",
        "numToStr/Comment.nvim",
        "fedepujol/move.nvim",
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        "nanozuki/tabby.nvim",
        "echasnovski/mini.basics",
        "folke/which-key.nvim"
    }
)


local theme = require("onedark")

-- Use system clipboard
vim.o.clipboard = "unnamed"
-- indent by 2 spaces by default
vim.o.shiftwidth = 2
vim.o.expandtab = true
-- No cursor line
vim.o.cursorline = false

-- Quiet leader key
vim.keymap.set({"n", "v"}, "<Space>", "<Nop>", {silent = true})
-- Don't add paragraph jumps to jumplist
vim.keymap.set("n", "}", '<cmd>execute "keepjumps norm! " . v:count1 . "}"<CR>', {silent = true})
vim.keymap.set("n", "{", '<cmd>execute "keepjumps norm! " . v:count1 . "{"<CR>', {silent = true})
-- Clear highlight on esc (also ctrl-l by default)
vim.keymap.set("n", "<Esc>", "<Esc><cmd>:noh<CR>", {silent = true})

vim.o.showtabline = 2

-- Theme
theme.setup(
    {
        style = "deep"
    }
)
theme.load()

-- Plugins
require("mini.basics").setup()
require("nvim-surround").setup()
require("package-info").setup()
require("autoclose").setup()
require("nvim-ts-autotag").setup()
require("gitsigns").setup()
require("nvim-highlight-colors").setup()
require("Comment").setup()
require("move").setup({})
require("lsp_lines").setup({})
require("prettier").setup(
    {
        bin = "prettierd",
        filetypes = {
            "css",
            "graphql",
            "html",
            "javascript",
            "javascriptreact",
            "json",
            "less",
            "markdown",
            "scss",
            "typescript",
            "typescriptreact",
            "yaml"
        }
    }
)

require("lualine").setup(
    {
        sections = {
            lualine_b = {{"filename", file_status = true}},
            lualine_c = {{"diagnostics", sources = {"nvim_diagnostic"}}},
            lualine_x = {"encoding", "filetype"},
            lualine_y = {{"branch", icon = ""}}
        }
    }
)

require("nvim-treesitter.configs").setup(
    {
        ensure_installed = {"lua", "tsx", "typescript", "vue", "svelte", "css", "scss", "astro", "html", "javascript"},
        auto_install = true,
        highlight = {enable = true},
        indent = {enable = true, disable = {"python"}}
    }
)

require("tabby").setup(
    {
        preset = "active_tab_with_wins", 
        option = {
            theme = {
                fill = "TabLineFill", -- tabline background
                head = "TabLine", -- head element highlight
                current_tab = "TabLineSel", -- current tab label highlight
                tab = "TabLine", -- other tab label highlight
                win = "TabLine", -- window highlight
                tail = "TabLine" -- tail element highlight
            },
            nerdfont = true, -- whether use nerdfont
            lualine_theme = "onedark", -- lualine theme name
            tab_name = {
                name_fallback = function(tabid)
                local tab_name = vim.fn.fnamemodify(vim.fn.getcwd(-1, tabid), ":t")
                    return tab_name
                end
            },
            buf_name = {
                mode = "relative"
            }
        }
    }
)


require("neo-tree").setup(
    {
        close_if_last_window = true,
        bind_to_cwd = true,
        hide_dotfiles = false
    }
)

-- Close neotree on window switch
vim.cmd([[
  augroup WindowSwitch
    autocmd!
    autocmd WinEnter * lua require('neo-tree').close_all()
  augroup END
]])

-- Telescope binds
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>t", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>*", require("telescope.builtin").grep_string)

-- LSP binds
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover() <CR>")
vim.keymap.set("n", "<leader>k", "<cmd> lua vim.lsp.buf.code_action() <CR>")

-- Tabby binds
vim.keymap.set("n", "<leader>c", "<cmd> tabclose <CR>")

-- Misc binds
vim.keymap.set("n", "<leader>w", ":w <CR>")
vim.keymap.set("n", "<leader>e", "<cmd> Neotree <CR>")
vim.keymap.set("n", "<leader>l", require("lsp_lines").toggle)
vim.keymap.set("n", "L", ":tabn<CR>", {noremap = true})
vim.keymap.set("n", "H", ":tabp<CR>", {noremap = true})

-- LSP
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.tsserver.setup({})
lspconfig.eslint.setup({})
lspconfig.stylelint_lsp.setup({filetypes = {"scss", "css"}})
lspconfig.cssls.setup({capabilities = capabilities})

vim.keymap.set("n", "gr", vim.lsp.buf.rename, {silent = true})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {silent = true})
vim.keymap.set({"n", "v"}, "ga", vim.lsp.buf.code_action, {silent = true})
vim.keymap.set("n", "ge", vim.diagnostic.goto_next, {silent = true})
vim.keymap.set("n", "gE", vim.diagnostic.goto_prev, {silent = true})

-- Formatter
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", {clear = false})
local event = "BufWritePre"

null_ls.setup(
    {
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.keymap.set(
                    "n",
                    "<Leader>f",
                    function()
                        vim.lsp.buf.format({bufnr = vim.api.nvim_get_current_buf()})
                    end,
                    {buffer = bufnr, desc = "[lsp] format"}
                )

                -- format on save
                vim.api.nvim_clear_autocmds({buffer = bufnr, group = group})
                vim.api.nvim_create_autocmd(
                    event,
                    {
                        buffer = bufnr,
                        group = group,
                        callback = function()
                            vim.lsp.buf.format({bufnr = bufnr, async = event == "BufWritePost"})
                        end,
                        desc = "[lsp] format on save"
                    }
                )
            end

            if client.supports_method("textDocument/rangeFormatting") then
                vim.keymap.set(
                    "x",
                    "<Leader>f",
                    function()
                        vim.lsp.buf.format({bufnr = vim.api.nvim_get_current_buf()})
                    end,
                    {buffer = bufnr, desc = "[lsp] format"}
                )
            end
        end
    }
)

-- CMP
local cmp = require "cmp"
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {select = true}
    },
    sources = {
        {name = "vsnip"},
        {name = "nvim_lsp"},
        {name = "buffer"},
        {name = "path"}
    }
}

-- Move
local opts = {noremap = true, silent = true}

-- Normal-mode commands
vim.keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", opts)
vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", opts)
vim.keymap.set("n", "<A-h>", ":MoveHChar(-1)<CR>", opts)
vim.keymap.set("n", "<A-l>", ":MoveHChar(1)<CR>", opts)
-- -- Weird-ass keyboard
vim.keymap.set("n", "∆", ":MoveLine(1)<CR>", opts)
vim.keymap.set("n", "˚", ":MoveLine(-1)<CR>", opts)
vim.keymap.set("n", "˙", ":MoveHChar(-1)<CR>", opts)
vim.keymap.set("n", "¬", ":MoveHChar(1)<CR>", opts)

-- Visual-mode commands
vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
vim.keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
vim.keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)
-- -- Weird-ass keyboard
vim.keymap.set("v", "∆", ":MoveBlock(1)<CR>", opts)
vim.keymap.set("v", "˚", ":MoveBlock(-1)<CR>", opts)
vim.keymap.set("v", "˙", ":MoveHBlock(-1)<CR>", opts)
vim.keymap.set("v", "¬", ":MoveHBlock(1)<CR>", opts)

vim.diagnostic.config(
    {
        virtual_text = false
    }
)

-- WhichKey setup
local which = require("which-key")

which.setup {}

which.register({
    f = { "<cmd>Telescope find_files<cr>", "Find Files" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    t = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    ["*"] = { "<cmd>Telescope grep_string<cr>", "Grep String" },
    w = { "<cmd>w<cr>", "Save" },
    e = { "<cmd>Neotree<cr>", "Explorer" },
    c = { "<cmd>tabclose<cr>", "Close tab" },
    l = { require("lsp_lines").toggle, "Toggle LSP Lines" },
}, { prefix = "<leader>" })

which.register({
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
    ["<leader>k"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    gr = { vim.lsp.buf.rename, "Rename" },
    gd = { vim.lsp.buf.definition, "Go to Definition" },
    ga = { vim.lsp.buf.code_action, "Code Action" },
    ge = { vim.diagnostic.goto_next, "Next Diagnostic" },
    gE = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
}, { mode = "n" })

which.register({
    ["<A-j>"] = { ":MoveLine(1)<CR>", "Move Line Down" },
    ["<A-k>"] = { ":MoveLine(-1)<CR>", "Move Line Up" },
    ["<A-h>"] = { ":MoveHChar(-1)<CR>", "Move Char Left" },
    ["<A-l>"] = { ":MoveHChar(1)<CR>", "Move Char Right" },
    ["∆"] = { ":MoveLine(1)<CR>", "Move Line Down" },
    ["˚"] = { ":MoveLine(-1)<CR>", "Move Line Up" },
    ["˙"] = { ":MoveHChar(-1)<CR>", "Move Char Left" },
    ["¬"] = { ":MoveHChar(1)<CR>", "Move Char Right" },
}, { mode = "n" })

which.register({
    ["<A-j>"] = { ":MoveBlock(1)<CR>", "Move Block Down" },
    ["<A-k>"] = { ":MoveBlock(-1)<CR>", "Move Block Up" },
    ["<A-h>"] = { ":MoveHBlock(-1)<CR>", "Move Block Left" },
    ["<A-l>"] = { ":MoveHBlock(1)<CR>", "Move Block Right" },
    ["∆"] = { ":MoveBlock(1)<CR>", "Move Block Down" },
    ["˚"] = { ":MoveBlock(-1)<CR>", "Move Block Up" },
    ["˙"] = { ":MoveHBlock(-1)<CR>", "Move Block Left" },
    ["¬"] = { ":MoveHBlock(1)<CR>", "Move Block Right" },
}, { mode = "v" })
