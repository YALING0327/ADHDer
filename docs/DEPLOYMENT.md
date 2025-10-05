# 部署与集成指南（低成本栈）

## 1. Neon 数据库
- 注册 Neon 免费实例，创建数据库
- 复制连接串，替换 `DATABASE_URL`（建议 `sslmode=require`）

## 2. DBeaver 连接
- 新建连接：PostgreSQL
- Host/DB/User/Password 使用 Neon 提供的信息
- SSL: Verify Full

## 3. Vercel 部署 Web（apps/web）
- 在 Vercel 导入 `apps/web`
- 设置环境变量：`DATABASE_URL`、`RESEND_API_KEY`、`JWT_SECRET`、`CLARITY_PROJECT_ID`
- 选择 Node 20，自动构建

## 4. 邮件（Cloudflare 路由 + Resend 发送）
- Cloudflare Email Routing：将 `login@your-domain` 转发到你的私人邮箱
- Resend：创建 API Key，验证发信域名；把 `RESEND_API_KEY` 配到 Vercel

## 5. Cloudflare CDN / DDoS / WAF
- 域名接入 Cloudflare（NS）→ 开启代理（橙云）
- 开启缓存与压缩
- WAF：启用托管规则集；可选对 `/admin` 路径设 IP 允许名单

## 6. 分析（Microsoft Clarity）
- 创建项目，复制 `CLARITY_PROJECT_ID`
- 已在 Next.js `app/layout.tsx` 注入

## 7. Expo/EAS 构建 iOS/Android（apps/mobile）
- `npm i -g eas-cli`，在 `apps/mobile` 运行：`eas build:configure`
- iOS：登录 Apple 开发者账号；Android：生成签名或托管签名
- `eas build -p ios` / `eas build -p android`

## 8. 项目管理与文档
- GitHub Projects：工单与 Roadmap
- Notion：PRD/Runbook/QA
- Figma：界面与壁纸资源
