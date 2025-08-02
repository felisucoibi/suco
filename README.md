# .suco — Juegos MS-DOS en formato one-click para Linux

**.suco** es un proyecto personal para empaquetar juegos clásicos (inicialmente de MS-DOS pero tal evz también de otros sistemas) en archivos AppImage autoejecutables con algunas mejoras. El objetivo es ofrecer una experiencia "doble clic y a jugar" — sin configuraciones, sin instalaciones, sin complicaciones.

---

## ✅ Características actuales

- Se abre en **modo pantalla completa** por defecto.
- **Guarda partidas** automáticamente si el juego lo soporta fuera del appimage.
- Todo incluido: emulador DOSBox, juego, configuraciones, y si aplica, manuales y extras.
- Un solo archivo `.suco` para cada juego: portátil, simple, directo.

---

## 🎯 ¿Por qué este proyecto?

Existen frontends y emuladores, pero la mayoría requieren:

- Instalar dependencias
- Configurar rutas
- Cargar manualmente el ejecutable

**.suco** nace para evitar todo eso. Quiero poder tener mis juegos favoritos siempre listos para lanzar con un doble clic, como si fuera una consola retro, directamente en mi PC.

---

## 💡 Filosofía de diseño

- **Comodidad ante todo**: jugar debe ser inmediato.
- **Formato autocontenido**: todo va dentro del `.suco` (AppImage).
- **Sin instalación**: portátil y ejecutable desde cualquier ubicación.
- **Experiencia retro simplificada**: como una consola de los 90, pero en 2025.

---

## 📚 Ejemplo práctico

He incluido en el pack de *Indiana Jones and the Fate of Atlantis* todos los manuales y extras originales. Ayer, por primera vez en mucho tiempo, me puse a jugar sin buscar el SCUMMVM, sin configurar nada, sin pensar. Solo hice doble clic y estuve un buen rato disfrutando.

---

## ⚙️ Consideraciones técnicas

- Actualmente soportado en arquitectura **x86_64**.
- Se están explorando opciones para incluir versiones de DOSBox para:
  - ARMv7
  - AArch64
  - RISC-V  
  Esto requerirá pruebas adicionales.

- Aunque el tamaño de cada `.suco` es mayor que un ROM suelto, la comodidad lo compensa.
- Los archivos `.suco` son simplemente AppImages:
  - Se pueden abrir (`--appimage-extract`)
  - Se pueden auditar o analizar con herramientas como VirusTotal
  - Planeo liberar el código para que puedas crear los tuyos

---

## 📦 To-do

- [ ] Incluir soporte para múltiples arquitecturas (ARM, RISC-V, etc.).
- [ ] Hacer el proyecto **software libre**.
- [ ] Establecer una nomenclatura útil para archivar los juegos y oficializar la extensión `.suco`.

---

## 🕹️ Objetivo a largo plazo

Convertir toda mi colección de infancia de MS-DOS a este formato. También estoy valorando la posibilidad de incluir sistemas como:

- Microordenadores clásicos
- Consolas retro
- Otros juegos que requieran emulador

---

## ✍️ Autor

**Felisuco**  
Agosto de 2025  
Proyecto personal, hecho con nostalgia, paciencia y un toque de obsesión retro.
