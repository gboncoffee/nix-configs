{ config, ... }:

let
  isNixOS = builtins.pathExists "/etc/NIXOS";
  fileDir = builtins.toString ./.;
  wallpaper = "/home/gabriel/Pictures/wallpapers/share/tokyo-night/tokyo-night34.png";
in
{
  imports = [ <home-manager/nixos> ];

  home-manager = {
    useGlobalPkgs = isNixOS;
    backupFileExtension = ".bak";
    users.gabriel = { ... }: {
      imports = [ <plasma-manager/modules> ];

      targets.genericLinux.enable = ! isNixOS;

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        zsh = {
          enable = true;
          enableCompletion = true;
          syntaxHighlighting.enable = true;
          autocd = true;
          defaultKeymap = "emacs";
          history = {
            size = 2000;
            ignoreSpace = true;
          };
          initExtra = ''
            precmd() { print -rP "" }
            setopt print_exit_value
            bindkey ";5C" forward-word
            bindkey ";5D" backward-word
            eval "$(direnv hook zsh)"
          '';
          shellAliases = {
            music-dl = "yt-dlp -i -x --audio-format mp3";
            clang-format-all = "find . -name '*.[c,h]' -exec clang-format -i {} \;";
          };
        };

        git = {
          enable = true;
          userEmail = "gabrielgbrito@icloud.com";
          userName = "Gabriel G. de Brito";
          extraConfig = {
            advice.addEmptyPathspec = false;
            init.defaultBranch = "main";
            format.pretty = "oneline";
            receive.denyCurrentBranch = "warn";
          };
        };

        tmux = {
          enable = true;
          escapeTime = 0;
          mouse = true;
          extraConfig = ''
            set -ag terminal-overrides ",xterm-256color:RGB"
            set  -g default-terminal "tmux-256color"
          '';
        };

        konsole = {
          enable = true;
          defaultProfile = "Profile 1";
          profiles."Profile 1" = {
            colorScheme = "Tokyo Night";
            extraConfig = {
              General = {
                SemanticInputClick = true;
                TerminalColumns = 90;
                TerminalRows = 28;
              };
            };
          };
          customColorSchemes = {
            "Tokyo Night" = ./. + "/Tokyo\ Night.colorscheme";
          };
          extraConfig = {
            "Interaction Options" = {
              OpenLinksByDirectClickEnabled = true;
              TextEditorCmd = 1;
            };
            "Konsole Window" = {
              AllowMenuAccelerators = false;
              RememberWindowSize = false;
              ShowWindowTitleOnTitleBar = true;
            };
          };
        };

        okular = {
          enable = true;
          accessibility.highlightLinks = false;
          general = {
            obeyDrm = false;
            openFileInTabs = false;
            showScrollbars = true;
            smoothScrolling = true;
            viewContinuous = true;
            zoomMode = "fitWidth";
          };
        };

        # By nature, there's device specific configuration removed from this
        # file. Because of that, we cannot use that setting that "ensures
        # reproducibility". By the way, this was generated by rc2nix.py.
        plasma = {
          enable = true;
          panels = [
            {
              floating = true;
              hiding = "dodgewindows";
              widgets = [
                {
                  kickoff = {
                    sortAlphabetically = true;
                    icon = "nix-snowflake-white";
                  };
                }
                {
                  iconTasks = {
                    launchers = [
                      "applications:org.kde.konsole.desktop"
                      "applications:org.kde.dolphin.desktop"
                      "applications:firefox.desktop"
                      "applications:thunderbird.desktop"
                      "applications:code.desktop"
                      "applications:org.kde.kcalc.desktop"
                      "applications:geogebra.desktop"
                      "applications:logisim-evolution.desktop"
                      "applications:discord.desktop"
                      "applications:cantata.desktop"
                      # Only add osu! and Steam to Amuzino as it's the personal
                      # machine.
                    ] ++ (if config.networking.hostName == "amuzino" then [
                      "applications:osu!.desktop"
                      "applications:steam.desktop"
                    ] else [ ]);
                  };
                }
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.systemtray"
                "org.kde.plasma.digitalclock"
              ];
            }
          ];
          powerdevil = rec {
            AC = {
              autoSuspend.action = "nothing";
              dimDisplay.enable = false;
              whenLaptopLidClosed = "turnOffScreen";
            };
            battery = AC;
            lowBattery = AC;
          };
          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            wallpaper = wallpaper;
          };
          configFile = {
            baloofilerc."Basic Settings".Indexing-Enabled = false;
            dolphinrc = {
              ContextMenu = {
                ShowAddToPlaces = false;
                ShowCopyToOtherSplitView = false;
                ShowOpenInNewTab = false;
                ShowOpenInSplitView = false;
                ShowSortBy = false;
              };
              General = {
                AutoExpandFolders = true;
                RememberOpenedTabs = false;
                ShowFullPathInTitlebar = true;
              };
            };
            kded5rc = {
              Module-browserintegrationreminder.autoload = false;
              Module-device_automounter.autoload = false;
            };
            kdeglobals = {
              KDE.ShowDeleteCommand = true;
              "KFileDialog Settings" = {
                "Allow Expansion" = false;
                "Breadcrumb Navigation" = true;
                "Show Bookmarks" = false;
                "Show Full Path" = false;
                "Show Inline Previews" = true;
                "Show Preview" = false;
                "Show Speedbar" = true;
                "Sort by" = "Name";
                "Sort directories first" = true;
                "Sort hidden files last" = true;
              };
            };
            kiorc = {
              Confirmations = {
                ConfirmDelete = true;
                ConfirmEmptyTrash = true;
                ConfirmTrash = false;
              };
              "Executable scripts".behaviourOnLaunch = "alwaysAsk";
            };
            krunnerrc.Plugins = {
              baloosearchEnabled = false;
              browserhistoryEnabled = false;
              browsertabsEnabled = false;
              calculatorEnabled = false;
              helprunnerEnabled = false;
              krunner_charrunnerEnabled = false;
              krunner_katesessionsEnabled = false;
              krunner_konsoleprofilesEnabled = false;
              krunner_placesrunnerEnabled = false;
              krunner_plasma-desktopEnabled = false;
              krunner_recentdocumentsEnabled = false;
              krunner_sessionsEnabled = false;
              krunner_spellcheckEnabled = false;
              krunner_webshortcutsEnabled = false;
              locationsEnabled = false;
              "org.kde.activities2Enabled" = false;
              "org.kde.datetimeEnabled" = false;
              windowsEnabled = false;
            };
            kscreenlockerrc = {
              Daemon.Autolock = false;
              "Greeter/Wallpaper/org.kde.image/General" = {
                Image = wallpaper;
                PreviewImage = wallpaper;
              };
            };
            kservicemenurc.Show = {
              compressfileitemaction = true;
              decrypt-view = true;
              encrypt = true;
              extractfileitemaction = true;
              forgetfileitemaction = false;
              installFont = false;
              kactivitymanagerd_fileitem_linking_plugin = true;
              kio-admin = true;
              kleodecryptverifyfiles = true;
              kleoencryptfiles = true;
              kleoencryptfolder = true;
              kleoencryptsignfiles = true;
              kleosignencryptfolder = true;
              kleosignfilescms = true;
              kleosignfilesopenpgp = true;
              makefileactions = false;
              mountisoaction = true;
              runInKonsole = false;
              slideshowfileitemaction = false;
              tagsfileitemaction = false;
              wallpaperfileitemaction = true;
            };
            ktrashrc."\\/home\\/gabriel\\/.local\\/share\\/Trash" = {
              Days = 7;
              LimitReachedAction = 2;
              Percent = 2;
              UseSizeLimit = true;
              UseTimeLimit = true;
            };
            kwalletrc.Wallet."First Use" = false;
            kwinrc.Xwayland.Scale = 1;
            plasma-localerc.Formats.LANG = "en_DK.UTF-8";
          };
        };
      };

      home.file.".local/bin/mknix" = {
        enable = true;
        executable = true;
        text = ''
          #!/usr/bin/env bash

          if [ -f shell.nix ]; then
              echo "Directory already has a shell.nix"
              exit 1
          fi

          echo '{ pkgs ? import <nixpkgs> {} }:' >> shell.nix
          echo 'pkgs.mkShell rec {' >> shell.nix
          echo '  nativeBuildInputs = with pkgs.buildPackages; [' >> shell.nix
          echo '  ];' >> shell.nix
          echo '  buildInputs = with pkgs.buildPackages; [' >> shell.nix
          echo '  ] ++ nativeBuildInputs;' >> shell.nix
          echo '}' >> shell.nix

          echo 'use_nix' > .envrc
          direnv allow .
        '';
      };

      home.stateVersion = config.system.stateVersion;
    };
  };
}
