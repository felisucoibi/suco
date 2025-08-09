#!/bin/bash

# suco.sh - Proyecto .suco, one file, one game.
# Copyright (C) 2025 felisuco
#
# Este programa es software libre: puede redistribuirlo y/o modificarlo
# bajo los términos de la Licencia Pública General de GNU tal como está
# publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia,
# o (a su elección) cualquier versión posterior.
#
# Este programa se distribuye con la esperanza de que sea útil,
# pero SIN NINGUNA GARANTÍA; sin siquiera la garantía implícita de
# COMERCIALIZACIÓN o IDONEIDAD PARA UN PROPÓSITO PARTICULAR. Ver
# la Licencia Pública General de GNU para más detalles.
#
# Debería haber recibido una copia de la Licencia Pública General de GNU
# junto con este programa. Si no, vea <https://www.gnu.org/licenses/>.

# Script para crear un AppImage profesional para juegos de DOSBox.
set -e

# --- CONFIGURATION ---
BASE_SOURCE_DIR="msdos"
ASSETS_DIR="assets"
ICON_NAME="icon.png"
APPIMAGE_TOOL_NAME="appimagetool-x86_64.AppImage"
LICENSE_FILE_NAME="gpl-3.0.txt"
MAIN_GAMES_DIR="games"
INTERNAL_GAME_DIR="game"
VERBOSE=true

# --- NUEVAS CONFIGURACIONES PARA DESCARGAR LIBRERÍAS DE DEBIAN ---
SDL_DEB_PACKAGE="libsdl1.2debian_1.2.15+dfsg2-8_amd64.deb"
SDL_SOUND_DEB_PACKAGE="libsdl-sound1.2_1.0.3-9+b2_amd64.deb"
SDL_NET_DEB_PACKAGE="libsdl-net1.2_1.2.8-6+b2_amd64.deb"
MIKMOD_DEB_PACKAGE="libmikmod3_3.3.11.1-7_amd64.deb"
FLAC_DEB_PACKAGE="libflac12_1.4.2+ds-2_amd64.deb"
DEB_LIBS_DIR="${ASSETS_DIR}/debian-libs"
PRECOMPILED_LIBS_DIR="${ASSETS_DIR}/precompiled-libs"

# --- 1. INTERNATIONALIZATION (i18n) ---
if [[ $LANG == es* ]]; then
    STR_H1_VALIDATION="### Verificando requisitos..."
    STR_ERR_NO_PARAMS="Error: Faltan parámetros."
    STR_USAGE="Uso: $0 \"Nombre Del Juego\" [ComandoDeEjecucion]"
    STR_EXAMPLE="Ejemplo: $0 \"Doom 1\" DOOM.EXE (o sin el segundo parámetro para elegir)"
    STR_ERR_NO_SOURCE="Error: No se encuentra ni la carpeta ni un archivo .zip para '$APP_NAME' en el directorio '$BASE_SOURCE_DIR'."
    STR_INFO_EXPECTED_PATH="Se esperaba encontrar:"
    STR_ERR_EMPTY_FOLDER="Error: La carpeta de origen del juego está vacía."
    STR_INFO_EMPTY_FOLDER_HINT="Por favor, copia los archivos de tu juego dentro para poder continuar."
    STR_ERR_NO_DOSBOX="Error: 'dosbox' o 'dosbox-staging' no está instalado. Por favor, instálalo con 'sudo apt install dosbox' o 'sudo apt install dosbox-staging'."
    STR_ERR_NO_WGET="Error: 'wget' no está instalado. Por favor, instálalo con 'sudo apt install wget'."
    STR_ERR_NO_RSYNC="Error: 'rsync' no está instalado. Por favor, instálalo con 'sudo apt install rsync'."
    STR_ERR_NO_UNZIP="Error: 'unzip' no está instalado. Por favor, instálalo con 'sudo apt install unzip'."
    STR_ERR_NO_AR="Error: 'ar' no está instalado. Por favor, instálalo con 'sudo apt install binutils'."
    STR_OK_REQS_VERIFIED="✅ Requisitos verificados."
    STR_H2_PREPARE="### Preparando el entorno de compilación..."
    STR_INFO_DOWNLOAD_LIBS="-> Descargando y preparando librerías de Debian..."
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
    # NUEVAS CADENAS DE TEXTO PARA LA SELECCIÓN
    STR_INFO_NO_GAME_EXEC="El segundo parámetro (comando de ejecución) no fue proporcionado. Buscando ejecutables de DOS..."
    STR_ERR_NO_EXECUTABLES="Error: No se encontraron ejecutables de DOS (.bat, .com, .exe) en el directorio del juego."
    STR_CHOOSE_EXECUTABLE="Por favor, elige el archivo ejecutable a usar:"
    STR_INVALID_CHOICE="Opción inválida. Por favor, elige un número de la lista."
    STR_INFO_NO_PARAMS_CHOOSE_GAME="No se proporcionó ningún parámetro. Listando juegos disponibles..."
    STR_ERR_NO_GAMES_FOUND="Error: No se encontraron juegos en el directorio '$BASE_SOURCE_DIR'."
    STR_CHOOSE_GAME="Por favor, elige un juego de la lista para continuar:"
    STR_INVALID_GAME_CHOICE="Opción inválida. Por favor, elige un número de la lista de juegos."
else
    STR_H1_VALIDATION="### Checking requirements..."
    STR_ERR_NO_PARAMS="Error: Missing parameters."
    STR_USAGE="Usage: $0 \"Game Name\" [GameCommand]"
    STR_EXAMPLE="Example: $0 \"Doom 1\" DOOM.EXE (or without the second parameter to choose)"
    STR_ERR_NO_SOURCE="Error: Neither a directory nor a .zip file found for '$APP_NAME' in the '$BASE_SOURCE_DIR' directory."
    STR_INFO_EXPECTED_PATH="Expected to find either:"
    STR_ERR_EMPTY_FOLDER="Error: The game's source folder is empty."
    STR_INFO_EMPTY_FOLDER_HINT="Please copy your game files inside to continue."
    STR_ERR_NO_DOSBOX="Error: 'dosbox' or 'dosbox-staging' is not installed. Please install it with 'sudo apt install dosbox' or 'sudo apt install dosbox-staging'."
    STR_ERR_NO_WGET="Error: 'wget' is not installed. Please install it with 'sudo apt install wget'."
    STR_ERR_NO_RSYNC="Error: 'rsync' is not installed. Please install it with 'sudo apt install rsync'."
    STR_ERR_NO_UNZIP="Error: 'unzip' is not installed. Please install it with 'sudo apt install unzip'."
    STR_ERR_NO_AR="Error: 'ar' is not installed. Please install it with 'sudo apt install binutils'."
    STR_OK_REQS_VERIFIED="✅ Requirements checked."
    STR_H2_PREPARE="### Preparing build environment..."
    STR_INFO_DOWNLOAD_LIBS="-> Downloading and preparing Debian libraries..."
    STR_INFO_DOWNLOAD_APPIMAGETOOL="-> Downloading AppImageTool into '$ASSETS_DIR' folder..."
    STR_INFO_DOWNLOAD_LICENSE="-> Downloading GPLv3 license text into '$ASSETS_DIR' folder..."
    STR_ERR_DOWNLOAD_FAILED="Error: Could not download the required assets. Check your internet connection and try again."
    STR_INFO_CLEANING="-> Cleaning up and creating folder structure..."
    STR_H3_GENERATE="### Coping and generating files..."
    STR_INFO_FOUND_ZIP="-> .zip file found. Unzipping to a temporary folder..."
    STR_INFO_COPYING_FILES="-> Copying game files and DOSBox..."
    STR_INFO_CREATING_CONFIG="-> Creating DOSBox configuration file..."
    STR_INFO_CREATING_APP_RUN="-> Creating smart AppRun with persistence logic..."
    STR_INFO_CREATING_DESKTOP="-> Creating .desktop file..."
    STR_INFO_ICON_FOUND="-> Icon '$ICON_NAME' found in '$ASSETS_DIR'. Coping..."
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
    STR_FINAL_LAUNCHING="🚀 Running the game to test..."
    # NUEVAS CADENAS DE TEXTO PARA LA SELECCIÓN
    STR_INFO_NO_GAME_EXEC="The second parameter (execution command) was not provided. Searching for DOS executables..."
    STR_ERR_NO_EXECUTABLES="Error: No DOS executables (.bat, .com, .exe) were found in the game directory."
    STR_CHOOSE_EXECUTABLE="Please choose the executable file to use:"
    STR_INVALID_CHOICE="Invalid choice. Please choose a number from the list."
    STR_INFO_NO_PARAMS_CHOOSE_GAME="No parameters provided. Listing available games..."
    STR_ERR_NO_GAMES_FOUND="Error: No games were found in the directory '$BASE_SOURCE_DIR'."
    STR_CHOOSE_GAME="Please choose a game from the list to continue:"
    STR_INVALID_GAME_CHOICE="Invalid choice. Please choose a number from the list of games."
fi

# --- OTHER CONFIGURATION VARIABLES ---
# Las variables APP_NAME y GAME_EXEC se inicializarán más tarde
APP_NAME=""
GAME_EXEC="$2" # Se sigue tomando el segundo parámetro para la validación posterior
GAME_SOURCE_DIR_PATH=""
GAME_SOURCE_ZIP_PATH=""
CONFIG_NAME="dosbox.conf"
APP_DIR=""
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

# --- FUNCIÓN PARA DESCARGAR Y EXTRAER LAS LIBRERÍAS DE DEBIAN ---
download_and_extract_libs() {
    log_verbose "${STR_INFO_DOWNLOAD_LIBS}"
    mkdir -p "$DEB_LIBS_DIR"
    mkdir -p "$PRECOMPILED_LIBS_DIR"
    local temp_dir=$(mktemp -d)

    SDL_REPO_URL="http://deb.debian.org/debian/pool/main/libs/libsdl1.2"
    if [ ! -f "${DEB_LIBS_DIR}/${SDL_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${SDL_DEB_PACKAGE}" ]; then
        log_verbose "    -> Descargando ${SDL_DEB_PACKAGE}..."
        wget -O "${DEB_LIBS_DIR}/${SDL_DEB_PACKAGE}" "${SDL_REPO_URL}/${SDL_DEB_PACKAGE}"
    fi

    SDL_SOUND_REPO_URL="http://deb.debian.org/debian/pool/main/s/sdl-sound1.2"
    if [ ! -f "${DEB_LIBS_DIR}/${SDL_SOUND_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${SDL_SOUND_DEB_PACKAGE}" ]; then
        log_verbose "    -> Descargando ${SDL_SOUND_DEB_PACKAGE}..."
        wget -O "${DEB_LIBS_DIR}/${SDL_SOUND_DEB_PACKAGE}" "${SDL_SOUND_REPO_URL}/${SDL_SOUND_DEB_PACKAGE}"
    fi
    
    SDL_NET_REPO_URL="http://deb.debian.org/debian/pool/main/s/sdl-net1.2"
    if [ ! -f "${DEB_LIBS_DIR}/${SDL_NET_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${SDL_NET_DEB_PACKAGE}" ]; then
        log_verbose "    -> Descargando ${SDL_NET_DEB_PACKAGE}..."
        wget -O "${DEB_LIBS_DIR}/${SDL_NET_DEB_PACKAGE}" "${SDL_NET_REPO_URL}/${SDL_NET_DEB_PACKAGE}"
    fi

    MIKMOD_REPO_URL="http://deb.debian.org/debian/pool/main/libm/libmikmod"
    if [ ! -f "${DEB_LIBS_DIR}/${MIKMOD_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${MIKMOD_DEB_PACKAGE}" ]; then
        log_verbose "    -> Descargando ${MIKMOD_DEB_PACKAGE}..."
        wget -O "${DEB_LIBS_DIR}/${MIKMOD_DEB_PACKAGE}" "${MIKMOD_REPO_URL}/${MIKMOD_DEB_PACKAGE}"
    fi
    
    FLAC_REPO_URL="http://deb.debian.org/debian/pool/main/f/flac"
    if [ ! -f "${DEB_LIBS_DIR}/${FLAC_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${FLAC_DEB_PACKAGE}" ]; then
        log_verbose "    -> Descargando ${FLAC_DEB_PACKAGE}..."
        wget -O "${DEB_LIBS_DIR}/${FLAC_DEB_PACKAGE}" "${FLAC_REPO_URL}/${FLAC_DEB_PACKAGE}"
    fi
    
    if [ ! -s "${DEB_LIBS_DIR}/${SDL_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${SDL_SOUND_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${SDL_NET_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${MIKMOD_DEB_PACKAGE}" ] || [ ! -s "${DEB_LIBS_DIR}/${FLAC_DEB_PACKAGE}" ]; then
        echo -e "${RED}Error: No se pudieron descargar los paquetes .deb o están vacíos. Comprueba tu conexión a internet y las URLs.${NC}"
        exit 1
    fi

    log_verbose "    -> Extrayendo bibliotecas..."
    
    extract_and_verify() {
        local deb_file="$1"
        local lib_name_pattern="$2"
        local temp_dir_path="$3"
        local precompiled_dir="$4"
        
        ar x "${deb_file}" data.tar.xz --output="$temp_dir_path"
        tar --wildcards -xf "$temp_dir_path/data.tar.xz" --strip-components=4 -C "$precompiled_dir" "./usr/lib/x86_64-linux-gnu/${lib_name_pattern}"
        
        local files_extracted=$(find "$precompiled_dir" -maxdepth 1 -name "${lib_name_pattern}" | wc -l)
        if [ "$files_extracted" -eq 0 ]; then
            echo -e "${RED}Error de extracción: ${lib_name_pattern} binario no extraído correctamente.${NC}"
            exit 1
        fi
    }

    extract_and_verify "${DEB_LIBS_DIR}/${SDL_DEB_PACKAGE}" "libSDL-1.2.so.0*" "$temp_dir" "$PRECOMPILED_LIBS_DIR"
    extract_and_verify "${DEB_LIBS_DIR}/${SDL_SOUND_DEB_PACKAGE}" "libSDL_sound-1.0.so.1*" "$temp_dir" "$PRECOMPILED_LIBS_DIR"
    extract_and_verify "${DEB_LIBS_DIR}/${SDL_NET_DEB_PACKAGE}" "libSDL_net-1.2.so.0*" "$temp_dir" "$PRECOMPILED_LIBS_DIR"
    extract_and_verify "${DEB_LIBS_DIR}/${MIKMOD_DEB_PACKAGE}" "libmikmod.so.3*" "$temp_dir" "$PRECOMPILED_LIBS_DIR"
    extract_and_verify "${DEB_LIBS_DIR}/${FLAC_DEB_PACKAGE}" "libFLAC.so.12*" "$temp_dir" "$PRECOMPILED_LIBS_DIR"

    log_verbose "    -> Las bibliotecas se extrajeron correctamente a '$PRECOMPILED_LIBS_DIR'."
    
    rm -rf "$temp_dir"
}

# --- FUNCIÓN PARA COPIAR DOSBOX Y SUS DEPENDENCIAS ---
copy_dosbox_with_libs() {
    local appdir_bin_path="${APP_DIR}/usr/bin"
    local appdir_lib_path="${APP_DIR}/usr/lib"
    local appdir_locale_path="${APP_DIR}/usr/share/locale"
    local system_locale_path="/usr/share/locale"
    local precompiled_libs_path="${PRECOMPILED_LIBS_DIR}"

    log_verbose "-> Copiando el binario de dosbox..."
    cp "$DOSBOX_COMMAND" "$appdir_bin_path/dosbox"
    chmod +x "${appdir_bin_path}/dosbox"

    log_verbose "-> Copiando librerías manualmente desde la caché de Debian..."
    mkdir -p "$appdir_lib_path"

    cp -P "${precompiled_libs_path}/libSDL-1.2.so.0"* "$appdir_lib_path/"
    cp -P "${precompiled_libs_path}/libSDL_sound-1.0.so.1"* "$appdir_lib_path/"
    cp -P "${precompiled_libs_path}/libSDL_net-1.2.so.0"* "$appdir_lib_path/"
    cp -P "${precompiled_libs_path}/libmikmod.so.3"* "$appdir_lib_path/"
    cp -P "${precompiled_libs_path}/libFLAC.so.12"* "$appdir_lib_path/"

    if [ -d "$system_locale_path" ]; then
        log_verbose "-> Copiando archivos de localización de dosbox..."
        mkdir -p "$appdir_locale_path"
        rsync -a --include='dosbox' --include='*/' --exclude='*' "$system_locale_path/" "$appdir_locale_path/"
    fi
}

# --- 2. INPUT VALIDATION & SOURCE SETUP ---
if [ -z "$1" ]; then
    echo -e "${YELLOW}${STR_INFO_NO_PARAMS_CHOOSE_GAME}${NC}"
    
    mapfile -t games_raw < <(find "$BASE_SOURCE_DIR" -maxdepth 1 -mindepth 1 \( -type d ! -name "$ASSETS_DIR" ! -name "$MAIN_GAMES_DIR" -o -type f -iname "*.zip" \) -printf "%f\n")
    
    declare -a games_clean
    for game in "${games_raw[@]}"; do
        games_clean+=("$(basename -s .zip "$game")")
    done

    if [ ${#games_clean[@]} -eq 0 ]; then
        echo -e "${RED}${STR_ERR_NO_GAMES_FOUND}${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}${STR_CHOOSE_GAME}${NC}"
    select choice in "${games_clean[@]}"; do
        if [ -n "$choice" ]; then
            APP_NAME="$choice"
            echo -e "Has elegido: ${GREEN}${APP_NAME}${NC}"
            break
        else
            echo -e "${RED}${STR_INVALID_GAME_CHOICE}${NC}"
        fi
    done
else
    APP_NAME="$1"
fi
APP_DIR="${APP_NAME}.AppDir"

# Si solo se pasó un parámetro, GAME_EXEC sigue vacío y se pide.
if [ -z "$2" ]; then
    GAME_EXEC=""
fi

# --- 3. DEPENDENCY AND SOURCE CHECKS ---
echo -e "${YELLOW}${STR_H1_VALIDATION}${NC}"

DOSBOX_COMMAND=""

if command -v dosbox &> /dev/null; then
    DOSBOX_COMMAND="$(command -v dosbox)"
elif command -v dosbox-staging &> /dev/null; then
    DOSBOX_COMMAND="$(command -v dosbox-staging)"
else
    echo -e "${RED}${STR_ERR_NO_DOSBOX}${NC}"
    exit 1
fi

if ! command -v wget &> /dev/null; then echo -e "${RED}${STR_ERR_NO_WGET}${NC}"; exit 1; fi
if ! command -v rsync &> /dev/null; then echo -e "${RED}${STR_ERR_NO_RSYNC}${NC}"; exit 1; fi
if ! command -v unzip &> /dev/null; then echo -e "${RED}${STR_ERR_NO_UNZIP}${NC}"; exit 1; fi
if ! command -v ar &> /dev/null; then echo -e "${RED}${STR_ERR_NO_AR}${NC}"; exit 1; fi

# --- IMPORTANTE: Se ha movido este bloque. Ahora se determina la ruta del juego ANTES de buscar ejecutables.
GAME_SOURCE_DIR_PATH="${BASE_SOURCE_DIR}/${APP_NAME}"
GAME_SOURCE_ZIP_PATH="${BASE_SOURCE_DIR}/${APP_NAME}.zip"

if [ -d "$GAME_SOURCE_DIR_PATH" ]; then
    EFFECTIVE_SOURCE_PATH="$GAME_SOURCE_DIR_PATH"
elif [ -f "$GAME_SOURCE_ZIP_PATH" ]; then
    log_verbose "${STR_INFO_FOUND_ZIP}"
    TEMP_UNZIP_DIR=$(mktemp -d)
    unzip -q "$GAME_SOURCE_ZIP_PATH" -d "$TEMP_UNZIP_DIR"
    
    if [ "$(ls -1 "$TEMP_UNZIP_DIR" | wc -l)" -eq 1 ] && [ -d "$TEMP_UNZIP_DIR/$(ls -1 "$TEMP_UNZIP_DIR")" ]; then
        log_verbose "-> La carpeta descomprimida contiene un único subdirectorio. Ajustando la ruta..."
        EFFECTIVE_SOURCE_PATH="$TEMP_UNZIP_DIR/$(ls -1 "$TEMP_UNZIP_DIR")"
    else
        EFFECTIVE_SOURCE_PATH="$TEMP_UNZIP_DIR"
    fi
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

# --- AHORA QUE LA RUTA ESTÁ DEFINIDA, PODEMOS BUSCAR EJECUTABLES ---
if [ -z "$GAME_EXEC" ]; then
    echo -e "${YELLOW}${STR_INFO_NO_GAME_EXEC}${NC}"
    
    # LÍNEA CORREGIDA PARA ENCONTRAR EJECUTABLES
    mapfile -t executables < <(find "$EFFECTIVE_SOURCE_PATH" -maxdepth 1 -type f -printf "%f\n" | grep -iE '\.(exe|com|bat)$')

    if [ ${#executables[@]} -eq 0 ]; then
        echo -e "${RED}${STR_ERR_NO_EXECUTABLES}${NC}"
        if [ "$CLEANUP_TEMP_DIR" = true ]; then rm -rf "$EFFECTIVE_SOURCE_PATH"; fi
        exit 1
    fi

    echo -e "${YELLOW}${STR_CHOOSE_EXECUTABLE}${NC}"
    select choice in "${executables[@]}"; do
        if [ -n "$choice" ]; then
            GAME_EXEC="$choice"
            echo -e "Has elegido: ${GREEN}${GAME_EXEC}${NC}"
            break
        else
            echo -e "${RED}${STR_INVALID_CHOICE}${NC}"
        fi
    done
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

download_and_extract_libs

if [ ! -s "$APPIMAGE_TOOL_PATH" ] || [ ! -s "$LICENSE_FILE_PATH" ]; then
    echo -e "${RED}${STR_ERR_DOWNLOAD_FAILED}${NC}"
    exit 1
fi

log_verbose "${STR_INFO_CLEANING}"
rm -rf "$APP_DIR"
mkdir -p "${APP_DIR}/usr/bin"
mkdir -p "${APP_DIR}/${INTERNAL_GAME_DIR}"

# --- 5. COPY AND GENERATE FILES ---
echo -e "${YELLOW}${STR_H3_GENERATE}${NC}"
log_verbose "${STR_INFO_COPYING_FILES}"
cp -r "$EFFECTIVE_SOURCE_PATH"/* "${APP_DIR}/${INTERNAL_GAME_DIR}/"

copy_dosbox_with_libs

log_verbose "-> Asegurando que los archivos del juego tienen permisos correctos..."
chmod -R u+rw,g+r,o+r "${APP_DIR}/${INTERNAL_GAME_DIR}"

log_verbose "${STR_INFO_CREATING_CONFIG}"
cat << EOF > "${APP_DIR}/${CONFIG_NAME}"
[sdl]
fullscreen=true
fullresolution=desktop
aspect=true
output=opengl
autolock=false
priority=higher,normal
[render]
scaler=normal3x
[autoexec]
@echo off
mount c .
c:
${GAME_EXEC}
exit
EOF

log_verbose "${STR_INFO_CREATING_APP_RUN}"
cat << EOF > "${APP_DIR}/AppRun"
#!/bin/bash
set -e

# Verificación de la extensión .suco al ejecutar el binario
# Se usa la variable de entorno APPIMAGE para obtener el nombre del archivo contenedor.
EXEC_NAME=\$(basename "\$APPIMAGE")
if [[ ! "\$EXEC_NAME" =~ \.suco$ ]]; then
    echo "Error: Este archivo debe ser ejecutado con la extensión '.suco'."
    echo "Su nombre actual es '\$EXEC_NAME'. Por favor, renómbrelo para que termine en '.suco'."
    exit 1
fi

APP_NAME="${APP_NAME}"
GAME_EXEC="${GAME_EXEC}"
INTERNAL_GAME_DIR="${INTERNAL_GAME_DIR}"
PERSISTENT_DIR="\${HOME}/.local/share/${APP_NAME}"
APPIMAGE_DIR="\$(dirname "\$0")"

mkdir -p "\$PERSISTENT_DIR"
echo "${STR_APP_RUN_SYNC}"
rsync -a --update "\${APPIMAGE_DIR}/${INTERNAL_GAME_DIR}/" "\$PERSISTENT_DIR/"
cd "\$PERSISTENT_DIR"
echo "${STR_APP_RUN_START}"

# CORRECCIÓN: Añadimos nuestra ruta al LD_LIBRARY_PATH existente
export LD_LIBRARY_PATH="\${APPIMAGE_DIR}/usr/lib:\${LD_LIBRARY_PATH}"
export DOSBOX_CONFIG="\${APPIMAGE_DIR}/dosbox.conf"

exec "\${APPIMAGE_DIR}/usr/bin/dosbox" -conf "\${APPIMAGE_DIR}/dosbox.conf"
EOF

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

FINAL_FILENAME="${SANITIZED_APP_NAME}-x86_64.suco"
log_verbose "${STR_INFO_CREATING_OUTPUT_DIR}"
mkdir -p "$FINAL_OUTPUT_DIR"
mv "$SOURCE_APPIMAGE_FILENAME" "${FINAL_OUTPUT_DIR}/${FINAL_FILENAME}"

log_verbose "${STR_INFO_CLEANING_TEMP}"
rm -rf "$APP_DIR"
rm -rf "$PRECOMPILED_LIBS_DIR"

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
