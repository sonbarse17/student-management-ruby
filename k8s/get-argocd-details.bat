@echo off
echo Getting ArgoCD connection details...

echo ===================================
echo ArgoCD Connection Details
echo ===================================

REM Get service details
kubectl get svc argocd-server -n argocd

echo.
echo Username: admin
echo.
echo To get password, run this command:
echo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
echo.
echo Then decode the base64 password at: https://www.base64decode.org/
echo.
echo ArgoCD Status:
kubectl get pods -n argocd