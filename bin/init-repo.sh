#!/bin/bash

# Figma Design Skill - GitHub 仓库初始化脚本

echo "=== Figma Design Skill 仓库初始化 ==="
echo ""

# 检查是否在正确的目录
if [ ! -f "skills/figma-design/SKILL.md" ]; then
    echo "错误: 请在 figma-design-skill 目录中运行此脚本"
    exit 1
fi

# 检查 git 是否已安装
if ! command -v git &> /dev/null; then
    echo "错误: git 未安装"
    exit 1
fi

# 询问 GitHub 仓库 URL
read -p "请输入 GitHub 仓库 URL (例如: https://github.com/yourusername/figma-design-skill.git): " repo_url

if [ -z "$repo_url" ]; then
    echo "错误: 仓库 URL 不能为空"
    exit 1
fi

# 初始化 git 仓库
echo ""
echo "1. 初始化 git 仓库..."
if [ -d ".git" ]; then
    echo "   git 仓库已存在，跳过初始化"
else
    git init
    echo "   ✓ git 仓库初始化完成"
fi

# 添加文件
echo ""
echo "2. 添加文件到 git..."
git add .
echo "   ✓ 文件已添加"

# 提交
echo ""
echo "3. 提交更改..."
git commit -m "Initial commit: Figma Design Skill v1.0.0"
echo "   ✓ 提交完成"

# 添加远程仓库
echo ""
echo "4. 添加远程仓库..."
git remote add origin "$repo_url" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "   远程仓库已存在，更新 URL..."
    git remote set-url origin "$repo_url"
fi
echo "   ✓ 远程仓库配置完成"

# 推送到 GitHub
echo ""
echo "5. 推送到 GitHub..."
echo "   这可能需要输入 GitHub 凭据..."
git push -u origin main
if [ $? -ne 0 ]; then
    # 如果 main 分支不存在，尝试 master
    git push -u origin master
    if [ $? -ne 0 ]; then
        echo "   错误: 推送失败，请手动执行: git push -u origin main"
    else
        echo "   ✓ 成功推送到 master 分支"
    fi
else
    echo "   ✓ 成功推送到 main 分支"
fi

echo ""
echo "=== 初始化完成 ==="
echo ""
echo "下一步:"
echo "1. 在 Multica 中导入 Skill:"
echo "   multica skill import --url \"${repo_url%.git}\""
echo ""
echo "2. 配置 Figma 访问令牌:"
echo "   在 Multica 的 Skill 配置中设置 FIGMA_ACCESS_TOKEN"
echo ""
echo "3. 测试 Skill:"
echo "   将 Skill 分配给 Agent 并测试功能"
echo ""
echo "更多信息请参阅 DEPLOYMENT.md 文件"