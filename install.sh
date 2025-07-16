#!/usr/bin/env bash

# Instalador del Tema Fire Emblem para Qtile
# Este script configura un tema personalizado inspirado en Fire Emblem Fates para el gestor de ventanas Qtile

# === Función para mostrar mensajes en color ===
mostrar_mensaje() {
    local color=$1
    local mensaje=$2

    case $color in
        "verde") echo -e "\e[32m$mensaje\e[0m" ;;
        "rojo") echo -e "\e[31m$mensaje\e[0m" ;;
        "amarillo") echo -e "\e[33m$mensaje\e[0m" ;;
        *) echo "$mensaje" ;;
    esac
}

mostrar_mensaje "verde" "=== Instalación del Tema Fire Emblem para Qtile ==="

# === Verificar si Qtile está instalado ===
if ! command -v qtile &> /dev/null; then
    mostrar_mensaje "rojo" "✗ Qtile no está instalado. Por favor instálalo antes de continuar."
    exit 1
fi

# === Variables ===
FECHA_BACKUP=$(date +"%Y%m%d%H%M%S")
DIR_QTILE="$HOME/.config/qtile"
DIR_BACKUP="${DIR_QTILE}_backup_${FECHA_BACKUP}"

# === Crear copia de seguridad ===
if [ -d "$DIR_QTILE" ]; then
    mostrar_mensaje "amarillo" "Creando copia de seguridad de la configuración actual de Qtile..."
    if cp -r "$DIR_QTILE" "$DIR_BACKUP"; then
        mostrar_mensaje "verde" "✓ Copia de seguridad creada en $DIR_BACKUP"
    else
        mostrar_mensaje "rojo" "✗ Error al crear la copia de seguridad. Continuando de todas formas..."
    fi
fi

# === Crear directorio si no existe ===
mostrar_mensaje "amarillo" "Verificando directorio de configuración de Qtile..."
if mkdir -p "$DIR_QTILE"; then
    mostrar_mensaje "verde" "✓ Directorio listo"
else
    mostrar_mensaje "rojo" "✗ Error al crear el directorio de configuración"
    exit 1
fi

# === Verificar existencia de ./config ===
if [ ! -d "./config" ]; then
    mostrar_mensaje "rojo" "✗ Error: No se encontró el directorio ./config con la configuración Fire Emblem"
    exit 1
fi

# === Copiar configuración Fire Emblem ===
mostrar_mensaje "amarillo" "Copiando archivos del tema Fire Emblem..."
if cp -r ./config/* "$DIR_QTILE/"; then
    mostrar_mensaje "verde" "✓ Archivos copiados correctamente"
else
    mostrar_mensaje "rojo" "✗ Error al copiar los archivos de configuración"
    exit 1
fi

# === Copiar fondo de pantalla ===
if [ ! -f "./fates_wallpaper.jpg" ]; then
    mostrar_mensaje "rojo" "✗ Error: No se encontró el archivo de fondo fates_wallpaper.jpg"
    exit 1
fi

mostrar_mensaje "amarillo" "Copiando fondo de pantalla Fire Emblem..."
if install -Dm644 ./fates_wallpaper.jpg "$DIR_QTILE/wallpaper.jpg"; then
    mostrar_mensaje "verde" "✓ Fondo de pantalla copiado correctamente como wallpaper.jpg"
else
    mostrar_mensaje "rojo" "✗ Error al copiar el fondo de pantalla"
    exit 1
fi

# === Hacer autostart.sh ejecutable ===
if [ -f "$DIR_QTILE/autostart.sh" ]; then
    mostrar_mensaje "amarillo" "Haciendo autostart.sh ejecutable..."
    if chmod +x "$DIR_QTILE/autostart.sh"; then
        mostrar_mensaje "verde" "✓ autostart.sh ahora es ejecutable"
    else
        mostrar_mensaje "rojo" "✗ Error al modificar permisos de autostart.sh"
    fi
else
    mostrar_mensaje "rojo" "✗ No se encontró autostart.sh. Saltando este paso."
fi

# === Instalar dependencias ===
mostrar_mensaje "amarillo" "Instalando dependencias necesarias..."

if command -v pacman &> /dev/null; then
    mostrar_mensaje "verde" "✓ Arch Linux detectado. Instalando paquetes..."

    DEPENDENCIAS=("python-pip" "python-xcffib" "python-cairocffi" "python-cffi" "imagemagick" "feh" "picom")

    if command -v sudo &> /dev/null; then
        if sudo pacman -S --needed ${DEPENDENCIAS[@]}; then
            mostrar_mensaje "verde" "✓ Paquetes instalados correctamente"
        else
            mostrar_mensaje "rojo" "✗ Error al instalar los paquetes"
            mostrar_mensaje "amarillo" "Algunos componentes podrían no funcionar correctamente"
        fi
    else
        mostrar_mensaje "rojo" "✗ No se encontró el comando sudo. Instala manualmente los siguientes paquetes:"
        for pkg in "${DEPENDENCIAS[@]}"; do
            mostrar_mensaje "amarillo" "  - $pkg"
        done
    fi
else
    mostrar_mensaje "rojo" "✗ Sistema no basado en Arch Linux detectado."
    mostrar_mensaje "amarillo" "Instala manualmente los siguientes paquetes:"
    for pkg in "${DEPENDENCIAS[@]}"; do
        mostrar_mensaje "amarillo" "  - $pkg"
    done
fi

# === Instalar dependencia Python: psutil ===
mostrar_mensaje "amarillo" "Instalando dependencia Python: psutil..."

instalar_python_dependencia() {
    local pip_cmd=$1
    local ok=false

    if $pip_cmd install --user psutil; then
        ok=true
    else
        mostrar_mensaje "amarillo" "Intentando instalar sin --user..."
        if $pip_cmd install psutil; then
            ok=true
        fi
    fi

    if [ "$ok" = true ]; then
        mostrar_mensaje "verde" "✓ psutil instalado correctamente"
    else
        mostrar_mensaje "rojo" "✗ Error al instalar psutil"
        mostrar_mensaje "amarillo" "Puedes instalarlo manualmente con: $pip_cmd install --user psutil"
    fi
}

if command -v pip &> /dev/null; then
    instalar_python_dependencia "pip"
elif command -v pip3 &> /dev/null; then
    instalar_python_dependencia "pip3"
else
    mostrar_mensaje "rojo" "✗ pip no está instalado. Instala psutil manualmente."
fi

# === Finalización ===
mostrar_mensaje "verde" "=== Instalación completada ==="
mostrar_mensaje "amarillo" "Cierra sesión o reinicia Qtile (Mod + Ctrl + r) para aplicar el tema Fire Emblem."
mostrar_mensaje "amarillo" "Si encuentras errores, revisa la sección de solución de problemas en el archivo README.md"
