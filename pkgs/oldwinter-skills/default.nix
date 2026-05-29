{
  lib,
  stdenvNoCC,
  oldwinter-skills-src,
}:
assert lib.assertMsg (oldwinter-skills-src != null) "oldwinter-skills-src is required.";
  stdenvNoCC.mkDerivation {
    pname = "oldwinter-skills";
    version = "devel";

    src = oldwinter-skills-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out
      cp -r $src/. $out/
    '';

    meta = with lib; {
      description = "Oldwinter's Agent Skills";
      homepage = "https://github.com/oldwinter/skills";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
