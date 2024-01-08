# cloud-1

## Info

Automated deployment of Inception on a remote server using Ansible.

This project inventory is dynamic and designed to deploy on `Linode`,
if you want to deploy on another cloud provider, or on on-premise servers,
you can skip all the linode-related dependencies and just create your own
inventory file.

Supported systems:

- Ubuntu.

The docker deployed services/utilities include:

- Nginx.
- Php-FPM.
- MariaDB.
- FTP.
- Redis.
- Adminer.
- PhpMyAdmin.
- (A static website main page).

Is recommended to take a look at the playbook to fully understand features and how
to use them.

A user `ansible` is created for future playbooks runs, and a user `admin` is
created for servers administrators to use, since `root` ssh login is prohibited.

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

Since the `./vars/vault.yml` is encrypted, for the sake of you knowing what should
be there, here's a list of required variables, that must be preset in the vault,
so you can create this file easily:

- `vault_admin_user_password`: password for the `admin` user.

- `vault_ansible_user_authorized_key`: public key to add to `ansible` authorized keys.
- `vault_admin_user_authorized_key`: public key to add to `admin` authorized keys.
- All the docker secrets, look in `./roles/docker_deploy/defaults/main.yml` for the variable names.

> If you create additonal users, make sure to place those new passwords in the
> vault too!

## Deploy

If deploying on `Linode` export your API token:
```bash
export LINODE_API_TOKEN='your_token_here'
```

And run the playbook:
```bash
ansible-playbook --ask-vault-pass site.yml
```

A `run_playbook.sh` script is also provided for convenience:
```bash
./run_playbook.sh
```

You can provide the `Linode` token and vault password via environment, or you
can create a `.env` following the provided `.env.sample`, so you don't have to
export the token and vault password for every new shell session:
```bash
cp .env.sample .env
vim .env # Edit the values
```

## Deploy options

As you may expect, by default, password is only set on user creation (`update_password: on_create`).
If you want to update users password, explicitely specify `update_passwords=true`,
to run a specific tasks for this (with `update_password: always`):
```
./run_playbook.sh -e update_passwords=true
```

> The reasons behind this decision is to avoid false `changed` reports and most
> important, so it doesn't mesh around with passwords if this script is executed
> in multiple machines (that should have different passwords for security).

UFW by default does not clean previous rules, if you want to force a reset of
the current rules, do it with `reset_ufw=true`:
```bash
./run_playbook.sh -e reset_ufw=true
```

Docker compose by default does not restart if at least one container is running
on the compose project, you can force a restart with `restart_compose=true`:
```bash
./run_playbook.sh -e restart_compose=true
```

> You can always of course run the full ansible command instead of using the
> script since these flags are for ansible, and not for the script:
> `ansible-playbook --ask-vault-pass site.yml -e update_passwords=true`

## Common issues

### Connection time out after defaults modification

If you changed the ssh port or the default users array in the defaults,
make sure to change the remote user and port on `ansible.cfg`,
by default it works with the `ansible` user and the port `4242`.

> If the ssh custom port is closed it will attempt connection with `root` or port 22,
> assuming ssh config is not yet changed.

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
```bash
python3 -m pip install --upgrade requests
```
