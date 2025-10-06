# EAS Build 构建步骤

## 环境准备

### 1. 安装 EAS CLI
```bash
npm install -g @expo/eas-cli
```

### 2. 登录 Expo 账户
```bash
eas login
```

### 3. 配置项目
```bash
cd apps/mobile
eas build:configure
```

## 构建配置

### eas.json 配置
```json
{
  "cli": {
    "version": ">= 5.9.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "simulator": true
      }
    },
    "production": {
      "ios": {
        "autoIncrement": true
      },
      "android": {
        "autoIncrement": true
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your-apple-id@example.com",
        "ascAppId": "your-app-store-connect-app-id",
        "appleTeamId": "your-team-id"
      },
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "production"
      }
    }
  }
}
```

## 构建命令

### 开发构建
```bash
# iOS 开发构建
eas build --platform ios --profile development

# Android 开发构建  
eas build --platform android --profile development

# 双平台开发构建
eas build --platform all --profile development
```

### 预览构建
```bash
# iOS 预览构建 (模拟器)
eas build --platform ios --profile preview

# Android 预览构建
eas build --platform android --profile preview
```

### 生产构建
```bash
# iOS 生产构建
eas build --platform ios --profile production

# Android 生产构建
eas build --platform android --profile production

# 双平台生产构建
eas build --platform all --profile production
```

## 环境变量配置

### 1. 设置环境变量
```bash
# 设置生产环境变量
eas secret:create --scope project --name EXPO_PUBLIC_API_BASE --value "https://your-api-domain.com"

# 设置 Firebase 配置
eas secret:create --scope project --name GOOGLE_SERVICES_JSON --value "$(cat google-services.json)"
eas secret:create --scope project --name GOOGLE_SERVICE_INFO --value "$(cat GoogleService-Info.plist)"
```

### 2. 在 eas.json 中引用
```json
{
  "build": {
    "production": {
      "env": {
        "EXPO_PUBLIC_API_BASE": "https://your-api-domain.com"
      },
      "ios": {
        "env": {
          "GOOGLE_SERVICE_INFO": "secret:GOOGLE_SERVICE_INFO"
        }
      },
      "android": {
        "env": {
          "GOOGLE_SERVICES_JSON": "secret:GOOGLE_SERVICES_JSON"
        }
      }
    }
  }
}
```

## 应用商店提交

### iOS App Store 提交
```bash
# 构建并提交到 App Store
eas build --platform ios --profile production
eas submit --platform ios --profile production
```

### Google Play Store 提交
```bash
# 构建并提交到 Google Play
eas build --platform android --profile production
eas submit --platform android --profile production
```

## 构建状态检查

### 查看构建状态
```bash
# 查看所有构建
eas build:list

# 查看特定构建详情
eas build:view [BUILD_ID]

# 下载构建产物
eas build:download [BUILD_ID]
```

## 常见问题解决

### 1. 构建失败
```bash
# 查看构建日志
eas build:view [BUILD_ID] --logs

# 清理缓存重新构建
eas build --platform ios --profile production --clear-cache
```

### 2. 证书问题
```bash
# 重新生成证书
eas credentials

# 查看证书状态
eas credentials:list
```

### 3. 环境变量问题
```bash
# 查看环境变量
eas secret:list

# 删除错误的环境变量
eas secret:delete [SECRET_NAME]
```

## 自动化流程

### GitHub Actions 集成
```yaml
name: EAS Build
on:
  push:
    branches: [main]
    paths: ['apps/mobile/**']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: npm install -g @expo/eas-cli
      - run: eas build --platform all --profile production --non-interactive
        env:
          EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}
```

## 构建优化

### 1. 减小包体积
- 使用 `expo-optimize` 优化图片
- 启用 Hermes (Android)
- 移除未使用的依赖

### 2. 提高构建速度
- 使用构建缓存
- 并行构建多平台
- 使用 EAS Build 缓存

### 3. 安全配置
- 使用环境变量存储敏感信息
- 配置代码签名
- 启用应用传输安全 (iOS)

## 监控和分析

### 1. 构建分析
```bash
# 查看构建统计
eas build:list --limit 10

# 分析构建时间
eas build:view [BUILD_ID] --json
```

### 2. 应用性能
- 集成 Firebase Performance
- 监控崩溃率
- 分析用户行为

## 发布流程

### 1. 版本管理
```bash
# 更新版本号
eas version:set

# 查看版本历史
eas version:list
```

### 2. 分阶段发布
- 内部测试 (TestFlight/Internal Testing)
- 封闭测试 (Closed Testing)
- 开放测试 (Open Testing)
- 生产发布

### 3. 回滚策略
- 保留前一个版本
- 快速回滚机制
- 用户通知计划
