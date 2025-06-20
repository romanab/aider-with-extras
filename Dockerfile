# Start FROM the image you built previously.
FROM paulgauthier/aider-full:latest

# Switch to the root user to install new software system-wide.
USER root

# Install tmux, curl, and clean up.
RUN apt-get update && apt-get install -y \
    tmux \
    curl \
    unzip \
    ripgrep \
    fd-find \
    curl \
    liblua5.1-0-dev \
    luarocks \
    && rm -rf /var/lib/apt/lists/*

# Download and install the pre-compiled Neovim binary into /opt
WORKDIR /tmp

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz

# --- THIS IS THE NEW PART ---

# Copy our custom entrypoint script into the image
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make sure it's executable (good practice, in case you forget chmod locally)
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch back to the non-root user. The entrypoint script will run as this user.
USER appuser
WORKDIR /app

# Set the entrypoint to our script.
ENTRYPOINT ["entrypoint.sh"]

# Set the default command that the entrypoint script will execute.
CMD ["tmux"]
