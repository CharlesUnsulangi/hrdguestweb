@echo off
REM ci_local.bat - Run the same checks locally as CI (Windows)

:: Change to project root if needed
cd /d %~dp0

echo Running flutter pub get...
flutter pub get || goto :err

echo Running flutter analyze...
flutter analyze || goto :err

echo Running flutter test...
flutter test || goto :err

echo Building web release...
flutter build web --release || goto :err

echo All checks passed. Web build output: build\web
goto :eof

:err
echo One or more steps failed. Check output above.
exit /b 1
