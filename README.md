# Ansible_config

This repository will hold my personnal configs for the server(s) that I will run and deploy for personnal use using Ansible.

## 1. Requirements

### 1.1 General requirements

This setup assumes that you have key based ssh access to your server.
To setup a new key, you can use the following.

1. Genrate a new ssh key

```bash
ssh-keygen -t ed25516 -a 100 -f ~/.ssh/enter_your_custom_name
```

*Note: You can use the ```-t rsa -b 4096``` option instead of ```-t ed25519``` to generate a key with comparable security and better compatibility at the price of creation and login performance)*

1. Register your ssh key with your agent

```bash
eval $(ssh-agent -s)  # This starts your agent and gives you its PID
ssh-add /path/to/your/private/key/file
```

3. Copy the ssh key to your server

```bash
ssh-copy-id -i /path/to/your/private/key/file username@ip_address
```

### 1.2 Server specific requirmeents

#### 1.2.1 Pi

```python-is-python3``` has been purged manually to prevent ansible decrepation warnings due to the prescence of ```/usr/bin/python```.
