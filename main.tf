#-------------PROVIDER CONFIGURATION---------------------
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

#----------------CLOUD CONFIGURATION--------------------------------
  cloud {
    organization = "Foundationmon"
    workspaces {
      name = "Serverless"
    }
  }
}

#-----------------------VARIABLES-----------------------------
variable "HOPETONMON_COPY_ACCESS_KEY" {
    description = "HopetonMon Copy AWS Access Key"
    type        = string
    sensitive = true
}

variable "HOPETONMON_COPY_SECRET_KEY" {
    description = "HopetonMon Copy AWS Secret Key"
    type        = string
    sensitive = true
  
}

variable "AWS_REGION" {
    description = "AWS Region"
    type        = string
}

variable "AVAILABILITY_ZONE" {
    description = "Availability Zone (Distinct loaction in the Region)"
    type        = string
}

variable "AVAILABILITY_ZONE2" {
    description = "Availability Zone 2 (Distinct loaction in the Region)"
    type        = string
  
}


#------------------PROVIDER DEFINITION----------------------
provider "aws" {
    region     = var.AWS_REGION
    access_key = var.HOPETONMON_COPY_ACCESS_KEY
    secret_key = var.HOPETONMON_COPY_SECRET_KEY
  
}


#-------------------S3 BUCKET--------------------------
resource "aws_s3_bucket" "flappy-bucket" {
  bucket = "flappy-bucket-${var.AWS_REGION}-${var.AVAILABILITY_ZONE}"

tags = {
  Name        = "Flappy Bucket"
  Environment = "Server"
}
}

#--------------------S3 BUCKET WEBSITE CONFIG--------------------------
resource "aws_s3_bucket_website_configuration" "flappy_site" {
  bucket = aws_s3_bucket.flappy-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
