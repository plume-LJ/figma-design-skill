# Figma Design Skill - 项目概览

## 项目简介
这是一个为 Multica 平台设计的 Skill，使 AI 代理能够与 Figma 设计文件交互，提取设计元素、属性和截图。

## 核心功能
1. **文件信息获取** - 获取 Figma 文件的元数据和页面结构
2. **设计属性提取** - 从设计节点提取颜色、字体、间距、组件等属性
3. **截图导出** - 将设计节点导出为 PNG 图片
4. **设计系统分析** - 分析组件库和设计规范

## 文件结构
```
figma-design-skill/
├── SKILL.md              # Skill 主文件 (包含 frontmatter)
├── lib/
│   └── figma-client.js   # Figma API 客户端封装
├── examples/
│   └── basic-usage.js    # 基本使用示例
├── test/
│   └── figma-client.test.js # 单元测试
├── README.md             # 英文文档
├── README-zh.md          # 中文文档
├── DEPLOYMENT.md         # 部署指南
├── PROJECT-OVERVIEW.md   # 项目概览 (本文件)
├── package.json          # Node.js 项目配置
├── .env.example          # 环境变量示例
├── .gitignore           # Git 忽略文件
└── LICENSE              # MIT 许可证
```

## 技术要求
- **Node.js**: >= 16.0.0
- **Figma API**: v1 REST API
- **Multica**: 支持 Skill 系统的版本

## 配置参数
```json
{
  "FIGMA_ACCESS_TOKEN": "Figma 个人访问令牌",
  "FIGMA_FILE_ID": "可选默认文件 ID",
  "FIGMA_API_BASE": "https://api.figma.com/v1",
  "MAX_IMAGE_SIZE": 4096,
  "DEFAULT_FORMAT": "png"
}
```

## 使用方法

### 1. 导入到 Multica
```bash
# 通过 GitHub URL 导入
multica skill import --url "https://github.com/yourusername/figma-design-skill"
```

### 2. 分配给 Agent
在 Multica 界面中将 Skill 分配给 Agent。

### 3. 使用示例
```javascript
const FigmaClient = require('./lib/figma-client');
const client = new FigmaClient(config);

// 获取文件信息
const fileInfo = await client.getFile(fileId);

// 提取设计属性
const properties = await client.extractDesignProperties(fileId, nodeId);

// 导出截图
const images = await client.getImages(fileId, { ids: nodeId, format: 'png' });
```

## 开发指南

### 运行测试
```bash
npm test
```

### 添加新功能
1. 在 `lib/figma-client.js` 中添加新方法
2. 在 `test/` 目录中添加测试
3. 更新 `SKILL.md` 文档
4. 更新示例文件

### 发布流程
1. 更新 `SKILL.md` 中的版本号
2. 提交并推送到 GitHub
3. 在 Multica 中更新或重新导入 Skill

## 安全注意事项
1. **令牌安全**: 不要将 Figma 访问令牌提交到版本控制
2. **权限控制**: 使用最小必要权限的令牌
3. **速率限制**: 遵守 Figma API 的速率限制 (免费版每分钟 60 请求)

## 扩展建议
1. 添加设计差异比较功能
2. 支持批量导出多个节点
3. 集成设计令牌导出
4. 添加缓存机制减少 API 调用

## 故障排除
- **403 错误**: 检查访问令牌是否有效和有权限
- **404 错误**: 确认文件 ID 和节点 ID 正确
- **429 错误**: API 速率限制，等待后重试
- **导入失败**: 确保仓库是公开的且 SKILL.md 在根目录

## 贡献指南
1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送分支并创建 Pull Request

## 许可证
MIT License - 详见 LICENSE 文件

## 维护者
- Plume (主要维护者)

## 最后更新
2026-04-13

## 相关链接
- [Multica 文档](https://multica.ai/docs)
- [Figma API 文档](https://www.figma.com/developers/api)
- [GitHub 仓库](https://github.com/yourusername/figma-design-skill)