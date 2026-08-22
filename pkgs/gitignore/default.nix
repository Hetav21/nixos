{pkgs}: let
  pkg = pkgs.writeShellApplication {
    name = "gitignore";
    runtimeInputs = with pkgs; [
      curl
      jq
      gnused
      gnugrep
      coreutils
      fzf
    ];
    text = ''
            CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/gitignore-cli"
            TREE_CACHE="$CACHE_DIR/tree.json"
            TEMPLATES_DIR="$CACHE_DIR/templates"
            REPO_API="https://api.github.com/repos/github/gitignore/git/trees/main?recursive=1"
            RAW_BASE="https://raw.githubusercontent.com/github/gitignore/main"

            mkdir -p "$TEMPLATES_DIR"

            fetch_tree_if_needed() {
              local force="''${1:-0}"
              local now
              now=$(date +%s)
              local fetch=0

              if [[ "$force" -eq 1 ]] || [[ ! -f "$TREE_CACHE" ]]; then
                fetch=1
              else
                local mtime
                mtime=$(stat -c %Y "$TREE_CACHE" 2>/dev/null || echo 0)
                local age=$((now - mtime))
                if [[ "$age" -gt 86400 ]]; then
                  fetch=1
                fi
              fi

              if [[ "$fetch" -eq 1 ]]; then
                echo "Fetching gitignore templates list from GitHub..." >&2
                local tmp
                tmp=$(mktemp)
                # shellcheck disable=SC2064
                trap "rm -f '$tmp'" EXIT

                if curl -sSfL -H "User-Agent: gitignore-cli" "$REPO_API" -o "$tmp"; then
                  if jq -e '.tree' "$tmp" >/dev/null 2>&1; then
                    mv "$tmp" "$TREE_CACHE"
                  else
                    echo "Error: Invalid response from GitHub API." >&2
                    return 1
                  fi
                else
                  if [[ ! -f "$TREE_CACHE" ]]; then
                    echo "Error: Failed to fetch templates list and no cache exists." >&2
                    return 1
                  else
                    echo "Warning: Failed to refresh templates list. Using cached version." >&2
                  fi
                fi
              fi
            }

            list_templates() {
              fetch_tree_if_needed || return 1
              jq -r '.tree[] | select(.type=="blob" and (.path | endswith(".gitignore"))) | .path' "$TREE_CACHE" \
                | sed 's/\.gitignore$//'
            }

            cmd_search() {
              local query="''${1:-}"
              local templates
              templates=$(list_templates) || exit 1

              if [[ -z "$query" ]]; then
                if [[ -t 0 ]]; then
                  local selected
                  selected=$(echo "$templates" | fzf --prompt="Select gitignore template: ")
                  if [[ -n "$selected" ]]; then
                    cmd_copy "$selected"
                  fi
                  exit 0
                else
                  echo "$templates"
                  exit 0
                fi
              fi

              local matches
              matches=$(echo "$templates" | grep -i "$query" || true)
              if [[ -z "$matches" ]]; then
                echo "No gitignore templates found matching '$query'."
                exit 1
              fi
              echo "Matching gitignore templates:"
              echo "$matches"
            }

            cmd_copy() {
              local name="''${1:-}"
              if [[ -z "$name" ]]; then
                echo "Error: Template name required. Usage: gi copy <name>" >&2
                exit 1
              fi

              # Strip .gitignore extension if supplied
              name="''${name%.gitignore}"

              local templates
              templates=$(list_templates) || exit 1

              # Match exact or case-insensitive exact match
              local matched_path
              matched_path=$(echo "$templates" | grep -iFx "$name" | head -n 1 || true)

              if [[ -z "$matched_path" ]]; then
                # Try substring match
                matched_path=$(echo "$templates" | grep -iF "$name" | head -n 1 || true)
              fi

              if [[ -z "$matched_path" ]]; then
                echo "Error: Template '$name' not found." >&2
                echo "Run 'gi search $name' to search available templates." >&2
                exit 1
              fi

              local rel_file="''${matched_path}.gitignore"
              local cache_file="$TEMPLATES_DIR/$rel_file"
              mkdir -p "$(dirname "$cache_file")"

              if [[ ! -f "$cache_file" ]]; then
                local raw_url="$RAW_BASE/$rel_file"
                echo "Downloading $matched_path gitignore template..."
                if ! curl -sSfL -H "User-Agent: gitignore-cli" "$raw_url" -o "$cache_file"; then
                  echo "Error: Failed to download template from $raw_url." >&2
                  rm -f "$cache_file"
                  exit 1
                fi
              fi

              local target="$PWD/.gitignore"
              if [[ -f "$target" ]]; then
                {
                  echo ""
                  echo "# --- Appended $matched_path.gitignore ---"
                  cat "$cache_file"
                } >> "$target"
                echo "[SUCCESS] Appended $matched_path gitignore template to .gitignore"
              else
                cat "$cache_file" > "$target"
                echo "[SUCCESS] Created .gitignore with $matched_path gitignore template"
              fi
            }

            cmd_list() {
              list_templates || exit 1
            }

            show_help() {
              cat <<'EOF'
        gi - CLI tool to search and copy .gitignore templates from github/gitignore

        Usage:
          gi search [query]       Search templates (interactive fzf if no query provided)
          gi copy <template>      Copy template to .gitignore in current directory
          gi list                 List all available gitignore templates
          gi help                 Show this help message

        Examples:
          gi search python
          gi copy Python
          gi copy Global/VisualStudioCode
      EOF
            }

            main() {
              local subcommand="''${1:-help}"
              case "$subcommand" in
                search)
                  shift
                  cmd_search "''${1:-}"
                  ;;
                copy)
                  shift
                  cmd_copy "''${1:-}"
                  ;;
                list)
                  cmd_list
                  ;;
                help|--help|-h)
                  show_help
                  ;;
                *)
                  echo "Error: Unknown command '$subcommand'" >&2
                  show_help
                  exit 1
                  ;;
              esac
            }

            main "$@"
    '';
  };
in
  pkgs.symlinkJoin {
    name = "gitignore";
    paths = [pkg];
    postBuild = ''
      ln -s "$out/bin/gitignore" "$out/bin/gi"
    '';
    meta.mainProgram = "gi";
  }
