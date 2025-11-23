# Common system configuration shared across all hosts
{...}: {
  # Common imports
  imports = [
    ./user.nix
    ../../modules
    ./profiles
    ../../secrets
  ];

  # State version
  system.stateVersion = "24.11";
}
