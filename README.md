# 🚀 Start Project 

自用项目，用于快速安装常用工具

## 🛠️ 使用方法

1. 本地使用：
```bash
./start.sh --install [工具名]
```

2. 直接通过GitHub Raw使用：
```bash
bash <(curl -s https://raw.githubusercontent.com/mhduiy/start/main/start.sh) --install [工具名1] [工具名2] ...

# 或者通过短链接
bash <(curl -sL startdev.mhduiy.cn) --install [工具名1] [工具名2] ...
```

当前支持的工具：

- zsh      - 安装zsh和oh-my-zsh
- zsh-ext  - 安装zsh扩展插件 (包含语法高亮和自动补全)
- gh       - 安装GitHub CLI (直接安装DEB方式)
