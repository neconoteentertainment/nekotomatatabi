@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter command was not found. Add Flutter to PATH first.
  pause
  exit /b 1
)
if not exist windows\CMakeLists.txt (
  flutter create . --platforms=windows --org com.neconote --project-name nekotomatatabi
  if errorlevel 1 goto :error
)
flutter pub get
if errorlevel 1 goto :error
flutter run -d windows
exit /b %errorlevel%
:error
echo.
echo Setup or build failed.
pause
exit /b 1
