# QIIME 2 VM Playbooks

## Release Builds Quickstart

### Prereqs

- Packer
- AWS Account

### Version Bumping

Edit the first two lines of `Makefile`:

```bash
QIIME2_RELEASE := foo
HOSTNAME := qiime2corefoo
```

Please ensure that `QIIME2_RELEASE` is a valid release, with a published environment file on https://data.qiime2.org, and that `HOSTNAME` adheres to [system requirements](https://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_hostnames).

### Docker

```bash
# Build the docker image locally
$ make docker
# After inspecting the image, login to Docker Hub:
$ docker login
# Then push the build up:
$ docker push qiime2/core
```

### Virtualbox

```bash
# First, prep an OVF with base Ubuntu 16.04
$ make vbox-bootstrap
# Build the Virtualbox machine locally
$ make vbox
# Once done, upload the VMDK file to distribution server
```

### Amazon AWS AMI

```bash
# Set up AWS credentials
$ export AWS_ACCESS_KEY_ID='AK123'
$ export AWS_SECRET_ACCESS_KEY='abc123'
# Build the AWS image
$ make aws
# Once done and tested, make the AMI public through the AWS interface
```
