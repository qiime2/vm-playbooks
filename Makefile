QIIME2_RELEASE := 2017.4
HOSTNAME := qiime2core2017-4

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
		-t qiime2/core:$(QIIME2_RELEASE) \
		--build-arg QIIME2_RELEASE=$(QIIME2_RELEASE) .

.PHONY: vbox-bootstrap
vbox-bootstrap:
	packer build \
		-var 'QIIME2_RELEASE=$(QIIME2_RELEASE)' \
		-var 'HOSTNAME=$(HOSTNAME)' \
		-on-error=ask \
		packer_vars/vbox-bootstrap.json

.PHONY: vbox
vbox:
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
