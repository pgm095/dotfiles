#!/bin/zsh
# =============================================================================
# ZSH Configuration File
# =============================================================================

# -----------------------------------------------------------------------------
# Powerlevel10k Instant Prompt
# -----------------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------------------------------------
# Homebrew Setup (macOS)
# -----------------------------------------------------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# Zoxide Configuration
# -----------------------------------------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  # Clean up any existing zoxide-related functions and aliases
  unalias z zi 2>/dev/null || true
  unfunction z zi __zoxide_z __zoxide_zi 2>/dev/null || true
  
  # Initialize zoxide fresh
  eval "$(zoxide init zsh --hook pwd)"
fi

# -----------------------------------------------------------------------------
# Zinit Plugin Manager Setup
# -----------------------------------------------------------------------------
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [[ ! -d "$ZINIT_HOME" ]]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# -----------------------------------------------------------------------------
# Theme Configuration
# -----------------------------------------------------------------------------
# Add in Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# -----------------------------------------------------------------------------
# ZSH Plugins
# -----------------------------------------------------------------------------
# Essential plugins for better ZSH experience
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# -----------------------------------------------------------------------------
# Oh My ZSH Snippets
# -----------------------------------------------------------------------------
# Git functionality
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

# System utilities
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Development tools
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx

# OS-specific snippets
case "$(uname -s)" in
  Linux*)
    zinit snippet OMZP::archlinux
    ;;
  Darwin*)
    # Add macOS specific plugins here if needed
    ;;
esac

# -----------------------------------------------------------------------------
# Completions Setup
# -----------------------------------------------------------------------------
# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
# Use emacs-style key bindings
bindkey -e

# History search
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Kill region (similar to Ctrl+W in other shells)
bindkey '^[w' kill-region

# -----------------------------------------------------------------------------
# History Configuration
# -----------------------------------------------------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# History options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -----------------------------------------------------------------------------
# Completion Styling
# -----------------------------------------------------------------------------
# Case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Use colors in completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Disable default menu
zstyle ':completion:*' menu no

# FZF tab completions with preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -----------------------------------------------------------------------------
# Shell Integrations
# -----------------------------------------------------------------------------
# FZF integration
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
# File operations
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Editor
alias vim='nvim'
alias vi='nvim'

# System
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'

# Zoxide
alias zz='zoxide query -i'

# Git aliases (additional to OMZ git plugin)
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'

# -----------------------------------------------------------------------------
# Custom Functions
# -----------------------------------------------------------------------------
# Quick directory creation and navigation
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -----------------------------------------------------------------------------
# Powerlevel10k Configuration
# -----------------------------------------------------------------------------
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -----------------------------------------------------------------------------
# Local Configuration
# -----------------------------------------------------------------------------
# Source local zsh configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
