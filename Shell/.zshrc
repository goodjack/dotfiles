# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/goodjack/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

### Oh My Zsh Libraries
zinit snippet OMZ::lib/bzr.zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/compfix.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/correction.zsh
zinit snippet OMZ::lib/diagnostics.zsh
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/functions.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/grep.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/misc.zsh
zinit snippet OMZ::lib/nvm.zsh
zinit snippet OMZ::lib/prompt_info_functions.zsh
zinit snippet OMZ::lib/spectrum.zsh
zinit snippet OMZ::lib/termsupport.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

### Oh My Zsh Plugins

zinit snippet OMZ::plugins/composer/composer.plugin.zsh
zinit snippet OMZ::plugins/laravel5/laravel5.plugin.zsh
zinit snippet OMZ::plugins/docker/_docker
zinit snippet OMZ::plugins/docker-compose/docker-compose.plugin.zsh
# zinit snippet OMZ::plugins/z/z.plugin.zsh

### Zsh Plugins
zinit light rupa/z
zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light romkatv/powerlevel10k

### LS_COLORS
#zinit ice atclone"gdircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh"
#zinit load trapd00r/LS_COLORS
zinit ice atclone"gdircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

### Goodjack
#### Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

#### Google Cloud SDK
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

#### Git GPG
# https://unix.stackexchange.com/questions/608842/zshrc-export-gpg-tty-tty-says-not-a-tty
export GPG_TTY=${TTY}

#### Alias
alias sail='bash vendor/bin/sail'
alias myip='curl checkip.amazonaws.com'

#### AWS MSSH
function mssh() {
    command mssh ubuntu@${1}
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"
test -e /Users/goodjack/.iterm2_shell_integration.zsh && source /Users/goodjack/.iterm2_shell_integration.zsh || true

# less with source-highlight
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '
