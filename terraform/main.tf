terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_s3_bucket" "s3-backup-bucket" {
  bucket = "s3-backup-bucket-${var.bucket_postfix}"
  force_destroy = true

  tags = {
    Name = "S3 Cloud Backup"
  }
}

resource "aws_s3_bucket_acl" "s3-backup-bucket-acl" {
  bucket = aws_s3_bucket.s3-backup-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3-backup-bucket-pcb" {
  bucket = aws_s3_bucket.s3-backup-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "s3-backup-user" {
  name = "s3-backup-user"

  tags = {
    Name = "S3 Cloud Backup"
  }
}

resource "aws_iam_access_key" "s3-backup-user-ak" {
  user    = aws_iam_user.s3-backup-user.name
  pgp_key = file(var.base64_pgp_key_file_location)
}

resource "aws_iam_user_policy" "s3-backup-policy" {
  name = "s3-backup-policy"
  user = aws_iam_user.s3-backup-user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.s3-backup-bucket.arn}/*"
        ]
      },
    ]
  })
}

output "access_key_id" {
  value = aws_iam_access_key.s3-backup-user-ak.id
}

output "secret_access_key" {
  value = aws_iam_access_key.s3-backup-user-ak.encrypted_secret
}
