resource "rafay_aks_cluster" "cluster" {
  apiversion = "rafay.io/v1alpha1"
  kind       = "Cluster"
  metadata {
    name    = var.cluster_name
    project = var.project
  }
  spec {
    type          = "aks"
    blueprint     = var.blueprint_name
    blueprintversion = var.blueprint_version
    cloudprovider = var.cloud_credentials_name
    cluster_config {
      apiversion = "rafay.io/v1alpha1"
      kind       = "aksClusterConfig"
      metadata {
        name = var.cluster_name
      }
      spec {
        resource_group_name = var.cluster_resource_group
        managed_cluster {
          apiversion = "2021-05-01"
          identity {
            type = "SystemAssigned"
          }
          location = var.cluster_location
          properties {
            api_server_access_profile {
              enable_private_cluster = true
              enable_private_cluster_public_fqdn = false
            }
            dns_prefix         = "${var.cluster_name}-dns"
            enable_rbac        = true
            kubernetes_version = var.k8s_version
            addon_profiles {
              http_application_routing {
                enabled = false
              }
              azure_policy  {
                enabled = false
              }
              azure_keyvault_secrets_provider {
                enabled = true
                config {
                  enable_secret_rotation = "true"
                  rotation_poll_interval = "2m"
                }
              }
            }
            auto_scaler_profile {
              balance_similar_node_groups      = "false"
              expander                         = "random"
              max_graceful_termination_sec     = "600"
              max_node_provision_time          = "15m"
              ok_total_unready_count           =  "3"
              max_total_unready_percentage     = "45"
              new_pod_scale_up_delay           = "10s"
              scale_down_delay_after_add       = "10m"
              scale_down_delay_after_delete    = "10s"
              scale_down_delay_after_failure   = "3m"
              scan_interval                    = "10s"
              scale_down_unneeded_time         = "10m"
              scale_down_unready_time          = "20m"
              scale_down_utilization_threshold = "0.5"
              max_empty_bulk_delete            = "10"
              skip_nodes_with_local_storage    = "true"
              skip_nodes_with_system_pods      = "true"
            }
            network_profile {
              network_plugin = "kubenet"
              network_policy = "calico"
              outbound_type  = "loadBalancer"
            }
          }
          type = "Microsoft.ContainerService/managedClusters"
        }
        dynamic "node_pools" {
          for_each = var.nodePools
          content {
            apiversion = "2021-05-01"
            name       = node_pools.value.name
            location   = node_pools.value.location
            properties {
              count                = node_pools.value.count
              enable_auto_scaling  = true
              enable_node_public_ip = false
              max_count		         = node_pools.value.maxCount
              min_count		         = node_pools.value.minCount
              max_pods             = 110
              mode                 = node_pools.value.mode
              orchestrator_version = node_pools.value.k8sVersion
              os_type              = "Linux"
              os_disk_size_gb      = 30
              availability_zones   = [1, 2, 3]
              type                 = "VirtualMachineScaleSets"
              upgrade_settings {
                max_surge = "40%"
              }
              vm_size = node_pools.value.vmSize
            }
            type = "Microsoft.ContainerService/managedClusters/agentPools"
          }
        }
      }
    }
  }
}