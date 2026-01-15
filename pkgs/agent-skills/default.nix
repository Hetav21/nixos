{
  lib,
  stdenvNoCC,
  agent-skills-src,
}:
assert lib.assertMsg (agent-skills-src != null) "agent-skills-src is required.";
  stdenvNoCC.mkDerivation {
    pname = "agent-skills";
    version = "devel";

    src = agent-skills-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out
      # Check if skills directory exists (repo root case)
      if [ -d "$src/skills" ]; then
        cp -r $src/skills/. $out/
      else
        # Fallback: copy everything if no skills dir found
        cp -r $src/. $out/
      fi
    '';

    meta = with lib; {
      description = "Vercel Labs Agent Skills";
      homepage = "https://github.com/vercel-labs/agent-skills";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
