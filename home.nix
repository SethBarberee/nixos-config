{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  #imports = [  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sethb";
  home.homeDirectory = "/home/sethb";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ripgrep
    lua-language-server
    ctags

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      gpu_stats = true;
      gpu_temp = true;
      gpu_junction_temp = true;
      gpu_core_clock = true;
      gpu_mem_temp = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load_value = "60,90";
      gpu_load_color = lib.mkForce "39F900,FDFD09,B22222";
      gpu_fan = true;
      gpu_voltage = true;
      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;
      cpu_load_value = "60,90";
      cpu_load_color = lib.mkForce "39F900,FDFD09,B22222";
      vram = true;
      ram = true;
      fps = true;
      frame_timing = true;
      frametime = true;
      font_scale = lib.mkForce 2.25;
      fps_metrics = "avg,0.01";
      throttling_status = true;
      text_outline = true;
      round_corners = 10;
    };
  };

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


           vim.lsp.enable({'nixd'})
           vim.lsp.inlay_hint.enable()

           -- Global Keymaps for LSP functionality
           vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
           vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
           vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    '';
  };

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles = {
      sethb = {
        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
        };
      };
    };
  };

  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    config = {
      hwdec = "auto";
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
    };
  };

  programs.yt-dlp = {
    enable = true;
    settings = {
      "embed-chapters" = true;
      "embed-thumbnail" = true;
      "embed-subs" = true;
      "embed-metadata" = true;
      "default-search" = "ytsearch";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Seth Barberee";
        email = "seth.barberee@gmail.com";
      };
    };
  };

  programs.kitty = lib.mkForce {
    enable = true;

    # NOTE: use stylix instead for now
    #extraConfig = "include ~/.config/kitty/challenger-deep.conf";

    settings = {
      font_size = "12.0";
      enable_audio_bell = false;
    };
  };

  # TODO configure this
  programs.ranger = {
    enable = true;
  };

  # Stylix stuff
  stylix.targets.firefox.profileNames = ["sethb"];
  stylix.targets.neovim.enable = false; # disable stylix for neovim

  # NOTE: need this to fix overwriting the GTK2 config
  gtk.gtk2.configLocation = "${config.home.homeDirectory}/.config/.gtkrc-2.0";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # Add my nvim config
    #".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink /home/sethb/dotfiles/neovim/.config/nvim/init.lua;
    #".config/nvim/filetype.lua".source = config.lib.file.mkOutOfStoreSymlink /home/sethb/dotfiles/neovim/.config/nvim/filetype.lua;
    #".config/nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink /home/sethb/dotfiles/neovim/.config/nvim/lazy-lock.json;
    #".config/nvim/lua/seth".source = config.lib.file.mkOutOfStoreSymlink /home/sethb/dotfiles/neovim/.config/nvim/lua/seth;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sethb/etc/profile.d/hm-session-vars.sh
  #
  #home.sessionVariables = {
  #  EDITOR = "nvim";
  #};

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;
}
