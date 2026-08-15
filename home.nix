{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NVM_DIR = "$HOME/.nvm";
    BUN_INSTALL = "$HOME/.bun";
    SDKMAN_DIR = "$HOME/.sdkman";
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share/aquaproj-aqua/bin"
    "$HOME/.bun/bin"
    "$HOME/.krew/bin"
    "/Applications/Wireshark.app/Contents/MacOS"
    "/Applications/IntelliJ IDEA.app/Contents/MacOS"
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid

    # Formerly a hand-edited ~/.zshrc (Oh My Zsh) that the Oh My Zsh
    # installer had overwritten, silently detaching it from this config.
    # Migrated in so home-manager owns ~/.zshrc again. Prompt stays on
    # starship (below); oh-my-zsh is only used for the git/kubectl plugins.
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "kubectl" ];
      extraConfig = ''
        zstyle ':omz:update' mode auto
      '';
    };

    shellAliases = {
      ".." = "cd ..";
      "add" = "git add .";
      "push" = "git push";
      "pull" = "git pull";
      "m" = "git switch main";
      "cc" = "claude --dangerously-skip-permissions";
      "co" = "codex --full-auto";
      "ls" = "lsd";
      "ls-tree" = "lsd --tree";
      "idea" = "idea";
    };

    initContent = ''
      bindkey '^f' autosuggest-accept

      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
      [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

      setopt TRANSIENT_RPROMPT
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
