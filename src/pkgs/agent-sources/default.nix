{
  lib,
  stdenvNoCC,
  fetchurl,
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
    agent-browser = builtins.fetchTree {
      type = "github";
      owner = "vercel-labs";
      repo = "agent-browser";
      rev = "4b0e9f01fa8d214d39bbfe5391257640634fb9a0";
      narHash = "sha256-V0KcdCGAdtYQqFnZYv4DfN1PEj5cAYaoSHaw9HxJJ+8=";
    };
    vercel-skills = builtins.fetchTree {
      type = "github";
      owner = "vercel-labs";
      repo = "skills";
      rev = "d3701c11b1101251af14c9d148f026e1a47ebe17";
      narHash = "sha256-TDLIerf2DHWDuFfWnzBp5fEEQj3B9jtW4IIrpRXwoHg=";
    };
  };

  reclaudeSkill = fetchurl {
    url = "https://raw.githubusercontent.com/aiskillstore/marketplace/69951b8d76e9aeec481408ec1bec21026fa0209b/skills/brianlovin/reclaude/SKILL.md";
    sha256 = "0lvxiyw2n63ym8vrlskrw55wbkn91rni6yy01ixj969x23sr0vjv";
  };
in {
  anthropic-skills = mkAgentResource "anthropic-skills" "Anthropic Official Skills" "https://github.com/anthropics/skills" sources.anthropic-skills;
  mattpocock-skills = mkAgentResource "mattpocock-skills" "Matt Pocock's agent skills" "https://github.com/mattpocock/skills" sources.mattpocock-skills;
  emilkowalski-skills = mkAgentResource "emilkowalski-skills" "Emil Kowalski's agent skills" "https://github.com/emilkowalski/skills" sources.emilkowalski-skills;
  agent-browser = mkAgentResource "agent-browser" "Vercel Labs Agent Browser" "https://github.com/vercel-labs/agent-browser" sources.agent-browser;
  vercel-skills = mkAgentResource "vercel-skills" "Vercel Labs Agent Skills" "https://github.com/vercel-labs/skills" sources.vercel-skills;
  reclaude = stdenvNoCC.mkDerivation {
    pname = "reclaude";
    version = "devel";
    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp ${reclaudeSkill} $out/SKILL.md
      runHook postInstall
    '';
    meta = with lib; {
      description = "Refactor CLAUDE.md files following progressive disclosure";
      homepage = "https://github.com/aiskillstore/marketplace/tree/main/skills/brianlovin/reclaude";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}
