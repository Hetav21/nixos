{
  description = "A Nix-flake-based Python development environment with uv package manager";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          uv
          python312
          nodejs
          stdenv.cc.cc.lib
        ];

        shellHook = ''
          echo "🐍 Python development environment with uv/uvx"
          echo "uv version: $(uv --version)"
          echo "uvx is available via: uv tool run (or uvx alias)"
          echo ""
        '';

        # Make native libraries available to Python packages
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
        ];
      };
    });

    # Also expose uv as a package
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.uv;
    });
  };
}
