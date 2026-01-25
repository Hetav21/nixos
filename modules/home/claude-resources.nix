{
  extraLib,
  lib,
  pkgs,
  config,
  inputs,
  ...
} @ args: let
  name = "programs.claude-resources";
  module =
    (extraLib.modules.mkModule {
      inherit name;
      hasCli = true;

      cliConfig = {
        config,
        inputs,
        ...
      }: let
        cfg = config.programs.claude-resources;

        assets = extraLib.claude.buildAssets {
          inherit pkgs;
          agents = cfg.agents ++ (map (extraLib.claude.resolveSource pkgs inputs) cfg.sources.agents);
          skills = cfg.skills ++ (map (extraLib.claude.resolveSource pkgs inputs) cfg.sources.skills);
          commands = cfg.commands;
          hooks = cfg.hooks;
        };
      in {
        home.file = {
          ".claude/skills".source = "${assets}/skills";
          ".claude/agents".source = "${assets}/agents";
          ".claude/commands".source = "${assets}/commands";
          ".claude/hooks".source = "${assets}/hooks";
        };
      };
    })
    args;
in {
  inherit (module) config;

  options = lib.recursiveUpdate module.options {
    programs.claude-resources = {
      agents = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "List of agent packages to install.";
      };
      skills = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "List of skill packages to install.";
      };
      commands = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "List of command packages to install.";
      };
      hooks = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "List of hook packages to install.";
      };
      sources = {
        agents = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of GitHub URLs to resolve as agent sources.";
        };
        skills = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of GitHub URLs to resolve as skill sources.";
        };
      };
    };
  };
}
