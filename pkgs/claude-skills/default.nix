{
  lib,
  stdenvNoCC,
  claude-skills-src,
}:
assert lib.assertMsg (claude-skills-src != null) "claude-skills-src is required. Ensure the claude-skills flake input is properly configured.";
  stdenvNoCC.mkDerivation {
    pname = "claude-skills";
    version = "unstable-2025-01-11";

    src = claude-skills-src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out

      # Copy each skill directory (each contains a SKILL.md file)
      for skill_dir in $src/*/; do
        skill_name=$(basename "$skill_dir")
        # Skip hidden directories, documentation, and non-skill directories
        if [[ "$skill_name" != "."* ]] && \
           [[ -f "$skill_dir/SKILL.md" || -d "$skill_dir" ]]; then
          # Check if it's a skill directory (has SKILL.md or is a known skill folder)
          if [ -f "$skill_dir/SKILL.md" ]; then
            cp -r "$skill_dir" "$out/$skill_name"
          fi
        fi
      done

      runHook postInstall
    '';

    meta = with lib; {
      description = "A curated list of awesome Claude Skills for customizing Claude AI workflows";
      homepage = "https://github.com/ComposioHQ/awesome-claude-skills";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [];
    };
  }
