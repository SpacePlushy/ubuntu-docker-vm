#!/bin/bash

# VS Code Extension Installer for Open VSX Marketplace
# Uses code-server CLI to install from Open VSX

set -e

echo "🔧 Installing VS Code extensions from Open VSX marketplace..."

# Function to install extension
install_extension() {
    local extension_id=$1
    local display_name=$2
    
    echo "📦 Installing $display_name..."
    
    # Use code-server CLI to install extension
    if code-server --install-extension "$extension_id" --force 2>/dev/null; then
        echo "✅ Installed $display_name"
    else
        echo "⚠️  $display_name may not be available on Open VSX"
    fi
}

# Install essential extensions available on Open VSX
install_extension "ms-python.python" "Python"
install_extension "esbenp.prettier-vscode" "Prettier"
install_extension "dbaeumer.vscode-eslint" "ESLint"
install_extension "eamodio.gitlens" "GitLens"
install_extension "PKief.material-icon-theme" "Material Icon Theme"
install_extension "zhuangtongfa.material-theme" "One Dark Pro"
install_extension "ritwickdey.LiveServer" "Live Server"
install_extension "formulahendry.code-runner" "Code Runner"
install_extension "EditorConfig.EditorConfig" "EditorConfig"
install_extension "vscodevim.vim" "Vim"
install_extension "ms-vscode.cpptools" "C/C++"
install_extension "golang.go" "Go"
install_extension "rust-lang.rust-analyzer" "Rust Analyzer"
install_extension "redhat.vscode-yaml" "YAML"
install_extension "DotJoshJohnson.xml" "XML Tools"
install_extension "ms-azuretools.vscode-docker" "Docker"
install_extension "vscode-icons-team.vscode-icons" "VSCode Icons"
install_extension "oderwat.indent-rainbow" "Indent Rainbow"
install_extension "streetsidesoftware.code-spell-checker" "Code Spell Checker"
install_extension "wayou.vscode-todo-highlight" "TODO Highlight"

echo ""
echo "🎉 Extension installation complete!"
echo ""
echo "📋 Installed extensions:"
code-server --list-extensions 2>/dev/null | sed 's/^/  - /' || echo "  Run 'code-server --list-extensions' to see installed extensions"
echo ""
echo "💡 Note: Using Open VSX marketplace. Some Microsoft extensions may not be available."
echo "   You can still install more extensions from the UI!"