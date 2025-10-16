#!/bin/bash

# ===================================
# ADHDER 腾讯云服务器部署脚本
# ===================================

set -e  # 遇到错误立即退出

echo "🚀 开始部署ADHDER到腾讯云服务器..."
echo ""

# 服务器配置
SERVER_IP="122.51.20.50"
SERVER_USER="root"
DOMAIN="adhder.app"
API_DOMAIN="api.adhder.app"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 打印函数
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ===================================
# 步骤1: 检查SSH连接
# ===================================
print_step "检查服务器连接..."
if ssh -o ConnectTimeout=5 -o BatchMode=yes ${SERVER_USER}@${SERVER_IP} exit 2>/dev/null; then
    print_success "服务器连接正常"
else
    print_error "无法连接到服务器，请检查："
    echo "1. SSH密钥是否已配置"
    echo "2. 服务器IP是否正确: ${SERVER_IP}"
    echo ""
    echo "手动连接命令："
    echo "ssh ${SERVER_USER}@${SERVER_IP}"
    exit 1
fi

# ===================================
# 步骤2: 安装基础环境
# ===================================
print_step "安装Node.js和PM2..."

ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
# 更新系统
apt-get update -qq

# 检查Node.js是否已安装
if ! command -v node &> /dev/null; then
    echo "📦 安装Node.js 18.x..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
else
    echo "✅ Node.js 已安装: $(node -v)"
fi

# 检查PM2是否已安装
if ! command -v pm2 &> /dev/null; then
    echo "📦 安装PM2..."
    npm install -g pm2
else
    echo "✅ PM2 已安装"
fi

# 检查Git是否已安装
if ! command -v git &> /dev/null; then
    echo "📦 安装Git..."
    apt-get install -y git
else
    echo "✅ Git 已安装"
fi

# 检查Nginx是否已安装
if ! command -v nginx &> /dev/null; then
    echo "📦 安装Nginx..."
    apt-get install -y nginx
else
    echo "✅ Nginx 已安装"
fi

# 检查Certbot是否已安装（用于SSL）
if ! command -v certbot &> /dev/null; then
    echo "📦 安装Certbot (Let's Encrypt)..."
    apt-get install -y certbot python3-certbot-nginx
else
    echo "✅ Certbot 已安装"
fi

echo "✅ 环境安装完成"
ENDSSH

print_success "环境安装完成"

# ===================================
# 步骤3: 克隆代码
# ===================================
print_step "克隆GitHub代码..."

ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
# 删除旧代码（如果存在）
if [ -d "/root/ADHDer" ]; then
    echo "🗑️  删除旧代码..."
    rm -rf /root/ADHDer
fi

# 克隆新代码
echo "📥 克隆代码..."
cd /root
git clone https://github.com/YALING0327/ADHDer.git
cd ADHDer/website
echo "✅ 代码克隆完成"
ENDSSH

print_success "代码克隆完成"

# ===================================
# 步骤4: 配置环境变量
# ===================================
print_step "配置环境变量..."

# 提示用户：需要在本地创建配置文件
echo ""
echo "📝 请确保本地已有配置文件："
echo "   adhder-develop-final/website/.env"
echo ""
echo "如果没有，请按Ctrl+C取消，然后手动创建 .env 文件"
echo "或者等待10秒自动继续（将使用模板）..."
sleep 10

# 检查本地是否有.env文件
if [ -f "./adhder-develop-final/website/.env" ]; then
    print_step "上传本地 .env 文件到服务器..."
    scp ./adhder-develop-final/website/.env ${SERVER_USER}@${SERVER_IP}:/root/ADHDer/website/.env
    print_success ".env 文件已上传"
else
    print_error "本地没有 .env 文件！"
    echo "请执行以下步骤："
    echo "1. cd adhder-develop-final/website"
    echo "2. cp .env.template .env"
    echo "3. nano .env  # 填入真实配置"
    echo "4. 重新运行此脚本"
    exit 1
fi

# ===================================
# 步骤5: 安装依赖
# ===================================
print_step "安装Node.js依赖..."

ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
cd /root/ADHDer/website
echo "📦 安装npm依赖..."
npm install --production
echo "✅ 依赖安装完成"
ENDSSH

print_success "依赖安装完成"

# ===================================
# 步骤6: 启动应用
# ===================================
print_step "启动应用..."

ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
cd /root/ADHDer/website

# 停止旧进程（如果存在）
pm2 delete adhder-api 2>/dev/null || true

# 启动新进程
pm2 start server.js --name adhder-api --env production

# 保存PM2进程列表
pm2 save

# 设置PM2开机自启
pm2 startup systemd -u root --hp /root | tail -n 1 | bash

echo "✅ 应用启动成功"
pm2 status
ENDSSH

print_success "应用启动成功"

# ===================================
# 步骤7: 配置Nginx
# ===================================
print_step "配置Nginx反向代理..."

ssh ${SERVER_USER}@${SERVER_IP} << ENDSSH
# 创建Nginx配置
cat > /etc/nginx/sites-available/adhder << 'NGINX_EOF'
server {
    listen 80;
    server_name ${API_DOMAIN};

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
NGINX_EOF

# 启用站点
ln -sf /etc/nginx/sites-available/adhder /etc/nginx/sites-enabled/

# 删除默认站点
rm -f /etc/nginx/sites-enabled/default

# 测试Nginx配置
nginx -t

# 重启Nginx
systemctl restart nginx

echo "✅ Nginx配置完成"
ENDSSH

print_success "Nginx配置完成"

# ===================================
# 步骤8: 申请SSL证书（可选）
# ===================================
print_step "配置SSL证书..."

echo ""
echo "⚠️  SSL证书申请需要域名已解析到服务器IP"
echo "   请确保 ${API_DOMAIN} 已解析到 ${SERVER_IP}"
echo ""
read -p "是否立即申请SSL证书？(y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    ssh ${SERVER_USER}@${SERVER_IP} << ENDSSH
    certbot --nginx -d ${API_DOMAIN} --non-interactive --agree-tos --email admin@${DOMAIN} --redirect
    echo "✅ SSL证书申请成功"
ENDSSH
    print_success "SSL证书配置完成"
else
    echo "⏭️  跳过SSL配置，稍后可手动执行："
    echo "   ssh ${SERVER_USER}@${SERVER_IP}"
    echo "   certbot --nginx -d ${API_DOMAIN}"
fi

# ===================================
# 完成
# ===================================
echo ""
echo "🎉 部署完成！"
echo ""
echo "📊 服务状态："
echo "   服务器: ${SERVER_IP}"
echo "   API地址: http://${API_DOMAIN}"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "   HTTPS: https://${API_DOMAIN}"
fi
echo ""
echo "🔍 检查服务："
echo "   ssh ${SERVER_USER}@${SERVER_IP}"
echo "   pm2 status"
echo "   pm2 logs adhder-api"
echo ""
echo "🧪 测试API："
echo "   curl http://${API_DOMAIN}/api/v3/status"
echo ""

