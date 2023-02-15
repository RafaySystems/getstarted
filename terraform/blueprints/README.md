# Rafay terraform provider examples

This Getting Started exercise uses Terraform to create a blueprint. You can view your results in the Console.

For more exercises, go to the [Documentation site](https://docs.rafay.co/learn/quickstart/blueprint/blueprintlifecycle/overview/) to see the following:

- Create a blueprint
- Share a blueprint
- Update a blueprint

# Setup

- Update the API key, the API secret, and the Project ID in the Config JSON file.

    - The key, secret, and ID can be found in the RCTL CLI configuration file.
	- In the Console, go to My Tools > Download CLI Config.

```text
artifacts/credentials/config.json
```

- Update tfvars file with following variables. Optionally, you can use the tfvars file as-is.
- Note: For the purposes of this exercise, the number of variables has been limited.

```text
terraform.tfvars

#Project name variable
project                 = "<PROJECT_NAME>"

#Blueprint/Addons specific variables
blueprint_name         = "<BLUEPRINT_NAME>"
blueprint_version      = "<BLUEPRINT_VERSION>"
base_blueprint         = "minimal"
base_blueprint_version = "1.22.0"
```

- Update the Blueprints main.tf file with a project name to share the blueprint with. Path to file: /modules/blueprints/.
- Note: If the shared project name does not exist in your console, you may see an error message when running the ```terraform apply``` command.

## BUILD & RUN

Use the following command to init with Terraform.

```
terraform init
```

Use the following command to validate your configuration.

```
terraform validate
```

If validation is successful, use the following command to apply the configuration using Terraform.

```
terraform apply
```
