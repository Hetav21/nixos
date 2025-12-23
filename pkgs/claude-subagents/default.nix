{
  lib,
  stdenvNoCC,
  claude-subagents-src,
}:
assert lib.assertMsg (claude-subagents-src != null) "claude-subagents-src is required. Ensure the claude-subagents flake input is properly configured.";
  stdenvNoCC.mkDerivation {
    pname = "claude-subagents";
    version = "unstable-2025-12-17";

    src = claude-subagents-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      for category in $src/categories/*/; do
        for agent in "$category"*.md; do
          if [ -f "$agent" ]; then
            basename=$(basename "$agent")
            # Skip README files, only copy actual agent definitions
            if [ "$basename" != "README.md" ]; then
              cp "$agent" "$out/"
            fi
          fi
        done
      done

      runHook postInstall
    '';

    meta = with lib; {
      description = "Production-ready Claude Code subagents collection with 100+ specialized AI agents";
      homepage = "https://github.com/VoltAgent/awesome-claude-code-subagents";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [];
    };
  }
