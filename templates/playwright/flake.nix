{
  description = "A Nix-flake-based Playwright development environment";

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
  in {
    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nodejs
            nodePackages.pnpm
            playwright-driver.browsers
          ];

          env = {
            PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
            PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
            PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
          };

          shellHook = ''
            echo "🎭 Playwright dev environment"
            echo "  - Browsers: $PLAYWRIGHT_BROWSERS_PATH"
            echo "  - Nixpkgs version: ${pkgs.playwright-driver.version}"
            echo ""
            echo "Note: The @playwright/test version in package.json must match ${pkgs.playwright-driver.version}"
            echo "Run: pnpm install && pnpm test"
          '';
        };
      }
    );
  };
}
