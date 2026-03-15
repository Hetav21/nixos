{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  playwright-driver,
}: let
  pname = "agent-browser";
  version = "0.0.1-unstable-2026-03-15";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "1fd8e9d09a3fe434d5edca4415a12af7712ed85a";
    sha256 = "sha256-dL9mGtpWfgkrEjOE9FGY/HODli0r+Mk6gn88w85yRvI=";
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/cli";
    cargoHash = "sha256-ko/S5Sez2z6GPQePpbzndEYKJk7A+02BjBCv76ZL+zY=";

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    doCheck = false;

    postInstall = ''
      wrapProgram $out/bin/agent-browser \
        --set PLAYWRIGHT_BROWSERS_PATH "${playwright-driver.browsers}" \
        --set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD "1" \
        --prefix PATH : "${lib.makeBinPath [playwright-driver]}"
    '';

    meta = with lib; {
      description = "Agent Browser - Browser automation agent";
      homepage = "https://github.com/vercel-labs/agent-browser";
      license = licenses.mit;
      mainProgram = "agent-browser";
      maintainers = [];
    };
  }
