# --- NixOS Module Aggregator ---
{...}: {
  imports = [
    ./drivers
    ./system
  ];
}
