{
  extraLib,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.locale";
  hasGui = false;
  cliConfig = {
    # --- Timezone ---
    time.timeZone = settings.timeZone;

    # --- Internationalisation ---
    i18n = {
      defaultLocale = settings.locale;
      extraLocaleSettings = {
        LC_ADDRESS = settings.extraLocale;
        LC_IDENTIFICATION = settings.extraLocale;
        LC_MEASUREMENT = settings.extraLocale;
        LC_MONETARY = settings.extraLocale;
        LC_NAME = settings.extraLocale;
        LC_NUMERIC = settings.extraLocale;
        LC_PAPER = settings.extraLocale;
        LC_TELEPHONE = settings.extraLocale;
        LC_TIME = settings.extraLocale;
      };
    };

    # --- Console ---
    console.keyMap = settings.consoleKeymap;
  };
}
