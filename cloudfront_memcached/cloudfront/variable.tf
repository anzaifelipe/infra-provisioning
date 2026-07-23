variable "prefix_name" {
    type        = string
    description = "Set prefix name for all resources"
}

variable "host_name_medias_public" {
    type        = string
    description = "Public media URL"
}

#variable "host_name_pocus_api" {
#    type        = string
#    description = "Public Pocus API URL"
#}

variable "bucket_public_medias_name" {
    type        = string
    description = "Publica medias S3 bucket name"
}

variable "comment" {
    type        = string
    description = "Comment for CloudFront distribution"
    default     = "CloudFront distribution for public medias"
  
}

variable "bucket_public_medias_id" {
    type        = string
    description = "Publica medias S3 bucket id"
}

variable "certificate_agile_svcs"{
    type        = string
    description = "*.prism.agilesvcs.com certificate"
}

#variable "ec2_load_balancers"{
#    type        = any
#    description = "Available Load Balancers" 
#}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
