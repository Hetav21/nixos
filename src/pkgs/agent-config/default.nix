{
  lib,
  stdenvNoCC,
  agent-config-src,
}:
assert lib.assertMsg (agent-config-src != null) "agent-config-src is required.";
# --- Derivation ---
stdenvNoCC.mkDerivation {
  pname = "agent-config";
  version = "devel";

  src = agent-config-src;

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
    description = "Brian Lovin agent configuration resources";
    homepage = "https://github.com/brianlovin/agent-config";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
