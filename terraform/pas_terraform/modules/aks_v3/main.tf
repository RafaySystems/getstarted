resource "rafay_aks_cluster_v3" "cluster" {
  metadata {
    name    = var.cluster_name
    project = var.project
  }
  spec {
    type = "aks"
    blueprint_config {
      name = var.blueprint_name
      version = var.blueprint_version
    }
    cloud_credentials = var.cloud_credentials_name
    config {
      kind = "aksClusterConfig"
      metadata {
        name = var.cluster_name
      }
      spec {
        resource_group_name = var.cluster_resource_group
        managed_cluster {
          api_version = "2022-07-01"
          sku {
            name = "Basic"
            tier = "Free"
          }
          identity {
            type = "SystemAssigned"
          }
          location = "centralindia"
          tags = var.cluster_tags
          properties {
            api_server_access_profile {
              enable_private_cluster = true
            }
            dns_prefix         = "${var.cluster_name}-dns"
            kubernetes_version = var.k8s_version
            network_profile {
              network_plugin = "kubenet"
              load_balancer_sku = "standard"
            }
            addon_profiles {
              http_application_routing {
                enabled = true
              }
              azure_policy { 
                enabled = true
              }
              azure_keyvault_secrets_provider {
                enabled = true
                config {
                  enable_secret_rotation = false
                  rotation_poll_interval = "2m"
                }
              }
            }
          }
          type = "Microsoft.ContainerService/managedClusters"
        }
        node_pools {
          api_version = "2022-07-01"
          name = var.nodepool_name
          location = var.cluster_location
          properties {
            count                = var.node_count
            enable_auto_scaling  = true
            enable_node_public_ip = false
            max_count            = var.node_max_count
            max_pods             = 40
            min_count            = var.node_min_count
            mode                 = "System"
            orchestrator_version = var.k8s_version
            os_type              = "Linux"
            type                 = "VirtualMachineScaleSets"
            vm_size              = var.vm_size
            node_labels = var.node_labels
            tags = var.node_tags
          }
          type = "Microsoft.ContainerService/managedClusters/agentPools"
        }     
      }
    }
  }
}