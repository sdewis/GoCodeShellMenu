proj_doctor() {
    echo -e "🩺 Checking project health in /home/sean/CodeFolder/GoCodeShellMenu..."
    
    if [ -d .git ]; then
        local status=?? """"
        if [ -z "" ]; then
            echo -e "  ● Git: Clean"
        else
            echo -e "  ● Git: Uncommitted changes"
        fi
    else
        echo -e "  ● Git: Not a repository"
    fi
    
    if [ -f requirements.txt ]; then
        if [ -d .venv ] || [ -d venv ]; then
            echo -e "  ● Python: Virtualenv found"
        else
            echo -e "  ● Python: No virtualenv for requirements.txt"
        fi
    fi

    if [ -f package.json ]; then
        if [ -d node_modules ]; then
            echo -e "  ● Node: node_modules found"
        else
            echo -e "  ● Node: node_modules missing (run npm install)"
        fi
    fi
    
    if [ -f .env.example ] && [ ! -f .env ]; then
        echo -e "  ● Config: .env missing (example found)"
    fi
}
