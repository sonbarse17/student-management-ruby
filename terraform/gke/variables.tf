variable "project_id" {
  type        = string
  description = "Your GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  type        = string
  default     = "my-gke-cluster"
}

variable "node_count" {
  type        = number
  default     = 1
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
}
