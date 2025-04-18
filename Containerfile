FROM registry.fedoraproject.org/fedora-bootc:latest

# Build ID to identify the generated image
ARG buildid

# Set some image labels for identification
LABEL image.name="NAS4IPA"
LABEL image.descr="A bootc based NAS for FreeIPA environments"
LABEL vendor.name="Dirk Gottschalk"
LABEL vendor.email="dirk.gottschalk1980@googlemail.com"
LABEL image.build-id="$buildid"

# Copy local files
COPY etc /etc
COPY usr /usr

# Create Directory for NFS exports
RUN mkdir -p /var/storage

# Install needed software, update system and clean dnf caches
RUN <<EOF
set -eu

mkdir -p /var/storage
mkdir -p /usr/bootc-image
echo $buildid > /usr/bootc-image/build-od

dnf install -y --setopt="install_weak_deps=False" \
	NetworkManager-tui cockpit mc htop zsh greenboot \
	watchdog greenboot-default-health-checks firewalld freeipa-client \
	glibc-langpack-de radicale httpd mod_auth_gssapi

dnf clean all

systemctl enable cockpit.socket watchdog firstboot httpd radicale\
	greenboot-task-runner greenboot-healthcheck greenboot-status \
	greenboot-loading-message greenboot-grub2-set-counter \
	greenboot-grub2-set-success redboot-auto-reboot \
	redboot-task-runner greenboot-rpm-ostree-grub2-check-fallback
EOF
