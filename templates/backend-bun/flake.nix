{
  description = "A Nix-flake-based Bun backend development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    dotfiles.url = "git+file:///etc/nixos";

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    awesome-claude-skills = {
      url = "github:ComposioHQ/awesome-claude-skills";
      flake = false;
    };
    ai-skills = {
      url = "github:sanjay3290/ai-skills";
      flake = false;
    };
    aws-skills = {
      url = "github:zxkane/aws-skills";
      flake = false;
    };
    n8n-skills = {
      url = "github:haunchen/n8n-skills";
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
          packages = with pkgs; [bun];

          skills = [
            (dotfiles.lib.claude.extract pkgs inputs.anthropic-skills "skills" {
              includes = ["mcp-builder"];
            })
            "${inputs.awesome-claude-skills}/mcp-builder"
            "${inputs.ai-skills}/skills/postgres"
            "${inputs.aws-skills}"
            "${inputs.n8n-skills}"
          ];

          agents = [
            "${inputs.awesome-claude-code-subagents}/categories/01-core-development/backend-developer.md"
            "${inputs.awesome-claude-code-subagents}/categories/01-core-development/api-designer.md"
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/typescript-pro.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/postgres-pro.md"
          ];
        };
      }
    );
  };
}
