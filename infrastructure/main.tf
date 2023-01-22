terraform {

  #backend "s3" {
  #  bucket  = "tfstate"
  #  key     = "infra.tfstate"
  #  region  = "us-east-1"
  #  encrypt = true
  #}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
  }
}

################################################
#                    PROVIDERS                 #
################################################

provider "aws" {
  region = "us-east-1"
}

################################################
#                    S3                        #
################################################

module "s3" {
  source             = "./s3"
  bucket_name_prefix = "GBC"
}

################################################
#                    LAMBDA                    #
################################################

module "lambda_about" {
  source                 = "./lambda"
  lambda_bucket_id       = module.s3.bucket_id
  lambda_function_name   = "about"
  lambda_role_name       = "GBC_lambda_role"
  lamba_handler_function = "about"
}