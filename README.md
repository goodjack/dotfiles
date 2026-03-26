# dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理，搭配 [Bitwarden](https://bitwarden.com/) 存放機敏資料。

## 新電腦設定

### 1. 安裝基礎工具

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi bitwarden-cli age
```

### 2. 登入 Bitwarden

```bash
bw login
export BW_SESSION=$(bw unlock --raw)
```

### 3. 套用 dotfiles

```bash
chezmoi init --apply goodjack
```

這一步會自動：
- 還原所有設定檔（shell、git、vim、AI tools 等）
- 從 Bitwarden 拉取機敏資料（SSH keys、tokens 等）
- 匯入 GPG keys
- 還原 GitKraken 設定
- 匯入 macOS app 偏好設定（Amphetamine、BetterTouchTool、BreakTimer）

### 4. 安裝 Homebrew 套件

```bash
brew bundle --file=~/.Brewfile
```

### 5. 安裝編輯器 extensions

```bash
cat ~/.config/vscode-extensions.txt | xargs -L 1 code --install-extension
cat ~/.config/cursor-extensions.txt | xargs -L 1 cursor --install-extension
cat ~/.config/antigravity-extensions.txt | xargs -L 1 agy --install-extension
```

### 6. 手動處理項目

| 項目 | 操作 |
|------|------|
| **iTerm2** | Preferences → General → Settings → 指定 `~/.config/iterm2` 載入設定 |
| **BetterTouchTool** | Preferences → Manage Presets → Import `~/.config/bettertouchtool/Default.bttpreset` |
| **Sequel Ace** | File → Import Favorites（從舊電腦 AirDrop 過來） |

## 管理的檔案

### 直接管理（chezmoi）

| 類別 | 檔案 |
|------|------|
| Shell | `.zshrc`、`.zprofile`、`.p10k.zsh` |
| Git | `.gitconfig`、`.gitignore`、`.config/git/ignore` |
| Vim | `.vimrc` |
| Brew | `.Brewfile` |
| GitHub CLI | `.config/gh/config.yml` |
| Podman | `.config/containers/containers.conf` |
| iTerm2 | `.config/iterm2/com.googlecode.iterm2.plist` |
| BetterTouchTool | `.config/bettertouchtool/Default.bttpreset` |
| macOS defaults | `.config/macos-defaults/` (Amphetamine、BTT、BreakTimer) |
| BreakTimer | `Library/Application Support/BreakTimer/config.json` |
| Claude Code | `.claude/CLAUDE.md`、`settings.json`、`commands/`、`plugins/`、`skills/` |
| Codex | `.codex/AGENTS.md`、`config.toml` |
| Gemini | `.gemini/GEMINI.md`、`settings.json` |
| VS Code | `Library/Application Support/Code/User/settings.json`、`keybindings.json` |
| Cursor | `Library/Application Support/Cursor/User/settings.json`、`keybindings.json` |
| Antigravity | `Library/Application Support/Antigravity/User/settings.json`、`keybindings.json` |
| Extension 清單 | `.config/vscode-extensions.txt`、`cursor-extensions.txt`、`antigravity-extensions.txt` |

### 機敏資料（Bitwarden template）

| 類別 | Bitwarden item 名稱 |
|------|---------------------|
| SSH keys | `dotfiles/ssh-id-ed25519`、`ssh-id-ed25519-pub`、`ssh-config` |
| GitHub CLI token | `dotfiles/gh-hosts-yml` |
| Docker | `dotfiles/docker-config-json` |
| WakaTime | `dotfiles/wakatime-cfg` |
| GPG keys | `dotfiles/gpg-public`、`gpg-secret`、`gpg-trust` |
| GitKraken | `dotfiles/gitkraken-config`（gzip+base64） |

## 日常維護

### 改了設定檔後同步到 chezmoi

```bash
chezmoi re-add
cd $(chezmoi source-path) && git add -A && git commit -m "update: ..." && git push
```

### 在另一台電腦拉最新設定

```bash
chezmoi update
```

### 新增檔案到管理

```bash
chezmoi add ~/.some-config           # 一般檔案
chezmoi add --template ~/.some-tmpl  # 需要 template 的檔案
```

### 更新 Brewfile

```bash
brew bundle dump --file=~/.Brewfile --force
chezmoi re-add
```

### 更新編輯器 extension 清單

```bash
code --list-extensions | sort > ~/.config/vscode-extensions.txt
cursor --list-extensions | sort > ~/.config/cursor-extensions.txt
agy --list-extensions | sort > ~/.config/antigravity-extensions.txt  # 待確認 CLI 名稱
chezmoi re-add
```

### 更新 Bitwarden 中的機敏資料

機敏資料變更時（例如換了 SSH key），需要手動更新 Bitwarden：

```bash
# 範例：更新 SSH private key
jq -n --arg notes "$(cat ~/.ssh/id_ed25519)" \
  '{notes:$notes}' | bw encode | bw edit item <ITEM_ID>
```
