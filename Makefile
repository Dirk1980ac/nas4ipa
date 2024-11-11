all:	image push

image:
	sudo podman pull registry.fedoraproject.org/fedora-bootc:41
	sudo podman build --platform linux/amd64,linux/arm64  --manifest docker.io/dirk1980/nas4ipa:latest .

push:
	sudo podman manifest push docker.io/dirk1980/nas4ipa:latest

