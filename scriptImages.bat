@echo off
echo ===========================
echo 🛠️  Build: mathview-backend
echo ===========================
docker build -f dockerfile.api -t ghcr.io/alvarogaertnergit/mathview-backend:latest ..

echo ===========================
echo 🚀 Push: mathview-backend
echo ===========================
docker push ghcr.io/alvarogaertnergit/mathview-backend:latest

echo ===========================
echo 🛠️  Build: mathview-frontend
echo ===========================
docker build -f dockerfile.front -t ghcr.io/alvarogaertnergit/mathview-frontend:latest ..

echo ===========================
echo 🚀 Push: mathview-frontend
echo ===========================
docker push ghcr.io/alvarogaertnergit/mathview-frontend:latest

echo ===========================
echo 🛠️  Build: mathview-api-user
echo ===========================
docker build -f dockerfile.users -t ghcr.io/alvarogaertnergit/mathview-api-user:latest ..

echo ===========================
echo 🚀 Push: mathview-api-user
echo ===========================
docker push ghcr.io/alvarogaertnergit/mathview-api-user:latest

echo ===========================
echo ✅ Todo listo
pause
