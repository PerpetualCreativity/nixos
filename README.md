# PerpetualCreativity's NixOS flake

## installing

- reinstalling on an existing system: `nixos-install --flake github.com/PerpetualCreativity/nixos#hostname`, may need `--impure` for Asahi installs.
- installing on a new system: in the installer,
  - git clone this repo
  - edit `flake.nix` and add the new hostname. call standard with either server or desktop shared files
  - copy `/etc/nixos/configuration.nix` into `hosts/new_hostname/hardware_configuration.nix` and import from `hosts/new_hostname/configuration.nix`
  - `nixos-install --flake .#new_hostname`; may need `--impure` for Asahi installs.
