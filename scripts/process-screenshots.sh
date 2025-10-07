#!/bin/bash

# 应用截图生成脚本
echo "🎨 开始生成应用截图..."

# 创建目录结构
mkdir -p screenshots/{ios,android,marketing}/{raw,processed}

# 检查依赖
if ! command -v sips &> /dev/null; then
    echo "❌ 需要安装 sips (macOS 自带)"
    exit 1
fi

# 截图尺寸配置
declare -A sizes=(
    ["iPhone-14-Pro-Max"]="1290x2796"
    ["iPhone-11-Pro-Max"]="1242x2688"
    ["iPhone-8-Plus"]="1242x2208"
    ["iPad-Pro-12.9"]="2048x2732"
    ["Android-Phone"]="1080x1920"
    ["Android-Tablet"]="1200x1920"
)

# 页面列表
pages=("login" "tasks" "focus" "ideas" "sleep" "wallpaper")

echo "📱 请确保以下截图已保存到 screenshots/raw/ 目录:"
for page in "${pages[@]}"; do
    echo "  - ${page}.png"
done

echo ""
echo "🔄 开始批量处理截图..."

# 处理每个尺寸
for device in "${!sizes[@]}"; do
    size="${sizes[$device]}"
    width="${size%x*}"
    height="${size#*x}"
    
    echo "处理 ${device} (${width}x${height})..."
    
    # 创建设备目录
    mkdir -p "screenshots/processed/${device}"
    
    # 处理每个页面
    for page in "${pages[@]}"; do
        if [ -f "screenshots/raw/${page}.png" ]; then
            echo "  调整 ${page}.png..."
            sips -z "${height}" "${width}" "screenshots/raw/${page}.png" --out "screenshots/processed/${device}/${page}.png"
        else
            echo "  ⚠️  未找到 screenshots/raw/${page}.png"
        fi
    done
done

echo ""
echo "✅ 截图处理完成!"
echo "📁 处理后的截图保存在 screenshots/processed/ 目录"
echo ""
echo "📋 下一步:"
echo "1. 检查截图质量"
echo "2. 上传到应用商店"
echo "3. 准备应用描述和关键词"
