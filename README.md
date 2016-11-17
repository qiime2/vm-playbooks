# QIIME 2 Playbooks

Note, Ansible still requires Python 2
([3 is coming](http://docs.ansible.com/ansible/python_3_support.html)).


## Release Images Quickstart

### Prereqs

- Packer
- AWS Account

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
# Build the Virtualbox machine locally
$ make virtualbox
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

## Workshop Quickstart

### Prereqs

- Ansible
- Python 2
- AWS Account
- A domain to point the infrastructure to
- A tarball (`certs.tar.gz`) that contains a valid `/etc/letsencrypt` dir
  (including certs, config, etc.)

### Setup

```bash
$ virtualenv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
$ export AWS_ACCESS_KEY_ID='AK123'
$ export AWS_SECRET_ACCESS_KEY='abc123'
$ export QIIME_WORKSHOP_NAME='QIIME 2 Workshop'
$ export QIIME_EIP='1.2.3.4'
$ export QIIME_SSL_DOMAIN='workshop.example.org'
$ export QIIME_SSL_EMAIL='example@example.org'
```

- `QIIME_EIP` is the AWS Elastic IP that should be associated with the jump host.
- `QIIME_DOMAIN` is the domain to secure an SSL from Let's Encrypt for.
- `QIIME_SSL_EMAIL` is the administrative email to file with Let's Encrypt.

### Allocate infrastructure

```bash
$ ansible-playbook -i inventory playbooks/aws-workshop-allocate.yml
```

### Destroy all infrastructure (including EBS Volumes)

```bash
$ ansible-playbook -i inventory playbooks/aws-workshop-destroy.yml
```
