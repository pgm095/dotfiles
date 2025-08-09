#!/bin/bash

# === CONFIG ===
DOTFILES_DIR="$HOME/dotfiles"  # Carpeta donde está tu repo de dotfiles
PKG_DEBIAN="$DOTFILES_DIR/packages.list"
PKG_ARCH="$DOTFILES_DIR/pkglist.txt"

# Archivos de configuración que quieres enlazar (origen → destino)
declare -A FILES_TO_LINK=(
    [".vimrc"]="$HOME/.vimrc"
    [".zshrc"]="$HOME/.zshrc"
    [".bashrc"]="$HOME/.bashrc"
    ["nvim_init.vim"]="$HOME/.config/nvim/init.vim"
)

# === FUNCIONES ===
install_debian() {
    echo "[INFO] Instalando paquetes en Debian/Ubuntu..."
    sudo apt update
    sudo apt install -y $(awk '{print $1}' "$PKG_DEBIAN")
}

install_arch() {
    echo "[INFO] Instalando paquetes en Arch/Manjaro..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed - < "$PKG_ARCH"
}

link_files() {
    echo "[INFO] Creando enlaces simbólicos de dotfiles..."
    for src in "${!FILES_TO_LINK[@]}"; do
        dest="${FILES_TO_LINK[$src]}"
        mkdir -p "$(dirname "$dest")"
        ln -sf "$DOTFILES_DIR/$src" "$dest"
        echo "  - $src → $dest"
    done
}

# === MAIN ===
echo "[INFO] Detectando distribución..."
if [ -f /etc/debian_version ]; then
    install_debian
elif [ -f /etc/arch-release ]; then
    install_arch
else
    echo "[ERROR] Distribución no soportada automáticamente."
    exit 1
fi

link_files

	echo "[OK] Instalación y configuración completadas ✅"

