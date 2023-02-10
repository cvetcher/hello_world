# README


### Requirements

* POSIX shell
* Docker with buildkit enabled
* AWS CLI
* Terraform


### Infrastructure setup


#### Preliminary configuration

1. Setup AWS CLI
2. Setup AWS credentials for Terraform 
3. Export AWS_DEFAULT_PROFILE if needed


#### Setup infrastructure

TODO

```
cd terraform
```

Check the deployment settings in the 'terraform.tfvars'.


Install Terraform modules used in the deployment:


```
terraform init
```

Deploy the infrastructure:


```
terraform apply
```


### Build and deploy

To build an image, test it and deploy, run `ops` script with a 'deploy' command and a git reference - tag, branch, or commit:

```
./ops deploy v1

```

The script automatically builds and tests a Docker image locally before deployment.
