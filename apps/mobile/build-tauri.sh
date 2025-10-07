#!/bin/bash

echo "🚀 ADHDer Tauri构建脚本"
echo "================================"

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

# 安装Tauri CLI
echo "📦 安装Tauri CLI..."
npm install -g @tauri-apps/cli

# 初始化Tauri项目（如果还没有）
if [ ! -d "src-tauri" ]; then
    echo "🔧 初始化Tauri项目..."
    npx tauri init
fi

# 构建Tauri应用
echo "🔨 构建Tauri应用..."
npx tauri build

if [ $? -eq 0 ]; then
    echo "✅ Tauri应用构建成功！"
    echo "📱 应用位置: src-tauri/target/release/bundle/"
else
    echo "❌ Tauri构建失败"
    exit 1
fi

echo ""
echo "🎉 构建完成！"
echo "📱 可以在桌面和移动设备上运行"
