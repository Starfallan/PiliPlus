plugins {
    alias(libs.plugins.androidApplication)
    id("org.jetbrains.kotlin.android") version "2.1.0"
    id("org.lsposed.lsplugin.jgit") version "1.1" 
    id("org.lsposed.lsplugin.resopt") version "1.6" 
    id("org.lsposed.lsplugin.apksign") version "1.4"
    id("org.lsposed.lsplugin.apktransform") version "1.2" 
}

val appVerCode = jgit.repo()?.commitCount("refs/remotes/origin/main") ?: 1
val appVerName: String by rootProject

apksign {
    storeFileProperty = "releaseStoreFile"
    storePasswordProperty = "releaseStorePassword"
    keyAliasProperty = "releaseKeyAlias"
    keyPasswordProperty = "releaseKeyPassword"
}

apktransform {
    copy {
        when (it.buildType) {
            "release" -> file("${it.name}/TrialQualityStandalone_${appVerName}.apk")
            else -> null
        }
    }
}

android {
    namespace = "io.github.tqsa"
    compileSdk = 35
    buildToolsVersion = "36.0.0-rc4"

    defaultConfig {
        applicationId = "io.github.tqsa"
        minSdk = 24
        targetSdk = 35
        versionCode = appVerCode
        versionName = appVerName
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_23
        targetCompatibility = JavaVersion.VERSION_23
    }

    kotlinOptions {
        jvmTarget = "23"
        freeCompilerArgs = listOf(
            "-Xno-param-assertions",
            "-Xno-call-assertions",
            "-Xno-receiver-assertions",
            "-language-version=2.0",
        )
    }
}

configurations.all {
    exclude("org.jetbrains.kotlin", "kotlin-stdlib-jdk7")
    exclude("org.jetbrains.kotlin", "kotlin-stdlib-jdk8")
}

dependencies {
    compileOnly(libs.xposed)
}
