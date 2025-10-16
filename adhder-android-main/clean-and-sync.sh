#!/bin/bash

echo "🧹 清理Android项目缓存..."

cd "$(dirname "$0")"

# 1. 清理 Gradle 构建缓存
echo "1️⃣ 清理 Gradle 构建缓存..."
./gradlew clean

# 2. 删除 .gradle 目录
echo "2️⃣ 删除 .gradle 目录..."
rm -rf .gradle

# 3. 删除 build 目录
echo "3️⃣ 删除所有 build 目录..."
find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true

# 4. 删除 .idea 缓存（如果存在）
echo "4️⃣ 清理 IDE 缓存..."
rm -rf .idea

# 5. 使 gradlew 可执行
chmod +x gradlew

echo ""
echo "✅ 缓存清理完成！"
echo ""
echo "📋 下一步操作："
echo "  1. 在 Android Studio 中:"
echo "     - File → Invalidate Caches / Restart"
echo "     - 或者直接重新打开项目"
echo ""
echo "  2. 或者在命令行运行:"
echo "     ./gradlew build"
echo ""

