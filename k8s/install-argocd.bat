@echo off
echo Installing ArgoCD...

REM Create argocd namespace
kubectl create namespace argocd

REM Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo Waiting for ArgoCD to be ready...
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

REM Patch ArgoCD server service to LoadBalancer
kubectl patch svc argocd-server -n argocd -p "{\"spec\": {\"type\": \"LoadBalancer\"}}"

echo Waiting for external IP...
timeout /t 60

REM Get connection details
echo ===================================
echo ArgoCD Installation Complete!
echo ===================================
echo Getting connection details...

kubectl get svc argocd-server -n argocd
echo.
echo To get the admin password, run:
echo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" ^| base64 -d
echo.
echo Username: admin
echo ===================================