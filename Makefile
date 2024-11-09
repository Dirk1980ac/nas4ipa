build:
	sudo podman build -t nas4ipa:latest .

tag:
	sudo podman tag nas4ipa:latest dirk1980/nas4ipa:latest

push:
	sudo podman push dirk1980/nas4ipa:latest

all:	build tag 
