show_welcome() {
    echo -e "🚀 SYSTEM ONLINE, SEAN"
    
    local cache="/tmp/wttr_sean_cache"
    # Display cached weather immediately if it exists
    [[ -f "" ]] && cat ""

    # Refresh the cache silently in the background for the next session
    ( 
        # Only fetch if cache is older than 30 minutes
        if [[ ! -f "" ]] || [[ -n  ]]; then
            curl -s "wttr.in?format=3" > "" 2>/dev/null
        fi
    ) & disown

    if [[ -f ".todo" ]]; then
        echo -e "--- LOCAL TODOs ---"
        head -n 3 .todo | sed "s/^/  /"
    fi

    echo -e "Type gocodehelp to display all shell functions and shortcuts."
}
