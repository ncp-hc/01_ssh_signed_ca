provider "vault" {
    address = var.vault_addr
   # token = var.vault_token
   /*
   Vault token that will be used by Terraform to authenticate.
    May be set via the VAULT_TOKEN environment variable. 
    If none is otherwise supplied, Terraform will attempt to read it from ~/.vault-token (where the vault command stores its current token). 
   */
}