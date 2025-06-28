#!/bin/bash

echo "Installing ArgoCD..."

# Create argocd namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Patch ArgoCD server service to LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo "Waiting for external IP..."
kubectl wait --for=jsonpath='{.status.loadBalancer.ingress[0].ip}' service/argocd-server -n argocd --timeout=300s

# Get external IP
EXTERNAL_IP=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Get initial admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "=================================="
echo "ArgoCD Installation Complete!"
echo "=================================="
echo "ArgoCD URL: https://$EXTERNAL_IP"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo "=================================="
echo "Note: It may take a few minutes for the LoadBalancer IP to be available"