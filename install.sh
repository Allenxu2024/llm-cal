#!/bin/bash
set -e

echo "========================================="
echo "       llm-cal (AI 日历) 安装程序"
echo "========================================="
echo ""

# 1. 安装系统依赖 calcurse
echo "[1/3] 检查底层依赖 (calcurse)..."
if ! command -v calcurse &> /dev/null; then
    echo "未找到 calcurse，尝试自动安装..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y calcurse
    elif command -v yum &> /dev/null; then
        sudo yum install -y calcurse
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm calcurse
    else
        echo "❌ 无法自动安装 calcurse，请手动安装后重试。"
        exit 1
    fi
else
    echo "✅ calcurse 已安装。"
fi

# 2. 安装 Python 运行环境 uv
echo ""
echo "[2/3] 检查 Python 运行环境 (uv)..."
if ! command -v uv &> /dev/null; then
    echo "未找到 uv，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    echo "✅ uv 安装完成。"
else
    echo "✅ uv 已安装。"
fi

# 3. 部署 llm-cal
echo ""
echo "[3/3] 部署 llm-cal 核心文件..."
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/llm-cal" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/llm-cal"

echo "✅ llm-cal 部署至 $INSTALL_DIR/llm-cal"
echo ""

# 4. 结束与提示
echo "========================================="
echo "🎉 安装成功！"
echo "========================================="
echo "要开始使用 llm-cal，请完成最后一步配置："
echo ""
echo "请将您的 Anthropic API Key 添加到环境变量中。"
echo "打开终端并运行（或加入到您的 ~/.bashrc 中）："
echo "  export ANTHROPIC_API_KEY='您的_sk-ant-..._密钥'"
echo ""
echo "随后，您即可直接使用命令："
echo "  llm-cal \"提醒我明天买咖啡\""
echo "========================================="
