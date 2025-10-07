#!/bin/bash

echo "🚀 ADHDer Capacitor构建脚本"
echo "================================"

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

# 安装Capacitor
echo "📦 安装Capacitor..."
npm install -g @capacitor/cli @capacitor/core

# 初始化Capacitor（如果还没有）
if [ ! -d "android" ]; then
    echo "🔧 初始化Capacitor Android项目..."
    npx cap add android
fi

# 构建Web版本
echo "🌐 构建Web版本..."
npx expo export

# 同步到Capacitor
echo "🔄 同步到Capacitor..."
npx cap sync android

# 构建APK
echo "🔨 构建APK..."
npx cap build android

if [ $? -eq 0 ]; then
    echo "✅ Capacitor APK构建成功！"
    echo "📱 APK位置: android/app/build/outputs/apk/debug/app-debug.apk"
else
    echo "❌ Capacitor构建失败"
    exit 1
fi

echo ""
echo "🎉 构建完成！"
echo "📱 安装到设备: adb install android/app/build/outputs/apk/debug/app-debug.apk"
