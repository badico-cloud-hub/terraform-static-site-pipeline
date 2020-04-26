variable "app_name" {
  description = "Website project name"
}

variable "aws_region" {
  description = "AWS Region for the VPC"
}

variable "git_repository_owner" {
  description = "Github Repository Owner"
}

variable "git_repository_name" {
  description = "Project name on Github"
}

variable "git_repository_branch" {
  description = "Github Project Branch"
}

variable "github_webhooks_token" {
  type        = string
  default     = ""
  description = "GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable"
}

variable "github_webhook_events" {
  type        = list(string)
  description = "A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/)"
  default     = ["push"]
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth Token with permissions to access private repositories"
}

variable "poll_source_changes" {
  type        = bool
  default     = false
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

variable "git_repository_branch_sanitized" {
  type        = string
  description = "Branch name without / and other symbols"
}

variable "api_url_env_name" {
  type        = string
  description = "API url environment variable name"
}

variable "api_url_env_value" {
  type        = string
  description = "API url environment variable value"
}

variable "websocket_url_env_name" {
  type        = string
  description = "WebSocket url environment variable name"
}

variable "websocket_url_env_value" {
  type        = string
  description = "WebSocket url environment variable value"
}
