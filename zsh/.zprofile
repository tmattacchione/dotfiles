# @note sets up Homebrew: adds it to PATH and sets HOMEBREW_PREFIX
# (/opt/homebrew), so the rest of our config can use the variable instead of
# running `brew --prefix`, which is slow because brew is a Ruby program.
eval "$(/opt/homebrew/bin/brew shellenv)"
