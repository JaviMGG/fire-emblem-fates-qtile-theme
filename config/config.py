# Configuración de Qtile con temática de Fire Emblem Fates
# Una configuración de Qtile con tema de Fire Emblem Fates, inspirada en los colores y elementos del juego.

import os
import subprocess
from typing import List

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Atajos de teclado
mod = "mod4"  # Tecla Super
terminal = guess_terminal()

# Paleta de colores de Fire Emblem Fates
colors = {
    "Dragon azul": "#164E73",               # Azul del Dragón
    "Escarlata de Hoshido": "#C1121F",      #(Sangre y estandartes de Hoshido).
    "Índigo de Nohr": "#601869",            #(Armaduras y noche perpetua de Nohr).
    "Azur de Azura":"#4EADCD",              #(El vestido y la conexión acuática de Azura).
    "Plateado de Corrin": "#C0D5DF",        #(Su cabello y armadura neutral).
    "Cyan de Takumi": "#00FFFF" ,           #(El color de su arco y habilidades de viento).
    "black": "#000000",
    "white": "#FFFFFF",
    "transparent": "#00000000",
}

# Atajos de teclado
keys = [
    # Cambiar entre ventanas
    Key([mod], "h", lazy.layout.left(), desc="Mover el foco a la izquierda"),
    Key([mod], "l", lazy.layout.right(), desc="Mover el foco a la derecha"),
    Key([mod], "j", lazy.layout.down(), desc="Mover el foco hacia abajo"),
    Key([mod], "k", lazy.layout.up(), desc="Mover el foco hacia arriba"),
    Key([mod], "space", lazy.layout.next(), desc="Mover el foco a otra ventana"),

    # Mover ventanas
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Mover ventana a la izquierda"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Mover ventana a la derecha"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Mover ventana hacia abajo"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Mover ventana hacia arriba"),

    # Redimensionar ventanas
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Agrandar ventana a la izquierda"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Agrandar ventana a la derecha"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Agrandar ventana hacia abajo"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Agrandar ventana hacia arriba"),
    Key([mod], "n", lazy.layout.normalize(), desc="Restablecer tamaño de ventanas"),

    # Alternar entre diseños
    Key([mod], "Tab", lazy.next_layout(), desc="Alternar entre diseños"),
    Key([mod], "w", lazy.window.kill(), desc="Cerrar ventana enfocada"),

    # Gestión de Qtile
    Key([mod, "control"], "r", lazy.restart(), desc="Reiniciar Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Apagar Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Ejecutar comando desde el prompt"),

    # Lanzar aplicaciones
    Key([mod], "Return", lazy.spawn(terminal), desc="Abrir terminal"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Abrir Firefox"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Abrir gestor de archivos"),
]

# Espacios de trabajo (Grupos)
groups = [
    Group("1", "1"),
    Group("2", "2"),
    Group("3", "3"),
    Group("4", "4"),
    Group("5", "5"),
    Group("6", "6"),
    Group("7", "7"),
    Group("8", "8"),
    Group("9", "9"),
]

# Añadir atajos para los grupos
for i in groups:
    keys.extend([
        # mod1 + número de grupo = cambiar a ese grupo
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Cambiar al grupo {}".format(i.name)),

        # mod1 + shift + número de grupo = mover ventana enfocada y cambiar a ese grupo
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Mover ventana enfocada y cambiar al grupo {}".format(i.name)),
    ])

# Diseños
layout_theme = {
    "border_width": 2,                              # Ancho del borde de las ventanas
    "margin": 6,                                    # Margen entre las ventanas
    "border_focus": colors["Plateado de Corrin"],          # Azul del Dragón para el borde enfocado
    "border_normal": colors["Dragon azul"],  # Plateado de Corrin para el borde normal
    "border_radius": 16,                            # Bordes redondeados como se pidió
}

layouts = [ 
    layout.Columns(**layout_theme), 
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Floating(**layout_theme),
]

# Widgets
widget_defaults = dict(
    font="sans",                        # Fuente sans-serif
    fontsize=12,                        # Tamaño de fuente
    padding=3,                          # Espaciado entre widgets
    background=colors["transparent"],   # Fondo transparente por defecto
)
extension_defaults = widget_defaults.copy()

# Definir colores con opacidad
bar_bg = "#1A1A1ACC"     # Negro con 80% de opacidad para la barra
widget_bg = "#214CCE5C"  # Gris oscuro con 87% de opacidad para los widgets

screens = [
    Screen( 
        top=bar.Bar( 
            [
                widget.CurrentLayout( 
                    foreground=colors["Escarlata de Hoshido"], 
                    background=widget_bg,  # Fondo más opaco para los widgets
                    padding=5,
                ),
                widget.GroupBox(
                    active=colors["Escarlata de Hoshido"],
                    inactive=colors["Cyan de Takumi"],
                    highlight_method="line",
                    highlight_color=[colors["Índigo de Nohr"], colors["Azur de Azura"]],
                    this_current_screen_border=colors["Cyan de Takumi"],
                    background=widget_bg,  # Fondo más opaco para los widgets
                    padding=3,
                    borderwidth=2,
                    rounded=True,          # Bordes redondeados para GroupBox
                ),
                widget.Prompt(                                  # Área para ingresar comandos
                    foreground=colors["Escarlata de Hoshido"],   # Color del texto
                    background=widget_bg,                       # Fondo del widget

                ),
                widget.WindowName(                              # Nombre de la ventana actual
                    foreground=colors["Índigo de Nohr"],     # Color del texto
                    background=bar_bg,                          # Fondo de la barra (no del widget)
                ),
                widget.Chord(                                   # Muestra atajos de teclado personalizados (modos "chord")
                    chords_colors={                             # Colores para modos específicos
                        "launch": (colors["Índigo de Nohr"], colors["transparent"]), # Modo de lanzamiento
                    },
                    name_transform=lambda name: name.upper(),   # Convierte nombres a mayúsculas
                    background=widget_bg,                       # Fondo del widget
                ),
                widget.Systray(                                 # Iconos del sistema (red, volumen, etc.)
                    background=widget_bg,                       # Fondo del widget
                    padding=5,                                  # Espacio interno
                ),
              
                widget.Clock(  # Reloj
                    format="%Y-%m-%d %a %I:%M %p",              # Formato de fecha/hora
                    foreground=colors["Escarlata de Hoshido"],  # Color del texto
                    background=widget_bg,                       # Fondo del widget
                    padding=5,                                  # Espacio interno
                ),
                widget.QuickExit(                               # Botón para salir de Qtile
                    foreground=colors["Azur de Azura"],         # Color del texto
                    default_text="[Salir]",                     # Texto del botón
                    background=widget_bg,                       # Fondo del widget
                    padding=5,                                  # Espacio interno
                ),
            ],
            25,                          # Altura de la barra
            opacity=1,                # Barra más opaca
            background=bar_bg,           # Fondo con opacidad para la barra
            margin=[4, 15, 0, 15],         # Margen [arriba, derecha, abajo, izquierda]
            border_width=[2, 2, 2, 2],   # Borde solo en la parte inferior
            border_color=[colors["Plateado de Corrin"], colors["Plateado de Corrin"], colors["Plateado de Corrin"], colors["Plateado de Corrin"]],
            rounded=True,                # Bordes redondeados para la barra
        ),
    ),
]

# Atajos de ratón
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# Otros ajustes
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Ejecuta la utilidad `xprop` para ver la clase wm y el nombre de un cliente X.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),     # gitk
        Match(wm_class="makebranch"),       # gitk
        Match(wm_class="maketag"),          # gitk
        Match(wm_class="ssh-askpass"),      # ssh-askpass
        Match(title="branchdialog"),        # gitk
        Match(title="pinentry"),            # Entrada de contraseña GPG
    ],
    **layout_theme
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# XXX: ¡Gasp! Aquí estamos mintiendo. De hecho, nadie realmente usa o le importa este
# string excepto los toolkits de UI de Java; puedes ver varias discusiones en las
# listas de correo, issues de GitHub y otra documentación de WM que sugieren establecer
# este string si tu aplicación Java no funciona correctamente. Así que simplemente mentimos
# y decimos que somos uno funcional por defecto.
# Elegimos LG3D para maximizar la ironía: es un WM 3D no-reparenting escrito en
# Java que casualmente está en la whitelist de Java.
wmname = "LG3D"

# Autostart
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])
