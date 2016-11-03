# Workshops Playbooks

Note, Ansible still requires Python 2
([3 is coming](http://docs.ansible.com/ansible/python_3_support.html)).


## Quickstart

### Prereqs

- Ansible
- Python 2
- AWS Account
- A domain to point the infrastructure to

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
$ ansible-playbook -i inventory allocate.yml
```

### Destroy all infrastructure (including EBS Volumes)

```bash
$ ansible-playbook -i inventory destroy.yml
```
