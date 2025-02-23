import org.gradle.api.tasks.Exec

plugins {
    kotlin("multiplatform") version "1.9.21"
    kotlin("plugin.serialization") version "1.9.21"
}

kotlin {
    iosArm64 {
        binaries.framework {
            baseName = "SharedKMP"
            isStatic = false
            freeCompilerArgs += listOf("-Xbinary=bundleId=com.chatsopond.myVehicle.SharedKMP")
        }
    }
    iosSimulatorArm64 {
        binaries.framework {
            baseName = "SharedKMP"
            isStatic = false
        }
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                // Coroutines
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.3")
                // MQTT
                implementation("org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.2.5")
                // Serialization
                implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.5.1")
            }
        }
    }
}

tasks.register("assembleXCFramework") {
    dependsOn(
        "linkReleaseFrameworkIosArm64",
        "linkReleaseFrameworkIosSimulatorArm64"
    )

    doLast {
        val buildDir = layout.buildDirectory.get().asFile
        val outputDir = buildDir.resolve("xcframework")
        outputDir.mkdirs()

        val arm64Framework = buildDir.resolve("bin/iosArm64/releaseFramework/SharedKMP.framework")
        val simArm64Framework = buildDir.resolve("bin/iosSimulatorArm64/releaseFramework/SharedKMP.framework")

        val outputXCFramework = outputDir.resolve("SharedKMP.xcframework")

        exec {
            commandLine(
                "xcodebuild",
                "-create-xcframework",
                "-framework", arm64Framework.absolutePath,
                "-framework", simArm64Framework.absolutePath,
                "-output", outputXCFramework.absolutePath
            )
        }

        println("✅ XCFramework created at: ${outputXCFramework.absolutePath}")
    }
}