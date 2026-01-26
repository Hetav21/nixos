{
  description = "A Nix-flake-based Python AI development environment (uv)";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  # Point this to your NixOS configuration repository
  inputs.dotfiles.url = "git+file:///etc/nixos";

  inputs.anthropic-skills.url = "github:anthropics/skills";
  inputs.anthropic-skills.flake = false;

  inputs.pypict-claude-skill.url = "github:omkamal/pypict-claude-skill";
  inputs.pypict-claude-skill.flake = false;

  inputs.awesome-claude-skills.url = "github:ComposioHQ/awesome-claude-skills";
  inputs.awesome-claude-skills.flake = false;

  inputs.awesome-claude-code-subagents.url = "github:VoltAgent/awesome-claude-code-subagents";
  inputs.awesome-claude-code-subagents.flake = false;

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
        default = inputs.dotfiles.lib.claude.mkProjectEnv {
          inherit pkgs inputs;

          packages = [
            pkgs.uv
            python
            pkgs.nodejs
          ];

          skills = [
            (inputs.dotfiles.lib.claude.extract pkgs inputs.anthropic-skills "skills" {
              includes = ["mcp-builder"];
            })
            "${inputs.pypict-claude-skill}"
            "${inputs.awesome-claude-skills}/webapp-testing"
          ];

          agents = [
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/python-pro.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/ai-engineer.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/llm-architect.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/data-scientist.md"
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
