#!/bin/sh

# Exit immediately if a command fails
set -e

# --- One-time setup for the /app volume ---

echo "Creating/Updating .tmux.conf..."
cat << EOF > /app/.tmux.conf
# Force tmux to run an interactive BASH LOGIN shell for every new window/pane.
# The "-l" flag is what makes it a login shell.
# A login shell will reliably source /app/.profile to set the environment.
set-option -g default-command "bash -l"

# Set a shorter escape time for a more responsive feel.
set-option -sg escape-time 10
EOF

# Clone Neovim config only if it doesn't already exist.
if [ ! -d "/app/.config/nvim/.git" ]; then
  echo "First run: Neovim config not found. Cloning kickstart.nvim..."
  git clone https://github.com/romanab/kickstart.nvim.git /app/.config/nvim
fi

# Add the PATH to .profile, which is the file read by login shells.
if ! grep -q "nvim-linux-x86_64" /app/.profile 2>/dev/null; then
    echo "First run: Adding nvim to PATH in .profile..."
    # Add a newline for safety, then our comments and command.
    echo '' >> /app/.profile
    echo '# Add Neovim to the PATH for login shells' >> /app/.profile
    echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >> /app/.profile
fi

echo "Configuration complete. Starting tmux..."
# Execute the command passed to this script (which will be "tmux" from the Dockerfile CMD)
exec "$@"
