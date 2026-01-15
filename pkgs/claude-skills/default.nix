{
  lib,
  stdenvNoCC,
  claude-skills-src,
}:
assert lib.assertMsg (claude-skills-src != null) "claude-skills-src is required. Ensure the claude-skills flake input is properly configured.";
  stdenvNoCC.mkDerivation {
    pname = "claude-skills";
    version = "unstable-2025-01-11";

    src = claude-skills-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out
      # Copy raw source to output. Flattening is handled by lib.claude.flattenSkills
      cp -r $src/* $out/
    '';

    meta = with lib; {
      description = "A curated list of awesome Claude Skills for customizing Claude AI workflows";
      homepage = "https://github.com/ComposioHQ/awesome-claude-skills";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [];
    };
  }
