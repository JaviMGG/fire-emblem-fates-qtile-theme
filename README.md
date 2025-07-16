# Qtile - Tema Fire Emblem Fates

¡Transforma tu experiencia con Qtile y sumérgete en el mundo épico de Fire Emblem Fates! Este proyecto proporciona una configuración de ejemplo, recursos visuales y una guía detallada para aplicar un tema inspirado en la aclamada saga de Nintendo a tu entorno de escritorio.

## ✨ Características

* **Paleta de Colores Épica:** Colores inspirados en los tonos oscuros de la noche y los vibrantes acentos de batalla de Fire Emblem Fates.
* **Fuentes Temáticas:** Recomendaciones y espacio para fuentes que capturen la esencia del juego.
* **Wallpapers de Alta Calidad:** Un fondo de pantalla inicial para sumergirte en el ambiente de Fates.
* **Configuración de Qtile de Ejemplo:** Un archivo `config.py` bien comentado que puedes usar como punto de partida para tu barra, widgets y layouts.

## 🚀 Requisitos

Para poder aplicar este tema, necesitarás:

* **Qtile:** Tu gestor de ventanas Qtile debe estar instalado y funcionando.
* **Python 3.x:** Qtile está escrito en Python, por lo que una versión reciente es necesaria.
* **Dependencias Comunes:** Dependiendo de los widgets que uses en tu `config.py`, podrías necesitar paquetes como `pulseaudio-utils` (para control de volumen), `acpi` (para batería), `feh` o `nitrogen` (para establecer el fondo de pantalla).

## 🖥️ Capturas de Pantalla

¡Mira cómo podría verse tu escritorio!

![Captura de Pantalla del Tema Fire Emblem Fates](screenshots/desktop_fates.png)

*(**Nota:** Reemplaza `desktop_fates.png` en la carpeta `screenshots/` con una captura de tu propia configuración una vez aplicada.)*

## 🛠️ Instalación y Uso

Sigue estos pasos cuidadosamente para aplicar el tema a tu Qtile. ¡Recuerda que este es un punto de partida y la personalización es clave!

1.  **Clonar el Repositorio:**
    ```bash
    git clone [https://github.com/TuUsuarioDeGitHub/qtile-fire-emblem-fates-theme.git](https://github.com/TuUsuarioDeGitHub/qtile-fire-emblem-fates-theme.git)
    ```
    *(**Nota:** Cambia `TuUsuarioDeGitHub` por tu nombre de usuario.)*

2.  **Navegar al Directorio del Proyecto:**
    ```bash
    cd qtile-fire-emblem-fates-theme
    ```

3.  **¡IMPORTANTE! Haz una Copia de Seguridad de tu Configuración Actual:**
    Siempre es una buena práctica guardar tu `config.py` actual antes de hacer cambios.
    ```bash
    cp ~/.config/qtile/config.py ~/.config/qtile/config.py.bak
    ```

4.  **Copiar la Configuración de Qtile de Ejemplo:**
    Copia el archivo `config.py` provisto a tu directorio de configuración de Qtile.
    ```bash
    cp ./config/config.py ~/.config/qtile/config.py
    ```
    **¡MUY IMPORTANTE!** Este `config.py` es un ejemplo. **Debes abrirlo (`~/.config/qtile/config.py`) y revisarlo cuidadosamente.** Ajusta las rutas, atajos de teclado y la configuración de monitor a tu gusto y a las especificaciones de tu sistema.

5.  **Instalar las Fuentes (Opcional, pero Recomendado):**
    Si deseas usar las fuentes personalizadas para el tema (coloca tus archivos `.ttf` o `.otf` en `assets/fonts/`):
    ```bash
    mkdir -p ~/.local/share/fonts/
    cp ./assets/fonts/*.ttf ~/.local/share/fonts/
    cp ./assets/fonts/*.otf ~/.local/share/fonts/
    fc-cache -fv # Actualiza el caché de fuentes para que el sistema las reconozca
    ```
    Luego, asegúrate de que el nombre de la fuente en tu `config.py` coincida exactamente con el nombre de la fuente instalada (ej. `font="Fire Emblem Font Name"`).

6.  **Configurar el Fondo de Pantalla:**
    El `config.py` de ejemplo intenta establecer el fondo de pantalla automáticamente. Asegúrate de que el archivo `fates_wallpaper.jpg` esté en `assets/wallpapers/` y que la ruta en `config.py` sea correcta.
    También puedes establecerlo manualmente con `feh` o `nitrogen`:
    ```bash
    feh --bg-fill ./assets/wallpapers/fates_wallpaper.jpg
    ```
    *(Puedes mover el wallpaper a otra ubicación, como `~/.local/share/backgrounds/`, y actualizar la ruta en `config.py`.)*

7.  **Iconos y Otros Recursos (Opcional):**
    Si planeas usar iconos personalizados, asegúrate de que las rutas a los archivos en `assets/icons/` estén correctamente referenciadas en tu `config.py`.

8.  **Reiniciar Qtile:**
    Una vez que hayas modificado y guardado tu `config.py`, reinicia Qtile para aplicar los cambios. La combinación de teclas por defecto suele ser `Mod + Shift + R`.

## 🎨 Personalización

Este tema es un punto de partida. Te animo a:

* **Experimentar con Colores:** Modifica la paleta de colores en `config.py` para ajustarla aún más a tus preferencias o a un personaje específico de Fire Emblem Fates.
* **Añadir Widgets:** Explora la documentación de Qtile para añadir más widgets a tu barra (clima, noticias, etc.).
* **Crear Diseños de Ventanas (Layouts) Personalizados:** Adapta los layouts a tu flujo de trabajo.
* **Cambiar el Fondo de Pantalla:** Explora más arte de Fire Emblem Fates y úsalo como fondo.

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si tienes ideas para mejorar el tema, nuevas configuraciones o recursos, no dudes en abrir un "issue" o enviar un "pull request". Por favor, revisa `CONTRIBUTING.md` para más detalles.

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Related
Algun proyecto relacionado con Qtile
[Zelda Qtile](https://github.com/JaviMGG/zelda-qtile-theme)

