// Configure the ncloud provider
provider "ncloud" {
  // access_key = var.access_key 
  // secret_key = var.secret_key
  region = var.ncloud.region
  site   = var.ncloud.site
}

resource "ncloud_login_key" "key" {
  key_name = "ncp-hs-webinar"
}