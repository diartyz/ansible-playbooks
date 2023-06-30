playbook:
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml --vault-password-file ~/.ansible_vault_pass.txt --become-password-file ~/.ansible_become_pass.txt

playbook-tags:
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml --vault-password-file ~/.ansible_vault_pass.txt --become-password-file ~/.ansible_become_pass.txt --tags ${tags}

playbook-limit:
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts.yml playbook.yml --vault-password-file ~/.ansible_vault_pass.txt --become-password-file ~/.ansible_become_pass.txt --limit ${limit}
