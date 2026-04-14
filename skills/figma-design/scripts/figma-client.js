// Figma API 客户端封装
class FigmaClient {
  constructor(config = {}) {
    // 配置读取优先级: 1. config参数 → 2. 环境变量 → 3. 默认值
    this.accessToken = config.FIGMA_ACCESS_TOKEN ||
                      process.env.FIGMA_ACCESS_TOKEN;

    this.apiBase = config.FIGMA_API_BASE ||
                   process.env.FIGMA_API_BASE ||
                   'https://api.figma.com/v1';

    this.defaultFileId = config.FIGMA_FILE_ID ||
                         process.env.FIGMA_FILE_ID;

    // 验证必要配置
    if (!this.accessToken) {
      throw new Error('Figma访问令牌未配置。请设置FIGMA_ACCESS_TOKEN环境变量或在技能配置中提供。');
    }
  }

  async request(endpoint, options = {}) {
    const url = `${this.apiBase}${endpoint}`;
    const response = await fetch(url, {
      ...options,
      headers: {
        'X-Figma-Token': this.accessToken,
        'Content-Type': 'application/json',
        ...options.headers,
      },
    });

    if (!response.ok) {
      throw new Error(`Figma API error: ${response.status} ${response.statusText}`);
    }

    return response.json();
  }

  // 获取文件信息
  async getFile(fileKey) {
    return this.request(`/files/${fileKey}`);
  }

  // 获取特定节点
  async getNodes(fileKey, nodeIds) {
    const ids = Array.isArray(nodeIds) ? nodeIds.join(',') : nodeIds;
    return this.request(`/files/${fileKey}/nodes?ids=${encodeURIComponent(ids)}`);
  }

  // 导出节点为图片
  async getImages(fileKey, params) {
    const query = new URLSearchParams(params).toString();
    return this.request(`/images/${fileKey}?${query}`);
  }

  // 提取设计属性
  async extractDesignProperties(fileKey, nodeId) {
    const [file, nodes] = await Promise.all([
      this.getFile(fileKey),
      this.getNodes(fileKey, nodeId),
    ]);

    const node = nodes.nodes[nodeId];
    if (!node) {
      throw new Error(`Node ${nodeId} not found`);
    }

    return this._analyzeNode(node.document);
  }

  _analyzeNode(node) {
    const properties = {
      colors: new Set(),
      typography: [],
      spacing: [],
      components: [],
    };

    const traverse = (n) => {
      // 提取颜色
      if (n.fills && Array.isArray(n.fills)) {
        n.fills.forEach(fill => {
          if (fill.color) {
            properties.colors.add(this._colorToString(fill.color));
          }
        });
      }

      // 提取字体
      if (n.style) {
        if (n.style.fontFamily || n.style.fontSize) {
          properties.typography.push({
            fontFamily: n.style.fontFamily,
            fontSize: n.style.fontSize,
            fontWeight: n.style.fontWeight,
            lineHeight: n.style.lineHeight,
            letterSpacing: n.style.letterSpacing,
          });
        }
      }

      // 提取间距和尺寸
      if (n.absoluteBoundingBox) {
        properties.spacing.push({
          width: n.absoluteBoundingBox.width,
          height: n.absoluteBoundingBox.height,
          x: n.absoluteBoundingBox.x,
          y: n.absoluteBoundingBox.y,
        });
      }

      // 检查组件
      if (n.type === 'COMPONENT' || n.type === 'COMPONENT_SET') {
        properties.components.push({
          id: n.id,
          name: n.name,
          type: n.type,
        });
      }

      // 递归遍历子节点
      if (n.children && Array.isArray(n.children)) {
        n.children.forEach(child => traverse(child));
      }
    };

    traverse(node);

    return {
      colors: Array.from(properties.colors),
      typography: properties.typography,
      spacing: properties.spacing,
      components: properties.components,
      nodeType: node.type,
      nodeName: node.name,
    };
  }

  _colorToString(color) {
    const { r, g, b, a } = color;
    if (a === 1) {
      return `rgb(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)})`;
    }
    return `rgba(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)}, ${a.toFixed(2)})`;
  }
}

module.exports = FigmaClient;