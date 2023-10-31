QIIME2_RELEASE := 2023.9
HOSTNAME := qiime2amplicon2023-9

BOOTSTRAPPED_VBOX = output-virtualbox-iso/QIIME_2_BASE_IMAGE.ovf

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  docker            to build a Docker image"
	@echo "  vbox-bootstrap    to prep a Virtualbox OVF"
	@echo "  vbox              to build a Virtualbox image"
	@echo "  aws               to build an AWS image"

.PHONY: docker
docker:
	docker build \
		-t quay.io/qiime2/amplicon:$(QIIME2_RELEASE) \
		-t quay.io/qiime2/amplicon:latest \
		--build-arg QIIME2_RELEASE=$(QIIME2_RELEASE) docker

$(BOOTSTRAPPED_VBOX):
	packer build \
		-var 'QIIME2_RELEASE=$(QIIME2_RELEASE)' \
		-var 'HOSTNAME=$(HOSTNAME)' \
		-on-error=ask \
		packer_vars/vbox-bootstrap.json

.PHONY: vbox-bootstrap
vbox-bootstrap: $(BOOTSTRAPPED_VBOX)

vbox: $(BOOTSTRAPPED_VBOX)
	packer build \
		-var 'QIIME2_RELEASE=$(QIIME2_RELEASE)' \
		-var 'HOSTNAME=$(HOSTNAME)' \
		-on-error=ask \
		packer_vars/qiime2-vbox.json

.PHONY: aws
aws:
	packer build \
		-var 'QIIME2_RELEASE=$(QIIME2_RELEASE)' \
		-var 'HOSTNAME=$(HOSTNAME)' \
		-on-error=ask \
		packer_vars/qiime2-aws.json
