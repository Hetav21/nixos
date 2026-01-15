{
  description = "Aggregated Claude/OpenCode Resources";

  inputs = {
    claude-subagents = {
      url = "github:VoltAgent/awesome-claude-code-subagents";
      flake = false;
    };
    claude-skills = {
      url = "github:ComposioHQ/awesome-claude-skills";
      flake = false;
    };
    superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };
    agent-skills = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs: {
    inherit (inputs) claude-subagents claude-skills superpowers agent-skills;
  };
}
