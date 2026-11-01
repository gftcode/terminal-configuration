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
- [Arquivos criados/modificados](#-arquivos-criadomodificados)
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
```

Ao final:

```bash
# Recarregue o Bash
source ~/.bashrc

# Abra o Kitty
kitty
```

---

## ⚙️ O que o script faz (passo a passo)

### 1. `detect_os` — Detecta o gerenciador de pacotes

Procura por `apt`, `dnf` ou `pacman` no sistema e define qual comando de instalação usar. Se não encontrar nenhum, aborta com erro.

### 2. `install_deps` — Instala dependências básicas

Instala o `curl`, necessário para baixar o Starship e (se preciso) o Kitty.

### 3. `install_starship` — Instala o Starship

- Baixa e executa o instalador oficial: `https://starship.rs/install.sh`
- Adiciona a linha `eval "$(starship init bash)"` ao `~/.bashrc` (caso ainda não exista), ativando o Starship em toda sessão do Bash.

### 4. `apply_starship_config` — Aplica sua config do Starship

Cria `~/.config/starship.toml` com o tema embutido (blocos coloridos com `░▒▓`, usuário, diretório, git, etc.).

### 5. `install_kitty` — Instala o Kitty

- Tenta primeiro via gerenciador de pacotes nativo (mais estável).
- Se falhar, usa o instalador oficial da página do Kitty.

### 6. `apply_kitty_config` — Aplica sua config do Kitty

Cria `~/.config/kitty/kitty.conf` com fonte, transparência, atalhos de edição e configuração para Wayland.

### 7. `finalize` — Resumo final

Exibe instruções pós-instalação (recarregar shell, abrir Kitty, instalar Nerd Font).

---

## 🎨 Configuração do Starship

Arquivo: `~/.config/starship.toml`

### Formato do prompt

```
[░▒▓] OS  usuário  diretório  git 
➜
```

O prompt tem **duas linhas**:

- **Linha 1:** segmentos coloridos com ícones (OS, usuário, pasta atual, branch e status do git)
- **Linha 2:** caractere `➜` (verde = sucesso, vermelho = erro)

### Blocos explicados

| Bloco | O que mostra | Estilo |
|---|---|---|
| `[░▒▓]` | Marcador visual estático | Azul `#52A7DE` |
| `$os` | Símbolo do sistema operacional | Fundo azul, texto escuro |
| `$username` | Nome do usuário (sempre visível) | Fundo azul, texto escuro (vermelho se for root) |
| `$directory` | Caminho atual (até 3 níveis, senão `…/`) | Fundo `#1D3244` |
| `$git_branch` | Nome da branch com ícone `` | Fundo `#2C4E66` |
| `$git_status` | Status do git (ahead/behind, alterações) | Fundo `#2C4E66`, texto vermelho |
| `$character` | `➜` (sucesso/erro) | Ciano / vermelho |

### Por que o `format` usa cores explícitas?

O bloco `format` usa **cores literais em hexadecimal** (`#52A7DE`, `#1D3244`, `#2C4E66`) em vez de referenciar estilos de módulos. Isso evita bugs de renderização em alguns terminais e mantém as "setas" `` sempre alinhadas com a cor do bloco anterior.

---

## 🖥 Configuração do Kitty

Arquivo: `~/.config/kitty/kitty.conf`

### Aparência

| Diretiva | Efeito |
|---|---|
| `font_family JetBrainsMono Nerd Font` | Fonte principal (necessária para ícones) |
| `font_size 10.5` | Tamanho da fonte |
| `font_style bold` | Texto em negrito |
| `background_opacity 0.7` | Janela 70% opaca (30% transparente) |
| `background_blur 0` | Sem desfoque de fundo |
| `dynamic_background_opacity yes` | Permite ajustar opacidade em tempo real (atalho `ctrl+shift+a>m`) |
| `enable_audio_bell no` | Desativa o "bipe" sonoro |

### Atalhos de edição de texto

Estes atalhos enviam **códigos de controle** para o shell, simulando os atalhos do Readline:

| Atalho | Comportamento |
|---|---|
| `Ctrl + Backspace` | Apaga a palavra inteira **para trás** |
| `Ctrl + Delete` | Apaga a palavra inteira **para frente** |
| `Ctrl + ←` | Pula uma palavra para a **esquerda** |
| `Ctrl + →` | Pula uma palavra para a **direita** |
| `Home` | Vai para o **início** da linha |
| `End` | Vai para o **final** da linha |

### Exibição

| Diretiva | Efeito |
|---|---|
| `linux_display_server wayland` | Força o Kitty a usar Wayland |

> ⚠️ **Atenção:** se você estiver em **X11** (não Wayland), o Kitty pode falhar ao abrir por causa dessa linha. Nesse caso, edite o arquivo e troque por:
>
> ```conf
> linux_display_server auto
> ```
>
> ou simplesmente remova a linha.

---

## 📁 Arquivos criados/modificados

| Caminho | Ação |
|---|---|
| `~/.bashrc` | Adiciona `eval "$(starship init bash)"` (se não existir) |
| `~/.config/starship.toml` | Criado/sobrescrito com o tema embutido |
| `~/.config/kitty/kitty.conf` | Criado/sobrescrito com a config embutida |

---

## 🔒 Backups e segurança

- Antes de sobrescrever qualquer arquivo de configuração existente, o script cria uma cópia com extensão `.bak`:
  - `~/.config/starship.toml.bak`
  - `~/.config/kitty/kitty.conf.bak`
- O `~/.bashrc` **não é sobrescrito** — apenas recebe uma linha adicional, e somente se ela ainda não existir (verificação via `grep -qF`).
- É seguro rodar o script várias vezes: ele é **idempotente** (não duplica a linha no `.bashrc`, e os backups são renovados).

---

## 🧩 Solução de problemas

### Ícones aparecem como quadrados (⬜)

Você não tem uma Nerd Font instalada. Baixe em <https://www.nerdfonts.com/font-downloads> (recomendado: **JetBrainsMono Nerd Font**), instale e reinicie o Kitty.

### O Starship não aparece no terminal

```bash
source ~/.bashrc
```

Se ainda não aparecer, verifique se a linha existe:

```bash
grep starship ~/.bashrc
```

### O Kitty não abre (erro de display server)

Você provavelmente está em **X11**, mas a config força `wayland`. Edite `~/.config/kitty/kitty.conf`:

```conf
linux_display_server auto
```

### `sudo` pede senha várias vezes

Normal neste script — ele usa `sudo` para instalar pacotes do sistema (`curl`, `kitty`) via gerenciador de pacotes.

### Como confirmar que o Starship está funcionando

```bash
starship --version
starship config
```

A segunda linha mostra a config que está sendo usada — deve ser `~/.config/starship.toml`.

---

## 🗑 Desinstalação

### Remover configs (mantém os programas)

```bash
rm ~/.config/starship.toml
rm -rf ~/.config/kitty
# Remova manualmente a linha do Starship no ~/.bashrc
```

### Desinstalar o Starship

```bash
rm "$(command -v starship)"
```

### Desinstalar o Kitty

```bash
# apt
sudo apt remove kitty
# dnf
sudo dnf remove kitty
# pacman
sudo pacman -R kitty
```

---

## 📌 Resumo

- ✅ Instala Starship + Kitty automaticamente.
- ✅ Aplica tema bonito e funcional de prompt (com git, diretório, OS).
- ✅ Aplica configuração de terminal com transparência, Nerd Font e atalhos de edição.
- ✅ Faz backup das configs antigas antes de sobrescrever.
- ✅ Idempotente e seguro para rodar múltiplas vezes.
