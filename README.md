# .suco — Juegos MS-DOS en formato one-click para Linux  
### .suco — One-click MS-DOS games for Linux

---

## 🚀 ¿Cómo usarlo? / How to use it?

### 🔧 Requisitos / Requirements

- Linux con `bash`, `wget`, `rsync`, y `dosbox` instalados.  
  Linux with `bash`, `wget`, `rsync`, and `dosbox` installed.
- El script `suco.sh` incluido.  
  The `suco.sh` script included.
- El juego (ejecutable y recursos) debe estar en la carpeta `game/`.  
  The game (executable and resources) must be placed in the `game/` folder.

### 🛠️ Instrucciones rápidas / Quick Instructions

```bash
./suco.sh "Nombre del Juego" EJECUTABLE.EXE
./suco.sh "Game Name" EXECUTABLE.EXE
```

Ejemplo / Example:

```bash
./suco.sh "Doom 1" DOOM.EXE
```

📦 El script hace lo siguiente / The script does the following:
1. Verifica dependencias. / Checks dependencies.
2. Crea la estructura AppImage con los archivos del juego. / Creates the AppImage structure with the game files.
3. Descarga herramientas si es necesario. / Downloads tools if needed.
4. Genera un archivo `.suco` (AppImage) que puedes ejecutar con doble clic.  
   Generates a `.suco` (AppImage) file you can launch with double-click.

🗃️ El archivo final estará en / The final file will be in:  
`games/Nombre_del_Juego/Nombre_del_Juego-x86_64.suco`

Este `.suco`:  
This `.suco`:

- Es autocontenido. / Is self-contained.  
- Se abre en pantalla completa. / Opens in fullscreen mode.  
- Soporta guardado externo si el juego lo necesita. / Supports external file saving if needed.  
- Puede desempaquetarse y auditarse. / Can be extracted and audited.

---

## ✅ Características actuales / Current Features

- Modo pantalla completa por defecto  
  Fullscreen mode by default
- Soporta salvado de archivos fuera del AppImage si el juego lo necesita  
  Supports saving files outside the AppImage if the game requires it
- Todo incluido: DOSBox, juego, configuración, extras  
  All-in-one: DOSBox, game, config, and extras
- Un único archivo `.suco` por juego  
  One single `.suco` file per game

---

## 🎯 ¿Por qué este proyecto? / Why this project?

Los emuladores actuales requieren instalación y configuración manual.  
Most emulators require manual setup and configuration.

**.suco** simplifica todo: como una consola retro en tu PC.  
**.suco** simplifies everything: like a retro console on your PC.

---

## 💡 Filosofía / Philosophy

- Comodidad ante todo / Convenience first  
- Formato autocontenido / Self-contained format  
- Sin instalación / No installation  
- Plug & Play / Just double-click and play

---

## 📚 Ejemplo / Example

En *Fate of Atlantis*, incluí manuales y extras originales dentro del `.suco`.  
In *Fate of Atlantis*, I included original manuals and extras inside the `.suco`.

Ayer simplemente hice doble clic y jugué sin configurar nada.  
Yesterday I just double-clicked and played without any setup.

---

## ⚙️ Consideraciones técnicas / Technical Notes

- Actualmente solo para **x86_64**  
  Currently only for **x86_64**
- Explorando soporte para / Exploring support for:
  - ARMv7
  - AArch64
  - RISC-V

### Seguridad / Security

- Los `.suco` son archivos AppImage.  
  `.suco` files are AppImages.
- Se pueden desempaquetar (`--appimage-extract`).  
  They can be unpacked (`--appimage-extract`).
- Se pueden analizar con VirusTotal.  
  Can be scanned with VirusTotal.
- ✅ El código ya es software libre.  
  ✅ The project is already open source.

---

## 📋 Tareas pendientes / To-do

- [ ] Soporte para arquitecturas ARM, RISC-V, etc.  
      Support for ARM, RISC-V, etc.
- ✅ Hacer el proyecto software libre  
      ✅ Make the project open source
- ✅ Establecer un sistema de nombres y extensión `.suco` oficial  
      ✅ Define naming system and official `.suco` extension
- [ ] Crear versión para Windows y otros sistemas operativos  
      Create Windows and cross-platform versions

---

## 🕹️ Objetivo a largo plazo / Long-term Goal

Convertir mi colección de MS-DOS de la infancia al formato `.suco`.  
Convert my childhood MS-DOS collection into `.suco` format.

Explorar otros sistemas:  
Explore other platforms:

- Microordenadores clásicos / Classic microcomputers  
- Consolas retro / Retro consoles  
- Juegos que requieran emulador / Emulator-based games

---

## ✍️ Autor / Author

**Felisuco**  
Agosto / August 2025  
Proyecto personal hecho con nostalgia y pasión retro.  
A personal project made with nostalgia and retro passion.
