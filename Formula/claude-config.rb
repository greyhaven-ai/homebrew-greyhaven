class ClaudeConfig < Formula
  desc "Comprehensive configuration manager for Claude Code"
  homepage "https://github.com/greyhaven-ai/claude-code-config"
  url "https://github.com/greyhaven-ai/claude-code-config/archive/v1.2.8.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"
  head "https://github.com/greyhaven-ai/claude-code-config.git", branch: "main"

  depends_on "git"

  def install
    # Install all files to libexec (including hidden directories)
    libexec.install Dir["*"]
    libexec.install Dir[".claude"]
    
    # Create wrapper script that finds Python dynamically
    (bin/"claude-config").write <<~EOS
      #!/bin/bash
      export CLAUDE_CONFIG_GLOBAL=1
      export CLAUDE_CONFIG_HOME="#{libexec}"
      
      # Try to find Python 3 in common locations
      if command -v python3 &> /dev/null; then
        exec python3 "#{libexec}/claude-config" "$@"
      elif command -v python &> /dev/null && python --version 2>&1 | grep -q "Python 3"; then
        exec python "#{libexec}/claude-config" "$@"
      elif command -v uv &> /dev/null; then
        exec uv run python "#{libexec}/claude-config" "$@"
      else
        echo "Error: Python 3 is required but not found in PATH" >&2
        echo "Please install Python 3 or uv to use claude-config" >&2
        exit 1
      fi
    EOS
    
    chmod 0755, bin/"claude-config"
  end

  def post_install
    # Check if npm version exists and warn about potential conflict
    npm_bin = "#{HOMEBREW_PREFIX}/bin/claude-config"
    if File.exist?(npm_bin) && File.readlink(npm_bin).include?("node_modules")
      opoo "Detected npm installation of claude-config at #{npm_bin}"
      opoo "Homebrew installation will take precedence. To use npm version instead:"
      opoo "  brew uninstall claude-config"
      opoo "To use Homebrew version, you may need to run:"
      opoo "  brew link --overwrite claude-config"
    end
  end

  def caveats
    msg = <<~EOS
      Claude Config has been installed!
      
      Quick Start:
        claude-config wizard              Interactive setup (recommended!)
        claude-config --help              Show all commands
        claude-config init                Initialize in current directory
        claude-config list-presets        Show available presets
      
      Documentation:
        https://github.com/greyhaven-ai/claude-code-config
    EOS
    
    # Check for npm version and provide resolution guidance
    npm_path = "#{HOMEBREW_PREFIX}/lib/node_modules/@greyhaven/claude-code-config"
    npm_bin = "#{HOMEBREW_PREFIX}/bin/claude-config"
    
    if File.directory?(npm_path)
      msg += <<~EOS
        
        ⚠️  Conflict Resolution:
        Both npm and Homebrew versions detected!
        
        Option 1: Use Homebrew version (recommended)
          brew link --overwrite claude-config
        
        Option 2: Use npm version
          brew uninstall claude-config
        
        Option 3: Keep both, use explicit paths
          Homebrew: #{opt_bin}/claude-config
          npm: npx @greyhaven/claude-code-config
      EOS
    end
    
    msg
  end

  test do
    system "#{bin}/claude-config", "--help"
    assert_match "Claude Config", shell_output("#{bin}/claude-config --help")
  end
end