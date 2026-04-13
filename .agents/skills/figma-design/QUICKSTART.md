# Figma Design Skill - 快速开始指南

## 项目已准备就绪！

Figma Design Skill 项目已经创建完成，包含所有必要文件。以下是推送到 GitHub 并导入到 Multica 的完整步骤。

## 第一步：推送到 GitHub

### 方法 A：使用初始化脚本（推荐）
```bash
cd /Users/plumezhou/learn/figma-design-skill
./init-repo.sh
```
按照脚本提示输入 GitHub 仓库 URL。

### 方法 B：手动推送
```bash
cd /Users/plumezhou/learn/figma-design-skill

# 1. 初始化 git（如果尚未初始化）
git init

# 2. 添加所有文件
git add .

# 3. 提交更改
git commit -m "Initial commit: Figma Design Skill v1.0.0"

# 4. 添加远程仓库
git remote add origin https://github.com/yourusername/figma-design-skill.git

# 5. 推送到 GitHub
git push -u origin main
# 如果 main 分支不存在，尝试：
git push -u origin master
```

## 第二步：导入到 Multica

### 选项 1：通过 GitHub URL 导入
```bash
multica skill import --url "https://github.com/yourusername/figma-design-skill"
```

### 选项 2：通过 skills.sh 导入（如果需要）
```bash
multica skill import --url "https://skills.sh/yourusername/figma-design-skill/figma-design"
```

### 选项 3：手动创建
如果导入失败，可以手动创建：

```bash
# 1. 创建 Skill
multica skill create \
  --name "Figma Design" \
  --description "从 Figma 文件获取设计元素、属性和截图" \
  --content "$(cat SKILL.md)"

# 2. 添加支持文件（使用输出的 Skill ID）
multica skill files upsert <skill-id> \
  --path "lib/figma-client.js" \
  --content "$(cat lib/figma-client.js)"

multica skill files upsert <skill-id> \
  --path "examples/basic-usage.js" \
  --content "$(cat examples/basic-usage.js)"
```

## 第三步：配置 Skill

在 Multica 的 Skill 配置中设置以下参数：

```json
{
  "FIGMA_ACCESS_TOKEN": "你的 Figma 个人访问令牌",
  "FIGMA_FILE_ID": "可选默认文件 ID",
  "FIGMA_API_BASE": "https://api.figma.com/v1",
  "MAX_IMAGE_SIZE": 4096,
  "DEFAULT_FORMAT": "png"
}
```

### 获取 Figma 访问令牌
1. 登录 Figma 账号
2. 访问 Settings → Account → Personal Access Tokens
3. 生成新令牌并复制

## 第四步：测试 Skill

### 1. 将 Skill 分配给 Agent
在 Multica 界面中将 "Figma Design" Skill 分配给一个 Agent。

### 2. 测试基本功能
使用以下命令测试：
```
请使用 Figma Design Skill 获取文件 [file_id] 的信息
```

或使用结构化命令：
```yaml
skill: figma-design
action: get_file_info
parameters:
  file_id: "abc123def456"
```

### 3. 验证功能
- 文件信息获取 ✓
- 设计属性提取 ✓
- 截图导出 ✓

## 项目文件说明

### 核心文件
- **SKILL.md** - Skill 主文件，包含 frontmatter 和详细说明
- **lib/figma-client.js** - Figma API 客户端封装
- **examples/basic-usage.js** - 使用示例

### 文档文件
- **README.md** - 英文文档
- **README-zh.md** - 中文文档
- **DEPLOYMENT.md** - 部署指南
- **PROJECT-OVERVIEW.md** - 项目概览
- **QUICKSTART.md** - 本快速开始指南

### 配置文件
- **package.json** - Node.js 项目配置
- **.env.example** - 环境变量示例
- **.gitignore** - Git 忽略文件
- **LICENSE** - MIT 许可证

### 工具文件
- **init-repo.sh** - GitHub 仓库初始化脚本
- **test/figma-client.test.js** - 单元测试

## 常见问题

### Q: 导入失败怎么办？
A: 检查：
1. GitHub 仓库是否为公开
2. SKILL.md 文件是否在仓库根目录
3. GitHub API 速率限制

### Q: Skill 无法访问 Figma？
A: 检查：
1. Figma 访问令牌是否有效
2. 令牌是否有访问目标文件的权限
3. 网络连接是否正常

### Q: 如何更新 Skill？
A: 
1. 更新本地文件
2. 提交并推送到 GitHub
3. 在 Multica 中重新导入或更新 Skill

## 技术支持

- **文档**: 查看 DEPLOYMENT.md 和 PROJECT-OVERVIEW.md
- **测试**: 运行 `npm test` 执行单元测试
- **示例**: 查看 examples/basic-usage.js
- **问题**: 在 GitHub 仓库中创建 Issue

## 下一步

1. 根据实际需求修改 FigmaClient 功能
2. 添加更多测试用例
3. 扩展功能（设计差异比较、批量导出等）
4. 集成到 CI/CD 流程

## 成功指标

✅ 项目创建完成  
✅ 所有文件就绪  
✅ 文档完整  
✅ 测试可用  
✅ 部署指南完备  

现在可以开始使用 Figma Design Skill 了！

---

**项目位置**: `/Users/plumezhou/learn/figma-design-skill/`  
**最后检查**: 2026-04-13  
**状态**: 准备部署 🚀