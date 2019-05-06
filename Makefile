playbook:
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml --vault-password-file ~/.ansible_vault_pass.txt --extra-vars "@~/.ansible_extra_vars.yml"

playbook-tags:
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml --vault-password-file ~/.ansible_vault_pass.txt --extra-vars "@~/.ansible_extra_vars.yml" --tags ${tags}

playbook-limit:
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml --vault-password-file ~/.ansible_vault_pass.txt --extra-vars "@~/.ansible_extra_vars.yml" --limit ${limit}
