# Architecture Diagrams - Student Management System

This document describes the architectural diagrams generated for the Ruby on Rails Student Management System deployed on Google Kubernetes Engine (GKE).

## Generated Diagrams

### 1. Main Architecture Diagram
**File:** `student_management_system_-_rails_on_gke.png`

This diagram shows the overall system architecture including:
- **GitHub Repository** - Source code and CI/CD workflows
- **Docker Hub** - Container registry for application and database images
- **Google Cloud Platform** - Cloud infrastructure
- **GKE Cluster** - Kubernetes cluster containing:
  - Rails Application (3 replicas)
  - PostgreSQL Database (StatefulSet)
  - Persistent Storage (30Gi GCE PD)
  - GCE Ingress (Load Balancer)
  - ArgoCD (Optional GitOps)
- **Terraform** - Infrastructure as Code

### 2. Detailed Architecture Diagram
**File:** `student_management_system_-_detailed_architecture.png`

This comprehensive diagram includes:
- **Development & Source Control**
  - GitHub Repository
- **CI/CD Pipeline** with all GitHub Actions workflows:
  - Docker Build & Push
  - Terraform Plan/Apply
  - Kubernetes Deploy
  - ArgoCD Install
  - Cleanup Workflows
- **Google Cloud Platform** with detailed GKE components:
  - Application Tier (Rails deployment and pods)
  - Database Tier (PostgreSQL StatefulSet)
  - Storage Layer (PVC, PV, Storage Class)
  - Database Operations (Migration Job)
  - Networking (Ingress, Load Balancer)
  - GitOps (ArgoCD Controller)

### 3. CI/CD Pipeline Flow Diagram
**File:** `cd_pipeline_flow_-_student_management_system.png`

This diagram illustrates the step-by-step deployment process:
1. **Source Control** - Developer pushes code to GitHub
2. **Automated Build** - Docker images built and pushed to registry
3. **Infrastructure** - Terraform provisions GKE cluster
4. **Deployment** - Kubernetes manifests deploy application
5. **GitOps** - ArgoCD manages deployments (optional)
6. **Cleanup** - Terraform destroy and workflow cleanup

## Architecture Components

### Application Stack
- **Frontend/Backend:** Ruby on Rails 7.1.5
- **Database:** PostgreSQL
- **Container Runtime:** Docker
- **Orchestration:** Kubernetes (GKE)
- **Load Balancer:** Google Cloud Load Balancer
- **Storage:** Google Cloud Persistent Disk

### CI/CD Pipeline
- **Source Control:** GitHub
- **CI/CD:** GitHub Actions
- **Container Registry:** Docker Hub
- **Infrastructure as Code:** Terraform
- **GitOps:** ArgoCD (Optional)

### Resource Specifications
- **Rails Application:**
  - Replicas: 3
  - CPU: 500m (limit), 250m (request)
  - Memory: 512Mi (limit), 256Mi (request)
  - Port: 3000

- **PostgreSQL Database:**
  - Replicas: 1 (StatefulSet)
  - CPU: 500m
  - Memory: 1Gi
  - Storage: 30Gi (Persistent Volume)
  - Port: 5432

### Networking
- **Ingress:** GCE Ingress Controller
- **Services:** ClusterIP for internal communication
- **Load Balancer:** External access via Google Cloud Load Balancer
- **SSL:** Automatic SSL termination at load balancer

### Deployment Workflow
1. Code push triggers Docker build workflow
2. Images pushed to Docker Hub registry
3. Manual trigger for Terraform infrastructure provisioning
4. Automatic deployment to Kubernetes after infrastructure creation
5. Optional ArgoCD installation for GitOps management
6. Manual cleanup and destroy workflows available

## Security Features
- **Container Security:** Images scanned and updated regularly
- **Network Security:** Private cluster with controlled ingress
- **Access Control:** Kubernetes RBAC and GCP IAM
- **Secrets Management:** Kubernetes secrets for sensitive data
- **SSL/TLS:** Encrypted communication via load balancer

## Monitoring & Observability
- **Health Checks:** Kubernetes readiness and liveness probes
- **Logging:** Centralized logging via Google Cloud Logging
- **Metrics:** Container and cluster metrics via Google Cloud Monitoring
- **Alerting:** Configurable alerts for system health

## Scalability
- **Horizontal Pod Autoscaling:** Automatic scaling based on CPU/memory
- **Cluster Autoscaling:** Node pool scaling based on demand
- **Database Scaling:** Vertical scaling for PostgreSQL
- **Load Distribution:** Multiple replicas with load balancing

## Disaster Recovery
- **Persistent Storage:** Data persistence via Google Cloud Persistent Disks
- **Backup Strategy:** Regular database backups
- **Multi-Zone Deployment:** High availability across zones
- **Infrastructure as Code:** Reproducible infrastructure via Terraform

---

**Generated on:** $(date)
**Tools Used:** Python Diagrams library with Graphviz
**Architecture:** Ruby on Rails on Google Kubernetes Engine