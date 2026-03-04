    echo -e "${GREEN}✔ Context packed. Copy $out to your LLM.${RESET}"
}

proj_doctor() {
    echo -e "${CYAN}🩺 Checking project health in $(pwd)...${RESET}"
    
    if [ -d .git ]; then
        local status=$(git status --short)
        if [ -z "$status" ]; then
            echo -e "  ${GREEN}●${RESET} Git: Clean"
        else
            echo -e "  ${YELLOW}●${RESET} Git: Uncommitted changes"
        fi
    else
        echo -e "  ${RED}●${RESET} Git: Not a repository"
    fi
    
    if [ -f requirements.txt ]; then
        if [ -d .venv ] || [ -d venv ]; then
            echo -e "  ${GREEN}●${RESET} Python: Virtualenv found"
        else
            echo -e "  ${YELLOW}●${RESET} Python: No virtualenv for requirements.txt"
        fi
    fi

    if [ -f package.json ]; then
        if [ -d node_modules ]; then
            echo -e "  ${GREEN}●${RESET} Node: node_modules found"
        else
            echo -e "  ${RED}●${RESET} Node: node_modules missing (run npm install)"
        fi
    fi
    
    if [ -f .env.example ] && [ ! -f .env ]; then
        echo -e "  ${RED}●${RESET} Config: .env missing (example found)"
