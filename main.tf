provider "aws" {
  region = "eu-west-2"
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

module "aws-iam" {
  source = "./aws-iam"
}

module "aws-redshift" {
  source              = "./aws-redshift"
  iam_role            = module.aws-iam.redshift_iam_role
  admin_user_password = module.aws-secrets-manager.random_password
  subnet_1            = module.common-connections.subnet_1
  subnet_2            = module.common-connections.subnet_2
  subnet_3            = module.common-connections.subnet_3
}

module "aws-s3" {
  source = "./aws-s3"
}

module "aws-sagemaker" {
  source                     = "./aws-sagemaker"
  iam_role                   = module.aws-iam.notebook_iam_role
  aws_default_security_group = module.common-connections.aws_default_security_group
  subnet_1                   = module.common-connections.subnet_1
}

module "aws-secrets-manager" {
  source = "./aws-secrets-manager"
}

module "common-connections" {
  source = "./common-connections"
}
