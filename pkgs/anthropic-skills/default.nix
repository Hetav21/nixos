{
  lib,
  stdenvNoCC,
  anthropic-skills-src,
}:
assert lib.assertMsg (anthropic-skills-src != null) "anthropic-skills-src is required.";
# --- Derivation ---
  stdenvNoCC.mkDerivation {
    pname = "anthropic-skills";
    version = "devel";

    src = anthropic-skills-src;

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
      description = "Anthropic Official Skills";
      homepage = "https://github.com/anthropics/skills";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
