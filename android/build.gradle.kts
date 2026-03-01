import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.9.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(file("../build"))

subprojects {
    project.layout.buildDirectory.set(
        file("${rootProject.layout.buildDirectory.get()}/${project.name}")
    )
}

subprojects {
    project.evaluationDependsOn(":app")
}

// The Stripe Android plugin currently emits many Kotlin warnings in third-party code.
// Keep local builds readable and avoid warning-to-error policies failing on dependency code.
subprojects {
    if (name == "stripe_android") {
        tasks.withType<KotlinCompile>().configureEach {
            compilerOptions {
                suppressWarnings.set(true)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
