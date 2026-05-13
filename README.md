# Dotfiles - Arch Linux + Hyprland

Este repositório contem as configurações do meu sistema Arch Linux usando Hyprland. Aqui estão os principais componentes e onde cada configuração fica.

[![Sistema](/img/2026-05-10-000136_hyprshot.png)](/img/2026-05-10-000136_hyprshot.png)


## Estrutura

- `hypr/`: configuração do Hyprland (monitor, apps, binds, etc.)
- `waybar/`: configuração do Waybar (módulos, temas e estilos)
- `kitty/`: configuração do terminal Kitty e tema atual
- `gtk-3.0/` e `gtk-4.0/`: configurações de temas e comportamento do GTK
- `qt5ct/` e `qt6ct/`: configurações de tema, fontes e estilo do Qt

## Observacoes

- Este repositório representa as configurações do meu ambiente atual.
- Algumas preferencias incluem tema escuro, fontes Nerd Font e temas Breeze.

## Uso

Copie as pastas para `~/.config` ou use links simbolicos conforme sua preferencia..

É necessário possuir todos os pacotes e ferramentas utilizados, breve citarei todos aqui...

## Instalacao automatica

Script de bootstrap para instalar pacotes, copiar configs e fazer checagens de boot.

Exemplo com curl:

```bash
curl -fsSL https://raw.githubusercontent.com/USERNAME/dotfiles/main/install.sh | bash -s -- --repo https://github.com/USERNAME/dotfiles.git
```

Opcoes:

- `--repo <git_url>`: URL do repositorio para clonar (obrigatorio se nao rodar dentro do repo)
- `--branch <branch>`: branch a usar (padrao: main)
- `--dry-run`: apenas mostra os comandos
- `--no-aur`: ignora pacotes AUR

Observacoes:

- O script cria backup em `~/.config-backups/<timestamp>` antes de sobrescrever configs.
- O script tenta detectar microcode e avisa sobre NVIDIA.
- Se quiser rodar localmente: `bash install.sh`.

Incluido em hypr/hyprland.lua a configuração traduzida para a nova linguagem Lua
