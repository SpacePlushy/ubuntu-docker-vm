FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    build-essential \
    sudo \
    vim \
    nano \
    htop \
    net-tools \
    iputils-ping \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with limited privileges
RUN useradd -m -s /bin/bash -u 1000 aiuser && \
    echo 'aiuser ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/bin/apt' >> /etc/sudoers.d/aiuser

# Create working directory
RUN mkdir -p /workspace && chown -R aiuser:aiuser /workspace

# Switch to non-root user
USER aiuser
WORKDIR /workspace

# Set up sparse file for efficient storage
RUN truncate -s 0 /workspace/.sparse-marker

CMD ["/bin/bash"]