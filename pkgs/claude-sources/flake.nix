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
    neolab-context-kit = {
      url = "github:NeoLabHQ/context-engineering-kit";
      flake = false;
    };
    mhattingpete-skills = {
      url = "github:mhattingpete/claude-skills-marketplace";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    agent-skills = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs: {
    inherit (inputs) claude-subagents superpowers agent-skills anthropic-skills neolab-context-kit mhattingpete-skills;
  };
}
