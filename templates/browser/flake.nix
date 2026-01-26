{
  description = "A Nix-flake-based Playwright browser testing environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    # Point this to your NixOS configuration repository
    dotfiles.url = "git+file:///etc/nixos";

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    playwright-skill = {
      url = "github:lackeyjb/playwright-skill";
      flake = false;
    };
    awesome-claude-skills = {
      url = "github:ComposioHQ/awesome-claude-skills";
      flake = false;
    };
    ffuf_claude_skill = {
      url = "github:jthack/ffuf_claude_skill";
      flake = false;
    };
    ai-skills = {
      url = "github:sanjay3290/ai-skills";
      flake = false;
    };
    awesome-claude-code-subagents = {
      url = "github:VoltAgent/awesome-claude-code-subagents";
      flake = false;
    };
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
            pkgs = import inputs.nixpkgs {inherit system;};
          }
      );
  in {
    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = dotfiles.lib.claude.mkProjectEnv {
          inherit pkgs inputs;
          packages = with pkgs; [
            nodejs
            nodePackages.pnpm
            playwright-driver.browsers
          ];

          env = {
            PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
            PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
            PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
            # Fix for WSL/NixOS: Playwright incorrectly detects host platform
            # causing webkit to look for wrong browser path
            PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
          };

          shellHook = ''
            echo "🎭 Playwright dev environment"
            echo "  - Browsers: $PLAYWRIGHT_BROWSERS_PATH"
            echo "  - Nixpkgs version: ${pkgs.playwright-driver.version}"
            echo ""
            echo "Note: The @playwright/test version in package.json must match ${pkgs.playwright-driver.version}"
            echo "Run: pnpm install && pnpm test"
          '';

          skills = [
            (dotfiles.lib.claude.extract pkgs inputs.anthropic-skills "skills" {
              includes = ["webapp-testing"];
            })
            "${inputs.playwright-skill}"
            "${inputs.awesome-claude-skills}/webapp-testing"
            "${inputs.ffuf_claude_skill}"
          ];

          agents = [
            "${inputs.awesome-claude-code-subagents}/categories/04-quality-security/test-automator.md"
            "${inputs.awesome-claude-code-subagents}/categories/04-quality-security/qa-expert.md"
            "${inputs.awesome-claude-code-subagents}/categories/04-quality-security/accessibility-tester.md"
          ];
        };
      }
    );
  };
}
