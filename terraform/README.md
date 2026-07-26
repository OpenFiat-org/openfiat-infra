# terraform

Terraform modules for deploying OpenFiat node infrastructure across major
cloud providers: AWS, Azure, GCP, Hetzner, DigitalOcean, and OVH.

Each module under `modules/<provider>/` defines the same variable surface
(`node_count`, `instance_size`, `tags`, and a provider-specific region
variable) so environments can mix providers with a consistent interface.
Resource blocks are intentionally left as scaffolding (commented examples)
until target account/project details are supplied — see each module's
`main.tf`.

```bash
cd modules/aws
terraform init
terraform plan -var="region=us-east-1" -var="instance_size=t3.medium"
```

> Terraform was not installed in the environment that generated this
> scaffold, so `terraform validate`/`plan` have not been run locally — the
> `terraform` CI job (`.github/workflows/ci.yml`) validates on every push.
