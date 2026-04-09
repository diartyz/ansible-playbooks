playbook:
	ansible-playbook playbook.yml

check:
	ansible-playbook playbook.yml --check --diff

list-tags:
	ansible-playbook playbook.yml --list-tags
