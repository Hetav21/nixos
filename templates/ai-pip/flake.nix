{
  description = "A Nix-flake-based Python AI development environment (pip)";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    dotfiles.url = "git+file:///etc/nixos";

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    pypict-claude-skill = {
      url = "github:omkamal/pypict-claude-skill";
      flake = false;
    };
    awesome-claude-skills = {
      url = "github:ComposioHQ/awesome-claude-skills";
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

    /*
    * Change this value ({major}.{min}) to
    * update the Python virtual-environment
    * version. When you do this, make sure
    * to delete the `.venv` directory to
    * have the hook rebuild it for the new
    * version, since it won't overwrite an
    * existing one. After this, reload the
    * development shell to rebuild it.
    * You'll see a warning asking you to
    * do this when version mismatches are
    * present. For safety, removal should
    * be a manual step, even if trivial.
    */
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
        default = dotfiles.lib.claude.mkProjectEnv {
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

            /*
            Add whatever else you'd like here.
            */
            # pkgs.basedpyright

            # pkgs.black
            /*
            or
            */
            # python.pkgs.black

            # pkgs.ruff
            /*
            or
            */
            # python.pkgs.ruff
          ];

          skills = [
            (dotfiles.lib.claude.extract pkgs inputs.anthropic-skills "skills" {
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
        };
      }
    );
  };
}
