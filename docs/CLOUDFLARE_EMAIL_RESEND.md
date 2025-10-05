# 邮件：Cloudflare Email Routing + Resend 发信

1) Cloudflare Email Routing
- 将域名接入 Cloudflare（更换 NS）
- 开启 Email Routing：创建 `login@your-domain` 转发至你的私人邮箱

2) Resend 发信
- 在 Resend 创建 API Key，验证发信域名（添加 DNS 记录）
- 在 Vercel 设置 `RESEND_API_KEY`
- 发件人可使用：`ADHDer <login@your-domain>`

3) 登录流程
- POST `/api/auth/request-otp` → 收取验证码（邮箱）
- POST `/api/auth/verify-otp` → 设置 `auth` JWT Cookie（30天）
