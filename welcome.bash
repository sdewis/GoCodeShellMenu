show_welcome() {
    echo -e "${PURPLE}🚀 SYSTEM ONLINE, SEAN${RESET}"
    
    local cache="/tmp/wttr_sean_cache"
    # Display cached weather immediately if it exists
    [[ -f "$cache" ]] && cat "$cache"

    # Refresh the cache silently in the background for the next session
    ( 
        # Only fetch if cache is missing or older than 30 minutes
        if [[ ! -f "$cache" ]] || [[ -n $(find "$cache" -mmin +30 2>/dev/null) ]]; then
            curl -s "wttr.in?format=3" > "$cache" 2>/dev/null
        fi
    ) & disown

    if [[ -f ".todo" ]]; then
        echo -e "${CYAN}--- LOCAL TODOs ---${RESET}"
        head -n 3 .todo | sed "s/^/  /"
    fi

    echo -e "${CYAN}Type ${YELLOW}gocodehelp${RESET}${CYAN} to display all shell functions and shortcuts.${RESET}"
}
