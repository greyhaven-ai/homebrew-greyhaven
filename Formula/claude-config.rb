class ClaudeConfig < Formula
  desc "Comprehensive configuration manager for Claude Code"
  homepage "https://github.com/greyhaven-ai/claude-code-config"
  url "https://github.com/greyhaven-ai/claude-code-config/archive/v1.0.0.tar.gz"
  sha256 "6091f0a196783414de152262ab69e9682ec533a6e9702d08ae21f0c9ee5a13cc"
  license "MIT"
  head "https://github.com/greyhaven-ai/claude-code-config.git", branch: "main"

  depends_on "git"

  def install
    # Install all files to libexec
    libexec.install Dir["*"]
    
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
    
    # Check if npm version exists
    npm_path = "#{HOMEBREW_PREFIX}/lib/node_modules/@greyhaven/claude-code-config"
    if File.directory?(npm_path)
      msg += <<~EOS
        
        ⚠️  Note: NPM version also detected at #{npm_path}
        The Homebrew version will take precedence.
        To use NPM version instead: brew uninstall claude-config
      EOS
    end
    
    msg
  end

  test do
    system "#{bin}/claude-config", "--help"
    assert_match "Claude Config", shell_output("#{bin}/claude-config --help")
  end
end