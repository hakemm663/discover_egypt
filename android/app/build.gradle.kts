import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"
val mapsApiKeyFromLocalProperties = localProperties.getProperty("MAPS_API_KEY")
val mapsApiKeyFromCi = System.getenv("MAPS_API_KEY")

val requiresReleaseSigning = gradle.startParameter.taskNames.any {
    val taskName = it.substringAfterLast(':').lowercase()
    val isReleasePackagingTask = listOf("assemble", "bundle", "package").any { prefix ->
        taskName.startsWith(prefix) && taskName.endsWith("release")
    }
    val isReleasePublishTask = taskName.startsWith("publish") && taskName.contains("release")

    // Keep signing strict for real release outputs, but allow release-flavored utility tasks (for example app-link/settings generation).
    isReleasePackagingTask || isReleasePublishTask
}
val allowDebugSigningForRelease =
    providers.gradleProperty("allowDebugSigningForRelease").orNull == "true"

// Keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.discoveregypt.app"
    compileSdk = 36
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main") {
            java.srcDir("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.discoveregypt.app"
        minSdk = 24
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        multiDexEnabled = true
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKeyFromLocalProperties ?: ""
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = when {
                keystorePropertiesFile.exists() -> signingConfigs.getByName("release")
                allowDebugSigningForRelease -> signingConfigs.getByName("debug")
                requiresReleaseSigning -> throw GradleException(
                    "Release signing key is required. Add android/key.properties or pass -PallowDebugSigningForRelease=true for local-only builds."
                )
                else -> signingConfigs.getByName("debug")
            }

            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Prefer CI-provided secrets for release builds and fall back to local.properties.
            manifestPlaceholders["MAPS_API_KEY"] = mapsApiKeyFromCi
                ?: mapsApiKeyFromLocalProperties
                ?: ""
        }
        
        getByName("debug") {
            
            versionNameSuffix = "-debug"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.4"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")
    implementation("com.google.firebase:firebase-messaging")
    implementation("androidx.multidex:multidex:2.0.1")
}

apply(plugin = "com.google.gms.google-services")
