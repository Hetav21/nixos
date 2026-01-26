{
  description = "A Nix-flake-based Node.js development environment with Playwright";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    dotfiles.url = "git+file:///etc/nixos";

    agent-skills = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    awesome-claude-skills = {
      url = "github:ComposioHQ/awesome-claude-skills";
      flake = false;
    };
    claude-d3js-skill = {
      url = "github:chrisvoncsefalvay/claude-d3js-skill";
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
            playwright-driver.browsers
          ];

          env = {
            PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
            PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
            PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
            PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
          };

          shellHook = ''
            echo "📦 Node.js + 🎭 Playwright dev environment"
            echo "  - Browsers: $PLAYWRIGHT_BROWSERS_PATH"
            echo "  - Nixpkgs version: ${pkgs.playwright-driver.version}"
            echo ""
            echo "Run: pnpm install && pnpm test"
          '';

          skills = [
            (dotfiles.lib.claude.extract pkgs inputs.agent-skills "." {
              includes = [
                "claude.ai-vercel-deploy-claimable"
                "react-best-practices"
                "web-design-guidelines"
              ];
            })
            (dotfiles.lib.claude.extract pkgs inputs.anthropic-skills "skills" {
              includes = [
                "frontend-design"
                "theme-factory"
                "webapp-testing"
              ];
            })
            "${inputs.anthropic-skills}/skills/web-artifacts-builder"
            "${inputs.awesome-claude-skills}/theme-factory"
            "${inputs.awesome-claude-skills}/canvas-design"
            "${inputs.claude-d3js-skill}"
          ];

          agents = [
            "${inputs.awesome-claude-code-subagents}/categories/01-core-development/frontend-developer.md"
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/react-specialist.md"
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/nextjs-developer.md"
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/typescript-pro.md"
            "${inputs.awesome-claude-code-subagents}/categories/04-quality-security/test-automator.md"
          ];
        };
      }
    );
  };
}
