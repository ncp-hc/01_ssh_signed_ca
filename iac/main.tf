terraform {
  required_version = ">= 0.13"

}


module "compute_node" {
  source = "./compute-node"
}

output "compute_nodes" {
  value = {
    "02_cn_client_pw"               = module.compute_node.cn_client_pw
    "01_cn_host_pw"              = module.compute_node.cn_host_pw
    }
}
