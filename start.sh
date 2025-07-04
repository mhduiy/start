#!/bin/bash

# ✨ 开发环境快速配置工具
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

install_zsh() {
    echo -e "${GREEN}🚀 开始安装zsh...${NC}"
    sudo apt update
    sudo apt install -y zsh
    
    echo -e "${GREEN}✨ 安装oh-my-zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_zsh_ext() {
    echo -e "${GREEN}🚀 开始安装zsh扩展...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "${GREEN}✨ 配置zsh...${NC}"
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
}

install_gh() {
    echo -e "${GREEN}🚀 开始安装gh...${NC}"
    
    # 检测系统架构
    ARCH=$(dpkg --print-architecture)
    echo -e "${GREEN}🔍 检测到系统架构: $ARCH${NC}"
    
    # 获取最新版本号
    echo -e "${GREEN}🔍 获取最新版本信息...${NC}"
    LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}❌ 无法获取最新版本信息${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}🎯 最新版本: $LATEST_VERSION${NC}"
    
    # 构建下载文件名
    VERSION_NUM=${LATEST_VERSION#v}  # 移除v前缀
    DEB_FILE="gh_${VERSION_NUM}_linux_${ARCH}.deb"
    DOWNLOAD_URL="https://github.com/cli/cli/releases/download/${LATEST_VERSION}/${DEB_FILE}"
    
    echo -e "${GREEN}📥 正在下载: $DEB_FILE${NC}"
    
    # 下载deb包
    if wget "$DOWNLOAD_URL"; then
        echo -e "${GREEN}✅ 下载成功${NC}"
        
        # 安装deb包
        echo -e "${GREEN}📦 正在安装...${NC}"
        sudo dpkg -i "$DEB_FILE"
        
        # 清理下载的文件
        rm "$DEB_FILE"
        echo -e "${GREEN}🧹 清理临时文件${NC}"
        
        echo -e "${GREEN}✨ 配置gh...${NC}"
        gh auth login
    else
        echo -e "${RED}❌ 下载失败，请检查网络连接或手动安装${NC}"
        exit 1
    fi
}

# 显示帮助信息
show_help() {
    echo "✨ DevKit - 开发环境快速配置工具"
    echo ""
    echo "用法: $0 [选项] [工具名...]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -i, --install  安装指定工具"
    echo ""
    echo "可用工具:"
    echo "  zsh      - 安装zsh和oh-my-zsh"
    echo "  zsh-ext  - 安装zsh扩展插件 (包含语法高亮和自动补全)"
    echo "  gh       - 安装GitHub CLI (直接安装DEB方式)"
}

# 安装指定工具
install_tool() {
    case "$1" in
        zsh)
            install_zsh
            ;;
        zsh-ext)
            install_zsh_ext
            ;;
        gh)
            install_gh
            ;;
        *)
            echo -e "${RED}❌ 未知工具: $1${NC}"
            echo "使用 $0 --help 查看可用工具"
            return 1
            ;;
    esac
}

# 参数处理
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -i|--install)
        if [ $# -lt 2 ]; then
            echo -e "${RED}❌ 请指定要安装的工具${NC}"
            echo "使用 $0 --help 查看用法"
            exit 1
        fi

        # 安装所有指定的工具
        shift  # 移除 --install 参数
        for tool in "$@"; do
            echo -e "${GREEN}🔧 正在安装: $tool${NC}"
            if install_tool "$tool"; then
                echo -e "${GREEN}✅ $tool 安装完成${NC}"
            else
                echo -e "${RED}❌ $tool 安装失败${NC}"
                exit 1
            fi
            echo ""
        done
        echo -e "${GREEN}🎉 所有工具安装完成！${NC}"
        ;;
    *)
        echo -e "${RED}❌ 未知选项: $1${NC}"
        echo "使用 $0 --help 查看用法"
        exit 1
        ;;
esac
