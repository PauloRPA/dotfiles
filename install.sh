DOT_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
LOCAL_DIR="$HOME/.local"

mkdir -p "$DOT_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_DIR"

find_managed_directories () {
    find "$1" -type d | cut -d/ -f 2-
}

find_managed_files () {
    find "$1" -type f | cut -d/ -f 2-
}

delete_managed_dots () {
    for dot in $(find_managed_files dot); do
        rm -rd $DOT_DIR/"$dot" 2>/dev/null
    done
}

delete_managed_config () {
    for config in $(find_managed_directories config); do
        rm -rd $CONFIG_DIR/"$config" 2>/dev/null
    done
}

delete_managed_local () {
    for local in $(find_managed_files local); do
        rm -rd $LOCAL_DIR/"$local" 2>/dev/null
    done
}

delete_config () {
    delete_managed_dots
    delete_managed_config
    delete_managed_local
}

stow_config () {
    delete_config
    stow -v -t "$DOT_DIR" "$1" dot
    stow -v -t "$CONFIG_DIR" "$1" config
    stow -v -t "$LOCAL_DIR" "$1" local
}

cp_config () {
    delete_config
    cp -rf "dot/." "$DOT_DIR"
    cp -rf "config/." "$CONFIG_DIR"
    cp -rf "local/share/applications/" "$LOCAL_DIR"
}

select option in "Install stow" "Install cp" "Unstow" "Uninstall" "Quit"
do
    case "$option" in

        "Install stow")
            delete_config
            stow_config -S
            ;;

        "Install cp")
            cp_config
            ;;

        "Unstow")
            stow_config -D
            ;;

        "Uninstall")
            delete_config
            ;;

        "Quit")
            exit 0
            ;;

        *)
            echo "Invalid option."
            ;;

        esac
done
