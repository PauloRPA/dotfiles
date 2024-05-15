DOT_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
LOCAL_DIR="$HOME/.local"

mkdir -p "$DOT_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_DIR"

select option in "Stow into home and .config" "Stow delete" "Restow" "Quit"
do
    case "$option" in

        "Stow into home and .config")
            stow -v -t "$DOT_DIR" -S dot
            stow -v -t "$CONFIG_DIR" -S config
            stow -v -t "$LOCAL_DIR" -S local
            ;;

        "Stow delete")
            stow -v -t "$DOT_DIR/" -D dot
            stow -v -t "$CONFIG_DIR" -D config
            stow -v -t "$LOCAL_DIR" -D local
            break 
            ;;

        "Restow")
            if [[ -f "$DOT_DIR/.zshrc" ]]; then
                mv "$DOT_DIR/.zshrc" "$DOT_DIR/.zshrc_original" 
            fi
            stow -v -t "$DOT_DIR" -R dot
            stow -v -t "$CONFIG_DIR" -R config
            stow -v -t "$LOCAL_DIR" -R local
            break 
            ;;

        "Quit")
            break 
            exit 0
            ;;

        *)
            echo "Invalid option."
            ;;

        esac
done

