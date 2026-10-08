{
  description = "Aggregated Claude/OpenCode Resources";

  # --- Source Inputs ---
  inputs = {
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    agent-config = {
      url = "github:brianlovin/agent-config";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    emilkowalski-skills = {
      url = "github:emilkowalski/skills";
      flake = false;
    };
  };

  # --- Flake Outputs ---
  outputs = {self, ...} @ inputs: {
    inherit
      (inputs)
      anthropic-skills
      agent-config
      mattpocock-skills
      emilkowalski-skills
      ;
  };
}
