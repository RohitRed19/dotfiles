{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
      "ada-url"
      "bash"
      "brotli"
      "btop"
      "c-ares"
      "ca-certificates"
      "colima"
      "docker"
      "docker-compose"
      "fmt"
      "fzf"
      "gettext"
      "glib"
      "glow"
      "gmp"
      "gnutls"
      "go"
      "hdrhistogram_c"
      "icu4c@78"
      "jq"
      "json-c"
      "k9s"
      "kubectx"
      "kubernetes-cli"
      "libevent"
      "libffi"
      "libgcrypt"
      "libgpg-error"
      "libidn2"
      "libmaxminddb"
      "libnghttp2"
      "libnghttp3"
      "libngtcp2"
      "libsmi"
      "libssh"
      "libtasn1"
      "libunistring"
      "libuv"
      "lima"
      "llhttp"
      "lpeg"
      "lsd"
      "lua"
      "luajit"
      "luv"
      "lz4"
      "merve"
      "mise"
      "mpdecimal"
      "nbytes"
      "ncurses"
      "neovim"
      "nettle"
      "node"
      "nx"
      "oniguruma"
      "openssl@3"
      "oxker"
      "p11-kit"
      "pcre2"
      "python@3.14"
      "readline"
      "simdjson"
      "simdutf"
      "spaceship"
      "speexdsp"
      "sqlite"
      "tmux"
      "tree-sitter"
      "trippy"
      "unibilium"
      "unzip"
      "usage"
      "utf8proc"
      "uv"
      "uvwasi"
      "watch"
      "wget"
      "wireshark"
      "xz"
      "zip"
      "zsh-async"
      "zstd"
    ];
    casks = [
      "wezterm"
      "claude-code"
      "gcloud-cli"
      "ngrok"
      "warp"
      "wireshark-chmodbpf"
    ];
  };
}
