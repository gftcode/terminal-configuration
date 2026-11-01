#!/usr/bin/env bash

# ==============================================================================
# Script de Instalação: Starship + Kitty
# Descrição: Instala Starship e Kitty e aplica as configurações embutidas.
# ==============================================================================

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; exit 1; }

# ------------------------------------------------------------------------------
# 1. Detectar Sistema / Gerenciador de Pacotes
# ------------------------------------------------------------------------------
detect_os() {
    if command -v apt >/dev/null 2>&1; then
        PKG_MANAGER="apt"
        INSTALL_CMD="sudo apt install -y"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    else
        error "Gerenciador de pacotes não suportado (apt, dnf ou pacman)."
    fi
    info "Gerenciador detectado: $PKG_MANAGER"
}

# ------------------------------------------------------------------------------
# 2. Instalar Dependências
# ------------------------------------------------------------------------------
install_deps() {
    info "Instalando dependências básicas (curl)..."
    $INSTALL_CMD curl
}

# ------------------------------------------------------------------------------
# 3. Instalar Starship
# ------------------------------------------------------------------------------
install_starship() {
    info "Instalando Starship..."
    if ! command -v starship >/dev/null 2>&1; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        warn "Starship já está instalado."
    fi

    # Ativar no .bashrc
    local BASHRC="$HOME/.bashrc"
    local INIT_LINE='eval "$(starship init bash)"'
    if ! grep -qF "$INIT_LINE" "$BASHRC" 2>/dev/null; then
        info "Adicionando inicialização do Starship ao .bashrc..."
        {
            echo ""
            echo "# Starship Prompt"
            echo "$INIT_LINE"
        } >> "$BASHRC"
    else
        warn "Starship já configurado no .bashrc."
    fi
}

# ------------------------------------------------------------------------------
# 4. Aplicar Configuração do Starship (EMBUTIDA)
# ------------------------------------------------------------------------------
apply_starship_config() {
    local CONFIG_DIR="$HOME/.config"
    local CONFIG_FILE="$CONFIG_DIR/starship.toml"

    mkdir -p "$CONFIG_DIR"

    if [ -f "$CONFIG_FILE" ]; then
        warn "Backup da configuração antiga do Starship -> starship.toml.bak"
        cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
    fi

    info "Escrevendo starship.toml..."
    cat > "$CONFIG_FILE" << 'STARSHIP_EOF'
# Formato direto usando códigos de cores explícitos para evitar bugs de renderização
format = """
[░▒▓](#52A7DE)\
$os\
$username\
[](bg:#1D3244 fg:#52A7DE)\
$directory\
[](fg:#1D3244 bg:#2C4E66)\
$git_branch\
$git_status\
[](fg:#2C4E66)\
\n$character\
"""

[os]
disabled = false
style = "bg:#52A7DE fg:#1D3244 bold"

[os.symbols]
NixOS = " "

[username]
show_always = true
style_user = "bg:#52A7DE fg:#1D3244 bold"
style_root = "bg:#52A7DE fg:red bold"
format = '[$user]($style)'

[directory]
style = "bg:#1D3244 fg:#52A7DE bold"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bg:#2C4E66 fg:#52A7DE bold"
format = '[[ $symbol$branch ]($style)]'

[git_status]
style = "bg:#2C4E66 fg:red bold"
format = '[[($all_status$ahead_behind )]($style)]'

[character]
success_symbol = "[ ➜ ](bold cyan)"
error_symbol = "[ ➜ ](bold red)"
STARSHIP_EOF
}

# ------------------------------------------------------------------------------
# 5. Instalar Kitty
# ------------------------------------------------------------------------------
install_kitty() {
    info "Instalando Kitty..."
    if command -v kitty >/dev/null 2>&1; then
        warn "Kitty já está instalado."
        return
    fi

    case "$PKG_MANAGER" in
        apt)
            $INSTALL_CMD kitty || {
                warn "Falha no apt, tentando instalador oficial..."
                curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
            }
            ;;
        dnf)
            $INSTALL_CMD kitty || {
                warn "Falha no dnf, tentando instalador oficial..."
                curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
            }
            ;;
        pacman)
            $INSTALL_CMD kitty
            ;;
    esac
}

# ------------------------------------------------------------------------------
# 6. Aplicar Configuração do Kitty (EMBUTIDA)
# ------------------------------------------------------------------------------
apply_kitty_config() {
    local CONFIG_DIR="$HOME/.config/kitty"
    local CONFIG_FILE="$CONFIG_DIR/kitty.conf"

    mkdir -p "$CONFIG_DIR"

    if [ -f "$CONFIG_FILE" ]; then
        warn "Backup da configuração antiga do Kitty -> kitty.conf.bak"
        cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
    fi

    info "Escrevendo kitty.conf..."
    cat > "$CONFIG_FILE" << 'KITTY_EOF'
# Configuração de Fonte (Nerd Font)
font_family      JetBrainsMono Nerd Font
font_size        10.5
font_style       bold
# Efeitos Visuais (Transparência e Blur)
background_opacity 0.7
background_blur    0
dynamic_background_opacity yes
# Comportamento
enable_audio_bell no

# --- Atalhos de Edição de Texto Avançados ---

# Ctrl + Backspace: Apaga a palavra inteira para TRÁS
map ctrl+backspace send_text all \x17

# Ctrl + Delete: Apaga a palavra inteira para FRENTE
map ctrl+delete send_text all \x1b[3;5~

# Ctrl + Seta para a Esquerda: Pula uma palavra inteira para a ESQUERDA
map ctrl+left send_text all \x1bb

# Ctrl + Seta para a Direita: Pula uma palavra inteira para a DIREITA
map ctrl+right send_text all \x1bf

# Home: Move o cursor para o INÍCIO da linha
map home send_text all \x01

# End: Move o cursor para o FINAL da linha
map end send_text all \x05

linux_display_server wayland
KITTY_EOF
}

# ------------------------------------------------------------------------------
# 7. Finalização
# ------------------------------------------------------------------------------
finalize() {
    echo ""
    info "========================================"
    info "Instalação concluída com sucesso!"
    info "========================================"
    echo ""
    warn "Ações necessárias:"
    echo "  1. Reinicie o terminal ou execute: source ~/.bashrc"
    echo "  2. Abra o Kitty para aplicar a configuração."
    echo "  3. Instale a 'JetBrainsMono Nerd Font' caso ainda não tenha:"
    echo "     https://www.nerdfonts.com/font-downloads"
    echo ""
    echo "  Configs aplicadas:"
    echo "   - ~/.config/starship.toml"
    echo "   - ~/.config/kitty/kitty.conf"
    echo ""
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    detect_os
    install_deps
    install_starship
    apply_starship_config
    install_kitty
    apply_kitty_config
    finalize
}

main "$@"
