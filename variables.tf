
variable "codebuild_arn" {
  type    = string
  description = "the arn of the codebuild IAM role"
}

variable "codebuild_role_name" {
  type    = string
  description = "the name of the codebuild IAM role"
}

variable "artifacts_bucket_id" {
  type    = string
  description = "the bucket where build artifacts are stored (like the nessus deb)"
}

variable "eks_cluster_name" {
  type    = string
  description = "the name of the EKS cluster we are deploying to"
}

variable "codepipeline_arn" {
  type    = string
  description = "the arn of the codepipeline IAM role"
}

variable "codepipeline_bucket" {
  type    = string
  description "the bucket that codepipeline uses"
}
