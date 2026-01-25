{
  description = "A Nix-flake-based Claude Project Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # In your own project, point this to your NixOS configuration repository:
    # dotfiles.url = "github:Hetav21/nixos";
    # For local testing of this template within the repo:
    dotfiles.url = "git+file:///etc/nixos";
  };

  outputs = {
    self,
    nixpkgs,
    dotfiles,
    ...
  } @ inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = dotfiles.lib.claude.mkProjectEnv {
        inherit pkgs inputs;

        # Define your project-specific Claude resources here.
        # These will be automatically linked into your .claude/ directory.

        agents = [
          # Example: Raw GitHub URLs are automatically resolved
          # "https://github.com/Hetav21/superpowers/blob/main/agents/coder.md"
        ];

        skills = [
          # Example: Local skills directory
          # ./skills

          # Example: Remote skills via flake input
          # inputs.superpowers
        ];

        commands = [
          # ./commands
        ];
      };
    });
  };
}
