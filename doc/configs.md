# Mis configuraciones

## WSL

### 1. Actualizar el sistema

Actualizar la lista de paquetes disponibles:

```bash
sudo apt update
```

### 2. Instalar paquetes esenciales

Estos paquetes son necesarios para el desarrollo y la configuración de herramientas:

```bash
sudo apt install make git ripgrep unzip xclip build-essential
```

### 3. Instalar `brew` como gestor de paquetes

[Consultar en la página oficial](https://brew.sh/) para su instalación.

Paquetes instalados con `brew`:

```bash
brew install go neovim rust bat gitui serie eza bottom
```

### 4. Instalar herramientas adicionales

#### `cargo`

Cargo es el gestor de paquetes y compilación de Rust. Para instalarlo:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Asegúrate de agregar `cargo` al `PATH`:

```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### `stylua` (formateador de Lua)

Requiere tener `cargo` instalado previamente.

```bash
cargo install stylua
```

#### `cargo-cache` (limpieza de caché de Cargo)

Permite limpiar la caché de Cargo para liberar espacio.

```bash
cargo install cargo-cache
```

Para limpiar la caché, ejecutar:

```bash
cargo cache -a
```

### 5. Instalar herramientas hechas en Rust

Estas herramientas pueden mejorar tu flujo de trabajo:

- [`serie`](https://github.com/lusingander/serie) - Generador de secuencias numéricas. (_Se puede instalar con Brew_)
- [`zellij`](https://github.com/zellij-org/zellij) - Administrador de terminal basado en mosaicos, similar a tmux.

Para instalar `zellij` con cargo:

```bash
cargo install zellij
```

### 6. Instalar starship para mejorar la terminal

```bash
curl -sS https://starship.rs/install.sh | sh
```

Luego agregar en el archivo `.bashrc`

```bash
eval "$(starship init bash)"
```

### 7. Instalar autocompletado para la terminal

```bash
sudo apt update && sudo apt install fzf
```

Verificar la correcta instalación

```bash
fzf --version
```

#### Activar autocompletado de `fzf` en Bash

```bash
echo "[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash" >> ~/.bashrc
source ~/.bashrc
```

### Instalar `fzf-tab`

```bash
git clone https://github.com/Aloxaf/fzf-tab ~/.config/fzf-tab
```

---

Si quieres descubrir más herramientas hechas en Rust, revisa esta lista: [Awesome Rust Tools](https://github.com/unpluggedcoder/awesome-rust-tools?tab=readme-ov-file).

