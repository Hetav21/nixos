{pkgs, ...}: let
in {
  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin]; # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
  };

  environment.systemPackages = with pkgs; [
    hplip
  ];
}
