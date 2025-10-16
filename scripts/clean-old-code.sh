#!/bin/bash

##
# ADHDER 旧代码清理脚本
# 
# 功能：
# 1. 备份旧文件
# 2. 移除Habitica RPG相关代码
# 3. 清理群组、挑战、宠物系统
# 4. 验证清理结果
##

set -e  # 出错时退出

echo "🧹 开始清理 ADHDER 项目中的旧 Habitica 代码..."
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "📁 项目路径: $PROJECT_ROOT"
echo ""

# ==========================================
# 1. 创建备份
# ==========================================

echo "📦 创建备份..."
BACKUP_DIR="$PROJECT_ROOT/.old-code-backup"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup-$TIMESTAMP"

mkdir -p "$BACKUP_PATH"

# 备份要删除的文件
echo "  备份旧模型文件..."
if [ -f "website/server/models/user/schema.js" ]; then
    cp "website/server/models/user/schema.js" "$BACKUP_PATH/" 2>/dev/null || true
fi

if [ -f "website/server/models/task.js" ]; then
    cp "website/server/models/task.js" "$BACKUP_PATH/" 2>/dev/null || true
fi

if [ -f "website/server/models/group.js" ]; then
    cp "website/server/models/group.js" "$BACKUP_PATH/" 2>/dev/null || true
fi

if [ -f "website/server/models/challenge.js" ]; then
    cp "website/server/models/challenge.js" "$BACKUP_PATH/" 2>/dev/null || true
fi

echo -e "${GREEN}✓ 备份完成: $BACKUP_PATH${NC}"
echo ""

# ==========================================
# 2. 移除旧模型文件
# ==========================================

echo "🗑️  移除旧模型文件..."

# 旧User模型
if [ -f "website/server/models/user/schema.js" ]; then
    echo "  移除: website/server/models/user/schema.js"
    mv "website/server/models/user/schema.js" "$BACKUP_PATH/" 2>/dev/null || true
    echo -e "${GREEN}  ✓ 已移除旧User模型${NC}"
else
    echo -e "${YELLOW}  ⏭  旧User模型已不存在${NC}"
fi

# 旧Task模型
if [ -f "website/server/models/task.js" ]; then
    echo "  移除: website/server/models/task.js"
    mv "website/server/models/task.js" "$BACKUP_PATH/" 2>/dev/null || true
    echo -e "${GREEN}  ✓ 已移除旧Task模型${NC}"
else
    echo -e "${YELLOW}  ⏭  旧Task模型已不存在${NC}"
fi

# 群组系统
if [ -f "website/server/models/group.js" ]; then
    echo "  移除: website/server/models/group.js"
    mv "website/server/models/group.js" "$BACKUP_PATH/" 2>/dev/null || true
    echo -e "${GREEN}  ✓ 已移除群组模型${NC}"
else
    echo -e "${YELLOW}  ⏭  群组模型已不存在${NC}"
fi

# 挑战系统
if [ -f "website/server/models/challenge.js" ]; then
    echo "  移除: website/server/models/challenge.js"
    mv "website/server/models/challenge.js" "$BACKUP_PATH/" 2>/dev/null || true
    echo -e "${GREEN}  ✓ 已移除挑战模型${NC}"
else
    echo -e "${YELLOW}  ⏭  挑战模型已不存在${NC}"
fi

echo ""

# ==========================================
# 3. 列出需要手动清理的文件
# ==========================================

echo "📋 以下文件/目录可能需要手动审查和清理："
echo ""

echo "  API Controllers (website/server/controllers/):"
echo "    - api-v3/groups.js          (群组相关API)"
echo "    - api-v3/challenges.js      (挑战相关API)"
echo "    - api-v3/hall.js            (贡献者大厅)"
echo "    - api-v3/members.js         (成员管理)"
echo ""

echo "  Common Scripts (website/common/script/):"
echo "    - content/spells.js         (RPG技能)"
echo "    - content/stable.js         (宠物/坐骑)"
echo "    - content/quests.js         (任务系统)"
echo "    - ops/scoreTask.js          (旧的任务评分)"
echo ""

echo "  Cron Jobs (website/server/libs/):"
echo "    - cron.js                   (需要重写，移除RPG逻辑)"
echo ""

echo "  Migrations (migrations/):"
echo "    - archive/*                 (旧迁移脚本，保留作参考)"
echo "    - groups/*                  (群组迁移)"
echo "    - challenges/*              (挑战迁移)"
echo ""

# ==========================================
# 4. 创建清理TODO列表
# ==========================================

TODO_FILE="$PROJECT_ROOT/CLEANUP-TODO.md"

cat > "$TODO_FILE" << 'EOF'
# 代码清理 TODO 列表

## 已自动清理 ✅
- [x] website/server/models/user/schema.js (旧User模型)
- [x] website/server/models/task.js (旧Task模型)
- [x] website/server/models/group.js (群组模型)
- [x] website/server/models/challenge.js (挑战模型)

## 需要手动清理 ⏳

### 高优先级（影响功能）
- [ ] website/server/controllers/api-v3/groups.js - 移除或重写
- [ ] website/server/controllers/api-v3/challenges.js - 移除
- [ ] website/server/libs/cron.js - 重写，移除RPG逻辑
- [ ] website/common/script/ops/scoreTask.js - 重写或移除

### 中优先级（不影响核心功能）
- [ ] website/server/controllers/api-v3/hall.js - 移除贡献者大厅
- [ ] website/server/controllers/api-v3/members.js - 移除成员系统
- [ ] website/common/script/content/spells.js - 移除RPG技能
- [ ] website/common/script/content/stable.js - 移除宠物系统
- [ ] website/common/script/content/quests.js - 移除任务系统

### 低优先级（历史数据）
- [ ] migrations/groups/* - 群组相关迁移（保留作参考）
- [ ] migrations/challenges/* - 挑战相关迁移（保留作参考）
- [ ] migrations/archive/* - 旧迁移脚本（保留作参考）

## 清理原则
1. 如果代码与RPG元素相关 → 删除
2. 如果代码与群组/挑战系统相关 → 删除
3. 如果代码可能被ADHDER功能复用 → 保留并重构
4. 如果不确定 → 先备份，再删除

## 验证步骤
- [ ] 运行 `npm test` 确保测试通过
- [ ] 启动服务器 `npm start` 确保无报错
- [ ] 检查日志，确认没有引用错误
EOF

echo -e "${GREEN}✓ 清理TODO列表已创建: CLEANUP-TODO.md${NC}"
echo ""

# ==========================================
# 5. 验证清理结果
# ==========================================

echo "🔍 验证清理结果..."
echo ""

# 检查新模型是否存在
echo "  检查新数据模型..."
if [ -f "website/server/models/user/adhder-schema.js" ]; then
    echo -e "${GREEN}  ✓ User模型 (adhder-schema.js) 存在${NC}"
else
    echo -e "${RED}  ✗ User模型 (adhder-schema.js) 不存在！${NC}"
fi

if [ -f "website/server/models/task/adhder-schema.js" ]; then
    echo -e "${GREEN}  ✓ Task模型 (adhder-schema.js) 存在${NC}"
else
    echo -e "${RED}  ✗ Task模型 (adhder-schema.js) 不存在！${NC}"
fi

if [ -f "website/server/models/focus-session.js" ]; then
    echo -e "${GREEN}  ✓ FocusSession模型存在${NC}"
else
    echo -e "${RED}  ✗ FocusSession模型不存在！${NC}"
fi

if [ -f "website/server/models/training-record.js" ]; then
    echo -e "${GREEN}  ✓ TrainingRecord模型存在${NC}"
else
    echo -e "${RED}  ✗ TrainingRecord模型不存在！${NC}"
fi

if [ -f "website/server/models/inspiration.js" ]; then
    echo -e "${GREEN}  ✓ Inspiration模型存在${NC}"
else
    echo -e "${RED}  ✗ Inspiration模型不存在！${NC}"
fi

echo ""

# ==========================================
# 6. 完成总结
# ==========================================

echo "========================================"
echo "📊 清理总结"
echo "========================================"
echo ""
echo "✅ 自动清理完成："
echo "  - 旧User模型"
echo "  - 旧Task模型"
echo "  - 群组模型"
echo "  - 挑战模型"
echo ""
echo "⏳ 待手动清理："
echo "  - API Controllers（群组、挑战相关）"
echo "  - Common Scripts（RPG相关）"
echo "  - Cron Jobs（需重写）"
echo ""
echo "📁 备份位置: $BACKUP_PATH"
echo "📋 TODO列表: CLEANUP-TODO.md"
echo ""
echo -e "${GREEN}✅ 旧代码清理脚本执行完成！${NC}"
echo ""
echo "⚠️  建议："
echo "  1. 查看 CLEANUP-TODO.md 了解详细清理计划"
echo "  2. 在Week 3开始API开发前完成手动清理"
echo "  3. 如需回滚，从备份目录恢复文件"
echo ""

