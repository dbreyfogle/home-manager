{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    asciinema
    asciinema-agg
    git-filter-repo
    nerd-fonts.fira-code
    tldr
    vim
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
        ".direnv/"
      ];
      userEmail = "27653146+dbreyfogle@users.noreply.github.com";
      userName = "Danny Breyfogle";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
      };
    };

    gh = {
      enable = true;
    };

    k9s = {
      enable = true;
      settings = {
        k9s = {
          noExitOnCtrlC = true;
          ui = {
            logoless = true;
            noIcons = true;
          };
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        fd
        gcc
        ripgrep
        ansible-language-server
        ansible-lint
        bash-language-server
        dockerfile-language-server-nodejs
        golangci-lint
        gopls
        hadolint
        helm-ls
        lua-language-server
        markdownlint-cli2
        nixd
        nixfmt-rfc-style
        nodePackages.prettier
        pyright
        rubocop
        rubyPackages.solargraph
        ruff
        shellcheck
        shfmt
        stylua
        taplo
        terraform-ls
        tflint
        vale
        vscode-langservers-extracted
        yaml-language-server
      ];
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        continuum
        logging
        resurrect
        yank
      ];
      extraConfig = ''
        # [[ Keymaps ]]

        # Pane navigation
        bind j select-pane -D
        bind k select-pane -U
        bind h select-pane -L
        bind l select-pane -R

        # Use current path for new splits
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        # Prompt navigation (OSC 133)
        bind b copy-mode\; send-keys -X previous-prompt
        bind B copy-mode\; send-keys -X next-prompt

        # Convenience shortcuts
        bind -r "<" swap-window -d -t -1
        bind -r ">" swap-window -d -t +1
        bind A setw synchronize-panes\; display-message "synchronize-panes: #{?pane_synchronized,on,off}"
        bind S command-prompt -p "join-pane source:"  "join-pane -s :'%%'"
        bind T command-prompt -p "join-pane target:"  "join-pane -t :'%%'"

        # [[ Options ]]

        # Window renaming
        set -g allow-rename off
        set -g renumber-windows on

        # Display pane numbers until selected
        bind -T prefix q display-panes -d 0

        # Increase history limit
        set -g history-limit 10000

        # Vim-style copy
        setw -g mode-keys vi
        bind -T copy-mode-vi v send -X begin-selection

        # Enable mouse usage
        set -g mouse on

        # Terminal colors
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",*256col*:Tc"

        # Theme
        set -g status-left ""
        set -g status-right "#{?client_prefix,#[fg=green bold],#[fg=default]}[#S]#[fg=default nobold]  #(date '+%a %b %-d  %-I:%M %p')"
        set -g status-style bg=default,fg=white
        setw -g window-status-current-style fg=green,bold
      '';
    };

    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
        strategy = [ "match_prev_cmd" ];
      };
      enableCompletion = true;
      history.ignoreSpace = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "argocd"
          "aws"
          "docker"
          "docker-compose"
          "git"
          "helm"
          "kubectl"
          "terraform"
          "tmux"
          "z"
        ];
      };
      shellAliases = {
        l = "ls -lFhAv --group-directories-first --color";
      };
      syntaxHighlighting.enable = true;
    };
  };

  home.sessionVariables = {
    MINIKUBE_IN_STYLE = "false";
    VALE_CONFIG_PATH = "$HOME/.config/vale/.vale.ini";
    VIRTUAL_ENV_DISABLE_PROMPT = 1;
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_AUTOQUIT = "false";
    ZSH_TMUX_UNICODE = "true";
  };

  xdg.configFile = {
    "alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/home-manager/dotfiles/alacritty/alacritty.toml";
    "alacritty/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/home-manager/dotfiles/alacritty/themes";
    "nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/home-manager/dotfiles/nvim";
    "starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/home-manager/dotfiles/starship/starship.toml";
    "vale/.vale.ini".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/home-manager/dotfiles/vale/.vale.ini";
  };

  home.file = {
    ".vimrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/home-manager/dotfiles/vim/.vimrc";
  };
}
