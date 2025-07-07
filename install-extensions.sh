#!/bin/bash

# VS Code Extension Installer Script
# Uses the official openvscode-server CLI for robust extension management

set -e

VSCODE_BIN="/opt/openvscode-server/bin/openvscode-server"

echo "🔧 Installing VS Code extensions using official CLI..."

# Function to install extension
install_extension() {
    local extension_id=$1
    local display_name=$2
    
    echo "📦 Installing $display_name..."
    
    # Use official CLI to install extension
    if $VSCODE_BIN --install-extension "$extension_id" --force; then
        echo "✅ Installed $display_name"
    else
        echo "❌ Failed to install $display_name"
        return 1
    fi
}

# Install essential extensions
install_extension "ms-python.python" "Python"
install_extension "ms-python.vscode-pylance" "Pylance"
install_extension "ms-python.jupyter" "Jupyter"
install_extension "esbenp.prettier-vscode" "Prettier"
install_extension "eamodio.gitlens" "GitLens"
install_extension "dbaeumer.vscode-eslint" "ESLint"
install_extension "ms-vscode.cpptools" "C/C++"
install_extension "golang.go" "Go"
install_extension "rust-lang.rust-analyzer" "Rust Analyzer"
install_extension "ms-azuretools.vscode-docker" "Docker"
install_extension "github.copilot" "GitHub Copilot"
install_extension "github.copilot-chat" "GitHub Copilot Chat"
install_extension "ms-vscode-remote.remote-containers" "Dev Containers"
install_extension "ms-toolsai.jupyter-keymap" "Jupyter Keymap"
install_extension "formulahendry.code-runner" "Code Runner"
install_extension "ritwickdey.liveserver" "Live Server"
install_extension "pkief.material-icon-theme" "Material Icon Theme"
install_extension "zhuangtongfa.material-theme" "One Dark Pro"
install_extension "vscodevim.vim" "Vim"
install_extension "editorconfig.editorconfig" "EditorConfig"

echo ""
echo "🎉 Extension installation complete!"
echo ""
echo "📋 Installed extensions:"
$VSCODE_BIN --list-extensions | sed 's/^/  - /'
echo ""
echo "💡 You can install more extensions from the VS Code marketplace"
echo "   Example: $VSCODE_BIN --install-extension <extension-id>"