variable "application_projects" {
  type = map(object({
    name          = string 
    description   = string
    size          = string
    groups        = map(object({
         name  = string
         roles = list(string)
        }))
  }))
}

variable "project_quotas" {
  default = {
    small = {
      cpu_requests = "2000m"
      memory_requests = "4096Mi"
      cpu_limits = "4000m"
      memory_limits = "8192Mi"
      config_maps = "20"
      persistent_volume_claims = "10"
      services = "20"    
      pods = "200"
      replication_controllers = "5"
      services_load_balancers = "10"
      services_node_ports = "10"
      storage_requests = "100Gi"
    }
    medium = {
      cpu_requests = "4000m"
      memory_requests = "8192Mi"
      cpu_limits = "8000m"
      memory_limits = "16384Mi"
      config_maps = "40"
      persistent_volume_claims = "20"
      services = "40"    
      pods = "400"
      replication_controllers = "10"
      services_load_balancers = "20"
      services_node_ports = "20"
      storage_requests = "200Gi"
    }
    large = {
      cpu_requests = "8000m"
      memory_requests = "16384Mi"
      cpu_limits = "16000m"
      memory_limits = "32768Mi"
      config_maps = "80"
      persistent_volume_claims = "40"
      services = "80"    
      pods = "800"
      replication_controllers = "20"
      services_load_balancers = "40"
      services_node_ports = "40"
      storage_requests = "400Gi"
    }
  }
}

variable "namespace_quotas" {
  default = {
    small = {
      cpu_requests = "500m"
      memory_requests = "1024Mi"
      cpu_limits = "1000m"
      memory_limits = "2048Mi"
      config_maps = "5"
      persistent_volume_claims = "2"
      services = "5"    
      pods = "25"
      replication_controllers = "1"
      services_load_balancers = "2"
      services_node_ports = "2"
      storage_requests = "50Gi"
    }
    medium = {
      cpu_requests = "1000m"
      memory_requests = "2048Mi"
      cpu_limits = "2000m"
      memory_limits = "4096Mi"
      config_maps = "10"
      persistent_volume_claims = "4"
      services = "10"    
      pods = "50"
      replication_controllers = "2"
      services_load_balancers = "4"
      services_node_ports = "4"
      storage_requests = "100Gi"
    }
    large = {
      cpu_requests = "4000m"
      memory_requests = "4096Mi"
      cpu_limits = "8000m"
      memory_limits = "8192Mi"
      config_maps = "15"
      persistent_volume_claims = "8"
      services = "20"    
      pods = "100"
      replication_controllers = "4"
      services_load_balancers = "8"
      services_node_ports = "8"
      storage_requests = "200Gi"
    }
  }
}