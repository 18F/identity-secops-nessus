
variable "codebuild_arn" {
  type    = string
}

variable "codebuild_role_name" {
  type    = string
}

variable "artifacts_bucket_id" {
  type    = string
}

variable "eks_cluster_name" {
  type    = string
}

variable "codepipeline_arn" {
  type    = string
}

variable "codepipeline_bucket" {
  type    = string
}

variable "codepipeline_kmskey_arn" {
  type    = string
}
