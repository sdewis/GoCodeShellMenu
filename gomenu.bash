# gomenu function extracted from ~/.bashrc

# shellcheck shell=bash
gomenu() {
  local root="$HOME/CodeFolder"
  cd "$root" || { printf '\e[31mgomenu: cannot cd to %s\e[0m\n' "$root" >&2; return 1; }

  # Colors
  local c_reset=$'\e[0m'
  local c_header=$'\e[36m'   # cyan
  local c_path=$'\e[33m'     # yellow
  local c_number=$'\e[32m'   # green
  local c_key=$'\e[35m'      # magenta
  local c_dim=$'\e[90m'      # bright black
  local c_warn=$'\e[31m'     # red

  # Determine shell for read -n/-k compatibility
  local shell_name
  shell_name=$(ps -p $$ -o comm= 2>/dev/null || echo "sh")

  local per_page=5
  local offset=0
  local total

  # Capture any currently active venv so we can offer to deactivate
  local prev_venv="${VIRTUAL_ENV:-}"

  # Precompute sorted list (dirs only, newest first)
  mapfile -t _gomenu_dirs < <(find . -maxdepth 1 -mindepth 1 -type d -printf '%T@ %P\n' \
    | sort -nr \
    | awk '{ $1=""; sub(/^ /,""); print }')

  total=${#_gomenu_dirs[@]}
  if (( total == 0 )); then
    printf '%sgomenu: no project directories found in %s%s\n' "$c_warn" "$root" "$c_reset" >&2
    return 1
  fi

  while :; do
    clear
    printf '%sgomenu%s - Projects in %s%s%s (newest first)\n\n' \
      "$c_header" "$c_reset" "$c_path" "$root" "$c_reset"

    local i idx label
    for (( i=0; i<per_page && (offset + i) < total; i++ )); do
      idx=$((offset + i))
      label=${_gomenu_dirs[$idx]}
      printf '  %s%d%s) %s\n' "$c_number" "$((i+1))" "$c_reset" "$label"
    done

    if (( offset + per_page < total )); then
      printf '\n  %sn%s) next page\n' "$c_key" "$c_reset"
    fi
    if (( offset > 0 )); then
      printf '  %sp%s) previous page\n' "$c_key" "$c_reset"
    fi
    printf '  %sq%s) quit %s(or Esc / Ctrl+C)%s\n' "$c_key" "$c_reset" "$c_dim" "$c_reset"

    printf '\nSelect project [%s1-%d%s, %sn/p/q%s]: ' "$c_number" "$per_page" "$c_reset" "$c_key" "$c_reset"

    # Single-key read, Bash and Zsh compatible
    local key
    case "$shell_name" in
      *zsh*)
        read -k 1 key 2>/dev/null || return 0 ;;
      *)
        read -r -n 1 key 2>/dev/null || return 0 ;;
    esac

    # Handle special keys
    case "$key" in
      $'\x03'|$'\x1b'|q|Q)
        printf '\n% sExiting gomenu.%s\n' "$c_dim" "$c_reset"
        cd "$root"
        return 0
        ;;
      n|N)
        if (( offset + per_page < total )); then
          offset=$((offset + per_page))
        fi
        ;;
      p|P)
        if (( offset - per_page >= 0 )); then
          offset=$((offset - per_page))
        else
          offset=0
        fi
        ;;
      [1-5])
        local choice=$((key - 1))
        local sel_idx=$((offset + choice))
        if (( sel_idx < total )); then
          local proj_name="${_gomenu_dirs[$sel_idx]}"
          local target="$root/$proj_name"
          printf '\nOpening %s\n' "$target"
          cd "$target" || { printf '%sgomenu: failed to cd to %s%s\n' "$c_warn" "$target" "$c_reset" >&2; cd "$root"; return 1; }

          # If we came from an active venv and this project has none, offer to deactivate
          local cur_venv="${VIRTUAL_ENV:-}"
          if [ -n "$prev_venv" ] && [ -z "$cur_venv" ]; then
            printf '\nPreviously active venv: %s%s%s\n' "$c_path" "$prev_venv" "$c_reset"
            printf 'Deactivate it now? [%sY%s/n]: ' "$c_key" "$c_reset"
            local d_ans
            read -r d_ans
            case "${d_ans:-y}" in
              y|Y)
                if command -v deactivate >/dev/null 2>&1; then
                  deactivate
                  printf '%sDeactivated previous virtualenv.%s\n' "$c_dim" "$c_reset"
                else
                  printf '%sNote: deactivate function not found; you may already be outside that venv.%s\n' "$c_dim" "$c_reset"
                fi
                ;;
            esac
          fi

          # Look for common venv locations in the new project
          local venv_path=""
          for cand in ".venv" "venv" "env"; do
            if [ -d "$cand" ] && [ -f "$cand/bin/activate" ]; then
              venv_path="$cand"
              break
            fi
          done

          if [ -n "$venv_path" ]; then
            printf '\nFound virtualenv at %s%s%s. Activate it? [%sY%s/n]: ' "$c_path" "$venv_path" "$c_reset" "$c_key" "$c_reset"
            local ans
            read -r ans
            case "${ans:-y}" in
              y|Y)
                # shellcheck disable=SC1090
                . "$venv_path/bin/activate" 2>/dev/null
                if [ -n "${VIRTUAL_ENV:-}" ] && [ -d "$VIRTUAL_ENV" ]; then
                  printf '%sVirtualenv activated:%s %s\n' "$c_dim" "$c_reset" "$VIRTUAL_ENV"
                else
                  printf '%sWarning:%s attempted to activate venv, but VIRTUAL_ENV is not set or invalid.\n' "$c_warn" "$c_reset" >&2
                fi
                ;;
            esac
          else
            # No venv present here; if requirements.txt exists, offer to create one
            if [ -f "requirements.txt" ]; then
              printf '\n%srequirements.txt%s found, but no virtualenv here. Create %s.venv%s and install requirements? [%sY%s/n]: ' \
                "$c_path" "$c_reset" "$c_path" "$c_reset" "$c_key" "$c_reset"
              local c_ans
              read -r c_ans
              case "${c_ans:-y}" in
                y|Y)
                  if command -v python3 >/dev/null 2>&1; then
                    python3 -m venv .venv && \
                    . .venv/bin/activate && \
                    pip install -r requirements.txt
                    if [ -n "${VIRTUAL_ENV:-}" ] && [ -d "$VIRTUAL_ENV" ]; then
                      printf '%sCreated and activated virtualenv:%s %s\n' "$c_dim" "$c_reset" "$VIRTUAL_ENV"
                    else
                      printf '%sWarning:%s venv creation/activation completed but VIRTUAL_ENV not set as expected.\n' "$c_warn" "$c_reset" >&2
                    fi
                  else
                    printf '%spython3 not found; cannot create virtualenv.%s\n' "$c_warn" "$c_reset" >&2
                  fi
                  ;;
              esac
            fi
          fi

          # Leave user in selected project directory (menu quits)
          return 0
        fi
        ;;
      *) ;;
    esac
  done
}
