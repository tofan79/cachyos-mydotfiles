# ---- fastfetch ----
fastfetch
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---- PATH ----
export PATH="$HOME/.local/bin:$PATH"

# ---- Better man pages ----
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ---- Eza ----
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"

# ---- Bat ----
alias cat='bat --style=plain'

# ---- Apps ----
alias op='opencode'
alias y='yazi'
alias nv='nvim'

# ---- Docker / Podman ----
alias d='docker'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# ---- CachyOS / Arch ----
alias update='sudo pacman -Syu && flatpak update -y'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias aur='paru -S'
alias clean='~/.config/clean/clean.sh'
alias jctl="journalctl -p 3 -xb"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias grep='grep --color=auto'
alias hw='hwinfo --short'

# ---- Zoxide ----
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# ---- FZF ----
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_R_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS='--height 40% --layout=reverse --border'

# ---- mise ----
eval "$(~/.local/bin/mise activate zsh)"

# ---- opencode ----
export PATH=/home/mindset/.opencode/bin:$PATH

# fastfetch ada di atas (sebelum instant prompt)
