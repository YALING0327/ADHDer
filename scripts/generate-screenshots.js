#!/usr/bin/env node

/**
 * 应用截图生成脚本
 * 用于生成应用商店所需的截图
 */

const fs = require('fs');
const path = require('path');

// 截图尺寸配置
const SCREENSHOT_SIZES = {
  // iOS 截图尺寸
  'iPhone 6.7"': { width: 1290, height: 2796, name: 'iPhone 14 Pro Max' },
  'iPhone 6.5"': { width: 1242, height: 2688, name: 'iPhone 11 Pro Max' },
  'iPhone 5.5"': { width: 1242, height: 2208, name: 'iPhone 8 Plus' },
  'iPad Pro 12.9"': { width: 2048, height: 2732, name: 'iPad Pro 12.9' },
  'iPad Pro 11"': { width: 1668, height: 2388, name: 'iPad Pro 11' },
  
  // Android 截图尺寸
  'Android Phone': { width: 1080, height: 1920, name: 'Android Phone' },
  'Android Tablet': { width: 1200, height: 1920, name: 'Android Tablet' },
};

// 需要截图的页面
const SCREENSHOT_PAGES = [
  {
    name: 'login',
    title: '登录页面',
    description: '展示邮箱/手机号双登录功能'
  },
  {
    name: 'tasks',
    title: '任务管理',
    description: '展示任务列表和 DDL 功能'
  },
  {
    name: 'focus',
    title: '专注计时器',
    description: '展示专注计时器界面'
  },
  {
    name: 'ideas',
    title: '想法记录',
    description: '展示想法记录功能'
  },
  {
    name: 'sleep',
    title: '助眠音景',
    description: '展示音效选择界面'
  },
  {
    name: 'wallpaper',
    title: '壁纸中心',
    description: '展示壁纸预览和保存'
  }
];

// 生成截图说明文档
function generateScreenshotGuide() {
  const guide = `# 应用截图生成指南

## 📱 需要生成的截图

### iOS App Store 截图
${Object.entries(SCREENSHOT_SIZES).map(([key, size]) => 
  `- **${size.name}** (${key}): ${size.width}x${size.height}px`
).join('\n')}

### Android Play Store 截图
- **手机**: 1080x1920px 或更高
- **平板**: 1200x1920px 或更高

## 🎨 截图内容

${SCREENSHOT_PAGES.map(page => 
  `### ${page.title}
- **文件名**: ${page.name}.png
- **描述**: ${page.description}
- **重点**: 突出核心功能和用户体验`
).join('\n')}

## 🛠️ 生成方法

### 方法 1: 使用 Expo 开发工具
1. 启动开发服务器: \`cd apps/mobile && pnpm dev\`
2. 在模拟器中打开应用
3. 导航到各个页面
4. 使用模拟器的截图功能
5. 调整尺寸到所需规格

### 方法 2: 使用真实设备
1. 在手机上安装开发版本
2. 导航到各个页面
3. 使用设备截图功能
4. 使用图片编辑软件调整尺寸

### 方法 3: 使用自动化工具
1. 使用 Appium 或 Detox 进行自动化测试
2. 在测试过程中自动截图
3. 批量调整尺寸

## 📁 文件组织

建议的文件结构:
\`\`\`
screenshots/
├── ios/
│   ├── iPhone-14-Pro-Max/
│   │   ├── login.png
│   │   ├── tasks.png
│   │   ├── focus.png
│   │   ├── ideas.png
│   │   ├── sleep.png
│   │   └── wallpaper.png
│   ├── iPhone-11-Pro-Max/
│   └── iPad-Pro-12.9/
├── android/
│   ├── phone/
│   └── tablet/
└── marketing/
    ├── banner-1024x500.png
    └── social-1200x630.png
\`\`\`

## 🎯 截图要求

### 内容要求
- 展示应用的核心功能
- 使用真实数据，不要用占位符
- 确保界面美观，无错误信息
- 突出 ADHD 用户的痛点解决方案

### 技术要求
- 高质量 PNG 格式
- 无压缩失真
- 正确的尺寸比例
- 清晰的文字和图标

### 设计建议
- 使用一致的配色方案
- 突出重要功能按钮
- 展示用户友好的界面
- 体现专业性和可信度

## 🚀 自动化脚本

可以使用以下脚本批量处理截图:

\`\`\`bash
#!/bin/bash
# 批量调整截图尺寸

for size in "1290x2796" "1242x2688" "1080x1920"; do
  for page in login tasks focus ideas sleep wallpaper; do
    if [ -f "screenshots/raw/\${page}.png" ]; then
      sips -z \${size#*x} \${size%x*} "screenshots/raw/\${page}.png" --out "screenshots/processed/\${size}/\${page}.png"
    fi
  done
done
\`\`\`

## 📋 检查清单

- [ ] 所有必需尺寸的截图已生成
- [ ] 截图质量清晰，无模糊
- [ ] 内容展示应用核心功能
- [ ] 界面美观，无错误信息
- [ ] 文件命名规范
- [ ] 文件大小合理 (< 5MB each)
- [ ] 符合应用商店要求

## 🎨 营销素材

除了应用截图，还需要准备:

### 应用商店横幅
- **尺寸**: 1024x500px
- **用途**: App Store 和 Google Play 展示
- **内容**: 应用名称、主要功能、品牌标识

### 社交媒体图片
- **尺寸**: 1200x630px
- **用途**: Facebook、Twitter 等社交平台
- **内容**: 应用介绍、下载链接

### 应用预览视频
- **时长**: 15-30秒
- **内容**: 应用功能演示
- **格式**: MP4, 高质量

## 📞 技术支持

如果在生成截图过程中遇到问题:
1. 检查设备/模拟器设置
2. 确保应用正常运行
3. 使用图片编辑软件调整
4. 参考应用商店指南
`;

  return guide;
}

// 生成脚本
function generateScript() {
  const script = `#!/bin/bash

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
for page in "\${pages[@]}"; do
    echo "  - \${page}.png"
done

echo ""
echo "🔄 开始批量处理截图..."

# 处理每个尺寸
for device in "\${!sizes[@]}"; do
    size="\${sizes[\$device]}"
    width="\${size%x*}"
    height="\${size#*x}"
    
    echo "处理 \${device} (\${width}x\${height})..."
    
    # 创建设备目录
    mkdir -p "screenshots/processed/\${device}"
    
    # 处理每个页面
    for page in "\${pages[@]}"; do
        if [ -f "screenshots/raw/\${page}.png" ]; then
            echo "  调整 \${page}.png..."
            sips -z "\${height}" "\${width}" "screenshots/raw/\${page}.png" --out "screenshots/processed/\${device}/\${page}.png"
        else
            echo "  ⚠️  未找到 screenshots/raw/\${page}.png"
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
`;

  return script;
}

// 主函数
function main() {
  console.log('🎨 生成应用截图指南...');
  
  // 创建文档目录
  const docsDir = path.join(__dirname, '..', 'docs');
  if (!fs.existsSync(docsDir)) {
    fs.mkdirSync(docsDir, { recursive: true });
  }
  
  // 生成指南文档
  const guide = generateScreenshotGuide();
  fs.writeFileSync(path.join(docsDir, 'SCREENSHOT_GUIDE.md'), guide);
  
  // 创建脚本目录
  const scriptsDir = path.join(__dirname, '..', 'scripts');
  if (!fs.existsSync(scriptsDir)) {
    fs.mkdirSync(scriptsDir, { recursive: true });
  }
  
  // 生成处理脚本
  const script = generateScript();
  fs.writeFileSync(path.join(scriptsDir, 'process-screenshots.sh'), script);
  
  // 设置脚本执行权限
  fs.chmodSync(path.join(scriptsDir, 'process-screenshots.sh'), '755');
  
  console.log('✅ 截图指南生成完成!');
  console.log('📁 文件位置:');
  console.log('  - docs/SCREENSHOT_GUIDE.md');
  console.log('  - scripts/process-screenshots.sh');
  console.log('');
  console.log('🚀 使用方法:');
  console.log('1. 阅读 docs/SCREENSHOT_GUIDE.md');
  console.log('2. 生成原始截图');
  console.log('3. 运行 scripts/process-screenshots.sh');
}

// 运行脚本
if (require.main === module) {
  main();
}

module.exports = { generateScreenshotGuide, generateScript };
