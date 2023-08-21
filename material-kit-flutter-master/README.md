# [Material Kit Pro Flutter](https://creativetimofficial.github.io/material-kit-pro-flutter) [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&logo=twitter)](https://twitter.com/intent/tweet?text=Start%20Your%20Development%20With%20A%20Badass%20Flutter%20app%20inspired%20by%20Material%20Design.%0Ahttps%3A//demos.creative-tim.com/material-kit-pro-flutter/)

## Configuracion google services
- Configurar Api Key de Android para geolocalizacion en AndroidManifest.xml (com.google.android.geo.API_KEY)
- Configurar ./android/app/google-services.json y apiKeyMaps de ./lib/constants/config.dart

## Configurar app
- Actualizar en ./lib/constants/config.dart la URL del Api  

## Desarrollo
- flutter pub run build_runner build --delete-conflicting-outputs

- flutter pub run build_runner watch --delete-conflicting-outputs

## Compilar APK
flutter build apk
