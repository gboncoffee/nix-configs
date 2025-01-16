{ pkgs, ... }:

let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
  locale = "en_DK.UTF-8";
in
{
  console.useXkbConfig = true;

  networking = {
    networkmanager.enable = true;
    tempAddresses = "disabled";
  };

  time.timeZone = "America/Sao_Paulo";

  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "terminate:ctrl_alt_bksp,compose:ralt";
      };
    };

    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmax11";
    };

    desktopManager.plasma6.enable = true;

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ "gabriel" ];
        UseDns = true;
        X11Forwarding = true;
        PermitRootLogin = "no";
        PrintMotd = true;
      };
    };

    fail2ban.enable = true;

    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
  };

  # For pipewire.
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

  # Don't forget to set a password with `passwd`.
  users = {
    users.gabriel = {
      isNormalUser = true;
      description = "Gabriel de Brito";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  programs = {
    firefox.enable = true;
    htop.enable = true;
    tmux.enable = true;
    git.enable = true;
    gnupg.agent.enable = true;

    vim = {
      enable = true;
      defaultEditor = true;
    };

    bash = {
      completion.enable = true;
      enableLsColors = true;
    };

    # KDE.
    partition-manager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      mandoc.enable = true;
      man-db.enable = false;
      generateCaches = true;
    };
  };

  fonts.fontconfig.useEmbeddedBitmaps = true;

  environment = {
    localBinInPath = true;

    # I don't like the Elisa music player (I don't like any KDE player
    # actually).
    plasma6.excludePackages = with pkgs; [
      kdePackages.elisa
    ];
    systemPackages = with pkgs; [
      #
      # System tools.
      #
      wget
      curl
      file
      neofetch
      sl
      wineWowPackages.stable
      ffmpeg
      hugo
      pandoc
      unstable.yt-dlp
      cloc
      qemu
      tmux
      unzip
      libguestfs-with-appliance
      plan9port

      libimobiledevice

      (callPackage ./pkgs/sentPDF.nix { })

      #
      # Docs.
      #
      linux-manual
      man-pages
      man-pages-posix

      #
      # Development.
      #

      # Native.
      unstable.clang
      unstable.lldb
      unstable.llvm
      unstable.lld
      unstable.clang-tools
      valgrind
      gcc
      bear
      nix-init

      # Haskell.
      ghc
      haskell-language-server
      cabal-install

      # Go.
      unstable.go
      unstable.gopls

      # Nix.
      nixpkgs-fmt

      # TeX.
      texliveFull

      # Python.
      python3Full

      #
      # Services.
      #
      mpd

      #
      # Applications.
      #
      thunderbird
      cantata
      geogebra6
      logisim-evolution
      unstable.discord
      unstable.vscode
      libreoffice-qt
      gimp
      rnote

      (wrapOBS {
        plugins = with obs-studio-plugins; [
          obs-pipewire-audio-capture
        ];
      })

      # Other programs.
      fortune
      cowsay
      gnugo
      gnuchess

      # KDE.
      kdePackages.okular
      kdePackages.kdenlive
      kdePackages.filelight
      kdePackages.kcolorchooser
      kdePackages.kcharselect
      kdePackages.kgpg
      kdePackages.kruler
      kdePackages.skanpage
      kdePackages.kleopatra
      kdePackages.ktorrent
      kdePackages.kmag
      kdePackages.kweather
      kdePackages.kmines
      kdePackages.kclock
      kdePackages.ksudoku
      kdePackages.kcalc
      kdePackages.knights
      kdePackages.kigo
      kdePackages.kalzium
      kdePackages.kbreakout
      kdePackages.krecorder
      kdePackages.kapman
      kdePackages.killbots
      kdePackages.isoimagewriter
      haruna
      okteta
    ];
  };
}
