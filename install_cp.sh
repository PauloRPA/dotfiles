DOT_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
LOCAL_DIR="$HOME/.local"

mkdir -p "$DOT_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_DIR"

select option in "CP into home and .config" "Quit"
do
    case "$option" in

        "CP into home and .config")
            cp -r "dot/." "$DOT_DIR"
            cp -r "dot/." "$CONFIG_DIR"
            cp -r "dot/." "$LOCAL_DIR"
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

