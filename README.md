# .suco — Juegos MS-DOS en formato one-click para Linux  
### .suco — One-click MS-DOS games for Linux

**.suco** es un proyecto personal para empaquetar juegos clásicos (inicialmente de MS-DOS) en archivos AppImage autoejecutables. El objetivo es ofrecer una experiencia "doble clic y a jugar" — sin configuraciones, sin instalaciones, sin complicaciones.

**.suco** is a personal project to package classic games (starting with MS-DOS) into self-contained AppImage executables. The goal is a true *double-click-and-play* experience — no setup, no installation, no hassle.

---

## ✅ Características actuales / Current Features

- Se abre en **modo pantalla completa** por defecto  
  Launches in **fullscreen mode** by default
- **Soporta salvado de archivos si el juego lo precisa, fuera del AppImage**  
  **Supports external file saving if the game requires it, outside the AppImage**
- Todo incluido: DOSBox, juego, configuración, y extras  
  All-in-one: DOSBox, game files, config, and extras
- Un único archivo `.suco` por juego  
  Single `.suco` file per game (AppImage format)

---

## 🎯 ¿Por qué este proyecto? / Why this project?

Los frontends y emuladores existentes requieren instalación, configuración y búsqueda manual del ejecutable.  
Existing frontends and emulators require installation, setup, and manual launching.

**.suco** simplifica todo. Como una consola retro en tu PC.  
**.suco** makes it simple. Like a retro console experience on your PC.

---

## 💡 Filosofía / Philosophy

- **Comodidad ante todo** / **Convenience first**
- **Formato autocontenido** / **Self-contained format**
- **Sin instalación** / **No installation needed**
- **Listo para jugar** / **Plug & play feeling**

---

## 📚 Ejemplo / Example

En *Fate of Atlantis*, incluí manuales y extras originales dentro del `.suco`.  
Ayer, sin configurar nada, simplemente hice doble clic y estuve jugando.  
In *Fate of Atlantis*, I included original manuals and PDFs inside the `.suco`.  
Yesterday, without any setup, I just double-clicked and played.

---

## ⚙️ Consideraciones técnicas / Technical Notes

- Soporta arquitectura **x86_64** por ahora  
  Currently supports **x86_64**
- Explorando soporte para / Exploring support for:
  - ARMv7
  - AArch64
  - RISC-V
- Archivos `.suco` = AppImage:  
  `.suco` files are AppImages:
  - Se pueden desempaquetar (`--appimage-extract`)  
    Can be extracted with `--appimage-extract`
  - Se pueden analizar con VirusTotal  
    Can be scanned with VirusTotal
  - Planeo liberar el código  
    Planning to open-source the project

---

## 📋 To-do

- [ ] Incluir soporte para múltiples arquitecturas (ARM, RISC-V, etc.)  
      Add support for multiple architectures (ARM, RISC-V, etc.)
- [ ] Hacer el proyecto **software libre**  
      Make the project **open source**
- [ ] Establecer una nomenclatura útil y extensión oficial `.suco`  
      Establish a useful naming system and `.suco` as an official extension
- [ ] Crear una versión para **Windows y otros sistemas operativos**  
      Create a version for **Windows and other operating systems**

---

## 🕹️ Objetivo a largo plazo / Long-term Goal

Convertir mi colección de MS-DOS de la infancia al formato `.suco`.  
También explorar otros sistemas:  
Convert my childhood MS-DOS game collection into `.suco` format.  
Also considering other platforms:

- Microordenadores clásicos / Classic microcomputers  
- Consolas retro / Retro consoles  
- Juegos que requieran emulador / Emulator-based games

---

## ✍️ Autor / Author

**Felisuco**  
Agosto / August 2025  
Proyecto personal hecho con nostalgia y pasión retro.  
A personal project built with nostalgia and retro passion.
