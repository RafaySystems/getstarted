# Introduction

This tool optimizes resource allocation for the applications running on a kubernetes cluster.

# Prerequisites

Following needs to be installed on the system where you plan to run this tool.

- python3
- python3-requests, kubernetes, PrettyTable (Requirement can be installed using python pip3)

# Usage

Export following environment variables.
```
export USER=rafay_console_username
export PASSWORD=rafay_console_password
export PROJECT=rafay_project_name
export CLUSTER=cluster_name
export KUBECONFIG=rafay_ztk_kubeconfig_file
```

To run a command with the dry-run option. This option is useful to review the usage vs current resource allocation configurations.
```
python3 resize.py --dry-run
```

To run a command. This option updates the resource allocation configurations (CPU/Memory requests) based on usage.
```
python3 resize.py --dry-run
```

# Output
This tool outputs resource usage before and after optimizing the resource allocation. 
