# NixOS Configuration

A modular and maintainable NixOS configuration supporting multiple hosts including desktop environments and WSL setups.

## Installation (Quick Overview)

1. **Clone & enter the repo** (the tree expects to live at `~/nixos`)
   ```bash
   git clone https://github.com/Hetav21/nixos.git ~/nixos
   cd ~/nixos
   ```
2. **Build & switch**
   ```bash
   sudo nixos-rebuild switch --flake .#<host> # nixbook or nixwslbook
   ```
   Use `NIX_CONFIG="experimental-features = nix-command flakes"` on the first run if flakes are not globally enabled.

3. **(Optional) Update inputs later**
   ```bash
   nix flake update
   sudo nixos-rebuild switch --flake .#<host>
   ```

## Contributing

Feel free to open issues or submit pull requests if you find bugs or have suggestions for improvements.

## License

MIT License - See LICENSE file for details

## Acknowledgments

- [NixOS](https://nixos.org/) - The declarative Linux distribution
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [Stylix](https://github.com/danth/stylix) - System-wide theming
- [vasujain275/rudra](https://github.com/vasujain275/rudra) - Dotfiles for this configuration
- NixOS community for excellent documentation and support

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS & Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

