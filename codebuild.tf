resource "aws_codebuild_project" "prod_app_build" {
  name          = "${var.app_name}-${var.git_repository_branch_sanitized}-codebuild"
  build_timeout = "80"
  service_role = aws_iam_role.codebuild_role.arn

  depends_on = [
    aws_s3_bucket.bucket_site,
    aws_s3_bucket.source,
  ]

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    // https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "WEB_BUCKET_NAME"
      value = aws_s3_bucket.bucket_site.bucket
    }
    environment_variable {
      name  = "DISTRIBUITION_ID"
      value = aws_cloudfront_distribution.site_s3_distribution.id
    }
  }

  source {
    # TODO: put the same as ecs pipeline
    type      = "CODEPIPELINE"
    # buildspec = "${data.template_file.prod_buildspec.rendered}"
  }

}

resource "aws_s3_bucket" "source" {
  bucket        = "${var.app_name}-${var.git_repository_branch_sanitized}-codepipeline"
  acl           = "private"
  force_destroy = true
}