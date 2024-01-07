# cloud-1

## Info

Automated deployment of Inception on a remote server using Ansible.

This project inventory is dynamic and designed to deploy on `Linode`,
if you want to deploy on another cloud provider, or on on-premise servers,
you can skip all the linode-related dependencies and just create your own
inventory file.

The deployed services include:

- TODO
- TODO
- TODO

Other useful features:

- Creation of an `ansible` user with locked login for playbook execution.
- Creation of an `admin` user for administration (since `root` SSH login is disabled).
- Adding your public key to `admin` authorized keys.
- Hardening of `sudoers`.
- TODO

Is recommended to take a look at the playbook to fully understand features and how
to use them.

## Dependencies

- `python3`.
- `ansible`.
- `linode_api4`.
- `passlib`
- `community.general` collection for `ansible`.

### Python3

```bash
sudo apt install python3
```

### Ansible & Linode API

`ansible` and `linode_api4` can be installed via `pip` once `python3` is installed:
```bash
python3 -m pip install --user ansible linode_api4 passlib
```

### Ansible plugin collection: community.general

This project uses the [linode inventory community plugin](https://docs.ansible.com/ansible/latest/collections/community/general/linode_inventory.html),
so we need to install the `community.general` collection.

Check if its installed by running:
```bash
ansible-galaxy collection list
```

If not in the list, install `community.general` collection by running:
```bash
ansible-galaxy collection install community.general
```

If it's in the list but version is below `8.1.0`, upgrade it by running:
```bash
ansible-galaxy collection install community.general --upgrade
```

*Collection is not included in the repo because it's heavy (26M aprox.).*

## Log

This project uses `/var/log/ansible` as log file, change it on `ansible.cfg` or
create it along with an `ansible` group (recommended):
```bash
sudo touch /var/log/ansible.log

sudo groupadd ansible
sudo chown root:ansible /var/log/ansible.log
sudo chmod 775 /var/log/ansible.log
sudo usermod "$USER" -aG ansible
```

## Vars

You can check and change them in `./vars/main.yml` for your needs.

But since the `./vars/vault.yml` is encrypted, here's a list of required variables,
that must be preset in the vault, so you can create this file easily:

- `admin_user_password`: password for the `admin` user.
- Other users passwords (if you add more users).

## Deploy

If deploying on `Linode` export your API token:
```bash
export LINODE_API_TOKEN='your_token_here'
```

And run the playbook:
```bash
ansible-playbook --ask-vault-pass site.yml
```

As you may expect, by default, password is only set on user creation (`update_password: on_create`).
If you want to update users password, explicitely specify `update_passwords=true`,
to run a specific tasks for this (with `update_password: always`):
```
ansible-playbook --ask-vault-pass site.yml -e update_passwords=true
```

> The reasons behind this decision is to avoid false `changed` reports and most
> important, so it doesn't mesh around with passwords if this script is executed
> in multiple machines (that should have different passwords for security).

## Common issues

### Unexpected keyword argument 'allowed_methods'

If you get this error when parsing the linode inventory file:
```
[WARNING]:  * Failed to parse /.../inventory.linode.yml with ansible_collections.community.general.plugins.inventory.linode plugin: __init__() got an unexpected keyword argument 'allowed_methods'
```

There's an incompatibility issue due to the `allowed_methods` argument in the
`urllib3.util.retry` module, which was added in `urllib3` version `1.26.0`.

To resolve this issue, you need to upgrade `urllib3` to a version `1.26.0` or higher:
```bash
python3 -m pip install --upgrade urllib3
```

And `request` in case you get a warning about not supported `urllib3` version:
```bas
python3 -m pip install --upgrade requests
```
