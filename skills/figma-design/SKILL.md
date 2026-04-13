---
name: Figma Design
description: 从 Figma 文件获取设计元素、属性和截图
tags:
  - design
  - ui
  - figma
  - screenshot
version: 1.0.0
---

# Figma Design Skill

让 AI 代理能够与 Figma 设计文件交互，提取设计元素和截图。

## 配置

在 Skill 的 `config` 字段中设置以下参数:

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

### 获取文件 ID
Figma 文件 URL 格式: `https://www.figma.com/file/{FILE_ID}/...`

## 可用功能

### 1. 获取文件信息
```
获取 Figma 文件 {file_id} 的元数据和页面结构
```

### 2. 提取设计元素
```
从文件 {file_id} 的节点 {node_id} 提取颜色、字体、间距等设计属性
```

### 3. 导出设计截图
```
将节点 {node_id} 导出为 PNG 截图，尺寸 {width}x{height}
```

### 4. 分析设计系统
```
分析文件 {file_id} 中的组件库和设计规范
```

## 示例用法

### 示例 1: 获取文件结构
```yaml
action: get_file_info
parameters:
  file_id: "abc123def456"
```

### 示例 2: 提取节点设计属性
```yaml
action: extract_design_properties
parameters:
  file_id: "abc123def456"
  node_id: "1:23"
  properties: ["colors", "typography", "spacing"]
```

### 示例 3: 导出节点截图
```yaml
action: export_node_image
parameters:
  file_id: "abc123def456"
  node_id: "1:23"
  format: "png"
  scale: 2
```

## API 参考

### Figma API 端点
- `GET /v1/files/{file_key}` - 获取文件内容
- `GET /v1/images/{file_key}` - 导出节点为图片
- `GET /v1/files/{file_key}/nodes` - 获取特定节点信息
- `GET /v1/teams/{team_id}/projects` - 获取团队项目

### 节点 ID 格式
- 格式: `{page_id}:{node_id}`
- 示例: `1:23`, `2:45`

## 错误处理

常见错误:
- `403`: 无效的访问令牌或无权限
- `404`: 文件或节点不存在
- `429`: API 速率限制
- `500`: Figma 服务器错误

## 限制
- 免费版 Figma 每分钟 60 个请求
- 截图最大尺寸 4096x4096
- 不支持实时协作数据

---

**维护者**: Plume  
**最后更新**: 2026-04-13  
**依赖**: Figma REST API v1

```javascript
// 导入 FigmaClient 类
import FigmaClient from './lib/figma-client.js';

// Skill 主函数
export default async function (args, context) {
  const { action, parameters, config } = args;
  const client = new FigmaClient(config);

  switch (action) {
    case 'get_file_info':
      const fileInfo = await client.getFile(parameters.file_id);
      return {
        success: true,
        data: fileInfo,
        message: `成功获取文件 ${parameters.file_id} 的信息`
      };

    case 'extract_design_properties':
      const properties = await client.extractDesignProperties(
        parameters.file_id,
        parameters.node_id
      );
      return {
        success: true,
        data: properties,
        message: `成功提取节点 ${parameters.node_id} 的设计属性`
      };

    case 'export_node_image':
      const images = await client.getImages(parameters.file_id, {
        ids: parameters.node_id,
        format: parameters.format || 'png',
        scale: parameters.scale || 1,
        use_absolute_bounds: parameters.use_absolute_bounds || false,
      });
      return {
        success: true,
        data: images,
        message: `成功导出节点 ${parameters.node_id} 的截图`
      };

    default:
      throw new Error(`未知操作: ${action}`);
  }
}
```