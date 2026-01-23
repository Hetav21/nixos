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
    claude-subagents-src = inputs.claude-sources.claude-subagents or null;
  };
  superpowers = pkgs.callPackage ./superpowers {
    superpowers-src = inputs.claude-sources.superpowers or null;
  };
  anthropic-skills = pkgs.callPackage ./anthropic-skills {
    anthropic-skills-src = inputs.claude-sources.anthropic-skills or null;
  };
  neolab-context-kit = pkgs.callPackage ./neolab-context-kit {
    neolab-context-kit-src = inputs.claude-sources.neolab-context-kit or null;
  };
  mhattingpete-skills = pkgs.callPackage ./mhattingpete-skills {
    mhattingpete-skills-src = inputs.claude-sources.mhattingpete-skills or null;
  };
  agent-skills = pkgs.callPackage ./agent-skills {
    agent-skills-src = inputs.claude-sources.agent-skills or null;
  };
  wsl-notify-send = pkgs.callPackage ./wsl-notify-send {};
}
