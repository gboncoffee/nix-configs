{ pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  imports =
    [
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Include desktop non-device-specific configuration.
      ./custom.nix
      # Include home manager configuration.
      ./home-manager.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "karulino";

  # Karulino is a personal machine, so it can have more games installed.
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    unstable.osu-lazer-bin
    melonDS
    ares

    # It also needs AMD gpu stuff.
    amdgpu_top
  ];

  users.motd = ''
    Welcome to karulino.
    "karulino" means "The girl for whom I care".
  '';

  # Karulino needs special config due to AMD.
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
