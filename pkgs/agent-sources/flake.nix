{
  description = "Aggregated Claude/OpenCode Resources";

  inputs = {
    claude-subagents = {
      url = "github:VoltAgent/awesome-claude-code-subagents";
      flake = false;
    };
    superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };

    agent-config = {
      url = "github:brianlovin/agent-config";
      flake = false;
    };

    oldwinter-skills = {
      url = "github:oldwinter/skills";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs: {
    inherit
      (inputs)
      claude-subagents
      superpowers
      anthropic-skills
      agent-config
      oldwinter-skills
      ;
  };
}
