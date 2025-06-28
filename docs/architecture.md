# Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              GITHUB ACTIONS CI/CD                          │
├─────────────────────────────────────────────────────────────────────────────┤
│  Code Push → Docker Build → Terraform Plan → Manual Deploy → ArgoCD        │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GOOGLE CLOUD PLATFORM                            │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        GKE CLUSTER                                  │    │
│  │                                                                     │    │
│  │  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐  │    │
│  │  │   RAILS APP     │    │   POSTGRESQL    │    │     ARGOCD      │  │    │
│  │  │   (3 replicas)  │    │  (StatefulSet)  │    │   (Optional)    │  │    │
│  │  │                 │    │                 │    │                 │  │    │
│  │  │ Port: 3000      │    │ Port: 5432      │    │ Port: 80/443    │  │    │
│  │  │ Image: ruby-app │    │ Image: ruby-db  │    │ Helm Chart      │  │    │
│  │  │ Resources:      │    │ Resources:      │    │                 │  │    │
│  │  │ - CPU: 500m     │    │ - CPU: 500m     │    │                 │  │    │
│  │  │ - Memory: 512Mi │    │ - Memory: 1Gi   │    │                 │  │    │
│  │  └─────────────────┘    └─────────────────┘    └─────────────────┘  │    │
│  │           │                       │                       │         │    │
│  │           ▼                       ▼                       ▼         │    │
│  │  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐  │    │
│  │  │  ClusterIP SVC  │    │  ClusterIP SVC  │    │ LoadBalancer    │  │    │
│  │  │  app-service    │    │   db-service    │    │   argocd-svc    │  │    │
│  │  │  Port: 80       │    │   Port: 5432    │    │  External IP    │  │    │
│  │  └─────────────────┘    └─────────────────┘    └─────────────────┘  │    │
│  │           │                                                         │    │
│  │           ▼                                                         │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │                    GCE INGRESS                              │    │    │
│  │  │                                                             │    │    │
│  │  │  - External IP: Load Balancer                              │    │    │
│  │  │  - SSL Termination                                         │    │    │
│  │  │  - Path-based routing                                      │    │    │
│  │  │  - Health checks                                           │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │                                                                     │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │                 PERSISTENT STORAGE                          │    │    │
│  │  │                                                             │    │    │
│  │  │  - Storage Class: standard (GCE PD)                        │    │    │
│  │  │  - Size: 30Gi                                              │    │    │
│  │  │  - Access Mode: ReadWriteOnce                              │    │    │
│  │  │  - Mounted: /var/lib/postgresql/data                       │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      TERRAFORM STATE                                │    │
│  │                                                                     │    │
│  │  - Backend: Google Cloud Storage                                   │    │
│  │  - Bucket: {project-id}-terraform-state                            │    │
│  │  - Versioning: Enabled                                             │    │
│  │  - Location: us-central1                                           │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              EXTERNAL ACCESS                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Internet → GCE Load Balancer → Ingress → Rails App                        │
│                                                                             │
│  ArgoCD → LoadBalancer Service → External IP                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                            DEPLOYMENT FLOW                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. Code Push → Docker Build & Push to DockerHub                           │
│  2. Manual: Terraform Apply → Create GKE Cluster                           │
│  3. Auto: K8s Deploy → Deploy App + DB + Migrations                        │
│  4. Manual: ArgoCD Install → Install ArgoCD with Helm                      │
│  5. Manual: Terraform Destroy → Clean up everything                        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Components

### **Application Layer**
- **Rails 7.1.5** - Ruby web application
- **PostgreSQL 15** - Database with persistent storage
- **3 App Replicas** - High availability setup

### **Infrastructure Layer**
- **GKE Cluster** - Managed Kubernetes on Google Cloud
- **Node Pool** - e2-medium instances
- **GCE Ingress** - External load balancer
- **Cloud Storage** - Terraform state backend

### **CI/CD Pipeline**
- **7 GitHub Actions** - Automated deployment pipeline
- **Docker Hub** - Container registry
- **Terraform** - Infrastructure as Code
- **Helm** - ArgoCD package management

### **Networking**
- **ClusterIP** - Internal service communication
- **LoadBalancer** - External access for ArgoCD
- **Ingress** - HTTP/HTTPS routing for main app

### **Storage**
- **StatefulSet** - Database persistence
- **PVC** - 30Gi standard storage class
- **Terraform State** - GCS bucket with versioning