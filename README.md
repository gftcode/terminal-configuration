# Instalador Starship + Kitty

Script Bash que instala e configura automaticamente o **Starship** (prompt) e o **Kitty** (terminal), já com configurações prontas embutidas no próprio script.

---

## 📋 Sumário

- [O que é instalado](#-o-que-é-instalado)
- [Pré-requisitos](#-pré-requisitos)
- [Como usar](#-como-usar)
- [O que o script faz (passo a passo)](#-o-que-o-script-faz-passo-a-passo)
- [Configuração do Starship](#-configuração-do-starship)
- [Configuração do Kitty](#-configuração-do-kitty)
- [Arquivos criados/modificados](#-arquivos-criadosmodificados)
- [Backups e segurança](#-backups-e-segurança)
- [Solução de problemas](#-solução-de-problemas)
- [Desinstalação](#-desinstalação)

---

## 🚀 O que é instalado

| Programa | Função |
|---|---|
| **Starship** | Prompt de shell rápido, customizável e multiplataforma (substitui o prompt padrão do Bash) |
| **Kitty** | Emulador de terminal GPU-acelerado, rápido e altamente configurável |

Além disso, o script aplica **suas configurações pessoais** de ambos automaticamente.

---

## ✅ Pré-requisitos

- Sistema Linux com um destes gerenciadores de pacotes:
  - `apt` (Debian, Ubuntu, Mint…)
  - `dnf` (Fedora, RHEL…)
  - `pacman` (Arch, Manjaro…)
- Acesso a `sudo` (para instalar pacotes do sistema)
- Conexão com a internet (para baixar Starship, Kitty e dependências)
- **Recomendado:** uma **Nerd Font** instalada (ex: `JetBrainsMono Nerd Font`), caso contrário os ícones do prompt e do terminal aparecerão como quadrados.

---

## 🛠 Como usar

```bash
# 1. Salve o script como install-starship-kitty.sh
# 2. Torne executável
chmod +x install-starship-kitty.sh

# 3. Execute
./install-starship-kitty.sh
