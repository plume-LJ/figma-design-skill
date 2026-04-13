#!/bin/bash

# 准备上传到 skills.sh 的脚本
# 帮助用户验证结构并提供上传命令

set -e

echo "=== 准备上传到 skills.sh ==="
echo ""

# 运行结构检查
if [ -f "check-structure.sh" ]; then
    ./check-structure.sh
else
    echo "⚠️  警告: check-structure.sh 不存在，跳过结构检查"
fi

echo ""
echo "=== 上传准备 ==="
echo ""

# 获取当前仓库信息
REPO_URL=""
if [ -d ".git" ]; then
    REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -z "$REPO_URL" ]; then
        echo "⚠️  警告: 未找到 Git 远程仓库 URL"
        echo "   请先添加远程仓库: git remote add origin <仓库URL>"
    else
        echo "✓ 远程仓库 URL: $REPO_URL"
    fi
else
    echo "⚠️  警告: 当前目录不是 Git 仓库"
fi

# 提取用户名和仓库名
USERNAME=""
REPO_NAME=""
if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]%.git}"
    echo "✓ GitHub 用户名: $USERNAME"
    echo "✓ 仓库名: $REPO_NAME"
fi

echo ""
echo "=== 上传命令 ==="
echo ""

# 生成上传命令
if [ -n "$USERNAME" ] && [ -n "$REPO_NAME" ]; then
    echo "1. 通过 skills.sh 导入:"
    echo "   multica skill import --url \"https://skills.sh/$USERNAME/$REPO_NAME/figma-design\""
    echo ""
    echo "2. 通过 GitHub 目录导入:"
    echo "   multica skill import --url \"https://github.com/$USERNAME/$REPO_NAME/tree/main/skills/figma-design\""
    echo ""
    echo "3. 通过 GitHub 仓库导入:"
    echo "   multica skill import --url \"https://github.com/$USERNAME/$REPO_NAME\""
else
    echo "请手动替换以下命令中的 <用户名> 和 <仓库名>:"
    echo ""
    echo "1. 通过 skills.sh 导入:"
    echo "   multica skill import --url \"https://skills.sh/<用户名>/<仓库名>/figma-design\""
    echo ""
    echo "2. 通过 GitHub 目录导入:"
    echo "   multica skill import --url \"https://github.com/<用户名>/<仓库名>/tree/main/skills/figma-design\""
    echo ""
    echo "3. 通过 GitHub 仓库导入:"
    echo "   multica skill import --url \"https://github.com/<用户名>/<仓库名>\""
fi

echo ""
echo "=== 下一步 ==="
echo ""
echo "1. 确保所有更改已提交并推送到 GitHub:"
echo "   git add ."
echo "   git commit -m '准备技能上传'"
echo "   git push"
echo ""
echo "2. 运行导入命令（选择上述任一方式）"
echo ""
echo "3. 在 Multica 中配置技能参数:"
echo "   - FIGMA_ACCESS_TOKEN: 你的 Figma 访问令牌"
echo "   - FIGMA_FILE_ID: 可选默认文件 ID"
echo ""
echo "4. 测试技能功能"
echo ""
echo "如有问题，请参阅 DEPLOYMENT.md 文件。"