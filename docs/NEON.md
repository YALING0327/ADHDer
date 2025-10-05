# Neon（Postgres）配置

- 注册 Neon 免费账号，创建项目与数据库
- 在 Connection details 复制连接串（含 `sslmode=require`）
- Vercel 项目设置 `DATABASE_URL`
- 本地开发复制 `.env.example` 为 `.env` 并填入同样的 `DATABASE_URL`
- 首次生成/推送 Schema：
  - `pnpm db:generate`
  - `pnpm db:push`
