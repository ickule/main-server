# Ansible_config

This repository will hold my personnal configs for the server(s) that I will run and deploy for personnal use using Ansible.

## 1. Requirements

### 1.1 General requirements

This setup assumes that you have key based ssh access to your server.
To setup a new key, you can use the following.

* Generate a new ssh key

    ```sh
    ssh-keygen -t ed25516 -a 128 -f ~/.ssh/enter_your_custom_name
    ```

*Note: You can use the ```-t rsa -b 4096``` option instead of ```-t ed25519``` to generate a key with comparable security and better compatibility at the price of creation and login performance)*

* Register your ssh key with your agent

    ```sh
    eval $(ssh-agent -s)  # This starts your agent and gives you its PID
    ssh-add /path/to/your/private/key/file
    ```

* Copy the ssh key to your server

    ```sh
    ssh-copy-id -i /path/to/your/private/key/file username@ip_address
    ```

### 1.2 Creating a secret vault

Create a new secret vault with ansible:

```bash
ansible-vault create /secret/folder/path/secret.yml
```

### 1.3 Installation

For reference, my Ubuntu server installation looks like the folowing and is done through terminal install:

1. Language -> English (UK)
2. Installer update avaiilable -> Update to the new installer
3. Keyboard configuration -> English (US), English (US)
4. Choose type of install -> Ubuntu Server, Search for third-party drivers
5. Network connections -> defaults
6. Configure proxy -> empty
7. Configure Ubuntu archive mirror -> default
8. Guided storage configuration -> Use entire disk, set up disk as LVM group, Encrypt teh LVM group with LUKS
9. Profile setup -> to preference
10. SSH Setup -> Install OpenSSH server
11. Third party driver -> install all
12. Featured Server Snaps -> none

## 2. Using the ansible playbook

With a system featuring the previous requirements, we can run the playbooks.

First, run the setup playbook. It will setup the system by:

* Add dropbear supportr for ssh remote unlocking
* Updating it to the latest version
* Allow passwordless sudo for your user
* Disable suspend when lid is closed
* Update the hostname
* Update ssh configuration to be more secure
* setup unatended upgrades with email notifications
* Install docker
* Install zfs

```bash
ansible-playbook setup.yml
```

 Now ios a good timne to create an encryption key for zfs and setup any new zfs pool for you data.
A key can be generated with teh following:

```bash
mkdir -p /path/to/key/folder
chmod 700 /path/to/key/folder
dd if=/dev/urandom of=/path/to/key/file bs=32 count=1
chmod 600 /path/to/key/file
```

A ZFS pool with an encrypted subpool can be added like so:

```bash
ls -l /dev/disk/by-id/ (to identify disks by id)
zpool create $pool_name mirror drive1-id drive2-id
zfs create $pool_name/$sub_pool -o encryption=on -o keyformat=raw -o  keylocation=file:///path/to/key/file
zpool set autotrim=on $pool_name
zfs set compression=lz4 $pool_name
zfs set atime=off $pool_name
```

With the ZFS storage setup, we can now proceed with installing the services:

* Install and configure a samba share
* Install script that update the IP of your local computer to OVH via DynDNS
* Build and deploy a nextcloud stack featuring reverse proxy and SSL certificate management

```bash
ansible-playbook deploy.yml
```

## Credits/Sources

<https://docs.ansible.com/ansible/latest/index.html>

<https://docs.docker.com>

<https://github.com/shaderecker/ansible-pihole/tree/master/roles/updates>

<https://khady.info/debian-remove-swap.html>

<https://somedudesays.com/2021/08/the-basic-guide-to-working-with-zfs>

<https://wiki.debian.org>

<https://github.com/chungy/zfs-boottime-encryption>

<https://github.com/notthebee/ansible-easy-vpn>

<https://github.com/notthebee/infra>

<https://github.com/chriswayg/ansible-msmtp-mailer>

<https://www.cyberciti.biz/security/how-to-unlock-luks-using-dropbear-ssh-keys-remotely-in-linux/>
