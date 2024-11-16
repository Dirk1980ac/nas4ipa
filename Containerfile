FROM registry.fedoraproject.org/fedora-bootc:latest

# Copy local files
COPY etc /etc
COPY usr /usr

# Create Directory for NFS exports
RUN mkdir -p /export

# Install needed software, update system and clean dnf caches
RUN dnf install -y NetworkManager-tui cockpit mc htop zsh greenboot greenboot-default-health-checks firewalld freeipa-client glibc-langpack-de && \
    dnf update -y && \
    dnf clean all

# Enable services on boot
RUN systemctl enable cockpit.socket firstboot
