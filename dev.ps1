$Root = $PSScriptRoot

Write-Host ""
Write-Host "  TaskFlow - Demarrage de la stack dev" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] PostgreSQL (Docker)..." -ForegroundColor Yellow
docker compose up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Erreur Docker Compose. Docker Desktop est-il lance ?" -ForegroundColor Red
    exit 1
}
Write-Host "  OK" -ForegroundColor Green

Write-Host "[2/3] Backend Spring Boot..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$Root'; `$host.UI.RawUI.WindowTitle = 'TaskFlow - Backend'; " +
    ".\taskflow-backend\mvnw.cmd --file taskflow-backend\pom.xml spring-boot:run"
)

Write-Host "[3/3] Frontend Nuxt..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$Root\taskflow-frontend'; `$host.UI.RawUI.WindowTitle = 'TaskFlow - Frontend'; pnpm dev"
)

Write-Host ""
Write-Host "  Stack demarree !" -ForegroundColor Green
Write-Host ""
Write-Host "  Frontend  ->  http://localhost:3000" -ForegroundColor White
Write-Host "  Backend   ->  http://localhost:8080" -ForegroundColor White
Write-Host "  Base      ->  localhost:5432  (DBeaver)" -ForegroundColor White
Write-Host ""