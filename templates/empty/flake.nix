{
  description = "An empty flake template that you can adapt to your own environment";

  # --- Flake Inputs ---
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nix-skills.url = "github:Hetav21/nix-skills";
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
  in {
    devShells = forEachSupportedSystem (
      {pkgs}: {
        default = nix-skills.lib.mkProjectEnv {
          inherit pkgs inputs;
          packages = with pkgs; [];
          env = {};
          shellHook = "";
        };
      }
    );
  };
}
