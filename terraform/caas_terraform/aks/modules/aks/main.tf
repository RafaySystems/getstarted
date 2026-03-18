resource "rafay_aks_cluster_v3" "aks-cluster" {
  metadata {
    name    = var.cluster_name
    project = var.project
  }
  spec {
    type          = "aks"
    blueprint_config {
      name = var.blueprint_name
      version = var.blueprint_version
    }
    /*proxy_config {
      http_proxy = var.http_proxy
      https_proxy = var.https_proxy
      no_proxy = var.no_proxy
    }*/
    cloud_credentials = var.cloud_credentials_name
    system_components_placement {
      node_selector = {
        app = "infra"
        dedicated = "true"
      }
      tolerations {
        effect = "PreferNoSchedule"
        key = "app"
        operator = "Equal"
        value =  "infra"
      }
      daemon_set_override {
        node_selection_enabled = false
        tolerations {
          key = "app1dedicated"
          value = true
          effect = "NoSchedule"
          operator = "Equal"
        }
      }
    }
    config {
      kind       = "aksClusterConfig"
      metadata {
        name = var.cluster_name
      }
      spec {
        resource_group_name = var.rg_name
        managed_cluster {
          api_version = "2024-01-01"
          sku {
            name = "Base"
            tier = "Free"
          }
          identity {
            type = "systemAssigned"
            user_assigned_identities = {}
          }
          location = var.location
          tags = {
            "email" = "user@company.com"
            "env" = "terraform"
          }
          properties {
            api_server_access_profile {
              enable_private_cluster = true
            }
            #disk_encryption_set_id = var.disk_encryption_set_id
            dns_prefix         = var.dns_prefix
            kubernetes_version = var.k8s_version
            network_profile {
              network_plugin      = "azure"
              load_balancer_sku   = "standard"
              network_plugin_mode = "overlay"
              network_dataplane   = "cilium"
              pod_cidr            = "192.168.0.0/16"
              service_cidr        = "10.0.0.0/16"
              dns_service_ip      = "10.0.0.10"
            }
            node_provisioning_profile {
              mode = "Auto"
              default_node_pools = "Auto"    
            }
            power_state {
              code = "Running"
            }
            oidc_issuer_profile {
              enabled = true
            }
            security_profile {
              workload_identity {
                enabled = true
              }
            }
            /*service_mesh_profile {
                istio {
                  mode = 
                }
            }*/
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
            auto_upgrade_profile {
              upgrade_channel = "rapid"
              node_os_upgrade_channel = "NodeImage"
            }
          }
          type = "Microsoft.ContainerService/managedClusters"
        }
        node_pools {
          api_version = "2024-01-01"
          name       = "primary"
          location = "centralindia"
          properties {
            count                = 1
            enable_auto_scaling  = false
            max_count            = 2
            max_pods             = 40
            min_count            = 1
            mode                 = "System"
            orchestrator_version = "1.25.6"
            os_type              = "Linux"
            type                 = "VirtualMachineScaleSets"
            vm_size              = "Standard_DS2_v2"
            node_labels = {
              app = "infra"
              dedicated = "true"
            }
            node_taints               = ["app=infra:PreferNoSchedule"]
          }
          type = "Microsoft.ContainerService/managedClusters/agentPools"
        }

        node_pools {
          api_version = "2024-01-01"
          name       = "agentpool2"
          location = "centralindia"
          properties {
            count                = 1
            enable_auto_scaling  = false
            max_count            = 2
            max_pods             = 40
            min_count            = 1
            mode                 = "User"
            orchestrator_version = "1.25.6"
            os_type              = "Linux"
            type                 = "VirtualMachineScaleSets"
            vm_size              = "Standard_B4ms"
            node_labels = {
              app = "infra"
              dedicated = "true"
            }
            node_taints               = ["app=infra:PreferNoSchedule"]
          }
          type = "Microsoft.ContainerService/managedClusters/agentPools"
        }
        maintenance_configurations {
          api_version = "2024-01-01"
          name = "aksManagedNodeOSUpgradeSchedule"
          properties {
            maintenance_window {
              duration_hours = 4
              schedule {
                daily {
                  interval_days = 1
                }
              }
              start_date = "2024-07-19"
              start_time = "11:38"
              utc_offset = "+05:30"
            }
          }
          type = "Microsoft.ContainerService/managedClusters/maintenanceConfigurations"
        }

      }
    }
  }
}
