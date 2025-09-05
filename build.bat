@echo off
echo 🚀 Building ChattyAI Flutter App...

echo 📦 Installing dependencies...
flutter pub get

echo 🔧 Generating Hive code...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo ✅ Build completed successfully!
echo.
echo To run the app:
echo flutter run
echo.
echo Note: If you encounter Hive generation issues, run:
echo flutter packages pub run build_runner build --delete-conflicting-outputs
pause 