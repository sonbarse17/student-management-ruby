output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubernetes_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "node_pool_name" {
  value = google_container_node_pool.primary_nodes.name
}

output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}
