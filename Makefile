build:
	sudo podman build --platform linux/amd64,linux/arm64  --manifest dirk1980/nas4ipa:latest .

push:
	sudo podman manifest push dirk1980/nas4ipa:latest

all:	build push
