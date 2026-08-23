{
  lib,
  stdenvNoCC,
  mattpocock-skills-src,
}:
assert lib.assertMsg (mattpocock-skills-src != null) "mattpocock-skills-src is required.";
# --- Derivation ---
  stdenvNoCC.mkDerivation {
    pname = "mattpocock-skills";
    version = "devel";

    src = mattpocock-skills-src;

    dontBuild = true;
    dontConfigure = true;

    # --- Installation ---
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r $src/. $out/
      runHook postInstall
    '';

    # --- Metadata ---
    meta = with lib; {
      description = "Matt Pocock's agent skills";
      homepage = "https://github.com/mattpocock/skills";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
