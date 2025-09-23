# Secure Private Web App on Azure (Terraform) — Short README

## Goal
Deploy an **Azure Linux Web App** that is **private-only** (no public IP exposure), with controlled access via NSGs and Private DNS.

## Architecture (at a glance)
- **VNet** `10.20.0.0/16`
  - **snet-app** `10.20.0.0/23` — VNet Integration (delegation: `Microsoft.Web/serverFarms`)
  - **snet-privatelink** `10.20.10.0/24` — Private Endpoints (`private_endpoint_network_policies = "Disabled"`)
- **Web App (Linux)**: `https_only`, `TLS ≥ 1.2`, `FTPS off`, `vnet_route_all = true`
- **Private Endpoint** for Web App (subresource `sites`) + **Private DNS** `privatelink.azurewebsites.net`
- **NSGs**:
  - `workload_nsg` for `snet-app`: Allow `VirtualNetwork` (in/out), **Deny Internet egress & inbound**
  - `pe_nsg` for `snet-privatelink`: Allow `VirtualNetwork` inbound, **Deny Internet inbound**
- (Optional) Observability: Log Analytics + Diagnostic Settings; NSG Flow Logs v2

## Requirements Coverage
- ✅ All resources inside a **private VNet**
- ✅ Web App integrated with **private subnet** (VNet Integration)
- ✅ **Private Endpoint** + **Private DNS** for inbound
- ✅ **No public IP addresses**
- ✅ **NSGs** restrict access to internal traffic; Internet is denied
- ⏳ (Bonus) **Key Vault** for secrets (recommended next)
- ⏳ (If Storage/ACR later) — make them **private-only** via PE & privatelink zones

## Prerequisites
- Terraform ≥ 1.5, `az login`, role: Contributor on the RG
- Pinned `azurerm` provider in `versions.tf`
- **.gitignore** must exclude `.terraform/`, `*.tfstate`, `*.tfvars` (keep `.terraform.lock.hcl`)

## Deploy (quick start)
```bash
terraform fmt -recursive
terraform init -reconfigure
terraform validate
terraform plan -var-file="terraform.tfvars" -out tfplan.out
terraform apply tfplan.out

Validate (post-deploy)

From a VM in the same VNet:
nslookup <appname>.privatelink.azurewebsites.net  # expect IP from 10.20.10.0/24
curl -I https://<appname>.privatelink.azurewebsites.net

From the Internet:
curl -I https://<appname>.azurewebsites.net      # should be blocked/inaccessible


In Azure Portal:
Web App → Networking: VNet Integration = On, Private Endpoint = Connected
Subnets → Effective security rules: no inbound Allow from Internet