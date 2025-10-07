#!/bin/bash

echo "🚀 ADHDer 简化APK构建脚本"
echo "================================"

# 设置环境变量
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

echo "📦 安装依赖..."
npx pnpm@9.11.0 install

echo "🔧 生成原生代码..."
npx expo prebuild -p android --clean

echo "🔨 构建APK..."
cd android

# 使用更简单的Gradle配置
cat > settings.gradle << 'EOF'
rootProject.name = 'ADHDer'
include ':app'
EOF

# 构建APK
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo "✅ APK构建成功！"
    echo "📱 APK位置: app/build/outputs/apk/debug/app-debug.apk"
    
    # 复制APK到项目根目录
    cp app/build/outputs/apk/debug/app-debug.apk ../ADHDer-debug.apk
    echo "📋 APK已复制到: ADHDer-debug.apk"
    
    # 显示APK信息
    if [ -f "../ADHDer-debug.apk" ]; then
        APK_SIZE=$(du -h "../ADHDer-debug.apk" | cut -f1)
        echo "📊 APK大小: $APK_SIZE"
    fi
else
    echo "❌ APK构建失败"
    exit 1
fi

cd ..

echo ""
echo "🎉 构建完成！"
echo "📱 你可以将APK安装到Android设备上"
echo "🔧 或者使用: adb install ADHDer-debug.apk"
