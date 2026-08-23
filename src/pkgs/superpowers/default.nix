{
  lib,
  stdenvNoCC,
  superpowers-src,
}:
assert lib.assertMsg (superpowers-src != null) "superpowers-src is required. Ensure the superpowers flake input is properly configured.";
# --- Derivation ---
  stdenvNoCC.mkDerivation {
    pname = "superpowers";
    version = "devel";

    src = superpowers-src;

    dontBuild = true;
    dontConfigure = true;

    # --- Installation ---
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r $src/* $out/
      cp -r $src/.opencode $out/ 2>/dev/null || true

      runHook postInstall
    '';

    # --- Metadata ---
    meta = with lib; {
      description = "Superpowers plugin for OpenCode - skill-based prompts and tools";
      homepage = "https://github.com/obra/superpowers";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
