#!/usr/bin/env bash
# ------------------------------------------------------------
# Dotfile Bootstrap — Install all required packages
# Arch Linux / yay or paru
# ------------------------------------------------------------
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
die()     { echo -e "${RED}[✗]${NC} $*" >&2; exit 1; }
section() { echo -e "\n${BOLD}--- $* ---${NC}"; }

# ---------- Detect AUR helper ---------------------------------------------
if command -v paru &>/dev/null; then
  AUR=paru
elif command -v yay &>/dev/null; then
  AUR=yay
else
  warn "Neither paru nor yay found. Installing yay from AUR..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  AUR=yay
fi
info "Using AUR helper: $AUR"

install_pkgs() {
  $AUR -S --needed --noconfirm "$@"
}

# ==========================================================================
section "Shell & Terminal"
install_pkgs \
  zsh \
  ghostty \
  tmux \
  starship \
  fzf

# ==========================================================================
section "Wayland / Hyprland Desktop"
install_pkgs \
  hyprland \
  hyprlock \
  hyprpaper \
  hypridle \
  waybar \
  swaync \
  wofi \
  rofi \
  rofi-wayland \
  numlockx \
  polkit-gnome \
  xdg-desktop-portal-hyprland

# ==========================================================================
section "Desktop Apps & System Tray"
install_pkgs \
  nautilus \
  blueman \
  network-manager-applet \
  pavucontrol \
  gsimplecal \
  qt5ct \
  qt6ct

# ==========================================================================
section "Audio & Media"
install_pkgs \
  pulseaudio \
  pulseaudio-bluetooth \
  playerctl \
  pactl

# ==========================================================================
section "Screenshots & Display"
install_pkgs \
  brightnessctl \
  grim \
  slurp \
  jq \
  wl-clipboard \
  libnotify

# ==========================================================================
section "Editor — Neovim + dependencies"
install_pkgs \
  neovim \
  git \
  make \
  gcc \
  unzip \
  curl \
  wget \
  ripgrep \
  fd \
  xclip

# ==========================================================================
section "Development Languages & Tools"
install_pkgs \
  nodejs \
  npm \
  go \
  python \
  python-pip \
  rustup \
  docker \
  base-devel

# ==========================================================================
section "Fonts & Themes"
install_pkgs \
  ttf-cascadia-code-nerd \
  ttf-jetbrains-mono-nerd \
  noto-fonts \
  noto-fonts-emoji \
  papirus-icon-theme \
  catppuccin-gtk-theme-mocha \
  catppuccin-mocha-dark-cursors

# ==========================================================================
section "System Utilities"
install_pkgs \
  pacman-contrib \
  reflector \
  btop \
  fastfetch \
  postgresql

# ==========================================================================
section "Setting zsh as default shell"
if [[ "$SHELL" != "$(which zsh)" ]]; then
  chsh -s "$(which zsh)"
  info "Default shell changed to zsh. Re-login to apply."
else
  info "zsh is already the default shell."
fi

# ==========================================================================
section "Git configuration"
git config --global user.name "adib ziad raed ahumada"
git config --global user.email "adibraed1@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor nvim
info "Git configured for adib ziad raed ahumada <adibraed1@gmail.com>"

# ==========================================================================
section "Tmux Plugin Manager (tpm)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  info "tpm installed. Press prefix+I inside tmux to install plugins."
else
  info "tpm already installed."
fi

echo -e "\n${GREEN}${BOLD}All packages installed successfully!${NC}"
echo "Next steps:"
echo "  1. Re-login or run: exec zsh"
echo "  2. Open tmux and press prefix+I to install tmux plugins"
echo "  3. Open neovim — lazy.nvim will auto-install plugins on first launch"
