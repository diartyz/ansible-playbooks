playbook:
	ansible-playbook playbook.yml

check:
	ansible-playbook playbook.yml --check

list-tags:
	ansible-playbook playbook.yml --list-tags

windows:
	ansible-playbook playbook.yml -l windows
