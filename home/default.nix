{
  config,
  pkgs,
  ...
}:

let
  flakePath = "${config.home.homeDirectory}/Projects/nix-config";
in
{
  # Core packages for both platforms
  home.packages = with pkgs; [
    # Editors & Multiplexers
    neovim
    zellij
    herdr

    # Git & CLI Utilities
    gnumake
    lazygit
    bat
    eza
    fd
    ripgrep
    fzf
    zoxide
    yazi
    atuin
    direnv
    btop
    fastfetch
    gum
    glow
    tealdeer
    jira-cli-go
    just
    mise
    pre-commit
    shellcheck
    gnused
    coreutils
    _7zz
    imagemagick
    ghostscript
    mermaid-cli
    tectonic

    # Data Processors
    jq
    htmlq
    yq-go

    # Neovim / LSP Dependencies
    unzip
    wget
    curl
    gzip
    python3
    luarocks
    stylua
    markdownlint-cli2
    statix
    nixfmt

    # Containers, Kubernetes & Cloud
    lazydocker
    k9s
    lazysql
    pgcli
    postgresql_18
    sqlite
    redis
    kubernetes-helm
    kubectx
    ansible
    ansible-lint
    awscli2
    sops

    # Global Toolchains
    nodejs
    bun
    go
    cargo
    uv
    phpactor
    gopls
    nil

    # AI Tools
    (writeShellScriptBin "agy" ''
      if [ ! -f ~/.local/bin/agy ]; then
        echo "Installing agy..."
        curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir ~/.local/bin
      fi
      exec ~/.local/bin/agy "$@"
    '')
  ];

  programs.home-manager.enable = true;
  programs.man.generateCaches = false;

  # Native Git Configuration
  programs.git = {
    enable = true;

    settings = {
      user.name = "Rauls Kjarners";
      user.email = "rauls.kjarners@gmail.com";
      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictStyle = "zdiff3";
    };

    lfs.enable = true;

    ignores = [
      ".phpactor.json"
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Thumbs.db"
    ];
  };

  # Delta Pager Configuration
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      hyperlinks = true;
      "hyperlinks-file-link-format" = "file://{path}:{line}";
      "line-numbers" = true;

      "gruvbox-material-dark" = {
        "syntax-theme" = "gruvbox-dark";
        "commit-style" = "#d8a657 bold";
        "commit-decoration-style" = "#504945 box";
        "file-style" = "#e2cca9 bold";
        "file-decoration-style" = "#d8a657 ul";
        "hunk-header-file-style" = "#7daea3";
        "hunk-header-line-number-style" = "#d8a657";
        "hunk-header-decoration-style" = "#504945 box";
        "minus-style" = "syntax #3c1f1e";
        "minus-non-emph-style" = "syntax #3c1f1e";
        "minus-emph-style" = "syntax #4c2f2e";
        "minus-empty-line-marker-style" = "syntax #3c1f1e";
        "line-numbers-minus-style" = "#ea6962";
        "plus-style" = "syntax #283b31";
        "plus-non-emph-style" = "syntax #283b31";
        "plus-emph-style" = "syntax #384b41";
        "plus-empty-line-marker-style" = "syntax #283b31";
        "line-numbers-plus-style" = "#a9b665";
        "line-numbers-zero-style" = "#504945";
      };

      "gruvbox-material-light" = {
        "syntax-theme" = "gruvbox-light";
        "commit-style" = "#b47109 bold";
        "commit-decoration-style" = "#e2cca9 box";
        "file-style" = "#514036 bold";
        "file-decoration-style" = "#b47109 ul";
        "hunk-header-decoration-style" = "#e2cca9 box";
        "hunk-header-file-style" = "#45707a";
        "hunk-header-line-number-style" = "#b47109";
        "minus-style" = "syntax #f0c6c6";
        "minus-non-emph-style" = "syntax #f0c6c6";
        "minus-emph-style" = "syntax #eeb6b6";
        "minus-empty-line-marker-style" = "syntax #f0c6c6";
        "line-numbers-minus-style" = "#c14a4a";
        "plus-style" = "syntax #d8e5cd";
        "plus-non-emph-style" = "syntax #d8e5cd";
        "plus-emph-style" = "syntax #c8d5bd";
        "plus-empty-line-marker-style" = "syntax #d8e5cd";
        "line-numbers-plus-style" = "#6c782e";
        "line-numbers-zero-style" = "#e2cca9";
      };
    };
  };

  # GitHub CLI and extensions
  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-dash ];
  };

  # Enable font management
  fonts.fontconfig.enable = true;

  # Enable Fish shell and native plugins
  programs.fish = {
    enable = true;
    shellAliases = {
      # System update command
      update = "just -f ${flakePath}/justfile update";

      # Core tools overrides
      cat = "bat";
      ls = "eza --color=always --icons=always";
      ll = "eza --color=always --long --git --icons=always";
      la = "eza --color=always --long --git --icons=always --all";

      # Shortcuts
      lzg = "lazygit";
      lzd = "lazydocker";
      lzs = "lazysql";
      zj = "zellij attach -c main";
      agya = "agy --dangerously-skip-permissions";
      dark = "switch_theme dark";
      light = "switch_theme light";
    };
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
    ];
    interactiveShellInit = ''
      source ${./configs/fish/config.fish}
    '';
  };

  # Symlink static dotfiles into ~/.config/ (Dynamic configs are built by switch_theme.fish)
  xdg.configFile = {
    "fish/functions".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/fish/functions";
    "tridactyl/themes".source = ./configs/tridactyl/themes;
    "tridactyl/tridactylrc".text = ''
      ${builtins.readFile ./configs/tridactyl/tridactylrc}

      " --- External Editor ---
      " Auto-generated by Nix based on OS
      ${
        if pkgs.stdenv.isDarwin then
          ''
            set editorcmd /opt/homebrew/bin/wezterm start --always-new-process -- ${pkgs.fish}/bin/fish -lc 'nvim "%f"; open -a Zen'
          ''
        else if pkgs.stdenv.isLinux then
          ''
            set editorcmd powershell.exe -NoProfile -WindowStyle Hidden -Command "& '\\wsl.localhost\NixOS\home\nixos\Projects\nix-config\home\configs\tridactyl\wsl_nvim.bat' '%f'"
          ''
        else
          ""
      }
    '';
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/wezterm";
    "phpactor".source = ./configs/phpactor;
    "glamour".source = ./configs/glamour;
    "mise".source = ./configs/mise;
    "herdr/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/herdr/config.toml";
  };

  # Home root symlinks
  home.file = {
    ".local/bin/neotest-remote".source = ./configs/bin/neotest-remote;
    ".markdownlint-cli2.yaml".source = ./configs/markdownlint/.markdownlint-cli2.yaml;

    # Custom AI Agents & Global Rules
    ".omp/agent/RULES.md".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/omp/RULES.md";
    ".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/claude/CLAUDE.md";
    ".claude/agents".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/claude/agents";
    ".gemini/config/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/configs/antigravity/AGENTS.md";
  };

  home.sessionVariables = {
    FLAKE_PATH = flakePath;
  };

  home.stateVersion = "26.11";
}
