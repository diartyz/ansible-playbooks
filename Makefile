playbook:
	ansible-playbook playbook.yml

playbook-tags:
	ansible-playbook playbook.yml --tags $(tags)

playbook-limit:
	ansible-playbook playbook.yml --limit $(limit)

check:
	ansible-playbook playbook.yml --check --diff

list-tags:
	ansible-playbook playbook.yml --list-tags
