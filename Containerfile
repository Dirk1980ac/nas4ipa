FROM registry.fedoraproject.org/fedora-bootc:latest

# Copy local files
COPY etc /etc
COPY usr /usr

# Create Directory for NFS exports
RUN mkdir -p /var/storage

# Install needed software, update system and clean dnf caches
RUN dnf install -y NetworkManager-tui cockpit mc htop zsh greenboot watchdog \
    greenboot-default-health-checks firewalld freeipa-client glibc-langpack-de && \
    dnf clean all

# Enable services on boot
RUN systemctl enable cockpit.socket watchdog firstboot

# Enable greenboot
RUN systemctl enable greenboot-grub2-set-counter.service \
    greenboot-grub2-set-success.service \
    greenboot-healthcheck.service \
    greenboot-loading-message.service \
    greenboot-rpm-ostree-grub2-check-fallback.service \
    greenboot-status.service \
    greenboot-task-runner.service
