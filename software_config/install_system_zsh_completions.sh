system_zsh_completion_path="/usr/local/share/zsh/site-functions"
pwd="$(pwd)"

mkdir -p "$system_zsh_completion_path"
find -D exec $pwd"/zsh/completions" -name "*.compl" -exec ln -sf {} "$system_zsh_completion_path" \;
