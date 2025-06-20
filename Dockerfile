FROM paulgauthier/aider-full:latest

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y tmux unzip ripgrep fd-find curl liblua5.1-0-dev luarocks && \
    rm -rf /var/lib/apt/lists/*

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz

# Add Neovim to PATH globally
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"

# Ensure correct permissions
RUN chown -R appuser:appuser /app

USER appuser
ENV HOME=/app
WORKDIR /app

# Set up Neovim config (create parent dir just in case)
RUN mkdir -p /app/.config && \
    git clone https://github.com/romanab/kickstart.nvim.git /app/.config/nvim

# Tmux configuration
RUN echo 'set-option -sg escape-time 10' >> /app/.tmux.conf


ENTRYPOINT ["/usr/bin/tmux"]
