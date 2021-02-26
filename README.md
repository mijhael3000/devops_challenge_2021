# devops_challenge_2021

This is an example about how to test terraform code with terrates. 

## Pre-requirements:

Terratest uses the Go testing framework. To use Terratest, you need to install:

- Install [Go](https://golang.org/ "Go") (requires version >=1.13)
- Configure your aws credentials setting up the env variables: **AWS_ACCESS_KEY_ID**
**AWS_SECRET_ACCESS_KEY** or your *~/.aws/credentials* file

## Usage
clone repo:
`git clone git@github.com:mijhael3000/devops_challenge_2021.git`

Configure dependencies:
```bash
cd test
go mod init test_s3.go
```
Run the tests:
```bash
go test -v
```
## Github actions
I configured a github workflow to run on pushes on branch main. The workflow will check the creation of a bucket and two objects.

The config for the workflow is in `.github/workflows/terratest.yml`

