FROM registry.fedoraproject.org/fedora-bootc:latest

ENV imagename="gatekeeper-os"

RUN dnf install -y --setopt="install_weak_deps=False" \
	NetworkManager-tui \
	cockpit \
	cockpit-storaged \
	cockpit-selinux \
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


# Build ID to identify the generated image
ARG buildid="unset"

# Authorized_keys formatted file content. - NOT it's filename.
ARG sshkeys=""

# Build for Raspberry Pi
ARG build_rpi="false"

# Set some image labels for identification
LABEL org.opencontainers.image.version=${buildid}
LABEL org.opencontainers.image.authors="Dirk Gottschalk"
LABEL org.opencontainers.image.name=${imagename}
LABEL org.opencontainers.image.desciption="A bootc based NAS image for FreeIPA environments"

# Copy local files
# Copy prepared files
COPY --chmod=600 configs/ssh-00-0local.conf /etc/ssh/sshd_config.d/00-0local.conf
COPY --chmod=644 configs/rpm-ostreed.conf /etc/rpm-ostreed.conf
COPY --chmod=644 configs/watchdog.conf /etc/watchdog.conf
COPY --chmod=700 scripts/bootupctl-shim /usr/bin/bootupctl
COPY --chmod=600 configs/sudoers-wheel /etc/sudoers.d/wheel
COPY --chmod=600 configs/jail-10-sshd.conf /etc/fail2ban/jail.d/10-sshd.conf
COPY --chmod=644 configs/dconf-user /usr/share/dconf/profile/user
COPY --chmod=644 configs/dconf-00-extensions /etc/dconf/db/local.d/00-extensions
COPY --chmod=644 configs/tmpfiles.conf /usr/lib/tmpfiles.d/cardterm.conf
COPY --chmod=644 configs/sysusers-yggdrasil.conf /usr/lib/sysusers.d/yggdrasil.conf

# Image signature settings
COPY --chmod=644 configs/registries-sigstore.yaml /usr/share/containers/registries.d/sigstore.yaml
COPY --chmod=644 configs/containers-toolbox.conf /etc/containers/toolbox.conf
COPY --chmod=644 configs/containers-policy.json /usr/share/containers/policy.json
COPY --chmod=644 keys /usr/share/containers/keys

# Inject formware for RaspBerry Pi if 'build_rpi' is true
RUN --mount=type=bind,source=./scripts,target=/scripts <<EORUN
set -eu

if [[ "${build_rpi}" == true ]] && [[ "$(arch)" == "aarch64" ]]; then
	dnf install -y bcm2711-firmware uboot-images-armv8
	cp -P /usr/share/uboot/rpi_arm64/u-boot.bin /boot/efi/rpi-u-boot.bin
	mkdir -p /usr/lib/bootc-raspi-firmwares
	cp -a /boot/efi/. /usr/lib/bootc-raspi-firmwares/
	dnf remove -y bcm2711-firmware uboot-images-armv8
	mkdir /usr/bin/bootupctl-orig
	mv /usr/bin/bootupctl /usr/bin/bootupctl-orig/
	cp /scripts/bootupctl-shim /usr/bin/bootupctl
fi
EORUN

# Install needed software, update system and clean dnf caches
RUN <<EOF
set -eu

echo "IMAGE_ID=${imagename}" >>/usr/lib/os-release
echo "IMAGE_VERSION=${buildid}" >>/usr/lib/os-release

if [[ -n "$sshkeys" ]]; then
	mkdir -p /usr/ssh
	echo $sshkeys > /usr/ssh/root.pub
fi

mkdir -p /var/storage

systemctl enable \
	cockpit.socket \
	watchdog \
	httpd \
	radicale \
	greenboot-task-runner \
	greenboot-healthcheck \
	greenboot-status \
	greenboot-loading-message \
	greenboot-grub2-set-counter \
	greenboot-grub2-set-success redboot-auto-reboot \
	redboot-task-runner \
	greenboot-rpm-ostree-grub2-check-fallback \
	bootloader-update.service

dnf -y clean all
rm -rf /var/{cache,log,tmp,spool}/*
bootc container lint
EOF
