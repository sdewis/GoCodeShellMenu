}

qjump() {
    local root="/home/sean/CodeFolder"
    if [ -z "$1" ]; then
        echo -e "${YELLOW}Usage: qjump <partial_name>${RESET}"
        return 1
    fi
    
    local match=$(find "$root" -maxdepth 1 -mindepth 1 -type d -iname "*$1*" -print -quit)
    
    if [ -n "$match" ]; then
        cd "$match" && echo -e "${GREEN}» Moved to $(pwd)${RESET}"
    else
