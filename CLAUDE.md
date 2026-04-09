# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal Ansible playbook repository for automating system configuration across multiple machines (localhost, remote Arch Linux, Ubuntu, and macOS). Configures development environments, desktop settings, and various services.

## Running Playbooks

Requires `~/.ansible_become_pass.txt` (become) and `~/.ansible_vault_pass.txt` (vault), configured in `ansible.cfg`.

```bash
make playbook                                  # Run full playbook
make check                                     # Dry-run with diff
make list-tags                                 # List available tags

# Run specific roles or host groups (no make target, use ansible directly):
ansible-playbook playbook.yml --tags "git,zsh"
ansible-playbook playbook.yml --limit arch
```

## Architecture

### Playbook Structure

`playbook.yml` defines two host groups:
- **localhost**: Runs all roles with a custom `PATH` that includes `~/.local/bin` and fnm. Roles are grouped into system/desktop/dev/network/apps sections.
- **ubuntu**: Remote Ubuntu hosts (runs only SSH role)

Each role has a tag matching its name for selective execution. The proxy role additionally has sub-tags (`clash`, `privoxy`, `proxychains`) so `--tags "clash"` runs only that component.

### Package Management via `pkg` Role

Central to the architecture — most roles delegate package installation to the `pkg` role via `include_role`:

```yaml
- include_role:
    name: pkg
  vars:
    packages: [common-pkg]              # All platforms
    packages_archlinux: [arch-only-pkg]  # Arch-specific
    packages_macos: [mac-only-pkg]       # macOS via homebrew
    packages_ubuntu: [ubuntu-only-pkg]   # Ubuntu via apt
    packages_cask: [mac-gui-app]         # macOS GUI apps via homebrew_cask
    binaries:
      - url: https://.../tool.tar.gz
        check: tool                     # Binary name to check (`which` is used)
        install: "tar -xzf ... -C /tmp && install /tmp/tool ~/.local/bin/tool"
```

**Binary fallback**: When a package isn't in system repos, `pkg` downloads it to `~/.cache/ansible/` and installs via a custom command. Use `prepare` tag to pre-cache binaries offline. Binaries install to `~/.local/bin/` (already in localhost's `PATH`).

**Tag convention inside pkg**: `online` (network ops), `sudo` (privilege escalation), `prepare` (pre-cache binaries).

### Role Convention

Most roles follow this pattern:
1. `include_role: pkg` to install packages/binaries
2. `git` clone for plugins/themes (with `depth: 1`, `update: no`, tag: `online`)
3. `file` to create config directories
4. `copy` for static configs, `template` for configs with platform/version conditionals
5. `lineinfile`/`blockinfile` to add env vars, aliases, or plugins to shell rc files

**Shell rc conventions**:
- `lineinfile` with `insertafter: '^export (?!PATH)'` for env vars
- `lineinfile` with `insertafter: '^alias'` for aliases
- `lineinfile` with `insertbefore: '# BEGIN ANSIBLE MANAGED OH-MY-ZSH'` for zsh plugins
- Loop over `['zsh', 'bash']` when adding to both rc files
- Platform conditionals use `ansible_distribution` (`Archlinux`, `MacOSX`, `Ubuntu`, `CentOS`) and `ansible_kernel` (WSL2 check via `find('microsoft-standard-WSL2')`)

### Key Variables

- `offline` — Skip network operations (git clones, package installs). Passed as extra var.
- `no_sudo` — Skip sudo operations on Ubuntu. Passed as extra var.
- `username` / `password` — Defined in encrypted `roles/user/vars/main.yml` (edit via `ansible-vault`)
- `hostname` — Defined in encrypted `roles/hostname/vars/main.yml`

### Notes

- Roles in `roles/` but **not** in `playbook.yml`: `display`, `sshd`, `v2ray-server`, `shadowsocks-server`, `shadowsocks`, `trojan`, `v2ray`. Add them to the playbook if needed.
- Inventory: copy `hosts.example.yml` to `hosts.yml` (gitignored)
- Handlers exist in: `system`, `nginx`, `osx`, `proxy`, `shadowsocks`, `trojan`, `v2ray`
- Templates (`.j2`) are only used in `git` and `ai` roles — most configs use `copy` with static files
- No `defaults/` directories — variables are passed inline via `include_role` vars or defined in encrypted `vars/main.yml`
