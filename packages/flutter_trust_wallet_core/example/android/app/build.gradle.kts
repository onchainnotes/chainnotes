plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    
}

android {
    namespace = "org.ab.newpay.flutter_trust_wallet_core.flutter_trust_wallet_core_example"
//    compileSdk = flutter.compileSdkVersion
    //这里是demo app 的build.gradle不影响插件，硬编compileSdk版本即可运行
    compileSdk = 35
//    ndkVersion = flutter.ndkVersion
    //这里是demo app 的build.gradle不影响插件，硬编ndk版本即可运行
    ndkVersion = "27.0.12077973"


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.ab.newpay.flutter_trust_wallet_core.flutter_trust_wallet_core_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
        //这里是demo app 的build.gradle不影响插件，硬编码23即可运行
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
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
