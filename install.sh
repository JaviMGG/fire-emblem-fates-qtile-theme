#!/bin/bash

# Instalador del Tema Fire Emblem Fates para Qtile
# Este script instala una configuración para el gestor de ventanas Qtile y configura todo automáticamente

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

# Crear directorios adicionales si no existen
show_message "yellow" "Creando directorios adicionales necesarios..."
mkdir -p "$HOME/.local/share/fonts/"
mkdir -p "$HOME/.local/share/backgrounds/"
show_message "green" "✓ Directorios adicionales creados correctamente"

# verifica si el directorio de configuración existe
if [ ! -d "./config" ]; then
    show_message "red" "✗ Error: No se encontró el directorio de configuración ./config"
    exit 1
fi

# Copiar archivos de configuración
show_message "yellow" "Copiando archivos de configuración del tema Fates..."

# Copia todos los archivos de ./config al directorio de configuración
if cp -r ./config/* "$QTILE_CONFIG_DIR/"; then
    show_message "green" "✓ Archivos de configuración copiados correctamente"
else
    show_message "red" "✗ Error al copiar los archivos de configuración"
    exit 1
fi

# Copia picom.conf si existe en ./config y no se copió correctamente
if [ -f ./config/picom.conf ]; then
    cp ./config/picom.conf "$QTILE_CONFIG_DIR/picom.conf"
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

# Asegurar que los archivos de configuración tengan los permisos correctos
show_message "yellow" "Configurando permisos de los archivos..."
chmod 644 "$QTILE_CONFIG_DIR/config.py"
chmod +x "$QTILE_CONFIG_DIR/autostart.sh"
show_message "green" "✓ Permisos de archivos configurados correctamente"

# Verifica si el archivo wallpaper existe
if [ ! -f "./fates_wallpaper.jpg" ]; then
    show_message "red" "✗ Error: El fondo de pantalla fates_wallpaper.jpg no se encuentra"
    exit 1
fi

# Copiar wallpaper
show_message "blue" "Copiando fondo de pantalla F.E.Fates..."
if cp ./fates_wallpaper.jpg "$QTILE_CONFIG_DIR/fates_wallpaper.jpg"; then
    show_message "green" "✓ Fondo de pantalla copiado correctamente"
else
    show_message "red" "✗ Error al copiar el fondo de pantalla"
    exit 1
fi

# Verificar que el script de autostart sea ejecutable
show_message "blue" "Verificando que el script de autostart sea ejecutable..."
if [ -x "$QTILE_CONFIG_DIR/autostart.sh" ]; then
    show_message "green" "✓ El script de autostart es ejecutable"
else
    show_message "yellow" "Haciendo el script de autostart ejecutable..."
    if chmod +x "$QTILE_CONFIG_DIR/autostart.sh"; then
        show_message "green" "✓ El script de autostart ahora es ejecutable"
    else
        show_message "red" "✗ Error haciendo el script de autostart ejecutable"
        exit 1
    fi
fi

# Instalar dependencias del sistema
show_message "blue" "Instalando dependencias..."

# Definir paquetes comunes para todas las distribuciones
COMMON_PACKAGES=("python-pip" "feh" "picom" "dunst" "nm-applet" "pasystray" "cbatticon")

# Detectar la distribución Linux
if command -v pacman &> /dev/null; then
    # Arch Linux y derivados
    show_message "green" "✓ Arch Linux detectado, instalando dependencias..."
    
    # Lista de paquetes específicos para Arch
    PACKAGES=("${COMMON_PACKAGES[@]}" "python-xcffib" "python-cairocffi" "python-cffi" "imagemagick" "network-manager-applet")
    
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
elif command -v apt &> /dev/null; then
    # Debian, Ubuntu y derivados
    show_message "green" "✓ Debian/Ubuntu detectado, instalando dependencias..."
    
    # Lista de paquetes específicos para Debian/Ubuntu
    PACKAGES=("python3-pip" "feh" "picom" "dunst" "network-manager-gnome" "pasystray" "python3-xcffib" "python3-cairocffi" "python3-cffi" "imagemagick")
    
    # Comprobar si el usuario tiene permisos de sudo
    if command -v sudo &> /dev/null; then
        show_message "blue" "Actualizando repositorios..."
        sudo apt update
        show_message "blue" "Instalando paquetes del sistema (puede pedir la contraseña)..."
        if sudo apt install -y ${PACKAGES[@]}; then
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
elif command -v dnf &> /dev/null; then
    # Fedora y derivados
    show_message "green" "✓ Fedora detectado, instalando dependencias..."
    
    # Lista de paquetes específicos para Fedora
    PACKAGES=("python3-pip" "feh" "picom" "dunst" "network-manager-applet" "pasystray" "python3-xcffib" "python3-cairocffi" "python3-cffi" "ImageMagick")
    
    # Comprobar si el usuario tiene permisos de sudo
    if command -v sudo &> /dev/null; then
        show_message "blue" "Instalando paquetes del sistema (puede pedir la contraseña)..."
        if sudo dnf install -y ${PACKAGES[@]}; then
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
    show_message "yellow" "No se pudo detectar la distribución Linux."
    show_message "yellow" "Por favor, instala manualmente los siguientes paquetes:"
    show_message "yellow" "  - python-pip o python3-pip"
    show_message "yellow" "  - python-xcffib o python3-xcffib"
    show_message "yellow" "  - python-cairocffi o python3-cairocffi"
    show_message "yellow" "  - python-cffi o python3-cffi"
    show_message "yellow" "  - imagemagick o ImageMagick"
    show_message "yellow" "  - feh"
    show_message "yellow" "  - picom"
    show_message "yellow" "  - dunst"
    show_message "yellow" "  - nm-applet o network-manager-applet o network-manager-gnome"
    show_message "yellow" "  - pasystray"
    show_message "yellow" "  - cbatticon"
fi

# Instalar dependencias de Python
show_message "yellow" "Intentando instalar dependencias de Python..."

# Lista de dependencias de Python necesarias para Qtile
PYTHON_DEPS=("psutil" "xcffib" "cairocffi" "cffi" "dbus-next")

# Función para instalar dependencias de Python
install_python_deps() {
    local pip_cmd=$1
    local success=true
    
    for dep in "${PYTHON_DEPS[@]}"; do
        show_message "blue" "Instalando $dep..."
        # Intenta instalar con --user primero
        if $pip_cmd install --user $dep; then
            show_message "green" "✓ $dep instalado correctamente"
        else
            show_message "yellow" "Intentando instalar sin --user..."
            if $pip_cmd install $dep; then
                show_message "green" "✓ $dep instalado correctamente"
            else
                show_message "red" "✗ Error al instalar $dep"
                success=false
            fi
        fi
    done
    
    if [ "$success" = true ]; then
        show_message "green" "✓ Todas las dependencias de Python instaladas correctamente"
    else
        show_message "red" "✗ Error al instalar algunas dependencias de Python"
        show_message "yellow" "Puedes instalarlas manualmente con: $pip_cmd install --user [nombre_paquete]"
        show_message "yellow" "O instalar los paquetes del sistema correspondientes"
    fi
}

if command -v pip &> /dev/null; then
    install_python_deps "pip"
elif command -v pip3 &> /dev/null; then
    install_python_deps "pip3"
else
    show_message "red" "✗ pip no encontrado. Por favor instala las dependencias de Python manualmente:"
    for dep in "${PYTHON_DEPS[@]}"; do
        show_message "yellow" "  - $dep (pip install --user $dep)"
    done
    show_message "yellow" "  - O instala los paquetes del sistema correspondientes"
fi

# Verificar la instalación
show_message "yellow" "Verificando la instalación..."

# Verificar que los archivos de configuración existen
if [ -f "$QTILE_CONFIG_DIR/config.py" ] && [ -f "$QTILE_CONFIG_DIR/autostart.sh" ] && [ -f "$QTILE_CONFIG_DIR/fates_wallpaper.jpg" ]; then
    show_message "green" "✓ Archivos de configuración verificados correctamente"
else
    show_message "red" "✗ Algunos archivos de configuración no se han instalado correctamente"
    show_message "yellow" "Por favor, revisa manualmente la instalación"
fi

# Verificar permisos del script de autostart
if [ -x "$QTILE_CONFIG_DIR/autostart.sh" ]; then
    show_message "green" "✓ Permisos del script de autostart verificados correctamente"
else
    show_message "red" "✗ El script de autostart no tiene permisos de ejecución"
    show_message "yellow" "Intentando corregir..."
    chmod +x "$QTILE_CONFIG_DIR/autostart.sh"
fi

# Crear un enlace simbólico al wallpaper en la ubicación estándar
show_message "blue" "Creando enlace simbólico al wallpaper en la ubicación estándar..."
ln -sf "$QTILE_CONFIG_DIR/fates_wallpaper.jpg" "$HOME/.local/share/backgrounds/fates_wallpaper.jpg"

show_message "green" "=== ¡Instalación completa! ==="
show_message "blue" "Por favor, cierra sesión y vuelve a entrar para aplicar el tema Fates de Qtile."
show_message "blue" "Alternativamente, puedes reiniciar Qtile presionando Mod+Control+r"
show_message "yellow" "Si encuentras algún error, revisa la sección 'Solución de Problemas de Instalación' en README.md"
show_message "green" "El tema ha sido optimizado para mejor rendimiento y carga más rápida."
show_message "yellow" "Si experimentas problemas de rendimiento, revisa la sección 'Optimización de Rendimiento' en README.md"
show_message "green" "¡Disfruta de tu nuevo tema Fire Emblem Fates para Qtile!"
