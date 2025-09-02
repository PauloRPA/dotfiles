###################################
#             Options             #
###################################

setopt extendedglob
setopt nobanghist
setopt prompt_subst

unsetopt beep

PAGER=less
HISTFILE=~/.histfile
HISTSIZE=7000
SAVEHIST=7000

parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/\(\*\) \(.*\)/ (\2\1)/'
}

setopt PROMPT_SUBST

PS1=$'[%B%F{14}%n%f%b: %B%F{blue}%1~%f%b]%B$(parse_git_branch)%F{red}$ %f%b'
zstyle ':omz:update' mode disabled  # disable automatic updates

######################################
#             Completion             #
######################################

zmodload zsh/complist
autoload -Uz compinit
compinit

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '(%b)'

#############################################################
# Oh my zsh activation                                      #
#############################################################

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    alias shrc='nvim ~/.zshrc && omz reload' 

    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME="philips"
    plugins=(git tmux urltools spring httpie asdf gitignore)
    source $ZSH/oh-my-zsh.sh
fi

#######################################
#             Keybindings             #
#######################################

bindkey -e # Selects keymap ‘emacs' for any operations by the current command.

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect ';' undo
bindkey -M menuselect 'm' accept-and-hold

# Navigation
#----------------------------------------------

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

if ! [[ -z "$res" ]] then
    bindkey -s '\er' 'cd "$res"\n'
fi

if ! [[ -z "$img" ]] then
    bindkey -s '\ei' 'cd "$img"\n'
fi

if ! [[ -z "$doc" ]] then
    bindkey -s '\ej' 'cd "$doc"\n'
fi

if [[ -f "$(where zoxide)" ]] then
    bindkey -s '\eu' 'z -\n'
fi

# Shortcuts
#----------------------------------------------

bindkey -s '\e^[' 'cd ..\n'

bindkey -s '\el' 'ls\n'
bindkey -s '\ew' 'pwd\n'

bindkey -s '\eo' 'git log --oneline\n'
bindkey -s '\es' 'git status\n'

bindkey -s '\e.' 'shrc\n'
bindkey -s '\en' 'nvim\n'

#############################################################
# Variaveis                                                 #
#############################################################
# Locations
#------------------------------------------------------------

# Archive root
export arq="/mnt/extended"
export dev="$arq/dev"
export res="$arq/resources"

# Home
export home="$HOME"
export con="$home/.config"

# Arquive locations
export dev="$arq/dev"
export res="$arq/resources"

# Resources
export dat="$res/data/"
export liv="$res/livros"
export doc="$res/documentos"
export media="$res/media"

# Media
export vid="$media/videos"
export sfx="$media/sfx"
export mus="$media/musicas"

# Images
export img="$media/imagens"
export scr="$img/screenshots"
export wpp="$img/wallpaper"

# Environment
#------------------------------------------------------------

export EDITOR=nvim
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share"

# Software Paths
#------------------------------------------------------------

# Deprecated ASDF Config
# if [[ -e $(where asdf) ]]; then
#     export PATH="$PATH:/opt/asdf-vm/bin" # asdf bin
#     export JAVA_HOME=$(asdf where java)
#
#     if ! [[ -d "$home/.oh-my-zsh" ]]; then
#         . "$home/.asdf/asdf.sh"
#         # append completions to fpath
#         fpath=(${ASDF_DIR}/completions $fpath)
#         # initialise completions with ZSH's compinit
#         autoload -Uz compinit && compinit
#     fi
# fi

export PATH="$PATH:$home/.local/bin" # Local bin
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export JAVA_HOME=$(asdf where java)

#############################################################
# Alias                                                     #
#############################################################
# Navegacao
#------------------------------------------------------------

alias h="cd ${home}"
alias arq="cd ${arq}"
alias dev="cd ${dev}"
alias res="cd ${res}"
alias dat="cd ${dat}"
alias con="cd $con"
alias cscp="cd $scp"
alias scr="cd $scr"
alias s="cd $scr"
alias d="cd ${home}/Desktop"

# Configuracoes
#------------------------------------------------------------

alias 3r='nvim ~/.config/i3/config' 
alias shrc='nvim ~/.zshrc && source ~/.zshrc' 
alias nvrc='nvim ~/.config/nvim/init.lua' 
alias porc='nvim ~/.config/polybar/config' 
alias alrc='nvim ~/.config/alacritty/alacritty.yml' 

# Atalhos
#------------------------------------------------------------

alias r='ranger' 
alias nv="nvim"

alias gmail="xdg-open https://mail.google.com/mail/u/0/ & disown"
alias pmail="xdg-open https://mail.proton.me/u/0/inbox & disown"
alias lowdl='yt-dlp -S "res:720,fps" '
alias adlo='yt-dlp -f bestaudio -x --audio-format opus --audio-quality 320k'
alias adl='yt-dlp -f ba'
alias strdl='yt-dlp -S "res:720,fps" -i --external-downloader aria2c --download-archive file'
alias du="du -h -s --apparent-size"
alias grep='grep -i --colour=auto' # grep colorido e case insensitive

alias clip='xclip -i -sel clip' # envia o standard input para o clipboard
alias cc='wl-copy' # envia o standard input para o clipboard
alias cv='wl-paste' # printa o standard output 

alias killscr="rm $scr/**" # Delete all screenshots

#Util
alias gc='xprop | grep -i wm_class | cut -d\" -f 4' # Busca a classe de uma janela
# Busca a classe de uma janela e move para area de transferencia
alias cgc='xprop | grep -i wm_class | cut -d\" -f 4 | xclip -i -sel clip'

# Scripts
#------------------------------------------------------------

#############################################################
# Sources                                                   #
#############################################################

# source "/opt/asdf-vm/bin/asdf.sh"

#############################################################
# Functions                                                 #
#############################################################

function f () {
    copy_current_path_or_file_wayland $@
}

function fp () {
    copy_current_path_or_file $@
}

# Install oh my zsh
function install_ohMyZsh () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install asdf
function install_asdf () {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
}

# Find mime type of a file: <file> 
function get_file_mime_type () {
    file -i "$1" | cut -d ':' -f 2 | tr -d ';' | cut -d ' ' -f 2
}

# Restart plasmashell and disown the proccess: <>
function kde_restart () {
	zsh -c 'plasmashell --replace & disown'
}

# Copy current path or the referenced file path: <file> (wayland)
function copy_current_path_or_file_wayland (){
	echo -n "$(pwd)/$1" | wl-copy
}

# Copy current path or the referenced file path: <file>
function copy_current_path_or_file (){
	echo -n "$(pwd)/$1" | xclip -i -sel clip
}

# Outputs the classpath of a java project managed by maven 
function get_maven_java_project_classpath(){
    mvnRAWBuildClasspath=$(mvn dependency:build-classpath)
    mvnBuildClasspath="$(echo $mvnRAWBuildClasspath | grep -vE "\[INFO\]|\[ERROR\]")"
}

# Output clipboard content
function get_clipboard () {
    echo $(xclip -o -sel clip)
}

# This function Downloads streams from any supported sources
function dlst () {
    # $1 = https://www.twitch.tv/gaules 
    yt-dlp -S "res:720,fps" -i --external-downloader aria2c --download-archive stream "$1"
}

# This function Downloads songs from any supported sources
function dlsp () {
    # $1 playlist = spotify:playlist:4CWuuvLwRQ2CBZlDZaxCzi
    podman run -it --rm -v .:/data docker.io/freyrcli/freyrjs --no-net-check get "$1"
}

# This function removes orphan packages from the system
function remove_orphans () {
    sudo pacman -Rsu $(pacman -Qdtq)
}

# This function records the screen
function record () {
    ffmpeg -f x11grab -video_size 800x800 -i :0.0+0,0 -codec:v libx264 -pix_fmt yuv420p out.mkv && mpv out.mkv
}

# This function lists the largest packages on the system
function largest_packages () {
     pacman -Qi | gawk '/^Name/ { x = $3 }; /^Installed Size/ { sub(/Installed Size  *:/, ""); print x":" $0 }' | sort -k2,3rn | head -n10 | gawk 'BEGIN { print "\n""These are your 10 largest programs:""\n" }; { print }'
}

# This function lists the sizes of the packages installed on the system
function list_packages_size () {
    pacman -Qi | gawk '/^Name/ { x = $3 }; /^Installed Size/ { sub(/Installed Size  *:/, ""); print x":" $0 }' | sort -k2,3n
}

# This function runs the MariaDB client
function podcmd () {
	echo 'podman run --network host -ti docker.io/library/mariadb:latest mariadb -P 8999 -u prpa -p'
}

function e(){
    dolphin $@ > /dev/null 2>&1 & disown 
}

function togif () {
    video="$1"
    fps="fps=10"
    scale="scale=1280:-1:flags=lanczos"

    if ! [[ -z "$2" ]]; then 
        fps="fps=$2"
    fi

    if ! [[ -z "$3" ]]; then 
        scale="scale=$3:-1:flags=lanczos"
    fi

    echo "Converting -> $1 to gif at $fps fps and scale $scale."

    ffmpeg -i $video -vf "$fps,$scale,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$1.gif"
}

function togifb () {
    videos=("${@:3}")
    fps="fps=10"
    scale="scale=1280:-1:flags=lanczos"

    echo "============================"
    echo "Converting -> $videos "
    echo "============================"

    if ! [[ -z "$1" ]]; then 
        fps="fps=$1"
    fi

    if ! [[ -z "$2" ]]; then 
        scale="scale=$2:-1:flags=lanczos"
    fi

    for video in $videos
    do
        echo "Converting -> $video to gif at $fps fps and scale $scale."
        ffmpeg -i "$video" -vf "$fps,$scale,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "${video%.*}.gif"
        echo "------------------------------------"
    done

}

# Remove background of an image
function rm_background () {

    if [[ -z "$*" ]]; then
        echo "No image file provided."
        return
    fi

    suffix=""

    select option in "Overwrite" "Save as a copy"
    do
        case "$option" in

            "Overwrite")
                suffix=""
                break 
                ;;

            "Save as a copy")
                suffix="-transparent"
                break 
                ;;

            *)
                echo "Invalid option."
                return
                ;;

            esac
    done

    file=""
    filename=""
    extension=""
    output=""

    if [[ $# == 1 ]]; then

        file="$1"
        filename="${file%.*}"
        extension="${file##*.}"

        if [[ $extension != 'png' ]]; then
            extension="png"
        fi

        output="$filename$suffix.$extension"

        echo "Removing background from image: $file"
        convert "$file" -alpha off -fuzz 10% -fill none -draw "alpha 0,0 floodfill" \( +clone -alpha extract -blur 0x2 -level 50x100% \) -alpha off -compose copy_opacity -composite "$output"

        return
    fi

    echo "Removing background from multiple images."
    for image in $@
    do
        file="$image"
        filename="${file%.*}"
        extension="${file##*.}"
        output="$filename$suffix.$extension"

        echo "Removing background from image: $file"
        convert "$file" -alpha off -fuzz 10% -fill none -draw "alpha 0,0 floodfill" \( +clone -alpha extract -blur 0x2 -level 50x100% \) -alpha off -compose copy_opacity -composite "$output"

    done
}

#############################################################
# AutoStart                                                 #
#############################################################

#############################################################
# Software dependant config                                 #
#############################################################

if [[ -e $(where trash) ]]; then
    # Trash-cli dependent
    alias rm="trash"
fi

if [[ -e $(where zoxide) ]]; then
    # Zoxide dependent
    alias cd="z"
    alias c="z -"
fi

if [[ -e $(where exa) ]]; then
    # Exa dependent
    alias ls='exa --grid' # exa
    alias ll='exa --long --grid --header --icons -lag' # atalho exa -la
    alias tree='exa --tree ' # atalho mostra uma tree
    alias ltree='exa --tree --level=2' # atalho exa -la
    alias long='exa --tree --long --level=2' # atalho exa -la
fi

if [[ -e $(where bat) ]]; then
    # Bat dependent
    alias bat='bat' #Config bat
fi

if [[ -e $(where feh) ]]; then
    # Feh dependent
    alias feh="feh -."
    alias fscr="feh $scr/** -F"
    alias fdlp="feh -. -D 2.6 -z -n $dlp/ "
fi

#############################################################
# Zoxide                                                    #
#############################################################

# shellcheck shell=bash

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
\builtin typeset -ga precmd_functions
\builtin typeset -ga chpwd_functions
# shellcheck disable=SC2034,SC2296
precmd_functions=("${(@)precmd_functions:#__zoxide_hook}")
# shellcheck disable=SC2034,SC2296
chpwd_functions=("${(@)chpwd_functions:#__zoxide_hook}")
chpwd_functions+=(__zoxide_hook)

# Report common issues.
function __zoxide_doctor() {
    [[ ${_ZO_DOCTOR:-1} -ne 0 ]] || return 0
    [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] || return 0

    _ZO_DOCTOR=0
    \builtin printf '%s\n' \
        'zoxide: detected a possible configuration issue.' \
        'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.zshrc).' \
        '' \
        'If the issue persists, consider filing an issue at:' \
        'https://github.com/ajeetdsouza/zoxide/issues' \
        '' \
        'Disable this message by setting _ZO_DOCTOR=0.' \
        '' >&2
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    __zoxide_doctor
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]; then
        __zoxide_cd "$2"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    __zoxide_doctor
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

function z() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _cd -/

        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Set a result to ensure completion doesn't re-run
            compadd -Q ""

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Sends query device status code, which results in a '\e[0n' being sent to console input.
            \builtin printf '\e[5n'

            # Report that the completion was successful, so that we don't fall back
            # to another completion function.
            return 0
        fi
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            __zoxide_result=''
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi

# =============================================================================
#
# To initialize zoxide, add this to your shell configuration file (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"
