# Degreed WApps (dev01) - Terraform

This Terraform configuration deploys:
- Azure Resource Group
- Azure SQL Server + Database (quotes storage)
- Azure App Service Plan + Web App (Node.js app)
- Application Insights
- Key Vault

## Naming Convention
`<company>-<workload>-<environment>[-<suffix>]-<resource>`

Example:
- Resource Group: `degreed-wapps-dev01-tobi-rg`
- Web App: `degreed-wapps-dev01-tobi-web`
- SQL Server: `degreed-wapps-dev01-tobi-sql`
- Key Vault: `degreedwappsdev01tobikv`

## Inputs
- `sql_admin_password` should be passed securely via GitHub Actions secret `SQL_ADMIN_PASSWORD`.

## Outputs
After apply, Terraform prints:
- Web app URL
- SQL server FQDN
- database name
