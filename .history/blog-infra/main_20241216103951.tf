terraform {
  backend "remote" {
    organization = "DZarpelon_Blog"
    workspaces {
      name = "blog"
    }

  }
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.100"
    }
  }
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}
module "cloudflare" {
  source            = "./modules/cloudflare"
  hcp_client_id     = var.hcp_client_id
  hcp_client_secret = var.hcp_client_secret
  domain_name       = var.domain_name
  validation_details = module.acm.validation_details

}

module "aws_s3_bucket" {
  source            = "./modules/s3_bucket"
  hcp_client_id     = var.hcp_client_id
  hcp_client_secret = var.hcp_client_secret
}

# Call the ACM module to create the ACM certificate.
module "acm" {
  hcp_client_id             = var.hcp_client_id
  hcp_client_secret         = var.hcp_client_secret
  source                    = "./modules/acm"
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  tags                      = var.tags
  cloudflare_zone_id        = module.cloudflare.zone_id
}

module "cloudfront" {
  hcp_client_id             = var.hcp_client_id
  hcp_client_secret         = var.hcp_client_secret
  source          = "./modules/cloudfront"
  origin_bucket   = module.aws_s3_bucket.bucket_name
  certificate_arn = module.acm.certificate_arn
  domain_name     = var.domain_name
  tags            = var.tags
}

# Outputs from the ACM module can now be referenced here, e.g.,:
output "certificate_arn" {
  description = "The ARN of the ACM certificate from the module."
  value       = module.acm.certificate_arn
}

output "validation_details" {
  description = "The DNS validation details from the ACM module."
  value       = module.acm.validation_details
}

