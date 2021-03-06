resource "aws_codepipeline" "prod_pipeline" {
  name     = "${var.app_name}-${var.git_repository_branch_sanitized}-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  depends_on = [
    "aws_s3_bucket.bucket_site",
    "aws_s3_bucket.source"
  ]
  
  artifact_store {
    location = "${aws_s3_bucket.source.bucket}"
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
      output_artifacts = ["code"]

      configuration    = {
        OAuthToken            = var.github_oauth_token
        Owner                 = var.git_repository_owner
        Repo                  = var.git_repository_name
        Branch                = var.git_repository_branch
        PollForSourceChanges  = var.poll_source_changes
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["code"]
      output_artifacts = ["bundle"]
    
      configuration    = {
        ProjectName = "${var.app_name}-${var.git_repository_branch_sanitized}-codebuild"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["bundle"]
      version         = "1"

      configuration   = {
        BucketName = "${var.app_name}-${var.git_repository_branch_sanitized}"
        Extract = "true"
      }
    }
  }
}
