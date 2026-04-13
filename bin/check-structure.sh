#!/bin/bash

# 检查技能文件结构脚本
# 用于验证技能目录结构是否符合 skills.sh 要求

set -e

echo "=== 检查技能文件结构 ==="
echo ""

# 检查技能目录是否存在
SKILL_DIR="skills/figma-design"
if [ ! -d "$SKILL_DIR" ]; then
    echo "❌ 错误: 技能目录不存在: $SKILL_DIR"
    echo "   请创建目录结构: skills/figma-design/"
    exit 1
fi
echo "✓ 技能目录存在: $SKILL_DIR"

# 检查必需文件
required_files=(
    "SKILL.md"
    "lib/figma-client.js"
    "examples/basic-usage.js"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$SKILL_DIR/$file" ]; then
        echo "❌ 错误: 必需文件不存在: $SKILL_DIR/$file"
        exit 1
    fi
    echo "✓ 文件存在: $SKILL_DIR/$file"
done

# 检查可选文件（警告）
optional_files=(
    "test/figma-client.test.js"
    "package.json"
    ".env.example"
    "LICENSE"
)

for file in "${optional_files[@]}"; do
    if [ -f "$SKILL_DIR/$file" ]; then
        echo "✓ 可选文件存在: $SKILL_DIR/$file"
    else
        echo "⚠️  警告: 可选文件不存在: $SKILL_DIR/$file"
    fi
done

# 检查 SKILL.md 格式
if grep -q "^---" "$SKILL_DIR/SKILL.md"; then
    echo "✓ SKILL.md 包含正确的 frontmatter 格式"
else
    echo "⚠️  警告: SKILL.md 可能缺少 frontmatter 格式"
fi

echo ""
echo "=== 结构检查完成 ==="
echo ""
echo "如果所有检查通过，技能结构符合 skills.sh 要求。"
echo ""
echo "上传说明:"
echo "1. 确保代码已推送到 GitHub 仓库"
echo "2. 使用以下命令导入到 Multica:"
echo "   multica skill import --url \"https://skills.sh/你的用户名/你的仓库名/figma-design\""
echo "3. 或者直接使用 GitHub URL:"
echo "   multica skill import --url \"https://github.com/你的用户名/figma-design-skill/tree/main/skills/figma-design\""
echo ""
echo "注意: 请将 '你的用户名' 和 '你的仓库名' 替换为实际值。"