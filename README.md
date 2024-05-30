# QIIME 2 VM Playbooks

## Release Builds Quickstart

### Prereqs

- Packer
- AWS Account
- VirtualBox (latest version)

### Version Bumping

Edit the first two lines of `Makefile`:

```bash
QIIME2_RELEASE := foo
DISTRIBUTION := bar
HOSTNAME := qiime2barfoo
```

Please ensure that `QIIME2_RELEASE` is a valid release, with a published environment file on https://data.qiime2.org, and that `HOSTNAME` adheres to [system requirements](https://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_hostnames).

### Docker

```bash
# Build the docker image locally
$ make docker
# After inspecting the image, login to Docker Hub:
$ docker login quay.io
# Then push both latest and version builds up:
$ docker push quay.io/qiime2/DISTRO:latest
$ docker push quay.io/qiime2/DISTRO:20XX.YY
# LOGOUT
$ docker logout quay.io
```

### Virtualbox

```bash
# Build the Virtualbox machine locally
$ make vbox
# Once done, zip the VMDK and OVF files, and upload to distribution server.
# Match the naming conventions of previous releases for the zip file, its
# extracted directory, and archive members.
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
