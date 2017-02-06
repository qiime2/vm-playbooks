CORE_VERSION := 2.0.6
HOSTNAME := qiime2core2-0-6

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  docker            to build a Docker image"
	@echo "  aws               to build an AWS image"
	@echo "  virtualbox        to build a Virtualbox image"
	@echo "  workshop-deploy   to build and deploy a workshop cluster"
	@echo "  workshop-destroy  to tear down a workshop cluster"

.PHONY: docker
docker:
	packer build \
		-only=docker \
		-var-file=variables.json \
		qiime2core.json
	docker run -i -t -d --name q2 qiime2/core:latest /bin/bash
	docker commit \
		-c 'ENV PATH=/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
		-c 'ENV LC_ALL=C.UTF-8' \
		-c 'ENV LANG=C.UTF-8' \
		-c 'VOLUME ["/data"]' \
		-c 'WORKDIR /data' \
		q2 qiime2/core:latest
	docker stop q2 && docker rm q2 && docker tag qiime2/core:latest qiime2/core:$(CORE_VERSION)

.PHONY: aws
aws:
	packer build \
		-only=amazon-ebs \
		-var-file=variables.json \
		-var 'core_version=$(CORE_VERSION)' \
		-var 'hostname=$(HOSTNAME)' \
		qiime2core.json

.PHONY: virtualbox
virtualbox:
	packer build \
		-only=virtualbox-iso \
		-var-file=variables.json \
		-var 'core_version=$(CORE_VERSION)' \
		-var 'hostname=$(HOSTNAME)' \
		-on-error=ask \
		qiime2core.json

.PHONY: vbox-devel
vbox-devel:
	vagrant up

.PHONY: vbox-devel-destroy
vbox-devel-destroy:
	vagrant destroy --force

.PHONY: workshop-deploy
workshop-deploy:
	ansible-playbook -i inventory playbooks/aws-workshop-allocate.yml

.PHONY: workshop-destroy
workshop-destroy:
	ansible-playbook -i inventory playbooks/aws-workshop-destroy.yml
