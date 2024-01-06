# cloud-1

## Info

Automated deployment of Inception on a remote server using Ansible.

This project inventory is dynamic and designed to deploy on `Linode`,
if you want to deploy on another cloud provider, or on on-premise servers,
you can skip all the linode-related dependencies and just create your own
inventory file.

## Dependencies

- `python3`.
- `ansible`.
- `linode_api4`.
- `community.general` collection for `ansible`.

### Python3

```bash
sudo apt install python3
```

### Ansible & Linode API

`ansible` and `linode_api4` can be installed via `pip` once `python3` is installed:
```bash
python3 -m pip install --user ansible linode_api4
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

## Deploy

If deploying on `Linode` export your API token:
```bash
export LINODE_API_TOKEN='your_token_here'
```

## Common errors

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
