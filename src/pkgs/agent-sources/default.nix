{
  lib,
  stdenvNoCC,
}: let
  mkAgentResource = pname: description: homepage: src:
    assert lib.assertMsg (src != null) "${pname}-src is required.";
      stdenvNoCC.mkDerivation {
        inherit pname;
        version = "devel";
        inherit src;
        dontBuild = true;
        dontConfigure = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r $src/. $out/
          runHook postInstall
        '';
        meta = with lib; {
          inherit description homepage;
          license = licenses.mit;
          platforms = platforms.all;
        };
      };

  sources = {
    anthropic-skills = builtins.fetchTree {
      type = "github";
      owner = "anthropics";
      repo = "skills";
      rev = "690f15cac7f7b4c055c5ab109c79ed9259934081";
      narHash = "sha256-GMXFJSePrpEvhzMQ82YI9Z10BDkuFK/lXUDELclvQ4c=";
    };
    mattpocock-skills = builtins.fetchTree {
      type = "github";
      owner = "mattpocock";
      repo = "skills";
      rev = "9603c1cc8118d08bc1b3bf34cf714f62178dea3b";
      narHash = "sha256-S6pARK99oGGSi6XdFm6zYKHT4gjOCN0wIPZFcl1hREE=";
    };
    emilkowalski-skills = builtins.fetchTree {
      type = "github";
      owner = "emilkowalski";
      repo = "skills";
      rev = "e8a175de22ae1e49370fc144c1f3bb9aeedf988d";
      narHash = "sha256-FG1zm/Vr00QAvpSA6uuVbPJrOjFj2W+F1SAChlJOGMk=";
    };
    agent-config = builtins.fetchTree {
      type = "github";
      owner = "brianlovin";
      repo = "agent-config";
      rev = "1a9819ebf3fee811150fc76cbe177ea4e5f747ff";
      narHash = "sha256-yY6xBsrC/0HPp/6bk0h+sQFE2zqXfcLxuGA18Y+9dd0=";
    };
  };
in {
  anthropic-skills = mkAgentResource "anthropic-skills" "Anthropic Official Skills" "https://github.com/anthropics/skills" sources.anthropic-skills;
  mattpocock-skills = mkAgentResource "mattpocock-skills" "Matt Pocock's agent skills" "https://github.com/mattpocock/skills" sources.mattpocock-skills;
  emilkowalski-skills = mkAgentResource "emilkowalski-skills" "Emil Kowalski's agent skills" "https://github.com/emilkowalski/skills" sources.emilkowalski-skills;
  agent-config = mkAgentResource "agent-config" "Brian Lovin agent configuration resources" "https://github.com/brianlovin/agent-config" sources.agent-config;
}
