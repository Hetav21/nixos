{
  lib,
  stdenvNoCC,
  mhattingpete-skills-src,
}:
assert lib.assertMsg (mhattingpete-skills-src != null) "mhattingpete-skills-src is required.";
  stdenvNoCC.mkDerivation {
    pname = "mhattingpete-skills";
    version = "devel";

    src = mhattingpete-skills-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out
      cp -r $src/. $out/
    '';

    meta = with lib; {
      description = "Claude Skills Marketplace by mhattingpete";
      homepage = "https://github.com/mhattingpete/claude-skills-marketplace";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
