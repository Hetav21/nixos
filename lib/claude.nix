{lib, ...}: {
  # Helper to extract a subdirectory from a package
  # Usage: extract pkgs source "subdirectory"
  extract = pkgs: src: path:
    pkgs.runCommand "extract-${path}" {} ''
      mkdir -p $out
      if [ -d "${src}/${path}" ]; then
        cp -r "${src}/${path}/." $out/
      else
        echo "Warning: ${path} not found in ${src}"
      fi
    '';

  # Creates the ~/.claude environment by merging sources
  # Usage: mkEnvironment pkgs { skills = [...]; commands = [...]; agents = [...]; hooks = [...]; }
  mkEnvironment = pkgs: {
    skills ? [],
    commands ? [],
    agents ? [],
    hooks ? [],
  }: {
    ".claude/skills".source = pkgs.symlinkJoin {
      name = "claude-skills";
      paths = skills;
    };
    ".claude/commands".source = pkgs.symlinkJoin {
      name = "claude-commands";
      paths = commands;
    };
    ".claude/agents".source = pkgs.symlinkJoin {
      name = "claude-agents";
      paths = agents;
    };
    ".claude/hooks".source = pkgs.symlinkJoin {
      name = "claude-hooks";
      paths = hooks;
    };
  };
}
