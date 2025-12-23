{
  lib,
  stdenvNoCC,
  superpowers-src,
}:
assert lib.assertMsg (superpowers-src != null) "superpowers-src is required. Ensure the superpowers flake input is properly configured.";
  stdenvNoCC.mkDerivation {
    pname = "superpowers";
    version = "devel";

    src = superpowers-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      # Copy entire repo structure to output (no patching needed)
      mkdir -p $out
      cp -r $src/* $out/
      cp -r $src/.opencode $out/ 2>/dev/null || true

      runHook postInstall
    '';

    meta = with lib; {
      description = "Superpowers plugin for OpenCode - skill-based prompts and tools";
      homepage = "https://github.com/obra/superpowers";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [];
    };
  }
