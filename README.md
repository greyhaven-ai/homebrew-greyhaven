# Grey Haven Homebrew Tap

Homebrew formulas for Grey Haven tools.

## Installation

```bash
brew tap greyhaven-ai/greyhaven
```

## Available Formulas

### claude-config

Comprehensive configuration manager for Claude Code.

```bash
# Install
brew install greyhaven-ai/greyhaven/claude-config

# Or install directly
brew install greyhaven-ai/greyhaven/claude-config
```

Features:
- 23 preset configurations
- 22 slash commands  
- 19 specialized agents
- 20 statusline options
- Interactive setup wizard

Usage:
```bash
# Interactive setup
claude-config wizard

# Quick setup
claude-config init
claude-config preset recommended
```

Documentation: https://github.com/greyhaven-ai/claude-code-config

## Adding the Tap

```bash
# Add the tap
brew tap greyhaven-ai/greyhaven

# Install formula
brew install claude-config

# Update
brew upgrade claude-config
```

## Development

To add new formulas:
1. Create a `.rb` file in the `Formula/` directory
2. Test locally: `brew install --build-from-source Formula/<name>.rb`
3. Commit and push to this repository

## Support

For issues with formulas, please open an issue in this repository.

## License

MIT © Grey Haven Studio