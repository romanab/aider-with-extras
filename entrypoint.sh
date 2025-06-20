#!/bin/sh

# Exit immediately if a command fails
set -e

# --- One-time setup ---
# This script runs every time the container starts.
# We check if the config files exist in the /app volume before creating them.
# This makes the setup idempotent (it won't re-clone every time you start).

# We check for the .git directory as a robust sign of a successful clone.
if [ ! -d "/app/.config/nvim/.git" ]; then
  echo "First run: Neovim config not found. Cloning kickstart.nvim..."
  # git clone will create the parent /app/.config directory for us
  git clone https://github.com/romanab/kickstart.nvim.git /app/.config/nvim
fi

if [ ! -f "/app/.tmux.conf" ]; then
  echo "First run: .tmux.conf not found. Creating..."
  echo 'set-option -sg escape-time 10' > /app/.tmux.conf
fi

# Add nvim to PATH in .bashrc if it's not already there
if ! grep -q "nvim-linux64" /app/.bashrc 2>/dev/null; then
    echo "First run: Adding nvim to PATH in .bashrc"
    echo 'export PATH="/opt/nvim-linux64/bin:$PATH"' >> /app/.bashrc
fi

# --- Execute the main command ---
# 'exec "$@"' runs the command passed to the script.
# In our Dockerfile, this will be "tmux" (from the CMD instruction).
exec "$@"
