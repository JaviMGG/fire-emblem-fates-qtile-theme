#!/bin/bash

# Instalador del Tema Fire Emblem Fates para Qtile
# Este script instala una configuración para el gestor de ventanas Qtile

# Función para mostrar mensajes en color
show_message() {
    local color=$1
    local message=$2
    
    case $color in
        "green") echo -e "\e[32m$message\e[0m" ;;
        "red") echo -e "\e[31m$message\e[0m" ;;
        "yellow") echo -e "\e[33m$message\e[0m" ;;
        *) echo "$message" ;;
    esac
}

show_message "green" "=== Instalando Tema F.E.Fates para Qtile ==="

# Crear backup de la configuración existente
BACKUP_DATE=$(date +"%Y%m%d%H%M%S")
QTILE_CONFIG_DIR="$HOME/.config/qtile"

if [ -d "$QTILE_CONFIG_DIR" ]; then
    show_message "green" "Creando un backup de la configuración existente de Qtile..."
    if cp -r "$QTILE_CONFIG_DIR" "${QTILE_CONFIG_DIR}_backup_${BACKUP_DATE}"; then
        show_message "green" "✓ Backup creado en ${QTILE_CONFIG_DIR}_backup_${BACKUP_DATE}"
    else
        show_message "red" "✗ Error al crear el backup. Continuando de todas formas..."
    fi
fi

# crea el directorio de configuración si no existe
show_message "yellow" "Verificando directorio de configuración de Qtile..."
if mkdir -p "$QTILE_CONFIG_DIR"; then
    show_message "green" "✓ Directorio de configuración listo"
else
    show_message "red" "✗ Error creando el directorio de configuración de Qtile"
    exit 1
fi

# verifica si el directorio de configuración existe
if [ ! -d "./config" ]; then
    show_message "red" "✗ Error: No se encontró el directorio de configuración ./config"
    exit 1
fi

# Copiar archivos de configuración
show_message "yellow" "Copiando archivos de configuración del tema Fates..."
if cp -r ./config/* "$QTILE_CONFIG_DIR/"; then
    show_message "green" "✓ Archivos de configuración copiados correctamente"
else
    show_message "red" "✗ Error al copiar los archivos de configuración"
    exit 1
fi

# Asegura que picom.conf tenga los permisos correctos e informa sobre las optimizaciones
show_message "yellow" "Configurando picom.conf optimizado para un mejor rendimiento..."
if [ -f "$QTILE_CONFIG_DIR/picom.conf" ]; then
    if chmod 644 "$QTILE_CONFIG_DIR/picom.conf"; then
        show_message "green" "✓ Configuración optimizada de picom instalada correctamente"
        show_message "yellow" "  La configuración ha sido optimizada para un mejor rendimiento"
        show_message "yellow" "  Si prefieres efectos visuales más avanzados, puedes editar $QTILE_CONFIG_DIR/picom.conf"
    else
        show_message "red" "✗ Error al establecer los permisos de picom.conf"
    fi
fi 

# Verifica si el archivo wallpaper existe
if [ ! -f "./fates_wallpaper.jpg" ]; then
    show_message "red" "✗ Error: El fondo de pantalla fates_wallpaper.jpg no se encuentra"
    exit 1
fi

# Copiar wallpaper
show_message "blue" "Copiando fondo de pantalla F.E.Fates..."
if cp ./fates_wallpaper.jpg "$QTILE_CONFIG_DIR/wallpaper.jpg"; then
    show_message "green" "✓ Fondo de pantalla copiado correctamente"
else
    show_message "red" "✗ Error al copiar el fondo de pantalla"
    exit 1
fi

# Hacer el script de autostart ejecutable
show_message "blue" "Haciendo el script de autostart ejecutable..."
if chmod +x "$QTILE_CONFIG_DIR/autostart.sh"; then
    show_message "green" "✓ El script de autostart ahora es ejecutable"
else
    show_message "red" "✗ Error haciendo el script de autostart ejecutable"
    exit 1
fi

# Instalar dependencias del sistema
show_message "blue" "Instalando dependencias..."

# Chequea si estamos en Arch Linux
if command -v pacman &> /dev/null; then
    show_message "green" "✓ Arch Linux detectado, instalando dependencias..."
    
    # Lista de paquetes a instalar
    PACKAGES=("python-pip" "python-xcffib" "python-cairocffi" "python-cffi" "imagemagick" "feh" "picom")
    
    # Comprobar si el usuario tiene permisos de sudo
    if command -v sudo &> /dev/null; then
        show_message "blue" "Instalando paquetes del sistema (puede pedir la contraseña)..."
        if sudo pacman -S --needed ${PACKAGES[@]}; then
            show_message "green" "✓ Paquetes del sistema instalados correctamente"
        else
            show_message "red" "✗ Error al instalar los paquetes del sistema"
            show_message "blue" "Continuando con la instalación."
        fi
    else
        show_message "red" "✗ El comando sudo no está instalado. No se pueden instalar dependencias automáticamente."
        show_message "yellow" "Por favor, instala los siguientes paquetes manualmente:"
        for pkg in "${PACKAGES[@]}"; do
            show_message "yellow" "  - $pkg"
        done
    fi
else
    show_message "red" "✗ Este script está diseñado para Arch Linux."
    show_message "yellow" "Por favor, instala manualmente los siguientes paquetes:"
    show_message "yellow" "  - python-pip"
    show_message "yellow" "  - python-xcffib"
    show_message "yellow" "  - python-cairocffi"
    show_message "yellow" "  - python-cffi"
    show_message "yellow" "  - imagemagick"
    show_message "yellow" "  - feh"
    show_message "yellow" "  - picom"
fi

# Instalar dependencias de Python
show_message "yellow" "Intentando instalar dependencias de Python..."

# Función para instalar dependencias de Python
install_python_deps() {
    local pip_cmd=$1
    local success=false
    
    # Intenta instalar con --user primero
    if $pip_cmd install --user psutil; then
        success=true
    else
        show_message "yellow" "Intentando instalar sin --user..."
        if $pip_cmd install psutil; then
            success=true
        fi
    fi
    
    if [ "$success" = true ]; then
        show_message "green" "✓ Dependencias de Python instaladas correctamente"
    else
        show_message "red" "✗ Error al instalar las dependencias de Python"
        show_message "yellow" "Puedes instalarlas manualmente con: $pip_cmd install --user psutil"
        show_message "yellow" "O instalar el paquete del sistema: sudo pacman -S python-psutil"
    fi
}

if command -v pip &> /dev/null; then
    install_python_deps "pip"
elif command -v pip3 &> /dev/null; then
    install_python_deps "pip3"
else
    show_message "red" "✗ pip no encontrado. Por favor instala las dependencias de Python manualmente:"
    show_message "yellow" "  - psutil (pip install --user psutil)"
    show_message "yellow" "  - O instala el paquete del sistema: sudo pacman -S python-psutil"
fi

# No se necesita configuración de Neofetch

show_message "green" "=== ¡Instalación completa! ==="
show_message "blue" "Por favor, cierra sesión y vuelve a entrar para aplicar el tema Fates de Qtile."
show_message "blue" "Alternativamente, puedes reiniciar Qtile presionando Mod+Control+r"
show_message "blue" "Alternativamente, puedes reiniciar Qtile ejecutando el comando: reboot"
show_message "yellow" "Si encuentras algún error, revisa la sección 'Solución de Problemas de Instalación' en README.md"
show_message "green" "El tema ha sido optimizado para mejor rendimiento y carga más rápida."
show_message "yellow" "Si experimentas problemas de rendimiento, revisa la sección 'Optimización de Rendimiento' en README.md"