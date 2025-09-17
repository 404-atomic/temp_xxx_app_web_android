MAIN

------------------------------------------------------------
Gradle 8.7
------------------------------------------------------------

Build time:   2024-03-22 15:52:46 UTC
Revision:     650af14d7653aa949fce5e886e685efc9cf97c10

Kotlin:       1.9.22
Groovy:       3.0.17
Ant:          Apache Ant(TM) version 1.10.13 compiled on January 4 2023
JVM:          17.0.11 (JetBrains s.r.o. 17.0.11+0--11852314)
OS:           Windows Server 2022 10.0 amd64

=== java -version ===
openjdk version "17.0.11" 2024-04-16
OpenJDK Runtime Environment (build 17.0.11+0--11852314)
OpenJDK 64-Bit Server VM (build 17.0.11+0--11852314, mixed mode)
=== flutter --version ===
Flutter 3.24.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 2663184aa7 (1 year ago) • 2024-09-11 16:27:48 -0500
Engine • revision 36335019a8
Tools • Dart 3.5.3 • DevTools 2.37.3
=== env JAVA_HOME ===
C:\Program Files\Android\Android Studio\jbr
=== show gradle.properties ===
org.gradle.jvmargs=-Xmx4G
android.useAndroidX=true
android.enableJetifier=true

=== show android/build.gradle ===
ext.kotlin_version = '1.8.0'
apply from:  'app/auto_build.gradle'
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}

buildscript {
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath "com.github.qq549631030:android-junk-code:1.3.2"
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:2.0.0'
    }
}
=== show app/build.gradle ===
plugins {
    id "com.android.application"
    id "kotlin-android"
//    id "dev.flutter.flutter-gradle-plugin"
}


apply from: './auto_build.gradle'
apply from: 'config_junk_code_guard.gradle'
rootProject.ext.autoBuild.preInitTask(project)

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

android {
    namespace rootProject.ext.configAppId
    compileSdk 34

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {

        applicationId rootProject.ext.configAppId
        minSdkVersion 21
        targetSdkVersion 34
        versionCode rootProject.ext.configAppBuild.toInteger()
        versionName rootProject.ext.configAppVersion
        manifestPlaceholders = [
                OP_APP_KEY: "${rootProject.ext.opAppKey}"
        ]
        ndk {
            abiFilters 'arm64-v8a' //'armeabi-v7a', 'arm64-v8a'
        }
    }

    signingConfigs {

        release {
            keyAlias rootProject.ext.configAlias
            keyPassword rootProject.ext.configKeypass
            storeFile file(rootProject.ext.configKeyPath)
            storePassword rootProject.ext.configStorepass
        }
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.release
        }
    }
    applicationVariants.all { variant ->
        if (variant.buildType.name == 'release') {
            // Specify APK output path
            variant.outputs.all { output ->
                outputFileName = "release.apk" //
            }
        }
    }
}

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])

    implementation(project(':ui'))
}


//鍗曠嫭鎵ц鐨則ask锛岀敤浜庤嚜鍔ㄦ墦鍖?
tasks.register('startAutoBuild') {
    rootProject.ext.autoBuild.startAssembleApk(project)
}


=== gradle wrapper properties ===
#Wed Apr 14 16:10:50 CST 2021
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
org.gradle.daemon=false
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
#systemProp.http.proxyHost=127.0.0.1
#systemProp.https.proxyHost=127.0.0.1
#systemProp.https.proxyPort=1087
#systemProp.http.proxyPort=1087