{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.development.misc";
  hasCli = true;
  hasGui = true;
  cliConfig = {
    # --- Nushell Docker Helpers ---
    programs.nushell.extraConfig = ''
      def "docker-clean" [] {
        print "Cleaning Docker..."
        docker container prune -f
        docker image prune -f
        docker network prune -f
        docker volume prune -f
        print "Docker clean complete."
      }
      def "docker-rmi-all" [] {
        print "Removing all Docker images (this may take a while)..."
        let image_ids = (docker images -q)
        if ($image_ids | is-empty) {
          print "No Docker images to remove."
        } else {
          docker rmi $image_ids
        }
        print "All Docker images removed."
      }
    '';

    # --- CLI Packages ---
    home.packages =
      (with pkgs; [
        awscli2
        distrobox
      ])
      ++ (with pkgs.unstable; [
        lazygit
        lazydocker
      ]);
  };

  guiConfig = {
    # --- GUI Packages ---
    home.packages = with pkgs; [
      mongodb-compass
      hoppscotch
      bruno
    ];
  };
}
