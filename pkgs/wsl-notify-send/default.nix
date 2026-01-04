{
  lib,
  stdenvNoCC,
  fetchzip,
  writeShellScriptBin,
  symlinkJoin,
}: let
  version = "0.1.871612270";

  exe = fetchzip {
    url = "https://github.com/stuartleeks/wsl-notify-send/releases/download/v${version}/wsl-notify-send_windows_amd64.zip";
    sha256 = "1023i80xmkm04jl75l0nzw8zg907kwll9g8280vxdhqj35pwj6rr";
    stripRoot = false;
  };

  # Wrapper that mimics libnotify's notify-send interface
  notify-send-wrapper = writeShellScriptBin "notify-send" ''
    # Parse arguments to extract summary and body
    # wsl-notify-send.exe expects: wsl-notify-send.exe [options] <summary> [body]
    exec "${exe}/wsl-notify-send.exe" --category "$0" "$@"
  '';

  # Direct access to wsl-notify-send
  wsl-notify-send = writeShellScriptBin "wsl-notify-send" ''
    exec "${exe}/wsl-notify-send.exe" "$@"
  '';
in
  symlinkJoin {
    name = "wsl-notify-send-${version}";
    paths = [
      notify-send-wrapper
      wsl-notify-send
    ];

    meta = with lib; {
      description = "Send Windows 10 toast notifications from WSL";
      homepage = "https://github.com/stuartleeks/wsl-notify-send";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "notify-send";
    };
  }
