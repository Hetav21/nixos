{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  pname = "nebula-zen-theme";
  version = "devel";

  src = fetchFromGitHub {
    owner = "JustAdumbPrsn";
    repo = "Zen-Nebula";
    rev = "78f67e443ab59d94f37dd5e44d7fb73da50f1f98";
    sha256 = "sha256-qXqS7LXDelE0qiPkr2irL6mRexrO5UhfuaKuPi/OeJc=";
  };

  installPhase = ''
    mkdir -p $out/
    cp -r $src/Nebula $out/
    cp -r $src/userChrome.css $out/
    cp -r $src/userContent.css $out/
  '';

  meta = {
    description = "Zen-Nebula theme for Zen browser";
    homepage = "https://github.com/JustAdumbPrsn/Zen-Nebula";
    license = "gpl3";
  };
}
