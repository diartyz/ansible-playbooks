# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Ansible playbook repository for automating system configuration across multiple machines (localhost, remote Arch Linux, Ubuntu, and macOS). The playbooks configure development environments, desktop settings, and various services.

## Running Playbooks

All playbook execution requires vault password and become password files:
- `~/.ansible_vault_pass.txt` - Vault password file
- `~/.ansible_become_pass.txt` - Become (sudo) password file

### Common Commands

Via Makefile:
```bash
make playbook                # Run full playbook
make playbook-tags tags=git,zsh    # Run specific roles by tag
make playbook-limit limit=arch    # Run for specific host group
```

Direct Ansible:
```bash
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml \
  --vault-password-file ~/.ansible_vault_pass.txt \
  --become-password-file ~/.ansible_become_pass.txt \
  --tags "git,zsh"
```

## Architecture

### Playbook Structure

The main `playbook.yml` defines two host groups:
- **localhost**: Runs all roles locally with tags for selective execution
- **ubuntu**: Remote Ubuntu hosts (runs only SSH role)

Each role has associated tags (see playbook.yml) that allow running specific configurations.

### Role Organization

Roles follow standard Ansible structure under `roles/`:
```
roles/<rolename>/
  tasks/main.yml      # Task definitions
  files/              # Static files to copy
  templates/          # Jinja2 templates
  vars/main.yml       # Variables (may be encrypted)
  meta/main.yml       # Role metadata
```

### Cross-Platform Pattern

Roles support three platforms via conditional logic:
- **Archlinux**: Uses `pacman` package manager
- **MacOSX**: Uses `homebrew` and `homebrew_cask`
- **Ubuntu**: Uses `apt` package manager (checks `no_sudo` variable)

Typical pattern in `tasks/main.yml`:
```yaml
- name: install packages
  become: true
  pacman:
    name: [pkg1, pkg2]
  when:
    - offline is not defined
    - ansible_distribution == 'Archlinux'
```

### Key Variables

- `offline` - Set to skip network operations (git clones, package installs)
- `no_sudo` - Set to skip sudo operations on Ubuntu
- `username` / `password` - Defined in encrypted `roles/user/vars/main.yml`

### Special Directories

- `chaos/` - Contains macOS-specific setup scripts (not Ansible-managed)
- `hosts.example.yml` - Template inventory file (copy to `hosts.yml`)

## Development Workflow

1. Create inventory file `hosts.yml` from `hosts.example.yml`
2. Set up password files (`~/.ansible_vault_pass.txt`, `~/.ansible_become_pass.txt`)
3. Use tags to test specific roles during development: `--tags "rolename"`
4. For encrypted variables, use `ansible-vault` to edit `roles/user/vars/main.yml`

## Role Categories

- **Development**: git, vim, python, node, rust
- **Shell**: zsh, tmux, ranger, terminal
- **Desktop**: i3, xinit, keyboard, display, rime
- **System**: user, system, hostname, locale, timedate, firewall
- **Network/Proxy**: clash, privoxy, proxychains, shadowsocks, v2ray, trojan
- **Services**: docker, nginx, ssh, sshd
- **Other**: app, bin, debug, grub, mail, mirrorlist
