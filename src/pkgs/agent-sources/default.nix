{
  lib,
  stdenvNoCC,
  inputs,
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
in {
  anthropic-skills = mkAgentResource "anthropic-skills" "Anthropic Official Skills" "https://github.com/anthropics/skills" (inputs.agent-sources.anthropic-skills or null);
  mattpocock-skills = mkAgentResource "mattpocock-skills" "Matt Pocock's agent skills" "https://github.com/mattpocock/skills" (inputs.agent-sources.mattpocock-skills or null);
  emilkowalski-skills = mkAgentResource "emilkowalski-skills" "Emil Kowalski's agent skills" "https://github.com/emilkowalski/skills" (inputs.agent-sources.emilkowalski-skills or null);
  agent-config = mkAgentResource "agent-config" "Brian Lovin agent configuration resources" "https://github.com/brianlovin/agent-config" (inputs.agent-sources.agent-config or null);
}
