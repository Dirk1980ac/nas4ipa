FROM registry.fedoraproject.org/fedora-bootc:latest

# Build ID to identify the generated image
ARG buildid="Testbuild"

# Set some image labels for identification
LABEL org.opencontainers.image.version="$buildid"
LABEL org.opencontainers.image.authors="Dirk Gottschalk"
LABEL org.opencontainers.image.name="NAS4IPA"
LABEL org.opencontainers.image.desciption="A bootc based NAS image for FreeIPA environments"

# Copy local files
COPY etc /etc
COPY usr /usr

# Install needed software, update system and clean dnf caches
RUN <<EOF
set -eu

echo "IMAGE_ID=$org.opencontainers.image.name" >>/usr/lib/os-release
echo "IMAGE_VERSION=$org.opencontainers.image.name" >>/usr/lib/os-release

dnf install -y --setopt="install_weak_deps=False" \
	NetworkManager-tui \
	cockpit \
	mc \
	htop \
	zsh \
	greenboot \
	watchdog \
	greenboot-default-health-checks \
	firewalld \
	freeipa-client \
	glibc-langpack-de \
	radicale \
	httpd \
	mod_auth_gssapi

dnf clean all

systemctl enable \
	cockpit.socket \
	watchdog \
	firstboot \
	httpd \
	radicale \
	greenboot-task-runner \
	greenboot-healthcheck \
	greenboot-status \
	greenboot-loading-message \
	greenboot-grub2-set-counter \
	greenboot-grub2-set-success redboot-auto-reboot \
	redboot-task-runner \
	greenboot-rpm-ostree-grub2-check-fallback
EOF
