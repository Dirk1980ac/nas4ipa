FROM registry.fedoraproject.org/fedora-bootc:latest

COPY etc /etc
COPY usr /usr

RUN dnf update -y && \
    dnf install -y NetworkManager-tui cockpit mc htop zsh greenboot greenboot-default-health-checks firewalld freeipa-client \
    glibc-langpack-de && \
    dnf autoremove -y && \
    dnf clean all && \
    systemctl enable nfs-server cockpit.socket firstboot && \
    mkdir -p /export
