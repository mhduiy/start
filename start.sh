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

    echo -e "${GREEN}✨ 安装高亮和补全插件...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "${GREEN}✨ 配置zsh...${NC}"
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
    
    echo -e "${GREEN}🎉 zsh和oh-my-zsh安装完成!${NC}"
    echo "请运行 'chsh -s $(which zsh)' 切换默认shell"
}

# 参数处理
case "$1" in
    --install)
        case "$2" in
            zsh)
                install_zsh
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
        exit 1
        ;;
esac
