# .suco — Juegos MS-DOS y CONSOLAS en formato one-click para Linux  
### .suco — One-click MS-DOS AND CONSOLE games for Linux
MS-DOS, MEGADRIVE/GENESIS, NINTENDO NES, NITNENDO SNES BY NOW
---

## 🚀 ¿Cómo usarlo? / How to use it?

1. 📦 **Bájate el .zip desde aquí  / Download the `.zip`**

2. 📂 **Descomprímelo en una carpeta de tu elección  /    Extract it anywhere**

3. ✅ **Dale permisos de ejecución al script / Give execute permissions to the script:**

   ```bash
   chmod +x sucomsdos.sh
   chmod +x sucoarch.sh
   ```

---

### 🔧 Requisitos / Requirements

- Linux `bash`, `wget`, `rsync`, `unzip`  `dosbox`
  
---

### 📦 Instalación de dependencias / Dependencies Install

#### ✅ Ubuntu / Debian / Linux Mint
```bash
sudo apt install dosbox wget unzip rsync
```

#### ✅ Arch Linux / Manjaro / EndeavourOS
```bash
sudo pacman -S --needed dosbox wget unzip rsync
```

#### ✅ Fedora / RHEL / Rocky Linux / AlmaLinux
```bash
sudo dnf install dosbox wget unzip rsync
```

#### ✅ openSUSE (Leap / Tumbleweed)
```bash
sudo zypper install dosbox wget unzip rsync
```


---

- Los script `sucomsdos.sh y sucoarch.sh` deben estar en el directorio actual  
  The `sucomsdos.sh and sucoarch.sh` scripts must be in the current directory

- El juego debe estar en la carpeta `/msdos o en /roms` como:
  - Carpeta con el nombre del juego, o  
  - Archivo `.zip` con el nombre del juego (solo para juegos msdos)  
  The game must be placed in the `/msdos or /roms` directory as:
  - A folder named after the game, or  
  - A `.zip` file named after the game (only for msdos games)

---

### 🛠️ Instrucciones rápidas / Quick Instructions

```bash
./sucomsdos.sh "Nombre del Juego" EJECUTABLE.EXE
./sucomsdos.sh "Game Name" EXECUTABLE.EXE
./sucoarch.sh "Nombre de la rom"
./sucoarch.sh "Rom Name" 
```

Ejemplo / Example:

In "/msdos/Doom 1" we have the doom files.

```bash
./sucomsdos.sh "Doom 1" DOOM.EXE
```

In "/roms/nes/nemo.nes" we have the nes game.

```bash
./sucoarch.sh "nemo.nes"
```

📦 El script sucomsdos.sh hace lo siguiente / The script does the following:
1. Verifica dependencias / Checks dependencies  
2. Usa `msdos/NOMBRE/` o `msdos/NOMBRE.zip` como origen  
   Uses `msdos/NAME/` or `msdos/NAME.zip` as source  
3. Crea la estructura AppImage con los archivos del juego  
   Builds the AppImage structure with the game files  
4. Genera un archivo `.suco` (AppImage) listo para ejecutar  
   Produces a ready-to-run `.suco` (AppImage) file

🗃️ El archivo final estará en / The final file will be in:  
`games/Nombre_del_Juego-x86_64.suco`

Este `.suco`:  
This `.suco`:

- Es autocontenido / Self-contained  
- Se abre en pantalla completa / Opens in fullscreen  
- Soporta guardado externo si el juego lo necesita / Supports external saving  
- Puede auditarse o desempaquetarse / Auditable and extractable

---

## ✅ Características actuales / Current Features

- Modo pantalla completa por defecto  
  Fullscreen mode by default
- Soporta guardado de archivos fuera del AppImage si el juego lo necesita  
  Supports saving files outside the AppImage if the game requires it
- Soporta entrada desde carpeta o `.zip` en `msdos/`  
  Accepts input from folder or `.zip` file in `msdos/`
- Todo incluido: DOSBox, juego, configuración y extras  
  All-in-one: DOSBox, game, config, and extras
- Un único archivo `.suco` por juego  
  Single `.suco` file per game

---

## 🎯 ¿Por qué este proyecto? / Why this project?

Los emuladores actuales requieren instalación y configuración manual  
Most emulators require setup and configuration

**.suco** lo simplifica todo: como una consola retro en tu PC  
**.suco** simplifies everything: like a retro console on your PC

---

## 💡 Filosofía / Philosophy

- Comodidad ante todo / Convenience first  
- Formato autocontenido / Self-contained format  
- Sin instalación / No installation  
- Plug & Play / Just double-click and play

---

## ⚙️ Consideraciones técnicas / Technical Notes

- Actualmente solo para **x86_64**  
  Currently for **x86_64** only
- Explorando soporte para / Exploring support for:
  - ARMv7  
  - AArch64  
  - RISC-V

### Seguridad / Security

- `.suco` son AppImages  
  `.suco` files are AppImages
- Se pueden desempaquetar (`--appimage-extract`)  
  Can be unpacked (`--appimage-extract`)
- Se pueden analizar con VirusTotal  
  Can be scanned with VirusTotal
- ✅ El código ya es software libre  
  ✅ Code is already open source

---

## 📋 Tareas pendientes / To-do

- [ ] Soporte para arquitecturas ARM, RISC-V, etc.  
      Support for ARM, RISC-V, etc.
- ✅ Hacer el proyecto software libre  
      ✅ Make the project open source
- ✅ Establecer un sistema de nombres y extensión `.suco` oficial  
      ✅ Define naming system and official `.suco` extension
- ✅ Añadir consolas con retroarch
      ✅ Add console roms with retroarch
- [ ] Crear versión para Windows y otros sistemas operativos  
      Create version for Windows and other operating systems

---

## 🕹️ Objetivo a largo plazo / Long-term Goal

Convertir mi colección de MS-DOS de la infancia al formato `.suco`  
Convert my childhood MS-DOS collection into `.suco` format

Explorar otros sistemas / Explore other platforms:

- Microordenadores clásicos / Classic microcomputers  
-  ✅ Consolas retro / Retro consoles  
-  ✅ Juegos que requieran emulador / Emulator-based games

---

## ✍️ Autor / Author

**Felisuco**  
Agosto / August 2025  
Proyecto personal hecho con nostalgia y pasión retro  
A personal project made with nostalgia and retro passion
