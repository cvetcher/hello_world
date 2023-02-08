# README


### Requirements

* Docker with buildkit enabled
* POSIX shell


### Infrastructure setup

TODO


### Build and deploy

To build an image, test it and deploy, run `ops` script with a 'deploy' command and a git reference - tag, branch, or commit:

```
./ops deploy v1

```

The script automatically builds and tests a Docker image locally before deployment.
