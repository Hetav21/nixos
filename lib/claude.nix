{lib, ...}: rec {
  parseGithubUrl = url: let
    # Regex to match: https://github.com/Owner/Repo/blob/Ref/Path/To/File
    match = builtins.match "https?://github.com/([^/]+)/([^/]+)/(blob|tree)/([^/]+)/(.*)" url;
  in
    if match == null
    then null
    else {
      owner = builtins.elemAt match 0;
      repo = builtins.elemAt match 1;
      type = builtins.elemAt match 2; # blob or tree
      ref = builtins.elemAt match 3;
      path = builtins.elemAt match 4;
    };

  resolveSource = pkgs: inputs: urlStr: let
    parsed = parseGithubUrl urlStr;
  in
    if parsed == null
    then throw "Invalid GitHub URL: ${urlStr}"
    else let
      # Try to find input by Repo name first, then Owner-Repo
      inputName =
        if inputs ? "${parsed.repo}"
        then parsed.repo
        else if inputs ? "${parsed.owner}-${parsed.repo}"
        then "${parsed.owner}-${parsed.repo}"
        else throw "Input not found for ${parsed.owner}/${parsed.repo}. Checked '${parsed.repo}' and '${parsed.owner}-${parsed.repo}'";

      src = inputs.${inputName};
    in
      extract pkgs src parsed.path {};

  # Helper to extract a subdirectory from a package with filtering
  # Usage: extract pkgs source "subdirectory" { includes = ["*"]; excludes = []; }
  extract = pkgs: src: path: {
    includes ? [],
    excludes ? [],
  } @ args: let
    inc =
      if args ? includes
      then args.includes
      else ["*"];
    exc =
      if args ? excludes
      then args.excludes
      else [];
    isSelectMode = inc != [] && inc != ["*"];

    excludeArgs = map (x: "--exclude='${x}'") exc;
    includeArgs = map (x: "--include='${x}' --include='${x}/**'") inc;

    finalArgs =
      excludeArgs
      ++ includeArgs
      ++ (
        if isSelectMode
        then ["--exclude='*'"]
        else []
      );
    argsStr = builtins.concatStringsSep " " finalArgs;
  in
    pkgs.runCommand "extract-${builtins.replaceStrings ["/"] ["-"] path}" {nativeBuildInputs = [pkgs.rsync];} ''
      mkdir -p $out
      if [ -d "${src}/${path}" ]; then
        rsync -av --copy-links ${argsStr} "${src}/${path}/" "$out/"
      elif [ -f "${src}/${path}" ]; then
        cp -a "${src}/${path}" "$out/"
      else
        echo "Warning: ${path} not found in ${src}"
      fi
    '';

  # Flattens a directory of skills based on SKILL.md presence
  # Recursively finds directories containing SKILL.md and moves them to root with flattened names (path/to/skill -> path-to-skill)
  flattenSkills = pkgs: src:
    pkgs.runCommand "flatten-skills" {nativeBuildInputs = [pkgs.rsync];} ''
      mkdir -p $out

      # Find directories containing SKILL.md, excluding hidden directories
      find "${src}" -name "SKILL.md" -not -path '*/.*' -printf "%h\n" | sort -u | while read -r skill_dir; do
        # Calculate relative path
        rel_path="''${skill_dir#${src}}"
        rel_path="''${rel_path#/}" # Remove leading slash

        if [ -z "$rel_path" ]; then
           flat_name="root"
        else
           # Replace / with -
           flat_name="''${rel_path//\//-}"
        fi

        echo "Flattening: $rel_path -> $flat_name"
        mkdir -p "$out/$flat_name"
        rsync -a --copy-links "$skill_dir/" "$out/$flat_name/"
      done
    '';

  # Helper to merge directories with priority (Last item in list = Highest Priority)
  merge = pkgs: name: paths:
    pkgs.runCommand name {nativeBuildInputs = [pkgs.rsync];} ''
      mkdir -p $out
      ${lib.concatMapStringsSep "\n" (p: ''
          rsync -a --chmod=u+w "${p}/" "$out/"
        '')
        paths}
    '';

  # Creates the ~/.claude environment by merging sources
  # Note: You should pass raw sources to 'skills', and this function (via extract/flatten logic in the module)
  # but here we just merge what is given.
  # Wait, the user wants "processing is done by the function".
  # So mkEnvironment should probably CALL flattenSkills for the skills list?
  # But mkEnvironment takes PRE-PROCESSED paths usually.
  # If I change mkEnvironment to auto-flatten skills, it's cleaner for the user.

  # I will update mkEnvironment to apply flattenSkills to each skill input.
  mkEnvironment = pkgs: {
    skills ? [],
    commands ? [],
    agents ? [],
    hooks ? [],
  }: {
    ".claude/skills".source = merge pkgs "claude-skills" (map (s: flattenSkills pkgs s) skills);
    ".claude/commands".source = merge pkgs "claude-commands" commands;
    ".claude/agents".source = merge pkgs "claude-agents" agents;
    ".claude/hooks".source = merge pkgs "claude-hooks" hooks;
  };
}
