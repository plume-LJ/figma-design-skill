# Deployment Guide

This guide explains how to deploy the Figma Design Skill to GitHub and make it available for import into Multica.

## Prerequisites

- GitHub account
- Git installed locally
- Multica CLI installed (for testing)

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and create a new repository:
   - Repository name: `figma-design-skill`
   - Description: "Figma Design Skill for Multica"
   - Visibility: Public (recommended for sharing)
   - Initialize with README: No (we already have one)

2. Copy the repository URL (e.g., `https://github.com/yourusername/figma-design-skill.git`)

## Step 2: Initialize Local Repository

```bash
# Navigate to the skill directory
cd figma-design-skill

# Initialize git repository
git init

# Add all files
git add .

# Commit files
git commit -m "Initial commit: Figma Design Skill v1.0.0"

# Add remote repository
git remote add origin https://github.com/yourusername/figma-design-skill.git

# Push to GitHub
git push -u origin main
```

## Step 3: Import into Multica

### Option A: Import via GitHub URL
```bash
multica skill import --url "https://github.com/yourusername/figma-design-skill"
```

### Option B: Import via skills.sh
If you want to make it available on skills.sh, you need to:
1. Ensure the repository has a `skills/figma-design/` directory structure
2. Or use the existing structure and import directly

```bash
# Assuming you structure it as:
# https://github.com/yourusername/skills/tree/main/figma-design
multica skill import --url "https://skills.sh/yourusername/skills/figma-design"
```

### Option C: Manual Creation
If import fails, create manually:

```bash
# 1. Create the skill
multica skill create \
  --name "Figma Design" \
  --description "Extract design elements and screenshots from Figma files" \
  --content "$(cat skills/figma-design/SKILL.md)" \
  --config '{"FIGMA_ACCESS_TOKEN": "your_token"}'

# Note the skill ID from the output
SKILL_ID="skill_xxxxx"

# 2. Add supporting files
multica skill files upsert $SKILL_ID \
  --path "skills/figma-design/scripts/figma-client.js" \
  --content "$(cat skills/figma-design/scripts/figma-client.js)"

multica skill files upsert $SKILL_ID \
  --path "skills/figma-design/examples/basic-usage.js" \
  --content "$(cat skills/figma-design/examples/basic-usage.js)"
```

## Step 4: Test the Skill

1. Assign the skill to an agent in Multica
2. Test with example commands:
   ```
   请使用 Figma Design Skill 获取文件 abc123 的信息
   ```
3. Verify the agent can access Figma API and return results

## Step 5: Update the Skill

When making updates to the skill:

```bash
# 1. Make changes locally
# 2. Commit and push to GitHub
git add .
git commit -m "Update: [description of changes]"
git push

# 3. Update in Multica (if using manual creation)
multica skill update $SKILL_ID \
  --content "$(cat skills/figma-design/SKILL.md)"

# Or re-import if using URL import
multica skill import --url "https://github.com/yourusername/figma-design-skill" --force
```

## GitHub Repository Structure

For optimal compatibility with Multica's import system:

```
figma-design-skill/
├── skills/
│   └── figma-design/
│       ├── SKILL.md              # Required: Main skill file with frontmatter
│       ├── scripts/                  # Optional: Supporting libraries
│       ├── examples/             # Optional: Usage examples
│       ├── test/                 # Optional: Test files
│       ├── package.json          # Optional: Node.js configuration
│       ├── .env.example          # Optional: Environment variables example
│       └── LICENSE               # Optional: MIT license
├── bin/                    # Scripts for deployment and validation
├── doc/                   # Documentation files
├── README.md             # Main documentation
├── README-zh.md          # Chinese documentation
└── package.json          # Root project configuration
```

## Import URL Formats

Multica supports several import URL formats:

1. **GitHub Repository**: `https://github.com/owner/repo`
2. **GitHub Directory**: `https://github.com/owner/repo/tree/main/path/to/skill`
3. **skills.sh**: `https://skills.sh/owner/repo/skill-name`
4. **ClawHub**: `https://clawhub.ai/owner/skill-slug`
5. **Raw GitHub URL**: `https://raw.githubusercontent.com/owner/repo/main/SKILL.md`

## Troubleshooting

### Import Fails
- Ensure the repository is public
- Check that SKILL.md exists in the skills/figma-design/ directory or specified path
- Verify GitHub API rate limits are not exceeded

### Skill Doesn't Work
- Check Figma access token is valid and has necessary permissions
- Verify file IDs are correct
- Test the FigmaClient locally with the example script

### Permission Errors
- Regenerate Figma access token with correct scopes
- Ensure the token has access to the target files
- Check workspace permissions in Figma

## Best Practices

1. **Versioning**: Update the version in skills/figma-design/SKILL.md frontmatter for each release
2. **Documentation**: Keep README files updated with new features
3. **Testing**: Add tests for new functionality
4. **Security**: Never commit actual tokens or sensitive data
5. **Backwards Compatibility**: Maintain compatibility with existing usage patterns

## Automation

Consider setting up GitHub Actions to:
- Run tests automatically
- Validate skills/figma-design/SKILL.md format
- Publish to skills.sh or ClawHub automatically

Example workflow file: `.github/workflows/ci.yml`

## Support

For issues with deployment:
- Check Multica documentation
- Open issues on the GitHub repository
- Ask in Multica community channels