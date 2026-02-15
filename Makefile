fmt:
	@echo "Format code (placeholder)"
lint:
	@echo "Lint code (placeholder)"
tf-init:
	terraform -chdir=infra/terraform init
tf-validate:
	terraform -chdir=infra/terraform validate
tf-plan:
	terraform -chdir=infra/terraform plan
tf-apply:
	terraform -chdir=infra/terraform apply
tf-destroy:
	terraform -chdir=infra/terraform destroy
