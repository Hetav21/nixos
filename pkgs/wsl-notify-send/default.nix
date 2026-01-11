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
  # notify-send accepts: notify-send [OPTIONS] SUMMARY [BODY]
  # wsl-notify-send only accepts a single positional arg, so we combine summary + body
  notify-send-wrapper = writeShellScriptBin "notify-send" ''
    # Parse arguments - extract options and positional args
    POSITIONAL=()
    while [[ $# -gt 0 ]]; do
      case $1 in
        -u|--urgency|-t|--expire-time|-i|--icon|-c|--category|-h|--hint)
          # Skip these options and their values (wsl-notify-send ignores most)
          shift 2
          ;;
        -*)
          # Skip unknown options
          shift
          ;;
        *)
          POSITIONAL+=("$1")
          shift
          ;;
      esac
    done

    # Combine positional args: first is summary, rest is body
    if [[ ''${#POSITIONAL[@]} -eq 0 ]]; then
      MESSAGE=""
    elif [[ ''${#POSITIONAL[@]} -eq 1 ]]; then
      MESSAGE="''${POSITIONAL[0]}"
    else
      # Combine: "SUMMARY: BODY"
      MESSAGE="''${POSITIONAL[0]}: ''${POSITIONAL[*]:1}"
    fi

    if [[ -z "$MESSAGE" ]]; then
      echo "Usage: notify-send [OPTIONS] SUMMARY [BODY]" >&2
      exit 1
    fi

    exec "${exe}/wsl-notify-send.exe" --appId "$WSL_DISTRO_NAME" --category "$WSL_DISTRO_NAME" "$MESSAGE"
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
