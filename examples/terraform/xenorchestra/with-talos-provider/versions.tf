terraform {
  required_providers {
    xenorchestra = {
      source = "vatesfr/xenorchestra"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

# Configure the Xen Orchestra Provider
provider "xenorchestra" {
  token = var.xoa_token
  url   = "ws://${var.xoa_url}"
}

provider "talos" {}

provider "helm" {
  kubernetes = {
    host     = "${local.cluster_endpoint}"

    client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
    
    depends_on = [talos_cluster_kubeconfig.this]  
  }
}