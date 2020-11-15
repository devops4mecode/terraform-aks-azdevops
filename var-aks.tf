#KeyVault Resource Group and KeyVaultName
variable "keyvault_rg" {
  type    = string
}
variable "keyvault_name" {
  type    = string
}

variable "azure_region" {
  type    = string
  default = "southeastasia"
}

#  Resource Group Name
variable "resource_group" {
  type    = string
  default = "do4m_aks_demo_rsg"
}

# AKS Cluster name
variable "cluster_name" {
  type    = string
  default = "do4m_aks_cluster"
}

#AKS DNS name
variable "dns_name" {
  type    = string
  default = "do4m_aks_cluster"
}

variable "admin_username" {
  type    = string
  default = "do4maksadmin"
}

# Specify a valid kubernetes version
variable "kubernetes_version" {
  type    = string
  default = "1.14.3"
}

#AKS Agent pools
variable "agent_pools" {
  default = [
    {
      name            = "pool1"
      count           = 3
      vm_size         = "Standard_D1_v2"
      os_type         = "Linux"
      os_disk_size_gb = "30"
    }
  ]
}
