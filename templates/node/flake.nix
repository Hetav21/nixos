{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    # Point this to your NixOS configuration repository
    dotfiles.url = "git+file:///etc/nixos";
  };

  outputs = {
    self,
    dotfiles,
    ...
  } @ inputs: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forEachSupportedSystem = f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [inputs.self.overlays.default];
            };
          }
      );
  in {
    overlays.default = final: prev: rec {
      nodejs = prev.nodejs;
      yarn = prev.yarn.override {inherit nodejs;};
    };

    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = dotfiles.lib.claude.mkProjectEnv {
          inherit pkgs inputs;
          packages = with pkgs; [
            node2nix
            nodejs
            nodePackages.pnpm
            yarn
          ];

          # agents = [
          #   "https://github.com/owner/repo/blob/main/agents/coder.md"
          # ];
          # skills = [
          #   "https://github.com/owner/repo/tree/main/skills"
          # ];
        };
      }
    );
  };
}
