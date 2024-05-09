DOT_DIR="$HOME"
CONFIG_DIR="$HOME/.config"

mkdir -p "$DOT_DIR"
mkdir -p "$CONFIG_DIR"

select option in "Stow into home and .config" "Stow delete" "Restow" "Quit"
do
    case "$option" in

        "Stow into home and .config")
            stow -v -t "$DOT_DIR" -S dot
            stow -v -t "$CONFIG_DIR" -S config
            ;;

        "Stow delete")
            stow -v -t "$DOT_DIR/" -D dot
            stow -v -t "$CONFIG_DIR" -D config
            break 
            ;;

        "Restow")
            if [[ -f "$DOT_DIR/.zshrc" ]]; then
                mv "$DOT_DIR/.zshrc" "$DOT_DIR/.zshrc_original" 
            fi
            stow -v -t "$DOT_DIR" -R dot
            stow -v -t "$CONFIG_DIR" -R config
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

