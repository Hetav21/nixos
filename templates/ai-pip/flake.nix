{
  description = "A Nix-flake-based Python AI development environment (pip)";

  # --- Flake Inputs ---
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nix-skills.url = "github:Hetav21/nix-skills";

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    pypict-claude-skill = {
      url = "github:omkamal/pypict-claude-skill";
      flake = false;
    };
    awesome-claude-code-subagents = {
      url = "github:VoltAgent/awesome-claude-code-subagents";
      flake = false;
    };
  };

  # --- Flake Outputs ---
  outputs = {
    self,
    nix-skills,
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

    # Target Python version (delete .venv/ when changing to trigger environment rebuild)
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
        default = nix-skills.lib.mkProjectEnv {
          inherit pkgs inputs;

          venvDir = ".venv";

          postShellHook = ''
            venvVersionWarn() {
              local venvVersion
              venvVersion="$("$venvDir/bin/python" -c 'import platform; print(platform.python_version())')"

              [[ "$venvVersion" == "${python.version}" ]] && return

              cat <<EOF
            Warning: Python version mismatch: [$venvVersion (venv)] != [${python.version}]
                     Delete '$venvDir' and reload to rebuild for version ${python.version}
            EOF
            }

            venvVersionWarn
          '';

          packages = [
            python.pkgs.venvShellHook
            python.pkgs.pip
            python.pkgs.uv
          ];

          skills = [
            (nix-skills.lib.extract pkgs inputs.anthropic-skills "skills" {
              includes = ["mcp-builder"];
            })
            "${inputs.pypict-claude-skill}"
          ];

          agents = [
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/python-pro.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/ai-engineer.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/llm-architect.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/data-scientist.md"
          ];
        };
      }
    );
  };
}
