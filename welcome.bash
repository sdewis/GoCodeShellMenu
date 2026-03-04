show_welcome() {
    echo -e "🚀 SYSTEM ONLINE, SEAN"
    # Weather call backgrounded to avoid shell startup delay
    (curl -s "wttr.in?format=3" || echo "Weather offline") &

    if [[ -f ".todo" ]]; then
        echo -e "--- LOCAL TODOs ---"
        head -n 3 .todo | sed "s/^/  /"
    fi

    echo -e "Type gocodehelp to display all shell functions and shortcuts."
}
