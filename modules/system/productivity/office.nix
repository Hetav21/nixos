{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.productivity.office";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services.flatpak.packages = [
      "org.libreoffice.LibreOffice"
      "org.onlyoffice.desktopeditors"
    ];
  };
})
args
