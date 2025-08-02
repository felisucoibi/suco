#!/bin/bash

# suco.sh - Proyecto .suco, one file, one game.
# Copyright (C) 2025 felisuco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# Script to create a professional DOSBox game AppImage.
set -e

# --- CONFIGURATION ---
BASE_SOURCE_DIR="source"
ASSETS_DIR="assets"
ICON_NAME="icon.png"
APPIMAGE_TOOL_NAME="appimagetool-x86_64.AppImage"
LICENSE_FILE_NAME="gpl-3.0.txt"
MAIN_GAMES_DIR="games"
INTERNAL_GAME_DIR="game"
VERBOSE=false

# --- 1. INTERNATIONALIZATION (i18n) ---
if [[ $LANG == es* ]]; then
    # --- Spanish Strings ---
    STR_H1_VALIDATION="### Verificando requisitos..."
    STR_ERR_NO_PARAMS="Error: Faltan parámetros."
    STR_USAGE="Uso: $0 \"Nombre Del Juego\" ComandoDeEjecucion"
    STR_EXAMPLE="Ejemplo: $0 \"Doom 1\" DOOM.EXE"
    STR_ERR_NO_SOURCE="Error: No se encuentra ni la carpeta ni un archivo .zip para '$APP_NAME' en el directorio '$BASE_SOURCE_DIR'."
    STR_INFO_EXPECTED_PATH="Se esperaba encontrar:"
    STR_ERR_EMPTY_FOLDER="Error: La carpeta de origen del juego está vacía."
    STR_INFO_EMPTY_FOLDER_HINT="Por favor, copia los archivos de tu juego dentro para poder continuar."
    STR_ERR_NO_DOSBOX="Error: 'dosbox' no está instalado. Por favor, instálalo con 'sudo apt install dosbox'."
    STR_ERR_NO_WGET="Error: 'wget' no está instalado. Por favor, instálalo con 'sudo apt install wget'."
    STR_ERR_NO_RSYNC="Error: 'rsync' no está instalado. Por favor, instálalo con 'sudo apt install rsync'."
    STR_ERR_NO_UNZIP="Error: 'unzip' no está instalado. Por favor, instálalo con 'sudo apt install unzip'."
    STR_OK_REQS_VERIFIED="✅ Requisitos verificados."
    STR_H2_PREPARE="### Preparando el entorno de compilación..."
    STR_INFO_DOWNLOAD_APPIMAGETOOL="-> Descargando AppImageTool en la carpeta '$ASSETS_DIR'..."
    STR_INFO_DOWNLOAD_LICENSE="-> Descargando texto de la licencia GPLv3 en la carpeta '$ASSETS_DIR'..."
    STR_ERR_DOWNLOAD_FAILED="Error: No se pudieron descargar los recursos necesarios. Comprueba tu conexión a internet y vuelve a intentarlo."
    STR_INFO_CLEANING="-> Limpiando y creando la estructura de carpetas..."
    STR_H3_GENERATE="### Copiando y generando archivos..."
    STR_INFO_FOUND_ZIP="-> Archivo .zip encontrado. Descomprimiendo en una carpeta temporal..."
    STR_INFO_COPYING_FILES="-> Copiando archivos del juego y DOSBox..."
    STR_INFO_CREATING_CONFIG="-> Creando archivo de configuración de DOSBox..."
    STR_INFO_CREATING_APP_RUN="-> Creando AppRun inteligente con lógica de persistencia..."
    STR_INFO_CREATING_DESKTOP="-> Creando archivo .desktop..."
    STR_INFO_ICON_FOUND="-> Icono '$ICON_NAME' encontrado en '$ASSETS_DIR'. Copiando..."
    STR_WARN_NO_ICON="-> Advertencia: No se encontró el icono '$ICON_NAME' en la carpeta '$ASSETS_DIR'. Se creará sin icono."
    STR_INFO_CREATING_METADATA="-> Creando metadatos de licencia (AppStream)..."
    STR_INFO_COPYING_LICENSE="-> Copiando archivo de licencia desde '$ASSETS_DIR'..."
    STR_APP_RUN_SYNC="Sincronizando archivos del juego..."
    STR_APP_RUN_START="Iniciando juego..."
    STR_DESKTOP_COMMENT="Proyecto .suco, one file, one game."
    STR_APPSTREAM_SUMMARY="Proyecto .suco, one file, one game."
    STR_APPSTREAM_DESC="<p>Versión portable de ${APP_NAME}, empaquetada por felisuco para ser ejecutada con DOSBox.</p>"
    STR_H4_PACKAGE="### Generando el archivo AppImage final..."
    STR_INFO_CREATING_OUTPUT_DIR="-> Creando directorio de salida y renombrando el archivo..."
    STR_INFO_CLEANING_TEMP="-> Limpiando directorio temporal de compilación..."
    STR_INFO_CLEANING_UNZIP="-> Limpiando archivos temporales de descompresión..."
    STR_FINAL_SUCCESS="### ¡PROCESO COMPLETADO! ###"
    STR_FINAL_READY="✅ Tu archivo está listo en la carpeta:"
    STR_FINAL_FILENAME="Nombre del archivo:"
    STR_FINAL_LAUNCHING="🚀 Ejecutando el juego para probar..."
else
    # --- English Strings (Default) ---
    STR_H1_VALIDATION="### Checking requirements..."
    STR_ERR_NO_PARAMS="Error: Missing parameters."
    STR_USAGE="Usage: $0 \"Game Name\" GameCommand"
    STR_EXAMPLE="Example: $0 \"Doom 1\" DOOM.EXE"
    STR_ERR_NO_SOURCE="Error: Neither a directory nor a .zip file found for '$APP_NAME' in the '$BASE_SOURCE_DIR' directory."
    STR_INFO_EXPECTED_PATH="Expected to find either:"
    STR_ERR_EMPTY_FOLDER="Error: The game's source folder is empty."
    STR_INFO_EMPTY_FOLDER_HINT="Please copy your game files inside to continue."
    STR_ERR_NO_DOSBOX="Error: 'dosbox' is not installed. Please install it with 'sudo apt install dosbox'."
    STR_ERR_NO_WGET="Error: 'wget' is not installed. Please install it with 'sudo apt install wget'."
    STR_ERR_NO_RSYNC="Error: 'rsync' is not installed. Please install it with 'sudo apt install rsync'."
    STR_ERR_NO_UNZIP="Error: 'unzip' is not installed. Please install it with 'sudo apt install unzip'."
    STR_OK_REQS_VERIFIED="✅ Requirements checked."
    STR_H2_PREPARE="### Preparing build environment..."
    STR_INFO_DOWNLOAD_APPIMAGETOOL="-> Downloading AppImageTool into '$ASSETS_DIR' folder..."
    STR_INFO_DOWNLOAD_LICENSE="-> Downloading GPLv3 license text into '$ASSETS_DIR' folder..."
    STR_ERR_DOWNLOAD_FAILED="Error: Could not download the required assets. Check your internet connection and try again."
    STR_INFO_CLEANING="-> Cleaning up and creating folder structure..."
    STR_H3_GENERATE="### Copying and generating files..."
    STR_INFO_FOUND_ZIP="-> .zip file found. Unzipping to a temporary folder..."
    STR_INFO_COPYING_FILES="-> Copying game and DOSBox files..."
    STR_INFO_CREATING_CONFIG="-> Creating DOSBox configuration file..."
    STR_INFO_CREATING_APP_RUN="-> Creating smart AppRun with persistence logic..."
    STR_INFO_CREATING_DESKTOP="-> Creating .desktop file..."
    STR_INFO_ICON_FOUND="-> Icon '$ICON_NAME' found in '$ASSETS_DIR'. Copying..."
    STR_WARN_NO_ICON="-> Warning: Icon '$ICON_NAME' not found in '$ASSETS_DIR' folder. It will be created without an icon."
    STR_INFO_CREATING_METADATA="-> Creating license metadata (AppStream)..."
    STR_INFO_COPYING_LICENSE="-> Copying license file from '$ASSETS_DIR'..."
    STR_APP_RUN_SYNC="Syncing game files..."
    STR_APP_RUN_START="Starting game..."
    STR_DESKTOP_COMMENT=".suco project, one file, one game."
    STR_APPSTREAM_SUMMARY=".suco project, one file, one game."
    STR_APPSTREAM_DESC="<p>Portable version of ${APP_NAME}, packaged by felisuco to be run with DOSBox.</p>"
    STR_H4_PACKAGE="### Generating final AppImage file..."
    STR_INFO_CREATING_OUTPUT_DIR="-> Creating output directory and renaming the file..."
    STR_INFO_CLEANING_TEMP="-> Cleaning up temporary build directory..."
    STR_INFO_CLEANING_UNZIP="-> Cleaning up temporary unzipped files..."
    STR_FINAL_SUCCESS="### PROCESS COMPLETE! ###"
    STR_FINAL_READY="✅ Your file is ready in the folder:"
    STR_FINAL_FILENAME="Filename:"
    STR_FINAL_LAUNCHING="🚀 Launching the game for a test run..."
fi

# --- OTHER CONFIGURATION VARIABLES ---
APP_NAME="$1"
GAME_EXEC="$2"
GAME_SOURCE_DIR_PATH="${BASE_SOURCE_DIR}/${APP_NAME}"
GAME_SOURCE_ZIP_PATH="${BASE_SOURCE_DIR}/${APP_NAME}.zip"
CONFIG_NAME="dosbox.conf"
APP_DIR="${APP_NAME}.AppDir"
FINAL_OUTPUT_DIR="$MAIN_GAMES_DIR"
APPIMAGE_TOOL_PATH="${ASSETS_DIR}/${APPIMAGE_TOOL_NAME}"
LICENSE_FILE_PATH="${ASSETS_DIR}/${LICENSE_FILE_NAME}"
ICON_PATH="${ASSETS_DIR}/${ICON_NAME}"
EFFECTIVE_SOURCE_PATH=""
CLEANUP_TEMP_DIR=false

# --- COLOR CODES ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- HELPER FUNCTION FOR VERBOSE LOGGING ---
log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "$@"
    fi
}

# --- 2. INPUT VALIDATION ---
if [ -z "$2" ]; then
    echo -e "${RED}${STR_ERR_NO_PARAMS}${NC}"
    echo "${STR_USAGE}"
    echo "${STR_EXAMPLE}"
    exit 1
fi

# --- 3. DEPENDENCY AND SOURCE CHECKS ---
echo -e "${YELLOW}${STR_H1_VALIDATION}${NC}"

if ! command -v dosbox &> /dev/null; then echo -e "${RED}${STR_ERR_NO_DOSBOX}${NC}"; exit 1; fi
if ! command -v wget &> /dev/null; then echo -e "${RED}${STR_ERR_NO_WGET}${NC}"; exit 1; fi
if ! command -v rsync &> /dev/null; then echo -e "${RED}${STR_ERR_NO_RSYNC}${NC}"; exit 1; fi
if ! command -v unzip &> /dev/null; then echo -e "${RED}${STR_ERR_NO_UNZIP}${NC}"; exit 1; fi

if [ -d "$GAME_SOURCE_DIR_PATH" ]; then
    EFFECTIVE_SOURCE_PATH="$GAME_SOURCE_DIR_PATH"
elif [ -f "$GAME_SOURCE_ZIP_PATH" ]; then
    log_verbose "${STR_INFO_FOUND_ZIP}"
    TEMP_UNZIP_DIR=$(mktemp -d)
    unzip -q "$GAME_SOURCE_ZIP_PATH" -d "$TEMP_UNZIP_DIR"
    EFFECTIVE_SOURCE_PATH="$TEMP_UNZIP_DIR"
    CLEANUP_TEMP_DIR=true
else
    echo -e "${RED}${STR_ERR_NO_SOURCE}${NC}"
    echo "${STR_INFO_EXPECTED_PATH}"
    echo " 1) ./${GAME_SOURCE_DIR_PATH}/"
    echo " 2) ./${GAME_SOURCE_ZIP_PATH}"
    exit 1
fi

if [ -z "$(ls -A "$EFFECTIVE_SOURCE_PATH")" ]; then
    echo -e "${RED}${STR_ERR_EMPTY_FOLDER} (${EFFECTIVE_SOURCE_PATH})${NC}"
    echo "${STR_INFO_EMPTY_FOLDER_HINT}"
    if [ "$CLEANUP_TEMP_DIR" = true ]; then rm -rf "$EFFECTIVE_SOURCE_PATH"; fi
    exit 1
fi
echo -e "${GREEN}${STR_OK_REQS_VERIFIED}${NC}"

# --- 4. PREPARE ENVIRONMENT ---
echo -e "${YELLOW}${STR_H2_PREPARE}${NC}"
mkdir -p "$ASSETS_DIR"

if [ ! -f "$APPIMAGE_TOOL_PATH" ]; then
    log_verbose "${STR_INFO_DOWNLOAD_APPIMAGETOOL}"
    wget -O "$APPIMAGE_TOOL_PATH" "https://github.com/AppImage/AppImageKit/releases/latest/download/$APPIMAGE_TOOL_NAME"
fi
chmod +x "$APPIMAGE_TOOL_PATH"

if [ ! -f "$LICENSE_FILE_PATH" ]; then
    log_verbose "${STR_INFO_DOWNLOAD_LICENSE}"
    wget -O "$LICENSE_FILE_PATH" https://www.gnu.org/licenses/gpl-3.0.txt
fi

if [ ! -f "$APPIMAGE_TOOL_PATH" ] || [ ! -f "$LICENSE_FILE_PATH" ]; then
    echo -e "${RED}${STR_ERR_DOWNLOAD_FAILED}${NC}"
    exit 1
fi
log_verbose "${STR_INFO_CLEANING}"
rm -rf "$APP_DIR"
# Se elimina la limpieza del directorio de salida para no borrar toda la carpeta 'games'
# rm -rf "$FINAL_OUTPUT_DIR"
mkdir -p "${APP_DIR}/usr/bin"

# --- 5. COPY AND GENERATE FILES ---
echo -e "${YELLOW}${STR_H3_GENERATE}${NC}"
log_verbose "${STR_INFO_COPYING_FILES}"
mkdir -p "${APP_DIR}/${INTERNAL_GAME_DIR}"
cp -r "$EFFECTIVE_SOURCE_PATH"/* "${APP_DIR}/${INTERNAL_GAME_DIR}/"
cp "$(which dosbox)" "${APP_DIR}/usr/bin/"

log_verbose "${STR_INFO_CREATING_CONFIG}"
cat << EOF > "${APP_DIR}/${CONFIG_NAME}"
[sdl]
fullscreen=true
[autoexec]
EOF

log_verbose "${STR_INFO_CREATING_APP_RUN}"
cat << 'EOF' > "${APP_DIR}/AppRun"
#!/bin/bash
APP_NAME="NOMBRE_APP_AQUI"
GAME_EXEC="EJECUTABLE_JUEGO_AQUI"
INTERNAL_GAME_DIR="NOMBRE_CARPETA_INTERNA_AQUI"
PERSISTENT_DIR="${HOME}/.local/share/${APP_NAME}"
mkdir -p "$PERSISTENT_DIR"
APPIMAGE_DIR="$(dirname "$0")"
echo "MENSAJE_APP_RUN_SYNC"
rsync -a --update "${APPIMAGE_DIR}/${INTERNAL_GAME_DIR}/" "$PERSISTENT_DIR/"
cd "$PERSISTENT_DIR"
echo "MENSAJE_APP_RUN_START"
"${APPIMAGE_DIR}/usr/bin/dosbox" -conf "${APPIMAGE_DIR}/dosbox.conf" -c "mount c ." -c "C:" -c "${GAME_EXEC}" -c "exit"
EOF
sed -i "s/NOMBRE_APP_AQUI/$APP_NAME/g" "${APP_DIR}/AppRun"
sed -i "s/EJECUTABLE_JUEGO_AQUI/$GAME_EXEC/g" "${APP_DIR}/AppRun"
sed -i "s/NOMBRE_CARPETA_INTERNA_AQUI/$INTERNAL_GAME_DIR/g" "${APP_DIR}/AppRun"
sed -i "s/MENSAJE_APP_RUN_SYNC/$STR_APP_RUN_SYNC/g" "${APP_DIR}/AppRun"
sed -i "s/MENSAJE_APP_RUN_START/$STR_APP_RUN_START/g" "${APP_DIR}/AppRun"
chmod +x "${APP_DIR}/AppRun"

log_verbose "${STR_INFO_CREATING_DESKTOP}"
cat << EOF > "${APP_DIR}/${APP_NAME}.desktop"
[Desktop Entry]
Name=$APP_NAME
Comment=${STR_DESKTOP_COMMENT}
Exec=AppRun
Icon=${ICON_NAME%.*}
Type=Application
Categories=Game;
EOF

if [ -f "$ICON_PATH" ]; then
    log_verbose "${STR_INFO_ICON_FOUND}"
    cp "$ICON_PATH" "$APP_DIR/"
else
    echo -e "${YELLOW}${STR_WARN_NO_ICON}${NC}"
fi

log_verbose "${STR_INFO_CREATING_METADATA}"
mkdir -p "${APP_DIR}/usr/share/metainfo"
cat << EOF > "${APP_DIR}/usr/share/metainfo/${APP_NAME}.metainfo.xml"
<?xml version="1.0" encoding="UTF-8"?>
<component type="desktop-application">
  <id>${APP_NAME}.desktop</id>
  <metadata_license>CC0-1.0</metadata_license>
  <project_license>GPL-3.0-or-later</project_license>
  <name>${APP_NAME}</name>
  <summary>${STR_APPSTREAM_SUMMARY}</summary>
  <developer_name>felisuco</developer_name>
  <description>
    ${STR_APPSTREAM_DESC}
  </description>
  <launchable type="desktop-id">${APP_NAME}.desktop</launchable>
  <releases>
    <release version="1.0" date="$(date +%Y-%m-%d)" />
  </releases>
  <content_rating type="oars-1.1" />
</component>
EOF

log_verbose "${STR_INFO_COPYING_LICENSE}"
mkdir -p "${APP_DIR}/usr/share/licenses/${APP_NAME}"
cp "$LICENSE_FILE_PATH" "${APP_DIR}/usr/share/licenses/${APP_NAME}/COPYING"

# --- 6. PACKAGE AND ORGANIZE ---
echo -e "${YELLOW}${STR_H4_PACKAGE}${NC}"
SANITIZED_APP_NAME=$(echo "$APP_NAME" | tr ' ' '_')
SOURCE_APPIMAGE_FILENAME="${SANITIZED_APP_NAME}-x86_64.AppImage"

if [ "$VERBOSE" = true ]; then
    ./"$APPIMAGE_TOOL_PATH" "$APP_DIR"
else
    ./"$APPIMAGE_TOOL_PATH" -s "$APP_DIR" > /dev/null 2>&1
fi

FINAL_FILENAME="${APP_NAME}-x86_64.suco"
log_verbose "${STR_INFO_CREATING_OUTPUT_DIR}"
mkdir -p "$FINAL_OUTPUT_DIR"
mv "$SOURCE_APPIMAGE_FILENAME" "${FINAL_OUTPUT_DIR}/${FINAL_FILENAME}"

log_verbose "${STR_INFO_CLEANING_TEMP}"
rm -rf "$APP_DIR"

if [ "$CLEANUP_TEMP_DIR" = true ]; then
    log_verbose "${STR_INFO_CLEANING_UNZIP}"
    rm -rf "$EFFECTIVE_SOURCE_PATH"
fi

echo -e "\n${GREEN}${STR_FINAL_SUCCESS}${NC}"
echo -e "${STR_FINAL_READY} ${GREEN}${FINAL_OUTPUT_DIR}/${NC}"
echo -e "${STR_FINAL_FILENAME} ${GREEN}${FINAL_FILENAME}${NC}"

# --- 7. EXECUTE FOR TESTING ---
echo ""
echo -e "${YELLOW}${STR_FINAL_LAUNCHING}${NC}"
"${FINAL_OUTPUT_DIR}/${FINAL_FILENAME}"
