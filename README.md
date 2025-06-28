# Student Management System - Rails on GKE

A Ruby on Rails application deployed on Google Kubernetes Engine (GKE) with complete CI/CD pipeline using GitHub Actions, Terraform, and ArgoCD.

## 🏗️ Architecture

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

## 🚀 Features

- **Rails 7.1.5** with PostgreSQL database
- **Kubernetes deployment** on Google Cloud GKE
- **CI/CD pipeline** with GitHub Actions
- **Infrastructure as Code** with Terraform
- **Container orchestration** with Docker
- **GitOps ready** with ArgoCD support
- **Auto-scaling** and high availability
- **Persistent storage** for database

## 📋 Prerequisites

### Required Accounts
- Google Cloud Platform account
- Docker Hub account
- GitHub repository

### Required Tools (for local development)
- Docker
- kubectl
- gcloud CLI
- Terraform

## ⚙️ Setup Instructions

### 1. Fork/Clone Repository
```bash
git clone https://github.com/your-username/student-management-ruby.git
cd student-management-ruby
```

### 2. Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `GCP_SERVICE_ACCOUNT_KEY` | GCP service account JSON key | `{"type": "service_account"...}` |
| `DOCKERHUB_USERNAME` | Docker Hub username | `your-dockerhub-username` |
| `DOCKERHUB_PASSWORD` | Docker Hub password/token | `your-dockerhub-password` |

### 3. Create GCP Service Account

```bash
# Create service account
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions"

# Grant necessary permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

# Create and download key
gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

### 4. Update Configuration

Edit these files with your values:
- `terraform/gke/terraform.tfvars` - Update project ID and region
- `.github/workflows/docker-build-push.yml` - Update Docker Hub username

## 🔄 Deployment Pipeline

### Pipeline Overview
```
Code Push → Docker Build → Terraform Plan → Manual Deploy → ArgoCD
```

### Available Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| **Docker Build & Push** | Push to main | Build and push container images |
| **Terraform Plan** | Push/PR | Preview infrastructure changes |
| **Terraform Apply** | Manual | Create GKE cluster |
| **Deploy to Kubernetes** | Auto after Terraform Apply | Deploy application |
| **Install ArgoCD** | Manual | Install ArgoCD with Helm |
| **Terraform Destroy** | Manual | Destroy infrastructure |
| **Cleanup Workflows** | Auto after destroy | Clean old workflow runs |

### Deployment Steps

#### Step 1: Build and Push Images
Push code to main branch:
```bash
git add .
git commit -m "Deploy to GKE"
git push origin main
```
This triggers Docker build and push automatically.

#### Step 2: Create Infrastructure
1. Go to **Actions** tab in GitHub
2. Run **"Terraform Apply"** workflow
3. Wait for GKE cluster creation (~10 minutes)

#### Step 3: Deploy Application
1. **"Deploy to Kubernetes"** runs automatically after Terraform Apply
2. Or run manually from Actions tab
3. Wait for deployment completion (~5 minutes)

#### Step 4: Install ArgoCD (Optional)
1. Run **"Install ArgoCD"** workflow manually
2. Get ArgoCD URL and credentials from output

#### Step 5: Access Application
- **Main App**: Check workflow output for external IP
- **ArgoCD**: Use LoadBalancer IP from ArgoCD installation

## 🌐 Accessing the Application

### Main Application
```
http://EXTERNAL_IP/
```
The external IP is displayed in the deployment workflow output.

### ArgoCD (if installed)
```
https://ARGOCD_EXTERNAL_IP/
Username: admin
Password: [from workflow output]
```

## 🗂️ Project Structure

```
├── app/                    # Rails application code
├── config/                 # Rails configuration
├── db/                     # Database migrations and seeds
├── k8s/                    # Kubernetes manifests
│   ├── app-deployment.yml  # Rails app deployment
│   ├── app-svc.yml        # Rails app service
│   ├── db-deploy.yml      # PostgreSQL StatefulSet
│   ├── db-svc.yml         # Database service
│   ├── db-init-job.yml    # Database migration job
│   └── ingress.yml        # GCE Ingress
├── terraform/gke/         # Terraform infrastructure code
├── .github/workflows/     # GitHub Actions pipelines
├── Dockerfile.app         # Rails app container
├── Dockerfile.db          # PostgreSQL container
└── docs/                  # Documentation
```

## 🔧 Configuration

### Environment Variables
The application uses these environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_HOST` | PostgreSQL host | `db-service` |
| `DATABASE_USERNAME` | Database username | `postgres` |
| `DATABASE_PASSWORD` | Database password | `postgres` |
| `DATABASE_PORT` | Database port | `5432` |
| `RAILS_ENV` | Rails environment | `development` |

### Resource Limits
- **Rails App**: 500m CPU, 512Mi Memory
- **PostgreSQL**: 500m CPU, 1Gi Memory
- **Storage**: 30Gi persistent volume

## 🧹 Cleanup

### Destroy Everything
1. Run **"Terraform Destroy"** workflow
2. This will:
   - Delete all Kubernetes resources
   - Destroy GKE cluster
   - Preserve Terraform state bucket
   - Trigger workflow cleanup

### Manual Cleanup
```bash
# Delete specific resources
kubectl delete namespace default --cascade
kubectl delete namespace argocd --cascade

# Delete cluster directly
gcloud container clusters delete my-gke-cluster --region=us-central1
```

## 🐛 Troubleshooting

### Common Issues

**1. Pipeline Fails with Permission Errors**
- Check GCP service account has required roles
- Verify GitHub secrets are set correctly

**2. Database Connection Issues**
- Check if database pod is running: `kubectl get pods`
- Verify service endpoints: `kubectl get svc`

**3. Ingress Not Getting External IP**
- Wait 10-15 minutes for GCE load balancer
- Check ingress status: `kubectl describe ingress rails-ingress`

**4. ArgoCD Installation Fails**
- Service account needs cluster admin permissions
- Try manual installation with proper RBAC

### Useful Commands
```bash
# Check pod status
kubectl get pods -o wide

# View pod logs
kubectl logs -f deployment/student-app

# Check services
kubectl get svc

# Describe ingress
kubectl describe ingress rails-ingress

# Port forward for local access
kubectl port-forward svc/app-service 3000:80
```

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment pipeline
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Rails, Kubernetes, and Google Cloud Platform**