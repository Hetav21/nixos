{
  description = "A Nix-flake-based Go development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable Nixpkgs

    # Point this to your NixOS configuration repository
    dotfiles.url = "git+file:///etc/nixos";
  };

  outputs = {
    self,
    dotfiles,
    ...
  } @ inputs: let
    goVersion = 24; # Change this to update the whole stack

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
    overlays.default = final: prev: {
      go = final."go_1_${toString goVersion}";
    };

    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = dotfiles.lib.claude.mkProjectEnv {
          inherit pkgs inputs;
          packages = with pkgs; [
            # go (version is specified by overlay)
            go

            # goimports, godoc, etc.
            gotools

            # https://github.com/golangci/golangci-lint
            golangci-lint
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
