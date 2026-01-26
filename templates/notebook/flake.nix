{
  description = "A Nix-flake-based Jupyter Notebook environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    dotfiles.url = "git+file:///etc/nixos";

    awesome-claude-code-subagents = {
      url = "github:VoltAgent/awesome-claude-code-subagents";
      flake = false;
    };
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

          skills = [];

          agents = [
            "${inputs.awesome-claude-code-subagents}/categories/02-language-specialists/python-pro.md"
            "${inputs.awesome-claude-code-subagents}/categories/05-data-ai/data-scientist.md"
          ];
        };
      }
    );
  };
}
