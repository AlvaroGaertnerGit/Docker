@echo off
setlocal

:: ===========================
:: CONFIGURACIÓN DEL REGISTRO
:: ===========================
set ACR=mathviewacr.azurecr.io

echo ===========================
echo 🔐 Login en ACR
echo ===========================
:: echo Haciendo login en %ACR%...
:: az acr login --name mathviewacr
:: echo ✅ Login completado, continuando...

echo ===========================
echo 🛠️  Build: mathview-backend
echo ===========================
docker build -f dockerfile.api -t %ACR%/mathview-backend:latest ..
if errorlevel 1 echo ❌ Fallo al construir mathview-backend && pause && exit /b

echo ===========================
echo 🚀 Push: mathview-backend
echo ===========================
docker push %ACR%/mathview-backend:latest

echo ===========================
echo 🛠️  Build: mathview-frontend
echo ===========================
docker build -f dockerfile.front -t %ACR%/mathview-frontend:latest ..
if errorlevel 1 echo ❌ Fallo al construir mathview-frontend && pause && exit /b

echo ===========================
echo 🚀 Push: mathview-frontend
echo ===========================
docker push %ACR%/mathview-frontend:latest

echo ===========================
echo 🛠️  Build: mathview-api-user
echo ===========================
docker build -f dockerfile.users -t %ACR%/mathview-api-user:latest ..
if errorlevel 1 echo ❌ Fallo al construir mathview-api-user && pause && exit /b

echo ===========================
echo 🚀 Push: mathview-api-user
echo ===========================
docker push %ACR%/mathview-api-user:latest

echo ===========================
echo ✅ Imágenes subidas correctamente a %ACR%
pause
