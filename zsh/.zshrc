# @profiling enable the following when you want to see what is taking a long
#            time to load.  To use:
#   - Change this file
#   - Reload by running `exec zsh`
#   - Run `zprof` to see the results
#
# and another way to track this is
#
#   - /usr/bin/time zsh -i -c exit
#   - for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;
#
# zmodload zsh/zprof

# Add `~/bin` to the `$PATH`
#export PATH="/usr/local/bin:$PATH"


export DOTFILES=$HOME/dotfiles  # path to dotfiles
export GPG_TTY=$(tty)           # GPG git commit signing

# ------------------------------------------------------------------------------
# ZSH Config
# ------------------------------------------------------------------------------
# @note `path` is an array zsh keeps in sync with PATH. -U drops duplicates,
# so adding a folder twice is harmless. Add folders with:
#
#     path+=(/some/dir)          end of PATH
#     path=(/some/dir $path)     front of PATH (wins over the others)
typeset -U path

export ZSH=$HOME/.oh-my-zsh     # Path to oh-my-zsh installation

# @note oh-my-zsh runs compinit itself when it's sourced below, so we don't run
# it here too.

# zsh theme name - see `themes/thomas.zsh-theme`
ZSH_THEME="thomas"

# auto-update zsh after 13 days
export UPDATE_ZSH_DAYS=13

# zsh plugins to improve your workflow
plugins=(
    # syntax highlight man pages for easier reading
    colored-man-pages
    # syntax higlight by file extension
    colorize
    # shortcuts like `hidefiles` & `showfiles`
    macos
)

# be sure to source this after you specify the plugins above or they will all
# not work as expected
source $ZSH/oh-my-zsh.sh



# ------------------------------------------------------------------------------
# USER SETTINGS
# ------------------------------------------------------------------------------

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Load shell dotfiles, and user specific configs:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extras can be used for other settings you don’t want to commit.
for file in ~/.{path,extras}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;




# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------

# quick access to config files
alias dotfiles="cd ~/dotfiles" # open dotfiles

# docker
alias containers="docker ps --format 'table {{.Names}}\t{{.Image}}'"

# ------------------------------------------------------------------------------
# NODE
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"'

# ------------------------------------------------------------------------------
# JAVA
# ------------------------------------------------------------------------------

# @performance jenv is slow.  This is a lazy loading technique we learned from
# https://github.com/shihyuho/zsh-jenv-lazy/blob/master/jenv-lazy.plugin.zsh
# I have no idea why I didn't just install as a custom plugin.  Likely, I was
# frustrated that jenv was taking 50% of the total load time.
export JENV_ROOT="${JENV_ROOT:=${HOME}/.jenv}"
if ! type jenv > /dev/null && [ -f "${JENV_ROOT}/bin/jenv" ]; then
    path=($JENV_ROOT/bin $path)
fi

# Lazy load jenv
if type jenv > /dev/null; then
    path=($JENV_ROOT/bin $JENV_ROOT/shims $path)
    function jenv() {
        unset -f jenv
        eval "$(command jenv init -)"
        jenv $@
    }
fi


# ------------------------------------------------------------------------------
# POSTGRES
# ------------------------------------------------------------------------------
path+=(/Applications/Postgres.app/Contents/Versions/latest/bin)
path=($HOMEBREW_PREFIX/opt/libpq/bin $path)


# ------------------------------------------------------------------------------
# Clojure
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Wireshark
# ------------------------------------------------------------------------------

alias cap="dumpcap -i 1 -i 10 -w ~/wireshark-capture/data.pcapng -b filesize:500000 -b files:5"

path+=(/Applications/Wireshark.app/Contents/MacOS)

# ------------------------------------------------------------------------------
# Rust
# ------------------------------------------------------------------------------

path+=($HOME/.cargo/bin)


# ------------------------------------------------------------------------------
# Odin
# ------------------------------------------------------------------------------

# odin-macos-arm64-nightly+2025-04-03
alias odin="$HOME/code/lang/odin/odin"

# ------------------------------------------------------------------------------
# JAI
# ------------------------------------------------------------------------------

alias jai="$HOME/code/lang/jai/bin/jai-macos"

# ------------------------------------------------------------------------------
# Kamal
# ------------------------------------------------------------------------------
# run `loadruby` to install (only if needed) Ruby 3.4.1 and then source chruby
# so we can use our version of Ruby in the current session.  The reason for
# this is because I don't require Ruby in my regular work, so no need to add
# to the session unless I call for it.
# https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/
alias loadruby='
    version=3.4.1
    source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh
    source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh

    if ! chruby | grep -q "ruby-${version}"; then
        echo "Ruby ${version} not found, installing..."
        ruby-install ruby-${version}
        echo "Ruby ${version} installed. Now enabling..."
        chruby ruby-${version}
    else
      echo "Ruby ${version} found, enabling..."
      chruby ruby-${version}
    fi'

# ------------------------------------------------------------------------------
# Syntax highlighting
# ------------------------------------------------------------------------------

# @note must stay the last thing in this file. It wraps every widget defined
# before it, so anything loaded after it won't be highlighted.
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
