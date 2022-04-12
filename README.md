# s3-cloud-backup
The scripts contained within this project create an encrypted file backup to AWS S3 using OCI container, tar, GnuPG and AWS CLI.

It consists of:
- terraform IaC Scripts to create an IAM User and a corresponding S3 Backup Bucket
- IaC scripts to create an OCI compliant container that creates an encrypted archive and uploads it to AWS S3

In order to encrypt IAM secret access keys and the backup archive GnuPG is used.

## Prerequisites
In order to use this project you need:
- An AWS account
- Environment with AWS CLI installed
- An AWS IAM user with all required priviledges to create all AWS resources

## Preparing AWS
In order to prepare AWS the terraform script has to be executed. The AWS user used for *aws configure* has be priviledged to create an IAM user, a S3 Bucket and a Bucket Policy.

To run terraform apply, two variables have to be set:
- Bucket name postfix that is appended to the bucket name to create a unique bucket name in your region
- Base 64 encoded GnuPG key used to encrypt the backup user's secret access key

First of all you should export and store your GnuPG public key:

```
gpg --export "YOUR_KEY_IDENTIFIER" | base64 > SOME_FILE_NAME.pgp
```

Afterwards you can apply the terraform plan using the following command:

```
terraform apply -var "bucket_postfix=SOME_BUCKET_POSTFIX" -var "base64_pgp_key_file_location=SOME_PATH/SOME_FILE_NAME.pgp"
```
