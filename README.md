To use this:

```shell
# Add the unstable channel.
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# Add the home-manager channel.
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
# Add the plasma-manager channel.
sudo nix-channel --add https://github.com/nix-community/plasma-manager/archive/trunk.tar.gz plasma-manager
# Finally update the channels.
sudo nix-channel --update
```

Now symlink the machine-specific configuration (`<hostname>-configuration.nix`)
to `/etc/nixos/configuration.nix`. And them rebuild.

(This is a note for myself. You may try to base your configurations on mine, but
trying to plainly using this configs is not recommended. Too much opinionated
for my needs. Some places have my name hard-coded).
