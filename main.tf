# ECR repo for nessus
resource "aws_ecr_repository" "secops-nessus" {
  name                 = "nessus-${var.eks_cluster_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# build project for nessus
resource "aws_codebuild_project" "nessus" {
  name           = "nessus-${var.eks_cluster_name}"
  description    = "build_nessus"
  build_timeout  = "5"
  queued_timeout = "5"

  service_role = var.codebuild_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true

    environment_variable {
      name  = "BUCKET"
      value = var.artifacts_bucket_id
    }
    environment_variable {
      name  = "IMAGE_REPO_URL"
      value = aws_ecr_repository.secops-nessus.repository_url
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.secops-nessus.name
    }
    environment_variable {
      name  = "CLUSTER"
      value = var.eks_cluster_name
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/18F/identity-secops-nessus.git"
    git_clone_depth = 1
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "builds"
      stream_name = "nessus-${var.eks_cluster_name}"
    }
  }

  tags = {
    Environment = var.eks_cluster_name
  }
}


# here is the codepipeline that builds/deploys it
resource "aws_codepipeline" "nessus" {
  name     = "nessus-${var.eks_cluster_name}"
  role_arn = var.codepipeline_arn

  artifact_store {
    location = var.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner  = "18F"
        Repo   = "identity-secops-nessus"
        Branch = "master"
      }
    }
  }

  stage {
    name = "BuildTestDeploy"

    action {
      name             = "NessusBuildTestDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "nessus-${var.eks_cluster_name}"
      }
    }
  }
}

# need this so that we can get the license key for nessus
resource "aws_iam_role_policy" "nessus" {
  role = var.codebuild_role_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "arn:aws:secretsmanager:*:*:secret:nessus-license-*",
      "Effect": "Allow"
    }
  ]
}
POLICY
}
