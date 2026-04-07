# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal Ansible playbook repository for automating system configuration across multiple machines (localhost, remote Arch Linux, Ubuntu, and macOS). Configures development environments, desktop settings, and various services.

## Running Playbooks

Requires vault and become password files: `~/.ansible_vault_pass.txt` and `~/.ansible_become_pass.txt`.

```bash
make playbook                                  # Run full playbook
make playbook-tags tags=git,zsh                # Run specific roles by tag
make playbook-limit limit=arch                 # Run for specific host group
```

Some proxy roles (clash, privoxy, proxychains) share the tag `proxy` — use `--tags "proxy"` to run all of them, or `--tags "clash"` for a single one.

## Architecture

### Playbook Structure

`playbook.yml` defines two host groups:
- **localhost**: Runs all roles locally with tags for selective execution
- **ubuntu**: Remote Ubuntu hosts (runs only SSH role)

Each role in `playbook.yml` has an associated tag matching its name for selective execution.

### Cross-Platform Pattern

Roles support three platforms via `when` conditionals:
- **Archlinux**: `pacman` package manager
- **MacOSX**: `homebrew` / `homebrew_cask`
- **Ubuntu**: `apt` package manager (checks `no_sudo` variable)

Typical pattern:
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

- `offline` — Skip network operations (git clones, package installs)
- `no_sudo` — Skip sudo operations on Ubuntu
- `username` / `password` — Defined in encrypted `roles/user/vars/main.yml` (edit via `ansible-vault`)

### Notes

- Some roles exist in `roles/` but are **not** included in `playbook.yml` (e.g. `sshd`, `v2ray-server`, `shadowsocks-server`, `display`). Add them to the playbook if needed.
- `chaos/` — macOS-specific setup scripts (not Ansible-managed)
- Inventory template: `hosts.example.yml` → copy to `hosts.yml`
