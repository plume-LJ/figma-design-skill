#!/bin/bash

# 测试技能导入脚本
# 验证技能结构并提供测试命令

set -e

echo "=== 测试技能导入 ==="
echo ""

# 检查 multica CLI 是否可用
if command -v multica &> /dev/null; then
    echo "✓ multica CLI 已安装"
    MULTICA_AVAILABLE=true
else
    echo "⚠️  警告: multica CLI 未安装"
    echo "   请先安装 multica CLI: https://docs.multica.dev/cli/installation"
    MULTICA_AVAILABLE=false
fi

echo ""
echo "=== 技能结构验证 ==="
echo ""

# 运行结构检查
if [ -f "check-structure.sh" ]; then
    ./check-structure.sh
else
    echo "❌ 错误: check-structure.sh 不存在"
    exit 1
fi

echo ""
echo "=== 测试命令 ==="
echo ""

# 获取仓库信息
REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]%.git}"

    echo "1. 测试 skills.sh 导入 (如果已发布到 skills.sh):"
    echo "   multica skill import --url \"https://skills.sh/$USERNAME/$REPO_NAME/figma-design\" --dry-run"
    echo ""
    echo "2. 测试 GitHub 目录导入:"
    echo "   multica skill import --url \"https://github.com/$USERNAME/$REPO_NAME/tree/main/skills/figma-design\" --dry-run"
    echo ""
    echo "3. 实际导入 (移除 --dry-run 参数):"
    echo "   multica skill import --url \"https://github.com/$USERNAME/$REPO_NAME/tree/main/skills/figma-design\""
    echo ""
    echo "4. 导入后测试技能功能:"
    echo "   # 在 Multica 中将技能分配给 Agent"
    echo "   # 使用测试命令:"
    echo "   multica agent test --skill figma-design --action get_file_info --parameters '{\"file_id\":\"测试文件ID\"}'"
else
    echo "请手动替换以下命令中的 <用户名> 和 <仓库名>:"
    echo ""
    echo "1. 测试 skills.sh 导入:"
    echo "   multica skill import --url \"https://skills.sh/<用户名>/<仓库名>/figma-design\" --dry-run"
    echo ""
    echo "2. 测试 GitHub 目录导入:"
    echo "   multica skill import --url \"https://github.com/<用户名>/<仓库名>/tree/main/skills/figma-design\" --dry-run"
fi

echo ""
echo "=== 测试步骤 ==="
echo ""
echo "1. 确保所有更改已推送到 GitHub:"
echo "   git push"
echo ""
echo "2. 运行上述任一测试命令（使用 --dry-run 参数先验证）"
echo ""
echo "3. 如果 --dry-run 成功，移除参数进行实际导入"
echo ""
echo "4. 在 Multica 界面中配置技能参数"
echo ""
echo "5. 测试技能功能"
echo ""
echo "注意: --dry-run 参数可能并非所有 multica 版本都支持，"
echo "      如果不支持，请直接运行导入命令。"