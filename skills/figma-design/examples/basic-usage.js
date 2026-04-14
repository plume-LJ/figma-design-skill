// 基本使用示例
const FigmaClient = require('../scripts/figma-client');

const config = {
  FIGMA_ACCESS_TOKEN: process.env.FIGMA_ACCESS_TOKEN,
  FIGMA_FILE_ID: 'abc123def456',
};

async function main() {
  const client = new FigmaClient(config);

  try {
    // 1. 获取文件信息
    const fileInfo = await client.getFile(config.FIGMA_FILE_ID);
    console.log('File:', fileInfo.name);
    console.log('Pages:', Object.keys(fileInfo.document.children));

    // 2. 提取设计属性
    const properties = await client.extractDesignProperties(
      config.FIGMA_FILE_ID,
      '1:23'
    );
    console.log('Colors:', properties.colors);
    console.log('Typography:', properties.typography);

    // 3. 导出截图
    const images = await client.getImages(config.FIGMA_FILE_ID, {
      ids: '1:23',
      format: 'png',
      scale: 2,
    });
    console.log('Image URL:', images.images['1:23']);

  } catch (error) {
    console.error('Error:', error.message);
  }
}

if (require.main === module) {
  main();
}