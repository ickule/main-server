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

Cretae a new secret vault with ansible:

```bash
ansible-vault create /secret/folder/path/secret.yml
```

### 1.3 Installation

For reference, my Debian server installation looks like the folowing and is done through terminal install:

1. Language -> to preference (English)
2. Country, territory or area -> to preference (United Kinmgdom)
3. Keymap -> to preference (British English)
4. Hostanme -> to convenience
5. Domain name -> to preference (skip)
6. root password -> skip (Will use user password for sudo automatically)
7. User -> to preference
8. User password -> to preference
9. Partitionning method -> Guided - use entire disk and set up encrypted LVM
10. Partitionning scheme -> All files in one partition
11. Debian archive mirror country -> United Kingdom
12. Debian archive mirror -> deb.debian.org
13. HTTP proxy information -> skip
14. Participate in teh package usage survey -> to convenience (No)
15. Choose software to  install -> SSH server, all other options disabled
16. Install GRUB boot loader to your primary drive -> Yes
17. Select disk for bootloader installation -> to preference

```python3``` is installed manually as it is necessary for ansible operation

```bash
sudo apt install python3
```

I also remove the default swap and extend the partition to the maximum available space manually.

```bash
swapoff -a
lvremove /dev/$hostname-vg/swap_1
lvextend -l +100%FREE /dev/$hostname-vg/root
resize2fs /dev/$hostname-vg/root
sed -i -e 's/^/# /' /etc/initramfs-tools/conf.d/resume
sed -i -e 's|\(/dev/mapper/$hostname--vg-swap_1\)|# \1|' /etc/fstab (-- is intentionnal)
update-initramfs -u
```

## 2. Using the ansible playbook

With a system featuring the previosu requirements, we can run the playbooks.

First, run the setup playbook. It will setup the system by:

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

* Build and deploy a nextcloud stack featuring reverse proxy and SSL certificate management
* Install scrript that update the IP of your local computer to OVH via DynDNS
* Install and configure a samba share

```bash
ansible-playbook deploy.yml
```

As a finishing touch, create a samba user and passwd from an existing user:

```bash
smbpasswd -a $username
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

<https://github.com/chriswayg/ansible-msmtp-mailer>
