#!/bin/bash

# 🛠️ 工具安装脚本
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

install_oh_my_zsh_extension() {
    echo -e "${GREEN}🚀 开始安装oh-my-zsh扩展...${NC}"
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

# 参数处理
case "$1" in
    --install)
        case "$2" in
            zsh)
                install_zsh
                ;;
            oh-my-zsh-extension)
                install_oh_my_zsh_extension
                ;;
            gh)
                install_gh
                ;;
            *)
                echo -e "${RED}❌ 未知工具: $2${NC}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "用法: $0 --install [工具名]"
        echo "可用工具:"
        echo "  zsh - 安装zsh和oh-my-zsh"
        echo "  oh-my-zsh-extension - 安装oh-my-zsh扩展"
        echo "  gh - 安装gh"
        exit 1
        ;;
esac
