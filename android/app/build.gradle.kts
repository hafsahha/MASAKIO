plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.capi"
    compileSdk = 34 // Updated to latest stable Android SDK
    ndkVersion = "26.1.10909125" // Updated to latest stable NDK
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Updated to Java 17
        targetCompatibility = JavaVersion.VERSION_17 // Updated to Java 17
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString() // Updated to Java 17
    }
    
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.capi"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21 // Updated to a widely compatible min SDK
        targetSdk = 34 // Updated to latest stable Android SDK
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
