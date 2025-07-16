#!/bin/bash

# Instalador del Tema Fire Emblem (Fates) para Qtile

# Función para mostrar mensajes de estado en colores
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

mostrar_mensaje "verde" "=== Instalando Tema Fire Emblem para Qtile ==="

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
        mostrar_mensaje "rojo" "✗ Error al crear copia. Continuando..."
    fi
fi

# === Crear directorio de configuración ===
mostrar_mensaje "amarillo" "Verificando directorio de configuración..."
if mkdir -p "$DIR_QTILE"; then
    mostrar_mensaje "verde" "✓ Directorio listo"
else
    mostrar_mensaje "rojo" "✗ Error al crear el directorio"
    exit 1
fi

# === Verificar existencia de ./config ===
if [ ! -d "./config" ]; then
    mostrar_mensaje "rojo" "✗ Error: No se encontró el directorio ./config con la configuración del tema"
    exit 1
fi

# === Copiar configuración del tema ===
mostrar_mensaje "amarillo" "Copiando archivos de configuración..."
if cp -r ./config/* "$DIR_QTILE/"; then
    mostrar_mensaje "verde" "✓ Archivos copiados correctamente"
else
    mostrar_mensaje "rojo" "✗ Error al copiar archivos"
    exit 1
fi

# === Configurar picom.conf si existe ===
mostrar_mensaje "amarillo" "Verificando picom.conf optimizado..."
if [ -f "$DIR_QTILE/picom.conf" ]; then
    if chmod 644 "$DIR_QTILE/picom.conf"; then
        mostrar_mensaje "verde" "✓ picom.conf optimizado instalado"
        mostrar_mensaje "amarillo" "  Puedes editarlo para efectos visuales adicionales en: $DIR_QTILE/picom.conf"
    else
        mostrar_mensaje "rojo" "✗ Error al establecer permisos en picom.conf"
    fi
fi

# === Verificar y copiar wallpaper ===
if [ ! -f "./fates_wallpaper.jpg" ]; then
    mostrar_mensaje "rojo" "✗ Error: No se encontró el archivo fates_wallpaper.jpg"
    exit 1
fi

mostrar_mensaje "amarillo" "Copiando fondo de pantalla Fire Emblem..."
if cp ./fates_wallpaper.jpg "$DIR_QTILE/wallpaper.jpg"; then
    mostrar_mensaje "verde" "✓ Fondo de pantalla copiado correctamente"
else
    mostrar_mensaje "rojo" "✗ Error al copiar el fondo de pantalla"
    exit 1
fi

# === Hacer autostart.sh ejecutable ===
mostrar_mensaje "amarillo" "Haciendo autostart.sh ejecutable..."
if chmod +x "$DIR_QTILE/autostart.sh"; then
    mostrar_mensaje "verde" "✓ autostart.sh ahora es ejecutable"
else
    mostrar_mensaje "rojo" "✗ Error al establecer permisos en autostart.sh"
    exit 1
fi

# === Instalar dependencias del sistema ===
mostrar_mensaje "amarillo" "Instalando dependencias necesarias..."

if command -v pacman &> /dev/null; then
    mostrar_mensaje "verde" "✓ Arch Linux detectado"
    DEPENDENCIAS=("python-pip" "python-xcffib" "python-cairocffi" "python-cffi" "imagemagick" "feh" "picom")

    if command -v sudo &> /dev/null; then
        mostrar_mensaje "amarillo" "Instalando paquetes (puede requerir contraseña)..."
        if sudo pacman -S --needed ${DEPENDENCIAS[@]}; then
            mostrar_mensaje "verde" "✓ Dependencias instaladas correctamente"
        else
            mostrar_mensaje "rojo" "✗ Error al instalar paquetes"
            mostrar_mensaje "amarillo" "  Algunos componentes podrían no funcionar correctamente"
        fi
    else
        mostrar_mensaje "rojo" "✗ sudo no encontrado. Instala manualmente:"
        for pkg in "${DEPENDENCIAS[@]}"; do
            mostrar_mensaje "amarillo" "  - $pkg"
        done
    fi
else
    mostrar_mensaje "rojo" "✗ No se detectó Arch Linux"
    mostrar_mensaje "amarillo" "Instala manualmente los siguientes paquetes:"
    for pkg in "python-pip" "python-xcffib" "python-cairocffi" "python-cffi" "imagemagick" "feh" "picom"; do
        mostrar_mensaje "amarillo" "  - $pkg"
    done
fi

# === Instalar psutil con pip/pip3 ===
mostrar_mensaje "amarillo" "Instalando dependencia Python: psutil..."

instalar_python_psutil() {
    local pip_cmd=$1
    if $pip_cmd install --user psutil; then
        mostrar_mensaje "verde" "✓ psutil instalado con $pip_cmd --user"
    elif $pip_cmd install psutil; then
        mostrar_mensaje "verde" "✓ psutil instalado con $pip_cmd"
    else
        mostrar_mensaje "rojo" "✗ No se pudo instalar psutil con $pip_cmd"
        mostrar_mensaje "amarillo" "  Puedes instalarlo manualmente con: $pip_cmd install --user psutil"
        mostrar_mensaje "amarillo" "  O usando pacman: sudo pacman -S python-psutil"
    fi
}

if command -v pip &> /dev/null; then
    instalar_python_psutil "pip"
elif command -v pip3 &> /dev/null; then
    instalar_python_psutil "pip3"
else
    mostrar_mensaje "rojo" "✗ pip no está disponible. Instala psutil manualmente."
fi

# === Final ===
mostrar_mensaje "verde" "=== Instalación completa ==="
mostrar_mensaje "amarillo" "Puedes cerrar sesión o reiniciar Qtile con Mod + Ctrl + r"
mostrar_mensaje "amarillo" "Si tienes problemas, revisa la sección de resolución de problemas en el README.md"
mostrar_mensaje "verde" "¡Disfruta del Tema Fire Emblem optimizado para rendimiento y estética!"
