# build.gradle.kts 报错修复总结

## 🐛 问题描述

`build.gradle.kts` 文件显示以下错误：
```
Unresolved reference: habitrpg
```

## 🔍 根本原因

在全局重命名过程中，虽然大部分文件已经从 "habitica" 改为 "adhder"，但存在不一致：

1. **`gradle/libs.versions.toml`** 中的插件定义已经改名：
   - `habitrpg.application` → `adhderapp.application`
   - `habitrpg.convention` → `adhderapp.convention`

2. 但 **`build.gradle.kts`** 中还在引用旧的插件名称

3. **`settings.gradle.kts`** 中的项目名称和模块名称也需要更新

## ✅ 修复内容

### 1. 修改 `build.gradle.kts`

**第17-18行：**
```kotlin
// 修改前
alias(libs.plugins.habitrpg.application) apply false
alias(libs.plugins.habitrpg.convention) apply false

// 修改后
alias(libs.plugins.adhderapp.application) apply false
alias(libs.plugins.adhderapp.convention) apply false
```

**第22行：**
```kotlin
// 修改前
dependsOn(":Habitica:testProdDebugUnitTest", ...)

// 修改后
dependsOn(":Adhder:testProdDebugUnitTest", ...)
```

### 2. 修改 `settings.gradle.kts`

**第47-48行：**
```kotlin
// 修改前
rootProject.name = "habitica-android"
include(":Habitica", ":wearos", ":common", ":shared")

// 修改后
rootProject.name = "adhder-android"
include(":Adhder", ":wearos", ":common", ":shared")
```

### 3. 清理缓存

删除了以下缓存目录：
- `.gradle/` - Gradle 守护进程和缓存
- `build/` - 构建输出目录

## 🚀 下一步操作

### 方法1: 使用 Android Studio（推荐）

1. 打开 Android Studio
2. 点击 **File → Invalidate Caches / Restart**
3. 等待 Gradle 同步完成

### 方法2: 使用命令行

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final/adhder-android-main

# 清理并重新构建
./gradlew clean
./gradlew build

# 或者只同步依赖
./gradlew --refresh-dependencies
```

### 方法3: 使用清理脚本

```bash
./clean-and-sync.sh
```

## 📝 验证修复

修复后，您应该能够：

1. ✅ 在 IDE 中打开项目，不再显示 "Unresolved reference" 错误
2. ✅ 成功执行 Gradle 同步
3. ✅ 成功构建项目：`./gradlew assembleDebug`
4. ✅ 运行单元测试：`./gradlew allUnitTests`

## 🔗 相关文件

修改的文件：
- ✅ `adhder-android-main/build.gradle.kts`
- ✅ `adhder-android-main/settings.gradle.kts`

参考文件：
- 📖 `adhder-android-main/gradle/libs.versions.toml`（插件定义，第217-218行）

## 💡 说明

这些错误是由于全局重命名时，Gradle 的版本目录（`libs.versions.toml`）中的插件别名已更新，但引用这些别名的构建脚本未同步更新导致的。现在所有引用已经对齐，项目应该可以正常构建了。

---

**修复日期**: 2025-10-15  
**状态**: ✅ 已完成

