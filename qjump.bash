qjump() {
    local root="/home/sean/CodeFolder"
    if [ -z "" ]; then
        echo -e "Usage: qjump <partial_name>"
        return 1
    fi
    
    local match=
    
    if [ -n "" ]; then
        cd "" && echo -e "» Moved to /home/sean/CodeFolder/GoCodeShellMenu"
    else
        echo -e "No project matching '' found."
    fi
}
