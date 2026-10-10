plugins {
    id("maven-publish")
}

publishing {
    publications {
        create<MavenPublication>("aar") {
            groupId = "org.abwallet"      // 修改为你的组织ID
            artifactId = "wallet-core"        // 修改为你的项目ID
            version = "3.0.0"                 // 修改为你的版本号
            artifact("../../android/libs/trustwalletcore-release.aar")  // 修改为你的 AAR 文件路径
        }
    }

    repositories {
        maven {
            name = "ForceRepo"
            url = uri("https://weixuefeng-maven.pkg.coding.net/repository/ab-wallet/wallet-core")  // 修改为你的 Maven 仓库地址
            credentials {
                username = "wallet-core-1747129113554"
                password = "e0399ca744f4e2f667314f211b7b58b8b3b08a8b"
            }
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
