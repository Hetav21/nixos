{
  lib,
  stdenvNoCC,
  emilkowalski-skills-src,
}:
assert lib.assertMsg (emilkowalski-skills-src != null) "emilkowalski-skills-src is required.";
# --- Derivation ---
  stdenvNoCC.mkDerivation {
    pname = "emilkowalski-skills";
    version = "devel";

    src = emilkowalski-skills-src;

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
      description = "Emil Kowalski's agent skills";
      homepage = "https://github.com/emilkowalski/skills";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
