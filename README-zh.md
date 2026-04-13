# Figma Design Skill 使用说明

## 快速开始

1. 配置 Figma 访问令牌
2. 设置默认文件 ID
3. 使用示例代码测试

## 常见用例

### 设计审查
- 提取 UI 组件的设计规范
- 检查颜色一致性
- 验证字体使用

### 设计系统提取
- 自动提取颜色变量
- 收集字体样式
- 导出组件库

### 原型截图
- 生成高保真截图
- 创建交互演示
- 导出设计资产

## 文件结构

```
figma-design-skill/
├── skills/
│   └── figma-design/
│       ├── SKILL.md              # Skill 主文件
│       ├── lib/
│       │   └── figma-client.js   # Figma API 客户端
│       ├── examples/
│       │   └── basic-usage.js    # 使用示例
│       ├── test/
│       │   └── figma-client.test.js # 单元测试
│       ├── README-zh.md         # 中文说明 (本文件)
│       └── package.json         # 项目配置
├── bin/                    # 部署和验证脚本
├── doc/                   # 文档文件
├── README.md             # 英文文档
└── package.json          # 根项目配置
```

## 配置示例

```javascript
// 在 Skill config 中配置
{
  "FIGMA_ACCESS_TOKEN": "figd_xxxxxxxxxxxxxxxxxxxx",
  "FIGMA_FILE_ID": "abc123def456",
  "FIGMA_API_BASE": "https://api.figma.com/v1",
  "MAX_IMAGE_SIZE": 4096,
  "DEFAULT_FORMAT": "png"
}
```

## API 方法

### FigmaClient 类

```javascript
const client = new FigmaClient(config);

// 获取文件信息
await client.getFile(fileKey);

// 获取节点信息
await client.getNodes(fileKey, nodeIds);

// 导出节点图片
await client.getImages(fileKey, params);

// 提取设计属性
await client.extractDesignProperties(fileKey, nodeId);
```

## 错误处理

```javascript
try {
  await client.getFile('invalid-file-id');
} catch (error) {
  console.error('错误:', error.message);
  // 处理 403, 404, 429 等错误
}
```

## 注意事项

1. **令牌安全**: 不要将访问令牌提交到版本控制系统
2. **速率限制**: Figma 免费版每分钟 60 个请求
3. **文件权限**: 确保令牌有访问目标文件的权限
4. **节点 ID**: 使用正确的节点 ID 格式 `page_id:node_id`

## 扩展建议

- 添加设计差异比较功能
- 支持批量导出多个节点
- 集成设计令牌导出
- 添加缓存机制减少 API 调用