# 📧 邮箱与短信登录配置指南

## 🎯 当前登录方式

您的ADHDER应用现在支持**两种登录方式**：

### 1️⃣ 邮箱+密码登录 ✅
**状态：** 已实现（使用本地认证）  
**数据存储：** MongoDB  
**无需额外配置**

### 2️⃣ 手机号+验证码登录 ✅ 
**状态：** 已实现并集成阿里云短信  
**API端点：**
- 发送验证码：`POST /api/v4/sms/send-code`
- 验证并登录：`POST /api/v4/sms/verify-and-login`

---

## 📱 短信登录配置（阿里云）

### ✅ 您已完成配置

**阿里云短信服务：**
```env
ALIYUN_ACCESS_KEY_ID=LTAI5tCXFu1bp4SZJjyK2zbB
ALIYUN_ACCESS_KEY_SECRET=ztVtPbyR3TulU8p1SDagnsW1Wubrx1
ALIYUN_SMS_TEMPLATE_CODE=SMS_496025850
ALIYUN_SMS_SIGN_NAME=亚韵科技
```

### 🎮 Flutter前端界面

**登录页面：**
- 邮箱登录（主界面）
- **「或」分隔线**
- **「📱 手机号验证码登录」按钮** ⬅️ **新增**

**手机号登录页面：**
- 输入手机号（+86自动添加）
- 点击「获取验证码」
- 输入6位验证码
- 点击「登录」

**特性：**
- ✅ 60秒倒计时防止重复发送
- ✅ 实时表单验证
- ✅ 自动创建账户（未注册用户）
- ✅ 错误提示

---

## 📧 邮箱功能说明

### 当前邮箱登录机制

**实现方式：** 本地认证（Local Auth）

**特点：**
- ✅ 无需邮件服务器
- ✅ 无需发送验证邮件
- ✅ 邮箱只用于登录标识
- ⚠️ 不支持邮箱验证
- ⚠️ 不支持密码重置邮件
- ⚠️ 不支持通知邮件

### 如果您需要发送邮件...

**选项1：使用SendCloud（推荐）**

**为什么选择SendCloud？**
- ✅ 中国大陆可用
- ✅ 有免费额度（500封/天）
- ✅ 已有集成代码

**配置步骤：**

1. **注册SendCloud**
   ```
   网址：https://www.sendcloud.net
   免费额度：500封/天
   费用：超出后约 ¥0.01/封
   ```

2. **获取API Key**
   ```
   - 登录控制台
   - API设置 → 创建API用户
   - 记录：API_USER 和 API_KEY
   ```

3. **添加环境变量**
   ```env
   # SendCloud邮件服务
   SENDCLOUD_API_USER=your_api_user
   SENDCLOUD_API_KEY=your_api_key
   SENDCLOUD_FROM=noreply@adhder.app
   SENDCLOUD_FROM_NAME=ADHDER
   ```

4. **验证发信域名**
   ```
   - 在SendCloud添加域名：adhder.app
   - 配置DNS记录（SPF、DKIM）
   - 等待验证通过
   ```

5. **测试发送**
   ```bash
   # 在服务器上运行
   node test-email-send.js
   ```

**选项2：使用腾讯云邮件推送**

**配置步骤：**

1. **开通服务**
   ```
   腾讯云控制台 → 邮件推送
   费用：约 ¥0.01/封
   ```

2. **创建发信域名和模板**

3. **获取密钥**
   ```env
   TENCENT_EMAIL_REGION=ap-hongkong
   TENCENT_EMAIL_FROM=noreply@adhder.app
   ```

**选项3：使用阿里云邮件推送**

类似配置方式，费用相近。

---

## 🔧 后端API实现细节

### 短信验证码登录API

**文件：** `website/server/controllers/api-v4/sms.js`

**主要功能：**

#### 1. 发送验证码
```javascript
POST /api/v4/sms/send-code
{
  "phone": "13800138000",
  "type": "login"
}
```

**流程：**
1. 验证手机号格式
2. 生成6位随机验证码
3. 调用阿里云短信API发送
4. 存储验证码（5分钟有效）
5. 返回成功消息

#### 2. 验证并登录
```javascript
POST /api/v4/sms/verify-and-login
{
  "phone": "13800138000",
  "code": "123456"
}
```

**流程：**
1. 验证验证码是否正确
2. 查找用户（通过手机号）
3. 如果不存在，自动创建新用户
4. 生成API Token
5. 返回用户信息和Token

**用户字段：**
```javascript
{
  auth: {
    local: {
      phone: "13800138000",
      username: "user_8000_1729xxx"
    }
  },
  profile: {
    name: "用户8000"
  },
  apiToken: "uuid-token"
}
```

---

## 📱 Flutter前端集成

### 新增文件

1. **`lib/screens/auth/phone_login_screen.dart`**
   - 手机号登录UI
   - 验证码倒计时
   - 表单验证

2. **`lib/services/sms_service.dart`**
   - 发送验证码API
   - 验证码登录API

3. **更新 `lib/providers/auth_provider.dart`**
   - `sendSmsCode()` - 发送验证码
   - `loginWithPhone()` - 手机号登录

4. **更新 `lib/screens/auth/login_screen.dart`**
   - 添加「手机号登录」入口

### 使用示例

```dart
// 发送验证码
final success = await context.read<AuthProvider>().sendSmsCode('13800138000');

// 验证并登录
final success = await context.read<AuthProvider>().loginWithPhone(
  '13800138000',
  '123456'
);
```

---

## ⚙️ 生产环境配置

### .env文件完整配置

```env
# ===================================
# 认证方式配置
# ===================================

# 短信登录（阿里云）✅ 已配置
ALIYUN_ACCESS_KEY_ID=LTAI5tCXFu1bp4SZJjyK2zbB
ALIYUN_ACCESS_KEY_SECRET=ztVtPbyR3TulU8p1SDagnsW1Wubrx1
ALIYUN_SMS_TEMPLATE_CODE=SMS_496025850
ALIYUN_SMS_SIGN_NAME=亚韵科技

# 邮件服务（可选）
# 如果需要发送邮件通知/验证，请配置以下之一：

# 方案1：SendCloud（推荐）
# SENDCLOUD_API_USER=
# SENDCLOUD_API_KEY=
# SENDCLOUD_FROM=noreply@adhder.app
# SENDCLOUD_FROM_NAME=ADHDER

# 方案2：腾讯云邮件推送
# TENCENT_EMAIL_REGION=ap-hongkong
# TENCENT_EMAIL_FROM=noreply@adhder.app

# 方案3：阿里云邮件推送
# ALIYUN_EMAIL_REGION=cn-hangzhou
# ALIYUN_EMAIL_FROM=noreply@adhder.app
```

---

## 🎯 推荐配置方案

### 🥇 方案A：仅短信登录（当前方案）✅

**优点：**
- ✅ 无需配置邮件服务
- ✅ 用户体验好（一键登录）
- ✅ 安全性高
- ✅ 成本低（短信已配置）

**缺点：**
- ❌ 无法发送邮件通知
- ❌ 无法邮箱找回密码

**适用场景：** 
- ✅ 您当前的情况（推荐）
- ✅ 主要面向中国用户
- ✅ 不需要邮件通知

---

### 🥈 方案B：短信+邮箱（完整方案）

**配置步骤：**
1. 注册SendCloud账号
2. 验证发信域名
3. 添加环境变量
4. 启用邮件通知功能

**额外成本：**
- 500封/天免费
- 超出后约 ¥30/月（1000封）

**适用场景：**
- 需要发送系统通知
- 需要邮箱验证功能
- 需要密码重置邮件

---

## 🔍 测试登录功能

### 在模拟器中测试

**步骤：**

1. **启动应用**
   ```bash
   cd adhder_flutter
   flutter run
   ```

2. **点击「手机号验证码登录」**

3. **输入测试手机号**
   ```
   13800138000
   ```

4. **点击「获取验证码」**
   - 查看终端日志确认短信发送
   - 或查看阿里云短信控制台

5. **输入验证码登录**

### 真实环境测试

**⚠️ 注意：**
- 需要服务器运行后端API
- 需要配置正确的API_BASE_URL
- 需要阿里云账号余额充足

---

## 📊 登录方式对比

| 特性 | 邮箱登录 | 短信登录 |
|------|---------|---------|
| **用户体验** | 需要记密码 ⭐⭐⭐ | 无需记密码 ⭐⭐⭐⭐⭐ |
| **安全性** | 中等 ⭐⭐⭐ | 高 ⭐⭐⭐⭐⭐ |
| **配置复杂度** | 简单 ⭐⭐⭐⭐⭐ | 中等 ⭐⭐⭐ |
| **成本** | 免费 | 约¥0.05/次 |
| **适用场景** | 海外用户 | 中国用户 |
| **实名制** | 否 | 是（手机号实名） |

---

## 🚀 下一步

### 如果您满意当前配置（仅短信）

✅ **无需任何操作！**

您的应用已经支持：
- ✅ 手机号验证码登录
- ✅ 邮箱密码登录
- ✅ 自动创建账户

### 如果您需要邮件功能

1. 选择邮件服务商（推荐SendCloud）
2. 注册并获取API密钥
3. 添加环境变量
4. 验证域名
5. 重启服务器

---

## 📞 常见问题

### Q1: 为什么邮箱登录不发验证邮件？
**A:** 当前使用本地认证，邮箱只作为登录标识，无需验证。如需邮箱验证，请配置邮件服务。

### Q2: 短信验证码没收到？
**A:** 
1. 检查手机号格式（必须是+86中国大陆）
2. 检查阿里云账号余额
3. 查看阿里云短信发送记录
4. 检查签名和模板是否审核通过

### Q3: 验证码过期时间？
**A:** 5分钟。超时需要重新获取。

### Q4: 可以同时用邮箱和手机号登录吗？
**A:** 可以。如果用户既有邮箱又有手机号，两种方式都能登录同一账户。

### Q5: 生产环境验证码存储方式？
**A:** 当前存储在内存中（开发/测试用）。生产环境建议：
```javascript
// 使用Redis存储
await redis.setex(`sms:${phone}`, 300, code); // 5分钟
```

### Q6: 如何防止短信轰炸？
**A:** 建议添加：
- 同一手机号1分钟内只能发送1次
- 同一IP每小时最多发送10次
- 图形验证码（防机器人）

---

## 🎉 总结

**✅ 您已经完成：**
1. ✅ 短信登录功能（阿里云）
2. ✅ 手机号验证码发送
3. ✅ 自动创建用户
4. ✅ Flutter前端界面

**📧 邮箱登录：**
- ✅ 已支持（本地认证）
- ⚠️ 不发验证邮件（无需配置）
- 🔄 可选：配置SendCloud发送邮件通知

**🎯 推荐：**
保持当前配置，短信登录即可满足大部分需求！

---

**准备好测试了吗？重新运行Flutter应用查看新的登录界面！** 🚀

