#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$PWD"
if [[ -n "${BASH_SOURCE[0]-}" ]]; then
  SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
fi

REPO_URL="https://github.com/EduardoGCT/dotfiles"
BRANCH="main"
DRY_RUN=0
NO_AUR=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_URL="$2"
      shift 2
      ;;
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --no-aur)
      NO_AUR=1
      shift
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

log() {
  printf "%s\n" "$*"
}

die() {
  log "ERROR: $*"
  exit 1
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log "DRY-RUN: $*"
    return 0
  fi
  "$@"
}

SUDO=""
if [[ $EUID -ne 0 ]]; then
  SUDO="sudo"
fi

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    die "Missing command: $1"
  fi
}

prepare_repo() {
  if [[ -d "$SCRIPT_DIR/hypr" && -d "$SCRIPT_DIR/waybar" ]]; then
    REPO_DIR="$SCRIPT_DIR"
    return
  fi

  if [[ -z "$REPO_URL" ]]; then
    die "Repo not found. Run from repo or pass --repo <git_url>"
  fi

  require_cmd git
  local tmpdir
  tmpdir=$(mktemp -d)
  log "Cloning repo to $tmpdir"
  run git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$tmpdir"
  REPO_DIR="$tmpdir"
}

cpu_vendor() {
  if command -v lscpu >/dev/null 2>&1; then
    lscpu | awk -F: '/Vendor ID/ {gsub(/ /,"",$2); print $2; exit}'
  fi
}

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  require_cmd git
  require_cmd makepkg

  local tmpdir
  tmpdir=$(mktemp -d)
  log "Installing yay from AUR"
  run git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && run makepkg -si --noconfirm)
}

install_pacman_packages() {
  local pkgs=()

  pkgs+=(base-devel curl git)
  pkgs+=(linux-firmware linux-headers efibootmgr dosfstools e2fsprogs)
  pkgs+=(pacman-contrib)
  pkgs+=(networkmanager nm-connection-editor bluez bluez-utils blueman)
  pkgs+=(pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber)
  pkgs+=(alsa-utils)
  pkgs+=(gstreamer gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ffmpeg)
  pkgs+=(hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker)
  pkgs+=(waybar kitty rofi-wayland)
  pkgs+=(dolphin dolphin-plugins ark kio-admin kservice kde-cli-tools)
  pkgs+=(polkit-gnome)
  pkgs+=(qt5-wayland qt6-wayland qt5ct qt6ct)
  pkgs+=(xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk)
  pkgs+=(mako cliphist mpv pavucontrol)
  pkgs+=(xdg-user-dirs xdg-user-dirs-gtk)
  pkgs+=(wl-clipboard grim slurp)
  pkgs+=(playerctl python python-gobject)
  pkgs+=(brightnessctl light htop gnome-disk-utility)
  pkgs+=(wlogout swaync)
  pkgs+=(upower lm_sensors)
  pkgs+=(mesa libva-mesa-driver vulkan-icd-loader vulkan-intel vulkan-radeon)
  pkgs+=(breeze breeze-gtk breeze-icons breeze-cursors)
  pkgs+=(ttf-font-awesome ttf-jetbrains-mono-nerd ttf-opensans ttf-droid noto-fonts noto-fonts-emoji noto-fonts-cjk)

  local vendor
  vendor=$(cpu_vendor || true)
  if [[ "$vendor" == "GenuineIntel" ]]; then
    pkgs+=(intel-ucode)
  elif [[ "$vendor" == "AuthenticAMD" ]]; then
    pkgs+=(amd-ucode)
  fi

  log "Installing pacman packages"
  run $SUDO pacman -Syu --needed --noconfirm "${pkgs[@]}"
}

install_aur_packages() {
  if [[ "$NO_AUR" == "1" ]]; then
    log "Skipping AUR packages"
    return
  fi

  install_yay

  local pkgs=()
  pkgs+=(awww)
  pkgs+=(waypaper)
  pkgs+=(brave-bin)
  pkgs+=(hyprshot)

  log "Installing AUR packages"
  run yay -S --needed --noconfirm "${pkgs[@]}"
}

backup_and_copy() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" ]]; then
    run mkdir -p "$BACKUP_ROOT"
    run mv "$dest" "$BACKUP_ROOT/"
    log "Backed up $dest to $BACKUP_ROOT"
  fi
  run cp -a "$src" "$dest"
}

deploy_dotfiles() {
  BACKUP_ROOT="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"
  local targets=(
    "hypr"
    "waybar"
    "kitty"
    "gtk-3.0"
    "gtk-4.0"
    "qt5ct"
    "qt6ct"
  )

  run mkdir -p "$HOME/.config"

  for dir in "${targets[@]}"; do
    if [[ -d "$REPO_DIR/$dir" ]]; then
      backup_and_copy "$REPO_DIR/$dir" "$HOME/.config/$dir"
    fi
  done

  if [[ -d "$REPO_DIR/Wallpapers" ]]; then
    backup_and_copy "$REPO_DIR/Wallpapers" "$HOME/Wallpapers"
  fi

  if [[ -d "$REPO_DIR/hypr/scripts" ]]; then
    run mkdir -p "$HOME/.config/hypr/scripts"
    run cp -a "$REPO_DIR/hypr/scripts/." "$HOME/.config/hypr/scripts/"
  fi

  if [[ -d "$REPO_DIR/system_scripts" ]]; then
    run mkdir -p "$HOME/.config/system_scripts"
    run cp -a "$REPO_DIR/system_scripts/." "$HOME/.config/system_scripts/"
  fi

  shopt -s nullglob
  run chmod +x "$HOME/.config/hypr/scripts"/*.sh
  run chmod +x "$HOME/.config/system_scripts"/*.py
  shopt -u nullglob
}

post_install_setup() {
  log "Enabling services"
  run $SUDO systemctl enable --now NetworkManager
  run $SUDO systemctl enable --now bluetooth

  if command -v systemctl >/dev/null 2>&1; then
    run systemctl --user enable --now pipewire pipewire-pulse wireplumber
  fi

  if command -v xdg-user-dirs-update >/dev/null 2>&1; then
    run xdg-user-dirs-update
  fi

  if ! command -v corectrl >/dev/null 2>&1; then
    log "CoreCtrl is not installed; Hyprland autostart may show an error."
  fi
}

check_boot() {
  log "Boot checks"

  if [[ -d /sys/firmware/efi ]]; then
    log "UEFI detected"
  else
    log "Legacy BIOS detected"
  fi

  if [[ -d /boot/loader/entries ]]; then
    log "systemd-boot entries found"
  elif [[ -f /boot/grub/grub.cfg ]]; then
    log "GRUB config found"
  else
    log "No bootloader config found in /boot"
  fi

  if [[ -f /etc/fstab ]]; then
    while read -r spec _; do
      [[ -z "$spec" ]] && continue
      [[ "$spec" =~ ^# ]] && continue

      if [[ "$spec" =~ ^UUID= ]]; then
        local uuid="${spec#UUID=}"
        if ! blkid -t UUID="$uuid" >/dev/null 2>&1; then
          log "Missing fstab UUID: $uuid"
        fi
      elif [[ "$spec" =~ ^PARTUUID= ]]; then
        local partuuid="${spec#PARTUUID=}"
        if ! blkid -t PARTUUID="$partuuid" >/dev/null 2>&1; then
          log "Missing fstab PARTUUID: $partuuid"
        fi
      elif [[ "$spec" =~ ^/dev/ ]]; then
        if [[ ! -e "$spec" ]]; then
          log "Missing fstab device: $spec"
        fi
      fi
    done < /etc/fstab
  fi

  if command -v lspci >/dev/null 2>&1 && lspci | grep -qi nvidia; then
    log "NVIDIA GPU detected. Install nvidia or nvidia-open if needed."
  fi
}

main() {
  prepare_repo
  install_pacman_packages
  install_aur_packages
  deploy_dotfiles
  post_install_setup
  check_boot
  log "Done"
}

main
