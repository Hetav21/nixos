{
  lib,
  stdenvNoCC,
  claude-subagents-src,
}:
assert lib.assertMsg (claude-subagents-src != null) "claude-subagents-src is required.";
# --- Derivation ---
  stdenvNoCC.mkDerivation {
    pname = "subagent-catalog";
    version = "unstable";

    src = claude-subagents-src;

    dontBuild = true;
    dontConfigure = true;

    # --- Installation ---
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r tools/subagent-catalog $out/
      runHook postInstall
    '';

    # --- Metadata ---
    meta = with lib; {
      description = "Subagent Catalog tool from awesome-claude-code-subagents";
      homepage = "https://github.com/VoltAgent/awesome-claude-code-subagents";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
