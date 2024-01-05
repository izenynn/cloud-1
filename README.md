# cloud-1

## Info

Automated deployment of Inception on a remote server using Ansible.

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

## Deploy

TODO
