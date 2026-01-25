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

        # Resolve sources
        resolvedAgentSources = map (extraLib.claude.resolveSource pkgs inputs) cfg.sources.agents;
        resolvedSkillSources = map (extraLib.claude.resolveSource pkgs inputs) cfg.sources.skills;

        # Merge
        finalAgents = cfg.agents ++ resolvedAgentSources;
        finalSkills = cfg.skills ++ resolvedSkillSources;
      in {
        # Call mkEnvironment
        home.file = lib.mkMerge [
          (extraLib.claude.mkEnvironment pkgs {
            agents = finalAgents;
            skills = finalSkills;
            commands = cfg.commands;
            hooks = cfg.hooks;
          })
        ];
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
