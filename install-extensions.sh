#!/bin/bash

# VS Code Extension Installer Script
# This script downloads and installs VS Code extensions from the official marketplace

set -e

EXTENSIONS_DIR="$HOME/.openvscode-server/extensions"
mkdir -p "$EXTENSIONS_DIR"
cd "$EXTENSIONS_DIR"

echo "🔧 Installing VS Code extensions from official marketplace..."

# Function to install extension
install_extension() {
    local publisher=$1
    local name=$2
    local display_name=$3
    
    echo "📦 Installing $display_name..."
    
    # Download from official marketplace
    wget -q "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${name}/latest/vspackage" \
         -O "${name}.vsix" || {
        echo "❌ Failed to download $display_name"
        return 1
    }
    
    # Extract the extension
    unzip -q "${name}.vsix" -d "${publisher}.${name}-latest" || {
        echo "❌ Failed to extract $display_name"
        rm -f "${name}.vsix"
        return 1
    }
    
    # Clean up
    rm -f "${name}.vsix"
    
    echo "✅ Installed $display_name"
}

# Install essential extensions
install_extension "ms-python" "python" "Python"
install_extension "ms-python" "vscode-pylance" "Pylance"
install_extension "ms-python" "jupyter" "Jupyter"
install_extension "esbenp" "prettier-vscode" "Prettier"
install_extension "eamodio" "gitlens" "GitLens"
install_extension "dbaeumer" "vscode-eslint" "ESLint"
install_extension "ms-vscode" "cpptools" "C/C++"
install_extension "golang" "go" "Go"
install_extension "rust-lang" "rust-analyzer" "Rust Analyzer"
install_extension "ms-azuretools" "vscode-docker" "Docker"
install_extension "github" "copilot" "GitHub Copilot"
install_extension "github" "copilot-chat" "GitHub Copilot Chat"
install_extension "ms-vscode-remote" "remote-containers" "Dev Containers"
install_extension "ms-toolsai" "jupyter-keymap" "Jupyter Keymap"
install_extension "formulahendry" "code-runner" "Code Runner"
install_extension "ritwickdey" "liveserver" "Live Server"
install_extension "pkief" "material-icon-theme" "Material Icon Theme"
install_extension "zhuangtongfa" "material-theme" "One Dark Pro"
install_extension "vscodevim" "vim" "Vim"
install_extension "editorconfig" "editorconfig" "EditorConfig"

echo ""
echo "🎉 Extension installation complete!"
echo ""
echo "📋 Installed extensions:"
ls -1 "$EXTENSIONS_DIR" | grep -E "^[a-z]+-?[a-z]*\." | sed 's/^/  - /'
echo ""
echo "💡 You can install more extensions from the VS Code marketplace"