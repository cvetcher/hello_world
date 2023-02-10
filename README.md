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




### Use the API

Get the API endpoint from Terraform output, register a user and check how soon is his birthday:

```
read API_ENDPOINT < terraform/.output_endpoint

curl -D - -X PUT -H 'content-type: application/json' -d '{"dateOfBirth": "2022-02-10" }' http://$API_ENDPOINT/hello/cv
curl -D - http://$API_ENDPOINT/hello/cv
```
