
# ============================================================
# ZSH CONFIGURATION
# ============================================================

# ---------- History ----------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# ---------- Shell behaviour ----------
setopt INTERACTIVE_COMMENTS
setopt AUTO_CD

# ---------- PATH management ----------
typeset -U path PATH
export PATH="/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.opencode/bin:$PATH"

# Use the locally installed Temurin JDK for Java tooling (no sudo required).
typeset jdk_root="$HOME/.local/lib/jdks"
if [[ -d "$jdk_root" ]]; then
    typeset -a jdk_dirs
    jdk_dirs=("$jdk_root"/jdk-*(N/))
    if (( ${#jdk_dirs} > 0 )); then
        export JAVA_HOME="${jdk_dirs[-1]}"
        path=("$JAVA_HOME/bin" $path)
    fi
fi

# ---------- Completion ----------
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ---------- Environment ----------
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BAT_THEME="ansi"

# ---------- FZF ----------
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=fg:#d8dee0,bg:-1,hl:#2bd1d1,fg+:#ffffff,bg+:#1b2a2d,hl+:#5fd7c8,pointer:#f2837f,prompt:#2bd1d1"

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude node_modules --exclude .venv --exclude target'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ---------- Tools ----------
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# ---------- Prompt ----------
# Same style as bash: [username@hostname folder]$
# Set after starship so this prompt takes precedence.
PROMPT='%F{35}[%n@%m %F{33}%1~%F{35}]%f$ '
RPROMPT=""
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# ---------- NVM / Node.js ----------
export NVM_DIR="$HOME/.nvm"

[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ---------- Aliases: General ----------
alias ff='fastfetch'
alias ls='eza --icons --group-directories-first'
alias la='eza -lah --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias update='sudo dnf upgrade --refresh'
alias myip='curl -s https://ifconfig.me; echo'

# ---------- Aliases: Git ----------
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate -15'
alias lg='lazygit'

# ---------- Aliases: Docker ----------
alias d='docker'
alias dps='docker ps'
alias dimg='docker images'
alias dlogs='docker logs -f'

# ---------- Aliases: Kubernetes ----------
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgn='kubectl get nodes'
alias kgd='kubectl get deployments'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete -f'

# ---------- Aliases: Python ----------
alias py='python3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'

# ---------- Aliases: System ----------
alias sysinfo='fastfetch'
alias mem='free -h'
alias disk='df -h'
alias journal='sudo journalctl -p 3 -xb'

# ---------- Aliases: Networking / Security ----------
alias localip='ip -4 -br addr'
alias ports='sudo ss -tulpn'
alias conns='sudo ss -tupn'
alias wifi='nmcli device wifi list'
alias pingg='ping -c 4 1.1.1.1'
alias trace='mtr --report -c 10'
alias dnscheck='resolvectl status'
alias capture='sudo tcpdump -i any -nn'
alias quickscan='nmap -T4 -F'
alias fullscan='nmap -sV -sC -T4'
alias hostscan='nmap -sn'
alias headers='curl -sI'
alias sec-audit='sudo lynis audit system'

# ---------- Functions ----------
mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

extract() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "Usage: extract <archive>"
        return 1
    fi

    case "$1" in
        *.tar.gz|*.tgz) tar -xzf "$1" ;;
        *.tar.bz2|*.tbz2) tar -xjf "$1" ;;
        *.tar.xz|*.txz) tar -xJf "$1" ;;
        *.tar.zst|*.tzst) tar --zstd -xf "$1" ;;
        *.tar) tar -xf "$1" ;;
        *.zip) unzip "$1" ;;
        *.gz) gunzip "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.xz) unxz "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "Unsupported archive: $1"; return 1 ;;
    esac
}

# ---------- Editor / Shell shortcuts ----------
alias vim='nvim'
alias v='nvim'
alias reload='exec zsh'
alias zshrc='${EDITOR:-nano} "$HOME/.zshrc"'

# ---------- Terminal compatibility ----------


if [[ -n "$TMUX" ]]; then
    export TERM="tmux-256color"
else
    export TERM="xterm-256color"
fi

zmodload zsh/terminfo
KEYTIMEOUT=40

# ---------- Line editing ----------
# Backspace
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

# Delete
bindkey '^[[3~' delete-char
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char

# Home
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[7~' beginning-of-line
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line

# End
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[8~' end-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line

# History search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Ctrl + Arrow navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Command-line deletion
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# ---------- Plugins ----------
# Load autosuggestions before syntax highlighting.
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting MUST be loaded last.
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "$HOME/.cargo/env"
