#!/bin/bash

echo "Deploying Student Management App to Kubernetes..."

# Deploy database first
echo "1. Deploying database StatefulSet..."
kubectl apply -f db-deploy.yml

echo "2. Deploying database service..."
kubectl apply -f db-svc.yml

# Wait for database to be ready
echo "3. Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=student-app-db --timeout=300s

# Deploy application
echo "4. Deploying application..."
kubectl apply -f app-deployment.yml

echo "5. Deploying application service..."
kubectl apply -f app-svc.yml

# Optional: Deploy ingress if needed
if [ -f "ingress.yml" ]; then
    echo "6. Deploying ingress..."
    kubectl apply -f ingress.yml
fi

echo "Deployment complete!"
echo "Check status with: kubectl get pods,svc"