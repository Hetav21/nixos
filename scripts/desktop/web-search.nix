{
  lib,
  pkgs,
}:
# --- Web Search Script ---
pkgs.writeShellScriptBin "web-search" ''
  declare -A URLS

  URLS=(
    ["🌎 Search"]="https://search.brave.com/search?q="
    ["❄️  Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
    ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
    ["🦥 Arch Wiki"]="https://wiki.archlinux.org/title/"
    ["🐃 Gentoo Wiki"]="https://wiki.gentoo.org/index.php?title="
  )

  gen_list() {
    for i in "''${!URLS[@]}"; do
      echo "$i"
    done
  }

  main() {
    platform=$(gen_list | ${lib.getExe pkgs.wofi} -dmenu)

    if [[ -n "$platform" ]]; then
      query=$(echo "" | ${lib.getExe pkgs.wofi} -dmenu)

      if [[ -n "$query" ]]; then
        url="''${URLS[$platform]}$query"
        xdg-open "$url"
      else
        exit 0
      fi
    else
      exit 0
    fi
  }

  main
''
