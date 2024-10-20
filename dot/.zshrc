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

bindkey -s '\e^[' 'PREV=$(pwd); cd ..; echo $PREV\n'

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
export scp="$con/scripts"

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

if [[ -e $(where asdf) ]]; then
    export PATH="$PATH:/opt/asdf-vm/bin" # asdf bin
    export JAVA_HOME=$(asdf where java)

    if ! [[ -d "$home/.oh-my-zsh" ]]; then
        . "$home/.asdf/asdf.sh"
        # append completions to fpath
        fpath=(${ASDF_DIR}/completions $fpath)
        # initialise completions with ZSH's compinit
        autoload -Uz compinit && compinit
    fi
fi

export PATH="$PATH:$con" # Scripts path
export PATH="$PATH:$home/.local/bin" # Local bin


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
alias e="dolphin"
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

alias killscr="rm $scr/**" # Delete all screenshots

# Set current dir as a safe.dir
alias safe="git config --global --add safe.directory $(pwd)"
alias gsd="git config --global --add safe.directory $(pwd)"

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
# Automatically initiate ssh-agent and add ID and GitHub keys to it.
#------------------------------------------------------------

#SSH_ENV="$HOME/.ssh/agent-environment"
#
#function start_agent {
#    echo "Initialising new SSH agent..."
#    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#    echo succeeded
#    chmod 600 "${SSH_ENV}"
#    . "${SSH_ENV}" > /dev/null
#    /usr/bin/ssh-add ~/.ssh/* 
#}
#
## Source SSH settings, if applicable
#
#if [ -f "${SSH_ENV}" ]; then
#    . "${SSH_ENV}" > /dev/null
#    #ps ${SSH_AGENT_PID} doesn't work under cywgin
#    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#        start_agent;
#    }
#else
#    start_agent;
#fi

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

if [[ -e $(where zoxide) ]]; then
    # Initialize hook.
    # shellcheck disable=SC2154
    if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
        chpwd_functions+=(__zoxide_hook)
    fi
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$@[-1]" == "${__zoxide_z_prefix}"* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@[-1]}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query -i -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin unalias z &>/dev/null || \builtin true
function z() {
    __zoxide_z "$@"
}

\builtin unalias zi &>/dev/null || \builtin true
function zi() {
    __zoxide_zi "$@"
}

if [[ -e $(where zoxide) ]]; then
    if [[ -o zle ]]; then
        function __zoxide_z_complete() {
            # Only show completions when the cursor is at the end of the line.
            # shellcheck disable=SC2154
            [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

            if [[ "${#words[@]}" -eq 2 ]]; then
                _files -/
            elif [[ "${words[-1]}" == '' ]]; then
                \builtin local result
                # shellcheck disable=SC2086,SC2312
                if result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -i -- ${words[2,-1]})"; then
                    result="${__zoxide_z_prefix}${result}"
                    # shellcheck disable=SC2296
                    compadd -Q "${(q-)result}"
                fi
                \builtin printf '\e[5n'
            fi
            return 0
        }

        \builtin bindkey '\e[0n' 'reset-prompt'
        if [[ "${+functions[compdef]}" -ne 0 ]]; then
            \compdef -d z
            \compdef -d zi
            \compdef __zoxide_z_complete z
        fi
    fi
fi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"

# Created by `pipx` on 2023-08-22 16:14:10
export PATH="$PATH:/home/prpa/.local/bin"
