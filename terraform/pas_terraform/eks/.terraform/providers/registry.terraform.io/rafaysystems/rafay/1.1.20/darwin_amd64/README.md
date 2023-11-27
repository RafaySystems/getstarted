# terraform-provider-rafay
Rafay terraform provider 

## Authentication

The Rafay provider offers a flexible means of providing credentials for
authentication. The following methods are supported, in this order, and
explained below:

- Environment variables
- Credentials/configuration file


### Environment Variables

You can provide your credentials via the `RCTL_REST_ENDPOINT`, `RCTL_API_KEY`, and `RCTL_PROJECT` environment variables, representing your Rafay
Console Endpoint, Rafay Access Key and Rafay Project respectively.


```terraform
provider "rafay" {}
```

Usage:

```sh
$ export RCTL_API_KEY="rafayaccesskey"
$ export RCTL_REST_ENDPOINT="console.rafay.dev"
$ export RCTL_PROJECT="defaultproject"
$ terraform plan
```
>! Note: For `RCTL_API_KEY`, use the entire output of the generated API key.

### Credentials/configuration file

You can use an [Rafay credentials or configuration file](https://docs.rafay.co/cli/config/#config-file) to specify your credentials. You can specify a location of the configuration file in the Terraform configuration by providing the `provider_config_file`  

Usage:

```terraform
provider "rafay" {
  provider_config_file = "/Users/tf_user/rafay_config.json"
}
```


## Build provider

Run the following command to build the provider

```shell
$ make
```

## Test sample configuration

First, build and install the provider.

```shell
$ make install
```

Then, navigate to the `examples` directory. 

```shell
$ cd examples/resources/rafay_project/
```

Run the following command to initialize the workspace and apply the sample configuration.

```shell
$ terraform init && terraform apply
```

## Debug

```shell
export TF_LOG=TRACE
export TF_LOG_PATH=log.txt
```

List terraform states
```shell
terraform state
terraform state show <name>
```
