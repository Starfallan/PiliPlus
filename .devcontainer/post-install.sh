#!/bin/bash
set -e

# --- 配置区 ---
FLUTTER_VERSION="3.38.6"
ANDROID_SDK_ROOT="$HOME/android-sdk"
# --------------

echo "🚀 正在完善 Android 环境..."

# 1. 下载并安装 Android SDK 命令行工具
if [ ! -d "$ANDROID_SDK_ROOT" ]; then
    echo "📥 下载 Android Command Line Tools..."
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
    # 下载 Linux 版工具包 (版本号可以根据需要调整，目前 11076708 是较新版本)
    curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    unzip -q sdk.zip -d $ANDROID_SDK_ROOT/cmdline-tools
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest
    rm sdk.zip
fi

# 2. 设置 Android 环境变量
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 写入 .bashrc 永久生效
if ! grep -q "ANDROID_HOME" ~/.bashrc; then
    echo "export ANDROID_HOME=$ANDROID_SDK_ROOT" >> ~/.bashrc
    echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools" >> ~/.bashrc
fi

# 3. 安装必要的 SDK 组件
echo "📦 正在安装 SDK 平台和工具 (这可能需要几分钟)..."
yes | sdkmanager --licenses > /dev/null
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 4. 关联 Flutter 与 Android SDK
flutter config --android-sdk $ANDROID_SDK_ROOT

# --- 原有的 Flutter 安装逻辑 ---
if [ ! -d "$HOME/flutter" ]; then
    echo "📥 正在安装 Flutter $FLUTTER_VERSION..."
    git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION $HOME/flutter
fi
export PATH="$PATH:$HOME/flutter/bin"

# 5. 应用 Patch 并获取依赖
FLUTTER_ROOT=$(flutter doctor -v | grep "Flutter SDK at" | awk '{print $NF}')
PATCH_FILE="$GITHUB_WORKSPACE/lib/scripts/bottom_sheet_patch.diff"
if [ -f "$PATCH_FILE" ]; then
    cd "$FLUTTER_ROOT"
    git apply --check "$PATCH_FILE" && git apply "$PATCH_FILE" || echo "补丁跳过"
    cd "$GITHUB_WORKSPACE"
fi

flutter pub get
echo "✅ 环境修复完成！"