# EAS 构建与上架清单

- 安装 `eas-cli`；在 `apps/mobile` 运行 `eas build:configure`
- iOS：登录 Apple 开发者账号，生成证书与描述文件
- Android：生成签名密钥或让 EAS 托管
- 试构建：`eas build -p ios` / `eas build -p android`
- 商店素材：名称、截图、隐私标签（iOS）/ Data Safety（Android）、内容分级
