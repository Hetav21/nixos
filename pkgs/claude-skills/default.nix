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

      for dir in $src/*/; do
        [ -d "$dir" ] || continue
        dirname=$(basename "$dir")

        # Skip hidden directories
        if [[ "$dirname" == "."* ]]; then
          continue
        fi

        if [ -f "$dir/SKILL.md" ]; then
          # Case 1: Top-level skill
          cp -r "$dir" "$out/$dirname"
        else
          # Case 2: Nested skills - flatten path
          # Find all SKILL.md files in subdirectories
          find "$dir" -type f -name "SKILL.md" | while read skill_file; do
             skill_dir=$(dirname "$skill_file")
             rel_path="''${skill_dir#$src/}"
             # Replace slashes with dashes
             flat_name="''${rel_path//\//-}"
             cp -r "$skill_dir" "$out/$flat_name"
          done
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
