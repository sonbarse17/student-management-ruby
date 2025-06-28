# Setup Instructions

## Required GitHub Secrets

Add these secrets to your GitHub repository:

### GCP Configuration
- `GCP_SERVICE_ACCOUNT_KEY` - Your GCP service account JSON key
- `GCP_PROJECT_ID` - Your GCP project ID (e.g., `your-project-123`)
- `GCP_REGION` - GCP region (e.g., `us-central1`)
- `GKE_CLUSTER_NAME` - Your GKE cluster name (e.g., `my-gke-cluster`)

## How to Add Secrets

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add each secret with the exact name above

## Pipeline Usage

1. **Deploy Infrastructure**: Run "Terraform Apply" workflow
2. **Deploy Application**: Run "Deploy to Kubernetes" workflow
3. **Destroy Everything**: Run "Terraform Destroy" workflow

## Security Note

This repository uses GitHub secrets to prevent hardcoded credentials. Anyone can fork this repo but cannot use your GCP resources without your secrets.