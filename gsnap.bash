gsnap() {
    local current_branch=main
    if [ -z "" ]; then
        echo -e "Error: Not a git repository."
        return 1
    fi
    local timestamp=20260304_004518
    local snapshot_branch="snapshot__"
    echo -e "» Creating snapshot: "
    git checkout -b "" && git add . && git commit -m "Snapshot: " && git checkout ""
    echo -e "✔ Snapshot created. Back on ."
}
