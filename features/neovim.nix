{ pkgs, ... } : {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPerl = false;
    withNodeJs = false;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-lspconfig
      blink-cmp
      mini-bracketed
      mini-indentscope
      mini-starter
      lualine-nvim
      hlargs-nvim
      glance-nvim
      which-key-nvim
      nvim-colorizer-lua
      vim-gutentags
      gitsigns-nvim
    ];
    initLua = ''

      vim.loader.enable()
      vim.opt.cursorline = true
      vim.opt.title = true
      vim.opt.number = true
      vim.opt.confirm = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.showmode = false
      vim.opt.timeoutlen = 200
      vim.opt.updatetime = 100
      vim.opt.winborder = 'rounded'
      vim.opt.termguicolors = true

      -- Indent
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.autoindent = true

      vim.opt.swapfile = false
      vim.opt.mouse = 'a'
      vim.opt.clipboard = "unnamedplus"
      vim.opt.splitbelow = true
      vim.opt.splitright = true
      vim.opt.shortmess = 'FaWc'
      vim.opt.scrolloff = 8 -- keep at least 8 lines (based off @ThePrimeagen)

      vim.opt.foldmethod = 'syntax'
      vim.opt.foldcolumn = '1'
      vim.opt.foldlevelstart = 99

      vim.opt.signcolumn = 'auto:1' -- only keep one column to make things nicier
      vim.opt.completeopt = "menu,menuone,noselect"

      vim.opt.spelllang = "en_us"


      vim.g.mapleader = " "      -- Change leader to space which is easier to reach
      vim.g.maplocalleader = ',' -- Change localleader to ,

      vim.keymap.set('n', 'Q', '<nop>', { desc = 'no need for ex mode' })

      vim.keymap.set('n', 'yy', '"+yy', { desc = 'Yank to system clipboard' })
      vim.keymap.set('n', 'dd', '"+dd', { desc = 'Delete and copy to system clipboard' })
      vim.keymap.set('n', 'p', '"+gP', { desc = 'Paste from system clipboard' })


      -- From @ThePrimeagan: autocenter the next match on the screen
      vim.keymap.set('n', 'n', "nzzzv")
      vim.keymap.set('n', 'N', "Nzzzv")

      vim.keymap.set('n', '<C-c>', '"+yy', { desc = 'Copy to system clipboard' })
      vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy to system clipboard' })
      vim.keymap.set('n', '<C-x>', '"+dd', { desc = 'Cut to system clipboard' })
      vim.keymap.set('v', '<C-x>', '"+d', { desc = 'Cut to system clipboard' })

      vim.keymap.set('n', '<Right>', ':bnext<CR>', { desc = 'move to next buffer' })
      vim.keymap.set('n', '<Left>', ':bprev<CR>', { desc = 'move to previous buffer' })
      vim.keymap.set('n', '<leader>T', ':enew<CR>', { desc = 'open a new buffer' })

      -- NOTE: more lsp mappings that I like. Some are handled by glances
      vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp-code_action' })
      vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, { desc = 'lsp-declaration' })
      vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'lsp-formatting' })
      vim.keymap.set('n', '<leader>lI', "<cmd>LspCapabilities<cr>", { desc = 'lsp-capabilities' })
      vim.keymap.set('n', '<leader><c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = 'lsp-sighelp' })
      vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, { desc = 'lsp-rename' })
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, { desc = 'lsp-references' })
      vim.keymap.set('n', '<leader>l0', vim.lsp.buf.document_symbol, { desc = 'lsp-docsymbol' })
      vim.keymap.set('n', '<leader>lW', vim.lsp.buf.workspace_symbol, { desc = 'lsp-workspacesymbol' })
      vim.keymap.set('n', '<leader>ll', vim.lsp.codelens.run, { desc = 'lsp-codelens-run' })


           require('which-key').setup {
            win = {
                 border = "rounded",
             },
             disable = { filetypes = { "neo-tree" } },
             plugins = {
                 spelling = {
                     enabled = true,
                 },
             },
             icons = {
                 mappings = false -- disable icons for which-key
             }
           }

           require('colorizer').setup {
             filetypes = {
                 "*",         -- highlight all filetypes
                 "!neo-tree", -- neo-tree has # numbers and we don't want that to highlight
             }
           }
           require('mini.bracketed').setup()
           require('mini.indentscope').setup()
           require('mini.starter').setup()
           require('gitsigns').setup {
                attach_to_untracked = false,
                preview_config = {
                    border = 'rounded',
                },
           }
           require('blink.cmp').setup {

             cmdline = {
                 keymap = { preset = 'default' },
                 completion = {
                     menu = {
                         auto_show = function(_)
                             return vim.fn.getcmdtype() == ':'
                             -- enable for inputs as well, with:
                             -- or vim.fn.getcmdtype() == '@'
                         end,
                     }
                 },
             },

             keymap = {
                 preset = 'super-tab',
                 -- Adding both Ctrl-Y and Enter keys because I can't decide on selection and
                 -- I like super tab for snippets/cmdline
                 ['<C-y>'] = { 'select_and_accept' },
                 ['<CR>'] = { 'accept', 'fallback' },
             },

           }
           require('lualine').setup()

           require('glance').setup()

           require('hlargs').setup {
           	color = "#95ffa4",
             hl_priority = 10000,
           }

           vim.g.gutentags_ctags_exclude = {
               '*.git', '*.svg', '*.hg',
               '*/tests/*',
               'build',
               'dist',
               '*sites/*/files/*',
               'bin',
               'node_modules',
               'bower_components',
               'cache',
               'compiled',
               'docs',
               'example',
               'bundle',
               'vendor',
               '*.md',
               '*-lock.json',
               '*.lock',
               '*bundle*.js',
               '*build*.js',
               '.*rc*',
               '*.json',
               '*.min.*',
               '*.map',
               '*.bak',
               '*.zip',
               '*.pyc',
               '*.class',
               '*.sln',
               '*.Master',
               '*.csproj',
               '*.tmp',
               '*.csproj.user',
               '*.cache',
               '*.ccls-cache',
               '*.pdb',
               'tags*',
               'cscope.*',
               '*.css',
               '*.less',
               '*.scss',
               '*.exe', '*.dll',
               '*.mp3', '*.ogg', '*.flac',
               '*.swp', '*.swo',
               '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
               '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
               '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
           }

           --vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/vim/ctags/')

           --
           --" a -> acccess or export of class members
           --" i -> inheritance information
           --" l -> language of input file containing tag
           --" m -> implementation information
           --" n -> line number of tag definition
           --" S -> Signature of routine (prototype or parameter list)
           --
           vim.g.gutentags_ctags_extra_args = {
               '--tag-relative=yes',
               '--fields=+ailmnS',
           }


           vim.lsp.enable({'nixd', 'clangd'})
           vim.lsp.inlay_hint.enable()

           -- Global Keymaps for LSP functionality
           vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
           vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
           vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    '';
  };
}
