{
  pkgs,
  inputs ? {},
  ...
}: {
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix {};
  browseros = pkgs.callPackage ./browseros/package.nix {};
  subagent-catalog = pkgs.callPackage ./subagent-catalog {
    claude-subagents-src = inputs.agent-sources.claude-subagents or null;
  };
  superpowers = pkgs.callPackage ./superpowers {
    superpowers-src = inputs.agent-sources.superpowers or null;
  };
  anthropic-skills = pkgs.callPackage ./anthropic-skills {
    anthropic-skills-src = inputs.agent-sources.anthropic-skills or null;
  };

  agent-config = let
    agent-config-src = inputs.agent-sources.agent-config or null;
  in
    assert pkgs.lib.assertMsg (agent-config-src != null) "agent-config-src is required.";
      pkgs.stdenvNoCC.mkDerivation {
        pname = "agent-config";
        version = "devel";

        src = agent-config-src;

        dontBuild = true;
        dontConfigure = true;

        installPhase = ''
          mkdir -p $out
          cp -r $src/. $out/
        '';

        meta = with pkgs.lib; {
          description = "Brian Lovin agent configuration resources";
          homepage = "https://github.com/brianlovin/agent-config";
          license = licenses.mit;
          platforms = platforms.all;
        };
      };
  wsl-notify-send = pkgs.callPackage ./wsl-notify-send {};
  mattpocock-skills = pkgs.callPackage ./mattpocock-skills {
    mattpocock-skills-src = inputs.agent-sources.mattpocock-skills or null;
  };
}
