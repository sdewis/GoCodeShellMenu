ai_pack() {
    local out="project_context.md"
    echo -e "${CYAN}»${RESET} Packing project into $out..."
    
    echo -e "# Project Context - Generated $(date)
" > "$out"
    
    # Simple recursive find ignoring common junk
    find . -maxdepth 3 -not -path "*/.*" -not -path "./node_modules*" -not -path "./venv*" -not -path "./env*" -type f | while read -r file; do
        echo -e "## File: $file
```" >> "$out"
        cat "$file" >> "$out"
        echo -e "
```
" >> "$out"
    done
