CORE_VERSION := "2.0.6"

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  docker      to a Docker image"
	@echo "  aws         to build an AWS image"
	@echo "  virtualbox  to build a Virtualbox image"

.PHONY: docker
docker:
	packer build --only=docker qiime2core.json
	docker run -i -t -d --name q2 qiime2/core:latest /bin/bash
	docker commit -c 'ENV PATH=/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' -c 'ENV LC_ALL=C.UTF-8' -c 'ENV LANG=C.UTF-8' -c 'VOLUME ["/data"]' q2 qiime2/core:latest
	docker stop q2 && docker rm q2 && docker tag qiime2/core:latest qiime2/core:$(CORE_VERSION)
