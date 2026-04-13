# Figma Design Skill for Multica

A skill that enables AI agents to extract design elements, properties, and screenshots from Figma files.

## Features

- **File Information**: Get metadata and page structure of Figma files
- **Design Properties**: Extract colors, typography, spacing, and components from design nodes
- **Screenshot Export**: Export design nodes as PNG images
- **Design System Analysis**: Analyze component libraries and design specifications

## Installation

### Option 1: Import via Multica CLI

```bash
multica skill import --url "https://github.com/yourusername/figma-design-skill"
```

### Option 2: Manual Creation

1. Create the skill in Multica:
```bash
multica skill create \
  --name "Figma Design" \
  --description "Extract design elements and screenshots from Figma files" \
  --content "$(cat skills/figma-design/SKILL.md)"
```

2. Add supporting files:
```bash
multica skill files upsert <skill-id> \
  --path "skills/figma-design/lib/figma-client.js" \
  --content "$(cat skills/figma-design/lib/figma-client.js)"
```

## Configuration

Set the following parameters in the skill's `config` field:

```json
{
  "FIGMA_ACCESS_TOKEN": "your_figma_personal_access_token",
  "FIGMA_FILE_ID": "optional_default_file_id",
  "FIGMA_API_BASE": "https://api.figma.com/v1",
  "MAX_IMAGE_SIZE": 4096,
  "DEFAULT_FORMAT": "png"
}
```

### Getting Figma Access Token
1. Log in to your Figma account
2. Go to Settings → Account → Personal Access Tokens
3. Generate a new token and copy it

### Getting File ID
Figma file URL format: `https://www.figma.com/file/{FILE_ID}/...`

## Usage Examples

### Basic Usage
```javascript
const FigmaClient = require('./lib/figma-client');

const config = {
  FIGMA_ACCESS_TOKEN: process.env.FIGMA_ACCESS_TOKEN,
  FIGMA_FILE_ID: 'abc123def456',
};

const client = new FigmaClient(config);

// Get file information
const fileInfo = await client.getFile(config.FIGMA_FILE_ID);

// Extract design properties
const properties = await client.extractDesignProperties(
  config.FIGMA_FILE_ID,
  '1:23'
);

// Export node as image
const images = await client.getImages(config.FIGMA_FILE_ID, {
  ids: '1:23',
  format: 'png',
  scale: 2,
});
```

### Skill Actions

#### Get File Information
```yaml
action: get_file_info
parameters:
  file_id: "abc123def456"
```

#### Extract Design Properties
```yaml
action: extract_design_properties
parameters:
  file_id: "abc123def456"
  node_id: "1:23"
  properties: ["colors", "typography", "spacing"]
```

#### Export Node Image
```yaml
action: export_node_image
parameters:
  file_id: "abc123def456"
  node_id: "1:23"
  format: "png"
  scale: 2
  use_absolute_bounds: true
```

## API Reference

### FigmaClient Class

```javascript
const client = new FigmaClient(config);

// Methods
await client.getFile(fileKey);                     // Get file metadata
await client.getNodes(fileKey, nodeIds);           // Get specific nodes
await client.getImages(fileKey, params);           // Export nodes as images
await client.extractDesignProperties(fileKey, nodeId); // Extract design properties
```

### Figma API Endpoints
- `GET /v1/files/{file_key}` - Get file contents
- `GET /v1/images/{file_key}` - Export nodes as images
- `GET /v1/files/{file_key}/nodes` - Get specific node information
- `GET /v1/teams/{team_id}/projects` - Get team projects

## Error Handling

Common errors:
- `403`: Invalid access token or insufficient permissions
- `404`: File or node not found
- `429`: API rate limit exceeded
- `500`: Figma server error

## Limitations
- Free Figma plan: 60 requests per minute
- Maximum image size: 4096x4096 pixels
- Real-time collaboration data not supported

## Development

### Running Tests
```bash
npm test
```

### Project Structure
```
figma-design-skill/
├── skills/
│   └── figma-design/
│       ├── SKILL.md              # Main skill file
│       ├── lib/
│       │   └── figma-client.js   # Figma API client
│       ├── examples/
│       │   └── basic-usage.js    # Usage examples
│       ├── test/
│       │   └── figma-client.test.js # Test files
│       └── package.json          # Skill configuration
├── bin/                    # Deployment and validation scripts
├── doc/                   # Documentation files
├── README.md             # English documentation
├── README-zh.md          # Chinese documentation
└── package.json          # Root project configuration
```

## Security Notes

1. **Token Security**:
   - Never commit access tokens to version control
   - Use environment variables or secure configuration storage
   - Rotate tokens regularly

2. **Permission Control**:
   - Use tokens with minimal necessary permissions
   - Restrict file access scope
   - Monitor API usage

3. **Rate Limiting**:
   - Implement request queuing and backoff retry
   - Cache frequently accessed data
   - Monitor Figma API limits

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please open an issue on GitHub.

---

**Maintainer**: Dofun 
**Last Updated**: 2026-04-13  
**Dependencies**: Figma REST API v1