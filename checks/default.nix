# Validates that every concrete repo path referenced in the docs exists.
# Convention (see "Docs Maintenance" in AGENTS.md): real paths in backticks or
# links must exist; illustrative paths use <angle-brackets> and are skipped.
# Fenced code blocks are illustrative-only and exempt.
{
  pkgs,
  self,
}: {
  doc-paths = pkgs.runCommand "doc-paths" {src = self;} ''
    cd "$src"
    errors="$TMPDIR/errors"
    : > "$errors"

    for doc in $(find . -type f -name '*.md' -not -path './dotfiles/*' -not -path './templates/*/*'); do
      docdir=$(dirname "$doc")
      awk '
        /^[[:space:]]*```/ { fence = !fence; next }
        fence { next }
        {
          s = $0
          while (match(s, /`[^`]+`/)) {
            printf "S\t%d\t%s\n", NR, substr(s, RSTART + 1, RLENGTH - 2)
            s = substr(s, RSTART + RLENGTH)
          }
          s = $0
          while (match(s, /\]\([^()]+\)/)) {
            printf "L\t%d\t%s\n", NR, substr(s, RSTART + 2, RLENGTH - 3)
            s = substr(s, RSTART + RLENGTH)
          }
        }
      ' "$doc" | while IFS=$'\t' read -r kind ln tok; do
        tok="''${tok%%#*}"
        [ -z "$tok" ] && continue
        case "$tok" in
          *[[:space:]]*|*'<'*|*'>'*|*:*|*'*'*|*'$'*|'~'*|/*) continue ;;
        esac
        if [ "$kind" = S ]; then
          # backtick spans: repo-root-relative; skip dotted-identifier and
          # bare-filename tokens (no slash) and project-local .dirs
          case "$tok" in .*) continue ;; */*) ;; *) continue ;; esac
          path="$tok"
        else
          # link targets: resolve relative to the containing doc
          path="$docdir/$tok"
        fi
        [ -e "$path" ] || printf '%s:%s: dead path: %s\n' "''${doc#./}" "$ln" "$tok" >> "$errors"
      done
    done

    if [ -s "$errors" ]; then
      echo "Docs reference repo paths that do not exist:" >&2
      sort "$errors" >&2
      echo "Fix the doc (code wins), or write illustrative paths with <angle-brackets>." >&2
      echo "See 'Docs Maintenance' in AGENTS.md." >&2
      exit 1
    fi
    touch "$out"
  '';
}
