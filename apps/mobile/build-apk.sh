#!/bin/bash

echo "🚀 ADHDer 本地APK构建脚本"
echo "================================"

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

# 检查依赖
echo "📦 检查依赖..."
if [ ! -d "node_modules" ]; then
    echo "安装依赖..."
    npx pnpm@9.11.0 install
fi

# 生成原生代码
echo "🔧 生成原生代码..."
npx expo prebuild -p android --clean

# 检查Android环境
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  未设置ANDROID_HOME，尝试自动检测..."
    
    # 常见的Android SDK路径
    ANDROID_PATHS=(
        "$HOME/Library/Android/sdk"
        "$HOME/Android/Sdk"
        "/usr/local/android-sdk"
        "/opt/android-sdk"
    )
    
    for path in "${ANDROID_PATHS[@]}"; do
        if [ -d "$path" ]; then
            export ANDROID_HOME="$path"
            export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
            echo "✅ 找到Android SDK: $ANDROID_HOME"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        echo "❌ 未找到Android SDK，请安装Android Studio或设置ANDROID_HOME"
        echo "📖 安装指南："
        echo "1. 下载Android Studio: https://developer.android.com/studio"
        echo "2. 安装后设置环境变量："
        echo "   export ANDROID_HOME=\$HOME/Library/Android/sdk"
        echo "   export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
        exit 1
    fi
fi

# 检查adb
if ! command -v adb &> /dev/null; then
    echo "❌ adb未找到，请确保Android SDK已正确安装"
    exit 1
fi

# 构建APK
echo "🔨 开始构建APK..."
cd android

# 清理之前的构建
./gradlew clean

# 构建调试版APK
echo "构建调试版APK..."
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo "✅ APK构建成功！"
    echo "📱 APK位置: android/app/build/outputs/apk/debug/app-debug.apk"
    
    # 显示APK信息
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        echo "📊 APK大小: $APK_SIZE"
        
        # 复制到项目根目录
        cp "$APK_PATH" "../ADHDer-debug.apk"
        echo "📋 APK已复制到: ADHDer-debug.apk"
    fi
else
    echo "❌ APK构建失败"
    exit 1
fi

cd ..

echo ""
echo "🎉 构建完成！"
echo "📱 安装到设备: adb install ADHDer-debug.apk"
echo "🔧 或者使用: npx expo run:android"
