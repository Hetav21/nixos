{
  lib,
  fetchzip,
  writeShellScriptBin,
  symlinkJoin,
}: let
  version = "0.1.871612270";

  # --- Source Binary ---
  exe = fetchzip {
    url = "https://github.com/stuartleeks/wsl-notify-send/releases/download/v${version}/wsl-notify-send_windows_amd64.zip";
    sha256 = "1023i80xmkm04jl75l0nzw8zg907kwll9g8280vxdhqj35pwj6rr";
    stripRoot = false;
  };

  # --- Wrappers ---
  # notify-send compatibility wrapper combining SUMMARY and BODY
  notify-send-wrapper = writeShellScriptBin "notify-send" ''
    POSITIONAL=()
    while [[ $# -gt 0 ]]; do
      case $1 in
        -u|--urgency|-t|--expire-time|-i|--icon|-c|--category|-h|--hint)
          shift 2
          ;;
        -*)
          shift
          ;;
        *)
          POSITIONAL+=("$1")
          shift
          ;;
      esac
    done

    if [[ ''${#POSITIONAL[@]} -eq 0 ]]; then
      MESSAGE=""
    elif [[ ''${#POSITIONAL[@]} -eq 1 ]]; then
      MESSAGE="''${POSITIONAL[0]}"
    else
      MESSAGE="''${POSITIONAL[0]}: ''${POSITIONAL[*]:1}"
    fi

    if [[ -z "$MESSAGE" ]]; then
      echo "Usage: notify-send [OPTIONS] SUMMARY [BODY]" >&2
      exit 1
    fi

    exec "${exe}/wsl-notify-send.exe" --appId "$WSL_DISTRO_NAME" --category "$WSL_DISTRO_NAME" "$MESSAGE"
  '';

  # Native wsl-notify-send executable wrapper
  wsl-notify-send = writeShellScriptBin "wsl-notify-send" ''
    exec "${exe}/wsl-notify-send.exe" "$@"
  '';
in
  # --- Package Output ---
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
