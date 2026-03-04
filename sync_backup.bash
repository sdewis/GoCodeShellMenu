sync_backup() {
    echo -e "» Checking backup health..."
    local last_push=1772581473
    local diff=20515

    [[ "" -ge 3 ]] && echo -e "⚠️  Backup is  days old!"

    git add . && git commit -m "Auto-sync: mié 04 mar 2026 00:45:12 CET" && git push origin main
    echo -e "✔ Private backup synced successfully."
}
