{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.shell.newsboat";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    home.shellAliases = {
      nb = "${lib.getExe pkgs.newsboat}";
    };

    programs.newsboat = {
      enable = true;
      autoFetchArticles = {
        enable = true;
      };
      urls = [
        {
          url = "https://blog.hetav.dev/rss";
          title = "Hetav's Blog";
          tags = [
            "personal"
            "tech"
          ];
        }
        {
          url = "https://news.ycombinator.com/rss";
          title = "Hacker News";
          tags = [
            "tech"
          ];
        }
        {
          url = "https://tdd.cat/rss.xml";
          title = "The Daily Diff";
          tags = [
            "tech"
          ];
        }
      ];
      extraConfig = ''
        bind-key j down
        bind-key k up
        bind-key j next articlelist
        bind-key k prev articlelist
        bind-key J next-feed feedlist
        bind-key K prev-feed feedlist
        bind-key o open
        bind-key q quit

        # UI configuration (Explicitly Mapped for Base16 / Rosé Pine)
        color background          color7    color0
        color listnormal          color7    color0
        color listnormal_unread   color6    color0  bold
        color listfocus           color7    color11
        color listfocus_unread    color6    color11 bold
        color info                color0    color5
        color title               color6    color0  bold
        color article             color7    color0

        # Other settings
        max-items 100
        show-read-feeds yes
      '';
    };
  };
})
args
