#!/usr/bin/env zsh
# Claude Code status line: project / branch · model (used tokens) · rate limits.
# Colours follow the active Ghostty theme.
# Reads Claude Code's status JSON on stdin.
#
# Usage: statusline.sh [label]
# Optional label distinguishes profiles; omit it for a single setup.

label="${1:-default}"
input=$(cat)

# --- palette: read off the active ghostty theme ------------------------------
# Roles map onto ANSI slots, so the line recolours itself when the terminal
# theme — or the desktop's light/dark preference — changes. Falls back to the
# Modus Operandi Tinted values if ghostty's config or theme file isn't readable.
ghostty_theme_file() {
  local cfg=$HOME/.config/ghostty/config line mode name
  [ -r "$cfg" ] || return 1
  line=$(sed -n 's/^[[:space:]]*theme[[:space:]]*=[[:space:]]*//p' "$cfg" | tail -1)
  [ -n "$line" ] || return 1
  if [ "${line#*:}" != "$line" ]; then          # `dark:A,light:B`
    case $({ gsettings get org.gnome.desktop.interface color-scheme || defaults read -g AppleInterfaceStyle; } 2>/dev/null) in
      *prefer-dark*|Dark) mode=dark ;;
      *) mode=light ;;
    esac
    name=$(printf '%s' "$line" | tr ',' '\n' | sed -n "s/^[[:space:]]*$mode://p" | head -1)
  else
    name=$line
  fi
  [ -n "$name" ] || return 1
  printf '%s/themes/%s' "${GHOSTTY_RESOURCES_DIR:-/usr/share/ghostty}" "$name"
}

ROSE='38;2;89;89;89'      # separators, brackets, chrome
TRACK='38;2;166;166;166'  # empty bar cells
OK='38;2;0;102;63'        # healthy remaining
WARN='38;2;136;73;0'      # getting low
HOT='38;2;166;0;0'        # nearly out
PURPLE='38;2;83;26;182'   # branch marker

tf=$(ghostty_theme_file) && [ -r "$tf" ] && eval "$(awk -F' *= *' '
  # POSIX awk only: macOS awk has no strtonum or match() capture groups
  function hex(s,  i, n) { s = tolower(s); for (i = 1; i <= length(s); i++) n = n*16 + index("0123456789abcdef", substr(s,i,1)) - 1; return n }
  function sgr(h) { return sprintf("38;2;%d;%d;%d",
      hex(substr(h,2,2)), hex(substr(h,4,2)), hex(substr(h,6,2))) }
  function lum(h) { return 0.2126*hex(substr(h,2,2)) \
                         + 0.7152*hex(substr(h,4,2)) \
                         + 0.0722*hex(substr(h,6,2)) }
  /^ *palette *=/ { if ($3 ~ /^#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]/) p[$2+0] = $3 }
  $1 == "foreground" { fg = $2 }
  $1 == "background" { bg = $2 }
  END {
    if (!fg || !bg) exit
    # chrome is whichever grey stands further off the background; the other one
    # is dim by construction, which is exactly what an empty bar cell wants
    far = (lum(p[7]) - lum(bg))^2 > (lum(p[8]) - lum(bg))^2 ? 7 : 8
    near = far == 7 ? 8 : 7
    printf "ROSE=\047%s\047 TRACK=\047%s\047 OK=\047%s\047 WARN=\047%s\047 HOT=\047%s\047 PURPLE=\047%s\047\n",
      sgr(p[far]), sgr(p[near]), sgr(p[10]), sgr(p[11]), sgr(p[1]), sgr(p[13])
  }' "$tf")"
PALE=$ROSE                # quiet glyphs share the chrome tone
PROJECT_COLOR='36'       # terminal theme cyan
MODEL_COLOR='34'         # terminal theme blue

c() { printf '\033[%sm%s\033[0m' "$1" "$2"; }

# Any "remaining" figure below this percentage renders hot.
alert_below=10
warn_below=30

tone() {  # $1 = remaining % → palette code
  if awk -v p="$1" -v t="$alert_below" 'BEGIN{exit !(p+0 < t+0)}'; then printf '%s' "$HOT"
  elif awk -v p="$1" -v t="$warn_below" 'BEGIN{exit !(p+0 < t+0)}'; then printf '%s' "$WARN"
  else printf '%s' "$OK"; fi
}

render_limit() {  # $1 = short name, $2 = remaining %, $3 = optional trailing note
  local t
  t=$(tone "$2")
  printf '%s %s%s%s' "$(c "$PALE" "$1")" \
    "$(c "$ROSE" '[')" "$(c "$t" "$(printf '%.0f%%' "$2")")" "$(c "$ROSE" ']')"
  [ -n "$3" ] && printf ' %s' "$(c "$PALE" "$3")"
}

join() {  # Dot separator between non-empty segments.
  local out="" s
  for s in "$@"; do
    [ -n "$s" ] || continue
    if [ -n "$out" ]; then out="${out}$(c "$ROSE" ' · ')${s}"; else out="$s"; fi
  done
  printf '%s' "$out"
}

# Parse stdin once. @sh quotes values before eval; missing fields become empty.
eval "$(printf '%s' "$input" | jq -r '
  def v: if . == null then "" else tostring end;
  def context_tokens:
    .context_window |
    if .current_usage != null then
      .current_usage |
      (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)
    elif .used_percentage != null and .context_window_size != null then
      .used_percentage * .context_window_size / 100
    else null end;
  [ "ctx_left=\(.context_window.remaining_percentage|v|@sh)",
    "ctx_used=\(context_tokens|v|@sh)",
    "five_used=\(.rate_limits.five_hour.used_percentage|v|@sh)",
    "five_reset=\(.rate_limits.five_hour.resets_at|v|@sh)",
    "model_name=\(.model.display_name|v|@sh)",
    "cwd=\((.workspace.current_dir // .cwd)|v|@sh)",
    "repo=\((.workspace.current_dir // .workspace.project_dir // .cwd)|v|split("/")|last|v|@sh)"
  ] | join("\n")' 2>/dev/null)"

fmt_reset() {  # $1 = resets_at epoch (may be empty/null), $2 = strftime format
  local e=${1%.*}
  [ -n "$e" ] && [ "$e" != "null" ] || return 0
  date -r "$e" "+$2" 2>/dev/null || date -d "@$e" "+$2" 2>/dev/null
}

# --- rate limits, model + context --------------------------------------------
# The 5-hour allowance may be absent before the first API response.
five_hour_limit() {
  [ -n "$five_used" ] || return 0
  local left note
  left=$(awk -v u="$five_used" 'BEGIN{printf "%.0f", 100-u}')
  note=$(fmt_reset "$five_reset" '%H:%M')
  [ -n "$note" ] && note=$'\uf021 '"$note"
  render_limit 5h "$left" "$note"
}

five_seg=$(five_hour_limit)

# Model with used context tokens — e.g. `Opus 5 (75.6k)`.
# Current usage excludes cumulative session totals, which grow across compactions.
human() { awk -v n="$1" 'BEGIN{ if(n>=1e6) printf "%.1fM", n/1e6; else if(n>=1e3) printf "%.1fk", n/1e3; else printf "%.0f", n }'; }

model=$model_name
if [ -n "$model" ]; then
  if [ -n "$ctx_used" ]; then
    model="$(c "$MODEL_COLOR" "$model")$(c "$ROSE" ' (')$(c "$(tone "${ctx_left:-100}")" "$(human "$ctx_used")")$(c "$ROSE" ')')"
  else
    model=$(c "$MODEL_COLOR" "$model")
  fi
fi

# --- project / branch -------------------------------------------------------

# Prefer the origin repository name, then the Git root, then the directory.
if [ -n "$cwd" ]; then
  if git_root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null); then
    repo=${git_root##*/}
    origin=$(git -C "$cwd" --no-optional-locks remote get-url origin 2>/dev/null)
    if [ -n "$origin" ]; then
      origin=${origin%/}
      origin=${origin##*/}
      origin=${origin##*:}
      origin=${origin%.git}
      [ -n "$origin" ] && repo=$origin
    fi
  fi
fi
dir_seg=""
[ -n "$repo" ] && [ "$repo" != . ] && dir_seg="$(c "$PROJECT_COLOR" $'\uf07b '"$repo")"
[ "$label" != default ] && dir_seg="$(join "$(c "$PALE" "$label")" "$dir_seg")"

# Read NUL-delimited porcelain so spaces and newlines in filenames are safe.
# Upstream counts use local tracking refs; rendering never fetches the network.
git_indicators() {
  local record ahead=0 behind=0 dirty=0 conflicted=0 counts
  while IFS= read -r -d '' record; do
    case "$record" in
      '# branch.ab '*)
        counts=${record#\# branch.ab }
        ahead=${counts%% *}; ahead=${ahead#+}
        behind=${counts##* }; behind=${behind#-}
        ;;
      'u '*) conflicted=1; dirty=1 ;;
      '? '*|'1 '*|'2 '*)
        dirty=1
        # Rename/copy records carry a second NUL-delimited pathname.
        [[ "$record" = '2 '* ]] && IFS= read -r -d '' record
        ;;
    esac
  done < <(git -C "$cwd" --no-optional-locks status --porcelain=v2 -z --branch --untracked-files=normal 2>/dev/null)

  local dirty_mark="" sync_marks=""
  if ((conflicted)); then
    dirty_mark="$(c "$HOT" "*")"
  elif ((dirty)); then
    dirty_mark="$(c "$WARN" "*")"
  fi
  ((ahead)) && sync_marks+="$(c "$OK" "⇡")"
  ((behind)) && sync_marks+="$(c "$WARN" "⇣")"

  printf '%s%s' "$dirty_mark" "${sync_marks:+ $sync_marks}"
  return 0
}

branch_seg=""
if [ -n "$cwd" ]; then
  if ref=$(git -C "$cwd" --no-optional-locks symbolic-ref --quiet --short HEAD 2>/dev/null); then
    branch=$ref
  elif ref=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null); then
    branch="detached:$ref"
  else
    branch=""
  fi
  if [ -n "$branch" ]; then
    branch_icon=$'\uf126 '
    gd=$(git -C "$cwd" --no-optional-locks rev-parse --git-dir 2>/dev/null)
    gc=$(git -C "$cwd" --no-optional-locks rev-parse --git-common-dir 2>/dev/null)
    if [ -n "$gd" ] && [ -n "$gc" ]; then
      [ "${gd#/}" = "$gd" ] && gd="$cwd/$gd"
      [ "${gc#/}" = "$gc" ] && gc="$cwd/$gc"
      if [ "$(readlink -f "$gd")" != "$(readlink -f "$gc")" ]; then
        branch_icon=$'\U000F0645 '
      fi
    fi
    branch_seg="$(c "$PURPLE" "${branch_icon}${branch}")$(git_indicators)"
  fi
fi

project=$dir_seg
if [ -n "$branch_seg" ]; then
  [ -n "$project" ] && project="$project$(c "$PALE" ' / ')"
  project="$project$branch_seg"
fi
status_line=$(join "$project" "$model" "$five_seg")
# Live permission mode and agent count belong to Claude's native footer;
# its statusline JSON does not expose them. Never hard-code live state.
[ -n "$status_line" ] && printf '%s\n' "$status_line"
exit 0
