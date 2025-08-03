#!/bin/bash
set -e

# --- CONFIGURACIÓN ---
ASSETS_DIR="assets"
ICON_NAME="icon.png"
APPIMAGE_TOOL_NAME="appimagetool-x86_64.AppImage"
LICENSE_FILE_NAME="gpl-3.0.txt"
MAIN_GAMES_DIR="games"
INTERNAL_ROM_DIR="rom"
VERBOSE=false
RETROARCH_APPIMAGE_NAME="RetroArch-Linux-x86_64.AppImage"
RETROARCH_EXTRACTED_DIR="squashfs-root"
CONFIG_NAME="retroarch.cfg"

# --- i18n español ---
if [[ $LANG == es* ]]; then
    STR_H1_VALIDATION="### Verificando requisitos..."
    STR_ERR_NO_PARAMS="Error: Faltan parámetros."
    STR_USAGE="Uso: $0 \"nombre_del_archivo.rom\""
    STR_EXAMPLE="Ejemplo: $0 \"Little Nemo.nes\""
    STR_ERR_ROM_NOT_FOUND="Error: El archivo ROM no se encuentra en la carpeta de su sistema."
    STR_INFO_EXPECTED_PATH="Se esperaba encontrarlo en:"
    STR_ERR_UNSUPPORTED_EXT="Error: La extensión de archivo no es compatible. Extensiones soportadas: .md, .gen, .sms, .nes, .sfc, .smc, .gb, .gbc, .gba, .n64, .z64, .v64, .bin, .cue, .iso, .chd"
    STR_ERR_NO_LOCAL_RETROARCH="Error: No se encuentra '${RETROARCH_APPIMAGE_NAME}' en '$ASSETS_DIR'."
    STR_WARN_NO_ROMS_FOLDER="Advertencia: La carpeta de ROMs '$BASE_ROMS_DIR' no se encuentra."
    STR_INFO_CREATING_ROMS_FOLDER="-> Creando la carpeta '$BASE_ROMS_DIR'..."
    STR_INFO_ROMS_FOLDER_CREATED="Carpeta creada. Organiza tus ROMs dentro y vuelve a ejecutar."
    STR_OK_REQS_VERIFIED="✅ Requisitos verificados."
    STR_H2_PREPARE="### Preparando el entorno de compilación..."
    STR_INFO_EXTRACTING_RETROARCH="-> Extrayendo RetroArch AppImage..."
    STR_INFO_DOWNLOAD_APPIMAGETOOL="-> Descargando AppImageTool..."
    STR_INFO_DOWNLOAD_LICENSE="-> Descargando licencia GPLv3..."
    STR_INFO_DOWNLOAD_CORE="-> Descargando Core (\$CORE_SO_NAME)..."
    STR_INFO_UNZIPPING_CORE="-> Descomprimiendo core..."
    STR_INFO_CLEANING="-> Borrando archivos anteriores..."
    STR_H3_GENERATE="### Copiando y generando archivos..."
    STR_INFO_CREATING_CONFIG="-> Escribiendo configuración personalizada..."
    STR_INFO_CREATING_APP_RUN="-> Creando AppRun..."
    STR_INFO_CREATING_DESKTOP="-> Creando archivo .desktop..."
    STR_WARN_NO_ICON="-> Advertencia: No se encontró el icono."
    STR_INFO_COPYING_LICENSE="-> Copiando licencia..."
    STR_H4_PACKAGE="### Generando el archivo .suco final..."
    STR_FINAL_SUCCESS="### ¡PROCESO COMPLETADO! ###"
    STR_FINAL_READY="✅ Tu archivo está listo en la carpeta:"
    STR_FINAL_FILENAME="Nombre del archivo:"
    STR_FINAL_LAUNCHING="🚀 Ejecutando el juego para probar..."
else
    echo "Configura LANG=es_ES.UTF-8 para mensajes en español"
    exit 1
fi

# --- COLORES Y LOG ---
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
log_verbose() { if [ "$VERBOSE" = true ]; then echo -e "$@"; fi; }

# --- PARÁMETROS ---
if [ -z "$1" ]; then
    echo -e "${RED}${STR_ERR_NO_PARAMS}${NC}"; echo "${STR_USAGE}"; echo "${STR_EXAMPLE}"; exit 1
fi

ROM_FILENAME="$1"
APP_NAME=$(basename "$ROM_FILENAME" .${ROM_FILENAME##*.})
ROM_EXTENSION_LOWER=$(echo "${ROM_FILENAME##*.}" | tr '[:upper:]' '[:lower:]')

case "$ROM_EXTENSION_LOWER" in
    md|gen) SYSTEM="megadrive"; CORE_ZIP_NAME="genesis_plus_gx_libretro.so.zip"; CORE_SO_NAME="genesis_plus_gx_libretro.so" ;;
    sms) SYSTEM="mastersystem"; CORE_ZIP_NAME="genesis_plus_gx_libretro.so.zip"; CORE_SO_NAME="genesis_plus_gx_libretro.so" ;;
    nes) SYSTEM="nes"; CORE_ZIP_NAME="fceumm_libretro.so.zip"; CORE_SO_NAME="fceumm_libretro.so" ;;
    sfc|smc) SYSTEM="snes"; CORE_ZIP_NAME="snes9x_libretro.so.zip"; CORE_SO_NAME="snes9x_libretro.so" ;;
    gb|gbc) SYSTEM="gb"; CORE_ZIP_NAME="gambatte_libretro.so.zip"; CORE_SO_NAME="gambatte_libretro.so" ;;
    gba) SYSTEM="gba"; CORE_ZIP_NAME="mgba_libretro.so.zip"; CORE_SO_NAME="mgba_libretro.so" ;;
    n64|z64|v64) SYSTEM="n64"; CORE_ZIP_NAME="mupen64plus_next_libretro.so.zip"; CORE_SO_NAME="mupen64plus_next_libretro.so" ;;
    bin|cue|iso|chd) SYSTEM="psx"; CORE_ZIP_NAME="pcsx_rearmed_libretro.so.zip"; CORE_SO_NAME="pcsx_rearmed_libretro.so" ;;
    *) echo -e "${RED}${STR_ERR_UNSUPPORTED_EXT}${NC}"; exit 1 ;;
esac

BASE_ROMS_DIR="roms"
ROM_PATH="${BASE_ROMS_DIR}/${SYSTEM}/${ROM_FILENAME}"
APP_DIR="${APP_NAME}.AppDir"
APPIMAGE_TOOL_PATH="${ASSETS_DIR}/${APPIMAGE_TOOL_NAME}"
LICENSE_FILE_PATH="${ASSETS_DIR}/${LICENSE_FILE_NAME}"
ICON_PATH="${ASSETS_DIR}/${ICON_NAME}"
RETROARCH_PATH="${ASSETS_DIR}/${RETROARCH_APPIMAGE_NAME}"
RETROARCH_EXTRACTED_PATH="${ASSETS_DIR}/${RETROARCH_EXTRACTED_DIR}"
CORE_ZIP_PATH="${ASSETS_DIR}/${CORE_ZIP_NAME}"
CORE_SO_PATH="${ASSETS_DIR}/${CORE_SO_NAME}"

# --- VERIFICACIONES ---
echo -e "${YELLOW}${STR_H1_VALIDATION}${NC}"
if [ ! -d "$BASE_ROMS_DIR" ]; then
    echo -e "${YELLOW}${STR_WARN_NO_ROMS_FOLDER}${NC}"; mkdir -p "${BASE_ROMS_DIR}/${SYSTEM}"; echo -e "${GREEN}${STR_INFO_ROMS_FOLDER_CREATED}${NC}"; exit 0
fi
if [ ! -f "$ROM_PATH" ]; then echo -e "${RED}${STR_ERR_ROM_NOT_FOUND}${NC}"; echo "${STR_INFO_EXPECTED_PATH} ./${ROM_PATH}"; exit 1; fi
for cmd in wget unzip rsync; do
    if ! command -v "$cmd" &> /dev/null; then echo -e "${RED}Falta: '$cmd'${NC}"; exit 1; fi
done
echo -e "${GREEN}${STR_OK_REQS_VERIFIED}${NC}"

# --- PREPARACIÓN ---
echo -e "${YELLOW}${STR_H2_PREPARE}${NC}"
mkdir -p "$ASSETS_DIR"
[ ! -f "$APPIMAGE_TOOL_PATH" ] && log_verbose "$STR_INFO_DOWNLOAD_APPIMAGETOOL" && wget -O "$APPIMAGE_TOOL_PATH" "https://github.com/AppImage/AppImageKit/releases/latest/download/$APPIMAGE_TOOL_NAME"
chmod +x "$APPIMAGE_TOOL_PATH"
[ ! -f "$LICENSE_FILE_PATH" ] && log_verbose "$STR_INFO_DOWNLOAD_LICENSE" && wget -O "$LICENSE_FILE_PATH" https://www.gnu.org/licenses/gpl-3.0.txt

if [ ! -d "$RETROARCH_EXTRACTED_PATH" ]; then
    log_verbose "$STR_INFO_EXTRACTING_RETROARCH"
    [ ! -f "$RETROARCH_PATH" ] && echo -e "${RED}${STR_ERR_NO_LOCAL_RETROARCH}${NC}" && exit 1
    chmod +x "$RETROARCH_PATH"
    (cd "$ASSETS_DIR" && ./"$RETROARCH_APPIMAGE_NAME" --appimage-extract > /dev/null 2>&1)
fi

if [ ! -f "$CORE_SO_PATH" ]; then
    log_verbose "$STR_INFO_DOWNLOAD_CORE"
    wget -O "$CORE_ZIP_PATH" "https://buildbot.libretro.com/nightly/linux/x86_64/latest/$CORE_ZIP_NAME"
    log_verbose "$STR_INFO_UNZIPPING_CORE"
    unzip -o "$CORE_ZIP_PATH" -d "$ASSETS_DIR"; rm "$CORE_ZIP_PATH"
fi

# --- GENERACIÓN ---
echo -e "${YELLOW}${STR_H3_GENERATE}${NC}"
rm -rf "$APP_DIR" "${MAIN_GAMES_DIR:?}/${APP_NAME}"
mkdir -p "$APP_DIR"
rsync -a --exclude=AppRun "$RETROARCH_EXTRACTED_PATH"/ "$APP_DIR/"
mkdir -p "$APP_DIR/$INTERNAL_ROM_DIR" "$APP_DIR/usr/lib/libretro"
cp "$ROM_PATH" "$APP_DIR/$INTERNAL_ROM_DIR/"
cp "$CORE_SO_PATH" "$APP_DIR/usr/lib/libretro/"

log_verbose "$STR_INFO_CREATING_CONFIG"
cat << EOF > "$APP_DIR/$CONFIG_NAME"
config_save_on_exit = "false"
video_driver = "gl"
video_fullscreen = "true"
video_windowed_fullscreen = "false"
video_fullscreen_x = 1920
video_fullscreen_y = 1080
video_force_aspect = "true"
aspect_ratio_index = "0"
menu_driver = "rgui"
EOF

log_verbose "$STR_INFO_CREATING_APP_RUN"
cat << EOF > "$APP_DIR/AppRun"
#!/bin/bash
set -e
APPDIR="\$(dirname "\$(readlink -f "\$0")")"
export LD_LIBRARY_PATH="\$APPDIR/usr/lib:\$LD_LIBRARY_PATH"
export RETROARCH_ASSETS_DIR="\$APPDIR/usr/share/retroarch/assets"
PERSISTENT_DIR="\${HOME}/.local/share/${APP_NAME}"
mkdir -p "\$PERSISTENT_DIR"
[ ! -f "\$PERSISTENT_DIR/${CONFIG_NAME}" ] && cp "\$APPDIR/${CONFIG_NAME}" "\$PERSISTENT_DIR/${CONFIG_NAME}"

cd "\$APPDIR"
exec ./usr/bin/retroarch \\
    --config "\$PERSISTENT_DIR/${CONFIG_NAME}" \\
    --appendconfig "\$APP_DIR/${CONFIG_NAME}" \\
    --set-shader "" \\
    --fullscreen \\
    -L "./usr/lib/libretro/${CORE_SO_NAME}" \\
    "./${INTERNAL_ROM_DIR}/${ROM_FILENAME}"
EOF
chmod +x "$APP_DIR/AppRun"

log_verbose "$STR_INFO_CREATING_DESKTOP"
cat << EOF > "$APP_DIR/${APP_NAME}.desktop"
[Desktop Entry]
Name=$APP_NAME
Comment=Juego clásico de consola
Exec=AppRun
Icon=${ICON_NAME%.*}
Type=Application
Categories=Game;
EOF

[ -f "$ICON_PATH" ] && cp "$ICON_PATH" "$APP_DIR/" || echo -e "${YELLOW}${STR_WARN_NO_ICON}${NC}"

mkdir -p "$APP_DIR/usr/share/licenses/${APP_NAME}"
cp "$LICENSE_FILE_PATH" "$APP_DIR/usr/share/licenses/${APP_NAME}/COPYING"

# --- COMPILACIÓN ---
echo -e "${YELLOW}${STR_H4_PACKAGE}${NC}"
# El nombre del archivo se sanitiza para la AppImage para evitar el problema de FUSE
SANITIZED_APP_NAME=$(echo "$APP_NAME" | tr -d '()' | tr ' ' '_')
SOURCE_APPIMAGE_FILENAME="${SANITIZED_APP_NAME}.AppImage"
[ "$VERBOSE" = true ] && ./"$APPIMAGE_TOOL_PATH" "$APP_DIR" "$SOURCE_APPIMAGE_FILENAME" || ./"$APPIMAGE_TOOL_PATH" -s "$APP_DIR" "$SOURCE_APPIMAGE_FILENAME" > /dev/null 2>&1

# El nombre final es el deseado, sin el sufijo de arquitectura
FINAL_FILENAME="${APP_NAME}.suco"
mkdir -p "$MAIN_GAMES_DIR"
mv "$SOURCE_APPIMAGE_FILENAME" "${MAIN_GAMES_DIR}/${FINAL_FILENAME}"
rm -rf "$APP_DIR"

echo -e "\n${GREEN}${STR_FINAL_SUCCESS}${NC}"
echo -e "${STR_FINAL_READY} ${GREEN}${MAIN_GAMES_DIR}/${NC}"
echo -e "${STR_FINAL_FILENAME} ${GREEN}${FINAL_FILENAME}${NC}"
echo -e "\n${YELLOW}${STR_FINAL_LAUNCHING}${NC}"

# Se crea un nombre temporal para la prueba y se elimina después
TEST_FILENAME_SAFE="temp_game_test.suco"
cp "${MAIN_GAMES_DIR}/${FINAL_FILENAME}" "${MAIN_GAMES_DIR}/${TEST_FILENAME_SAFE}"
"${MAIN_GAMES_DIR}/${TEST_FILENAME_SAFE}"
rm "${MAIN_GAMES_DIR}/${TEST_FILENAME_SAFE}"
