// FigmaClient 测试文件
const FigmaClient = require('../scripts/figma-client');
const { expect } = require('chai');

describe('FigmaClient', () => {
  let client;

  beforeEach(() => {
    client = new FigmaClient({
      FIGMA_ACCESS_TOKEN: 'test-token-123',
      FIGMA_API_BASE: 'https://api.figma.com/v1',
    });
  });

  describe('构造函数', () => {
    it('应该正确初始化配置', () => {
      expect(client.accessToken).to.equal('test-token-123');
      expect(client.apiBase).to.equal('https://api.figma.com/v1');
    });

    it('应该使用默认的 API 基础 URL', () => {
      const defaultClient = new FigmaClient({
        FIGMA_ACCESS_TOKEN: 'token',
      });
      expect(defaultClient.apiBase).to.equal('https://api.figma.com/v1');
    });
  });

  describe('颜色转换', () => {
    it('应该正确转换 RGB 颜色', () => {
      const color = { r: 1, g: 0.5, b: 0, a: 1 };
      const result = client._colorToString(color);
      expect(result).to.equal('rgb(255, 128, 0)');
    });

    it('应该正确转换 RGBA 颜色', () => {
      const color = { r: 0, g: 1, b: 0.5, a: 0.75 };
      const result = client._colorToString(color);
      expect(result).to.equal('rgba(0, 255, 128, 0.75)');
    });

    it('应该处理边界值', () => {
      const black = { r: 0, g: 0, b: 0, a: 1 };
      const white = { r: 1, g: 1, b: 1, a: 1 };
      expect(client._colorToString(black)).to.equal('rgb(0, 0, 0)');
      expect(client._colorToString(white)).to.equal('rgb(255, 255, 255)');
    });
  });

  describe('节点分析', () => {
    it('应该提取颜色属性', () => {
      const mockNode = {
        fills: [
          { color: { r: 1, g: 0, b: 0, a: 1 } },
          { color: { r: 0, g: 1, b: 0, a: 0.5 } },
        ],
        children: [],
      };

      const result = client._analyzeNode(mockNode);
      expect(result.colors).to.include('rgb(255, 0, 0)');
      expect(result.colors).to.include('rgba(0, 255, 0, 0.50)');
    });

    it('应该提取字体属性', () => {
      const mockNode = {
        style: {
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: 400,
          lineHeight: 24,
          letterSpacing: 0,
        },
        children: [],
      };

      const result = client._analyzeNode(mockNode);
      expect(result.typography[0].fontFamily).to.equal('Inter');
      expect(result.typography[0].fontSize).to.equal(16);
    });

    it('应该提取尺寸信息', () => {
      const mockNode = {
        absoluteBoundingBox: {
          width: 100,
          height: 50,
          x: 10,
          y: 20,
        },
        children: [],
      };

      const result = client._analyzeNode(mockNode);
      expect(result.spacing[0].width).to.equal(100);
      expect(result.spacing[0].height).to.equal(50);
    });

    it('应该识别组件', () => {
      const mockNode = {
        type: 'COMPONENT',
        id: '1:23',
        name: 'Button',
        children: [],
      };

      const result = client._analyzeNode(mockNode);
      expect(result.components[0].id).to.equal('1:23');
      expect(result.components[0].name).to.equal('Button');
      expect(result.components[0].type).to.equal('COMPONENT');
    });

    it('应该递归遍历子节点', () => {
      const mockNode = {
        children: [
          {
            fills: [{ color: { r: 1, g: 0, b: 0, a: 1 } }],
            children: [],
          },
          {
            style: { fontFamily: 'Inter' },
            children: [],
          },
        ],
      };

      const result = client._analyzeNode(mockNode);
      expect(result.colors).to.include('rgb(255, 0, 0)');
      expect(result.typography[0].fontFamily).to.equal('Inter');
    });
  });

  describe('错误处理', () => {
    it('应该处理空节点', () => {
      const result = client._analyzeNode({});
      expect(result.colors).to.be.an('array').that.is.empty;
      expect(result.typography).to.be.an('array').that.is.empty;
      expect(result.spacing).to.be.an('array').that.is.empty;
      expect(result.components).to.be.an('array').that.is.empty;
    });

    it('应该处理 undefined 样式', () => {
      const mockNode = {
        style: undefined,
        children: [],
      };

      const result = client._analyzeNode(mockNode);
      expect(result.typography).to.be.an('array').that.is.empty;
    });
  });
});