@echo off
cd /d "%~dp0"

echo Regenerating asset listing...
"C:\Program Files\Blender Foundation\Blender 5.2\blender.exe" -b -c asset_listing generate .
if errorlevel 1 (
    echo Blender failed - aborting.
    pause
    exit /b 1
)

echo Updating library name/contact info...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p = Join-Path (Get-Location) '_asset-library-meta.json';" ^
  "$j = Get-Content $p -Raw | ConvertFrom-Json;" ^
  "$j.name = 'DAE Assets';" ^
  "$j.contact.name = 'Cedric Van der Kelen / Howest DAE';" ^
  "$j.contact.url = 'https://github.com/DoCedric/DAE-Assets';" ^
  "$j.contact.email = 'cedric.van.der.kelen@howest.be';" ^
  "$j | ConvertTo-Json -Depth 10 | Set-Content -Path $p -Encoding UTF8"

echo Done.
pause