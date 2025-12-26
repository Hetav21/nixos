{
  extraLib,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.locale";
  hasGui = false;
  cliConfig = _: {
    time.timeZone = settings.timeZone;

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

    console.keyMap = settings.consoleKeymap;
  };
})
args
