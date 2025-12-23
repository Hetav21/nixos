{
  description = "A Nix-flake-based Python development environment with uv package manager";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs = {self, ...} @ inputs: let
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
            pkgs = import inputs.nixpkgs {inherit system;};
          }
      );

    # Change this value ({major}.{minor}) to update the Python version
    version = "3.13";
  in {
    devShells = forEachSupportedSystem (
      {pkgs}: let
        concatMajorMinor = v:
          pkgs.lib.pipe v [
            pkgs.lib.versions.splitVersion
            (pkgs.lib.sublist 0 2)
            pkgs.lib.concatStrings
          ];

        python = pkgs."python${concatMajorMinor version}";
      in {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.uv
            python
            pkgs.nodejs
          ];

          shellHook = ''
            echo "🐍 Python ${version} development environment with uv/uvx"
            echo "uv version: $(uv --version)"
            echo ""
          '';

          # Make native libraries available to Python packages
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
          ];
        };
      }
    );

    packages = forEachSupportedSystem (
      {pkgs}: {
        default = pkgs.uv;
      }
    );
  };
}
