{
  # Centralized nixpkgs configuration used across all channels
  # This config is applied to: nixpkgs, nixpkgs-unstable, nixpkgs-master, nixpkgs-kernel
  allowUnfree = true;
  allowBroken = true;
  permittedInsecurePackages = [
    # Add any insecure packages you absolutely need here
  ];
}
