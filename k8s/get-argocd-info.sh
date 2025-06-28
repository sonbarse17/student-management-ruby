#!/bin/bash

echo "Getting ArgoCD connection information..."

# Get external IP
EXTERNAL_IP=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Get initial admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "=================================="
echo "ArgoCD Connection Details"
echo "=================================="
echo "URL: https://$EXTERNAL_IP"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo "=================================="

# Check if ArgoCD is running
echo "ArgoCD Status:"
kubectl get pods -n argocd