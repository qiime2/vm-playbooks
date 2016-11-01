# Workshops Playbooks

Note, ansible still requires Python 2
([3 is coming](http://docs.ansible.com/ansible/python_3_support.html)).


## Quickstart

### Setup
```bash
$ virtualenv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
$ export AWS_ACCESS_KEY_ID='AK123'
$ export AWS_SECRET_ACCESS_KEY='abc123'
```

Since we don't use R53 for our DNS yet, the script assumes that you have
allocated an EIP, and updated the value in `vars.yml` accordingly.

### Allocate infrastructure
```bash
$ ansible-playbook -i inventory allocate.yml
```

### Destroy infrastructure
```bash
$ ansible-playbook -i inventory destroy.yml
```
