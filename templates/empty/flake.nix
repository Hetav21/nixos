{
  description = "An empty flake template that you can adapt to your own environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    # Point this to your NixOS configuration repository
    dotfiles.url = "git+file:///etc/nixos";
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

          # The Nix packages provided in the environment
          # Add any you need here
          packages = with pkgs; [];

          # Set any environment variables for your dev shell
          env = {};

          # Add any shell logic you want executed any time the environment is activated
          shellHook = ''
          '';

          # Example: Custom Claude Agents and Skills
          # agents = [ "https://github.com/org/repo/blob/main/agent.md" ];
          # skills = [ "https://github.com/org/repo/tree/main/skills" ];
        };
      }
    );
  };
}
