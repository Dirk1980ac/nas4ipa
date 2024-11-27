FROM registry.fedoraproject.org/fedora-bootc:latest

# Copy local files
COPY etc /etc
COPY usr /usr

# Create Directory for NFS exports
RUN mkdir -p /var/storage

# Install needed software, update system and clean dnf caches
RUN dnf install -y NetworkManager-tui cockpit mc htop zsh greenboot watchdog \
    greenboot-default-health-checks firewalld freeipa-client glibc-langpack-de && \
    dnf clean all  && \
    systemctl enable cockpit.socket watchdog firstboot \
    greenboot-task-runner greenboot-healthcheck greenboot-status \
    greenboot-loading-message greenboot-grub2-set-counter greenboot-grub2-set-success \
    greenboot-rpm-ostree-grub2-check-fallback redboot-auto-reboot redboot-task-runner
