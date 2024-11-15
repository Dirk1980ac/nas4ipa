FROM registry.fedoraproject.org/fedora-bootc:latest

COPY etc /etc

RUN dnf update -y && \
    dnf install -y NetworkManager-tui cockpit mc htop zsh greenboot greenboot-default-health-checks firewalld freeipa-client && \
    dnf autoremove -y \
    dnf clean all && \
    systemctl enable nfs-server cockpit.socket && \
    mkdir -p /export
