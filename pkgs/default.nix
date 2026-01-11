{
  pkgs,
  inputs ? {},
  ...
}: {
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix {};
  browseros = pkgs.callPackage ./browseros/package.nix {};
  claude-subagents = pkgs.callPackage ./claude-subagents {
    claude-subagents-src = inputs.claude-subagents or null;
  };
  superpowers = pkgs.callPackage ./superpowers {
    superpowers-src = inputs.superpowers or null;
  };
  claude-skills = pkgs.callPackage ./claude-skills {
    claude-skills-src = inputs.claude-skills or null;
  };
  wsl-notify-send = pkgs.callPackage ./wsl-notify-send {};
}
