# VARIABLES
$resourceGroup = "MathView-RG"
$acrName = "mathviewacr"
$acrLoginServer = "$acrName.azurecr.io"
$imageName = "mathview-frontend"
$imageTag = "latest"
$fullImageName = "${acrLoginServer}/${imageName}:${imageTag}"
$appServicePlan = "mathview-plan"
$webAppName = "mathview"

# 1. Construir la imagen Docker
Write-Host "Construyendo imagen Docker..."
docker build --no-cache -f ./dockerfile.front -t $fullImageName .

# 2. Login en el ACR
Write-Host "Iniciando sesión en Azure Container Registry..."
az acr login --name $acrName

# 3. Subir la imagen al ACR
Write-Host "Subiendo imagen a ACR..."
docker push $fullImageName

# 4. Obtener credenciales del ACR
Write-Host "Obteniendo credenciales del ACR..."
$acrCreds = az acr credential show --name $acrName --query "{username:username, password:passwords[0].value}" -o json | ConvertFrom-Json

# 5. Crear App Service Plan (si no existe)
Write-Host "Creando App Service Plan (si no existe)..."
az appservice plan create `
  --name $appServicePlan `
  --resource-group $resourceGroup `
  --is-linux `
  --sku B1 `
  --output none

# 6. Crear Web App (si no existe)
$appExists = az webapp show --name $webAppName --resource-group $resourceGroup --query "name" -o tsv 2>$null

if (-not $appExists) {
    Write-Host "Creando nueva Web App '$webAppName'..."
    az webapp create `
      --resource-group $resourceGroup `
      --plan $appServicePlan `
      --name $webAppName `
      --deployment-container-image-name $fullImageName `
      --output none
} else {
    Write-Host "La Web App ya existe. Se actualizará la imagen del contenedor..."
}

# 7. Configurar acceso al ACR
Write-Host "Configurando Web App con acceso al ACR..."
az webapp config container set `
  --name $webAppName `
  --resource-group $resourceGroup `
  --docker-custom-image-name $fullImageName `
  --docker-registry-server-url "https://${acrLoginServer}" `
  --docker-registry-server-user $acrCreds.username `
  --docker-registry-server-password $acrCreds.password `
  --output none

# 8. URL Final
Write-Host "`n✅ Despliegue completado. Accede a: https://$webAppName.azurewebsites.net"
