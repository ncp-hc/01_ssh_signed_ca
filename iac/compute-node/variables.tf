variable "tag" {
  default = {
    tag_key   = "owner"
    tag_value = "jsp@hashicorp.com"
  }
}

// Image list : ncloud server getServerImageProductList 
// Product list ex: ncloud server getServerProductList --serverImageProductCode SPSW0LINUX000130
variable "ncloud" {
  default = {
    region                    = "KR"
    site                      = "public"
    zone                      = "KR-2"
    server_image_product_code = "SPSW0LINUX000130"
    server_product_code       = "SPSVRSTAND000072"
  }
}

variable "ssh_external_port" {
  default = {
    cn_host  = "8200",
    cn_client  = "8200"
  }
}


#variable "credentials_file" {}