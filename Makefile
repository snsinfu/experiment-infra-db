ARTIFACTS = \
  $(CHECKPOINTS) \
  $(GENERATED)

CHECKPOINTS = \
  _terraform_init.ok \
  _terraform_resources.ok \
  _connection.ok

GENERATED = \
  terraform/backend.tfvars \
  terraform/terraform.tfvars \
  inventory/_10-terraform \
  inventory/_20-wireguard-data \
  _known_hosts


# TASKS ----------------------------------------------------------------------

.PHONY: all clean

all: _connection.ok
	@:

clean:
	rm -rf $(ARTIFACTS)


# INFRACTRUCTURE -------------------------------------------------------------

.PHONY: destroy

terraform/backend.tfvars: terraform/backend.tfvars.j2
	scripts/ansible-template $< $@

terraform/terraform.tfvars: terraform/terraform.tfvars.j2
	scripts/ansible-template $< $@

_terraform_init.ok: terraform/backend.tfvars
	cd terraform; terraform init -backend-config backend.tfvars
	@touch $@

_terraform_resources.ok: terraform/terraform.tfvars _terraform_init.ok
	cd terraform; terraform apply -auto-approve
	@touch $@

destroy: terraform/terraform.tfvars
	cd terraform; terraform destroy -auto-approve
	@rm -f _terraform_resources.ok


# CONNECTION -----------------------------------------------------------------

.PHONY: ssh ping

inventory/_10-terraform: _terraform_resources.ok
	{ cd terraform; terraform output inventory; } > $@

_connection.ok: inventory/_10-terraform
	ansible -o -m ping data
	@touch $@

ssh: _connection.ok
	ssh -F ssh_config $$(scripts/ansible-print -t data "{{ ansible_user }}@{{ ansible_host }}")

ping: inventory/_10-terraform
	ping $$(scripts/ansible-print -t data "{{ ansible_host }}")


# PROVISION ------------------------------------------------------------------

.PHONY: provision wireguard

provision: _connection.ok
	ansible-playbook ansible/provision.yml

wireguard:
	ansible-playbook ansible/wireguard.yml
