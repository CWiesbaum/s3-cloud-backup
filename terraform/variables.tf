variable "base64_pgp_key_file_location" {
  description = "File containing the Base64 encoded PGP key used to encrypt IAM user secret access key"
  type        = string
}

variable "bucket_postfix" {
  description = "Postfix to be appended to S3 bucket name"
  type        = string
}