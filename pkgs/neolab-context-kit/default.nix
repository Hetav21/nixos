{
  lib,
  stdenvNoCC,
  neolab-context-kit-src,
}:
assert lib.assertMsg (neolab-context-kit-src != null) "neolab-context-kit-src is required.";
  stdenvNoCC.mkDerivation {
    pname = "neolab-context-kit";
    version = "devel";

    src = neolab-context-kit-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out
      cp -r $src/. $out/
    '';

    meta = with lib; {
      description = "Context Engineering Kit from NeoLabHQ";
      homepage = "https://github.com/NeoLabHQ/context-engineering-kit";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
