ai_pack() {
    local out="project_context.md"
    echo -e "» Packing project into ..."
    
    echo -e "# Project Context - Generated mié 04 mar 2026 01:05:10 CET
" > ""
    
    # Simple recursive find ignoring common junk
    find . -maxdepth 3 -not -path "*/.*" -not -path "./node_modules*" -not -path "./venv*" -not -path "./env*" -type f | while read -r file; do
        echo -e "## File: 
\\n" >> ""
    done
    
    echo -e "✔ Context packed. Copy  to your LLM."
}
