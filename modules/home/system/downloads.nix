{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.system.downloads";
  hasCli = true;
  hasGui = false;

  cliConfig = {
    # --- Shell Integrations ---
    programs.nushell.extraConfig = ''
      def "dl-yt" [url: string] {
        ${lib.getExe pkgs.yt-dlp} --external-downloader ${lib.getExe pkgs.aria2} --external-downloader-args "-x 16 -s 16 -k 1M" -o $"~/Downloads/%(title)s.%(ext)s" $url
      }
    '';

    # --- Packages ---
    home.packages = [
      pkgs.aria2
      pkgs.yt-dlp
    ];
  };
}
