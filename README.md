# Ansible_config

This repository will hold my personnal configs for the server(s) that I will run and deploy for personnal use using Ansible.

## 1. Requirements

### 1.1 General requirements

This setup assumes that you have key based ssh access to your server.
To setup a new key, you can use the following.

1. Generate a new ssh key

```sh
ssh-keygen -t ed25516 -a 100 -f ~/.ssh/enter_your_custom_name
```

*Note: You can use the ```-t rsa -b 4096``` option instead of ```-t ed25519``` to generate a key with comparable security and better compatibility at the price of creation and login performance)*

1. Register your ssh key with your agent

```sh
eval $(ssh-agent -s)  # This starts your agent and gives you its PID
ssh-add /path/to/your/private/key/file
```

3. Copy the ssh key to your server

```sh
ssh-copy-id -i /path/to/your/private/key/file username@ip_address
```

### 1.2 Server specific requirmeents

#### 1.2.1 Pi

```python-is-python3``` has been purged manually to prevent ansible decrepation warnings due to the prescence of ```/usr/bin/python```.
I tried top set the variable ```ansible_interpreter=/usr/bin/python3``` explicitely but it did not remove the warning message.


## Credits/Sources

https://docs.ansible.com/ansible/latest/index.html

https://docs.docker.com/

https://github.com/shaderecker/ansible-pihole/tree/master/roles/updates (no liscence explicitely specified)
