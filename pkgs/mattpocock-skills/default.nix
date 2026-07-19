{
  lib,
  stdenvNoCC,
  mattpocock-skills-src,
}:
assert lib.assertMsg (mattpocock-skills-src != null) "mattpocock-skills-src is required.";
  stdenvNoCC.mkDerivation {
    pname = "mattpocock-skills";
    version = "devel";

    src = mattpocock-skills-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out
      cp -r $src/. $out/
    '';

    meta = with lib; {
      description = "Matt Pocock's agent skills";
      homepage = "https://github.com/mattpocock/skills";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
