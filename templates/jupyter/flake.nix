{
  description = "A Nix-flake-based Jupyter development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    # Point this to your NixOS configuration repository
    dotfiles.url = "git+file:///etc/nixos";
  };

  outputs = {
    self,
    nixpkgs,
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
      nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            pkgs = import nixpkgs {inherit system;};
          }
      );
  in {
    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = dotfiles.lib.claude.mkProjectEnv {
          inherit pkgs inputs;

          venvDir = ".venv";
          packages = with pkgs;
            [
              poetry
              python311
            ]
            ++ (with python311Packages; [
              ipykernel
              pip
              venvShellHook
            ]);

          # Example: Custom Claude Agents and Skills
          # agents = [
          #   "https://github.com/Owner/Repo/blob/main/agents/coder.md"
          # ];
          # skills = [
          #   "https://github.com/Owner/Repo/tree/main/skills"
          # ];
        };
      }
    );
  };
}
