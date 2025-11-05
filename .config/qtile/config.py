# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# IMPORTANT INFO IF MIGRATING
# keyboard cannot be changed directly, instead change XKB_DEFAULT_LAYOUT 

#TODO
# - background btop
# - dont focus notifications
# - dont move mouse unless explicitly move focus between windows (not switching workspaces)
# - move from/to floating windows with arrow keys
# - swipe gestures (see github issue 800)
# - fullscreen bar 
# - mouse movement to resize windows
# - cursor size/envs
# - microphone widget
# - chome tab drag and drop
# - force kill

from libqtile import bar, layout, widget, hook, qtile
from qtile_extras import widget as ewidget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification
from libqtile.backend.wayland.inputs import InputConfig
import subprocess
import random
import os

def is_process_running(process_name):
    try:
        subprocess.check_output(["pgrep", "-if", process_name])
        return True
    except subprocess.CalledProcessError:
        return False



mod = "mod4"
imageEditor = "gimp"
fileManager = "thunar"
is_on_wayland = qtile.core.name == "wayland" 
is_on_xfce = is_process_running("xfce")

if is_on_xfce:
    terminal = "xfce4-terminal" #guess_terminal()
    menu = "xfce4-popup-whiskermenu"
elif is_on_wayland:
    terminal = "kitty --single-instance" #guess_terminal()
    menu = "wofi --show drun"
else:
    terminal = "kitty --single-instance" #guess_terminal()
    menu = "rofi -show drun"

# thanks u/eXoRainbow
sticky_windows = []

@lazy.function
def toggle_sticky_windows(qtile, window=None):
    if window is None:
        window = qtile.current_screen.group.current_window
    if window in sticky_windows:
        sticky_windows.remove(window)
    else:
        sticky_windows.append(window)
    return window

@hook.subscribe.setgroup
def move_sticky_windows():
    for window in sticky_windows:
        window.togroup()
    return

@hook.subscribe.client_killed
def remove_sticky_windows(window):
    if window in sticky_windows:
        sticky_windows.remove(window)

# Below is an example how to make Firefox Picture-in-Picture windows automatically sticky.
# I have a German Firefox and don't know if the 'name' is 'Picture-in-Picture'.
# You can check yourself with `xprop` and then lookup at the line `wm_name`.
@hook.subscribe.client_managed
def auto_sticky_windows(window):
    info = window.info()
    if (info['wm_class'] == ['Toolkit', 'firefox']
            and info['name'] == 'Picture-in-Picture'):
        sticky_windows.append(window)



# transparency
transparent_windows = []

@lazy.function
def toggle_transparent_windows(qtile, window=None, transparency=0.5):
    if window is None:
        window = qtile.current_screen.group.current_window
    if window in transparent_windows:
        transparent_windows.remove(window)
        window.set_opacity(1)
    else:
        transparent_windows.append(window)
        window.set_opacity(transparency)
    return window


@hook.subscribe.client_killed
def remove_transparent_windows(window):
    if window in transparent_windows:
        transparent_windows.remove(window)

@hook.subscribe.client_managed
def auto_transparent_windows(window):
    info = window.info()
    auto_transparent = []# ["Picture in picture", "Picture-in-Picture"]
    # info['wm_class'] == ['Toolkit', 'firefox'] and
    if ( info['name'] in auto_transparent):
        transparent_windows.append(window)
        window.set_opacity(0.5)





keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html

    ############################# Window Movement ############
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "h", lazy.layout.move_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.move_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.move_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.move_up(), desc="Move window up"),

    Key([mod, "control"], "h", lazy.layout.flip_left(), desc="Move window to the left"),
    Key([mod, "control"], "l", lazy.layout.flip_right(), desc="Move window to the right"),
    Key([mod, "control"], "j", lazy.layout.flip_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.flip_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.integrate_left(), desc="Move window to the left"),
    Key([mod, "control"], "l", lazy.layout.integrate_right(), desc="Move window to the right"),
    Key([mod, "control"], "j", lazy.layout.integrate_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.integrate_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control", "shift"], "h", lazy.layout.grow_width(-20), desc="Grow window to the left"),
    Key([mod, "control", "shift"], "l", lazy.layout.grow_width(20), desc="Grow window to the right"),
    Key([mod, "control", "shift"], "j", lazy.layout.grow_height(-20), desc="Grow window down"),
    Key([mod, "control", "shift"], "k", lazy.layout.grow_height(20), desc="Grow window up"),
    
    ################# WM STUFF #################
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes [mod, "shift"], "Return",
    Key(
        [mod],
        "v",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "a", lazy.next_layout(), desc="Toggle Fullscreen"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    #Key(
    #    [mod],
    #    "a",
    #    lazy.window.toggle_fullscreen(),
    #    desc="Toggle fullscreen on the focused window",
    #),
    Key([mod], "d", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod], "space", toggle_sticky_windows(), desc="Toggle pin on the focused window"),
    Key([mod], "t", toggle_transparent_windows(transparency=0.5), desc="Toggle opacity on the focused window"),
    Key([mod, "shift"], "t", toggle_transparent_windows(transparency=0.9), desc="Toggle weak opacity on the focused window"),


    Key([mod, "control", "shift"], "o", 
        toggle_sticky_windows(), 
        lazy.window.toggle_floating(),
        lazy.window.toggle_maximize(),
        lazy.window.keep_below(True),
        desc="winwrap"),


    ######## Qtile Stuff #######
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    ########## Shortcuts ##############
    #Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawn(menu), desc="Spawn a command using a prompt widget"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    Key([mod], "e", lazy.spawn(fileManager), desc="Spawn file manager"),

## bindle = XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

]


if not is_on_xfce:
    keys += [
        Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Mute audio"),
        Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%"), desc="Increase Volume"),
        Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -1%"), desc="Decrease Volume"),
    ]

if is_on_wayland:
    keys += [
    Key([], "XF86MonBrightnessUp", lazy.spawn("brillo -A 1"), desc="Increase Brightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brillo -U 1"), desc="Decrease Brightness"),
    Key(["shift"], "XF86MonBrightnessUp", lazy.spawn("brillo -A 5"), desc="Increase Brightness"),
    Key(["shift"], "XF86MonBrightnessDown", lazy.spawn("brillo -U 5"), desc="Decrease Brightness"),
    Key([mod, "shift"], "s", lazy.spawn("grimblast --freeze copy area"), desc="Screenshot area and copy to clipboard"),
    Key([mod, "shift", "control"], "s", lazy.spawn("grimblast --freeze save area", shell=True, env={"XDG_SCREENSHOTS_DIR":"/home/leneth/Pictures/screenshots"}), desc="Screenshot area and save"),
    Key([mod], "c", lazy.spawn("cliphist list | wofi --dmenu | cliphist decode | wl-copy", shell=True), desc="Loads copied clipboard"),

    Key([mod], "Down", lazy.spawn("wlrctl pointer move 0 10"), desc="Moves mouse Down"),
    Key([mod], "Up", lazy.spawn("wlrctl pointer move 0 -10"), desc="Moves mouse Up"),
    Key([mod], "Right", lazy.spawn("wlrctl pointer move 10 0"), desc="Moves mouse Right"),
    Key([mod], "Left", lazy.spawn("wlrctl pointer move -10 0"), desc="Moves mouse left"),

    Key([mod, "shift"], "Down", lazy.spawn("wlrctl pointer move 0 50"), desc="Moves mouse Down"),
    Key([mod, "shift"], "Up", lazy.spawn("wlrctl pointer move 0 -50"), desc="Moves mouse Up"),
    Key([mod, "shift"], "Right", lazy.spawn("wlrctl pointer move 50 0"), desc="Moves mouse Right"),
    Key([mod, "shift"], "Left", lazy.spawn("wlrctl pointer move -50 0"), desc="Moves mouse left"),


    Key([mod], "z", lazy.spawn("sleep 0.1 && wlrctl pointer click left", shell=True), desc="Left Click"),
    Key([mod], "x", lazy.spawn("sleep 0.1 && wlrctl pointer click middle", shell=True), desc="Middle Click"),
    Key([mod], "Menu", lazy.spawn("sleep 0.1 && wlrctl pointer click right", shell=True), desc="Right Click"),
    Key([mod], "f", lazy.spawn("wl-kbptr -c ~/.config/wl-kbptr/config", shell=True), desc="Vimium click"),

]
elif is_on_xfce:
    keys += [
    Key([mod], "c", lazy.spawn("xfce4-popup-clipman", shell=True), desc="Loads copied clipboard"),
]


groups = [Group(i) for i in "1234567890"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_theme = {
    "border_width":2,
    "margin":2,
    "border_focus":"#8224bd",
    "border_normal":"#696969"
}


layouts = [
    #layout.Columns(border_focus_stack=["#8224bd", "#696969"], border_width=2, margin=1),
     #layout.Bsp(**layout_theme),
    layout.Plasma(**layout_theme),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
     #layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
     #layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

bars = dict()

if not is_on_xfce:
    bars["bottom"]=bar.Bar(
            [
                widget.GenPollCommand(cmd="whoami"),
                widget.GenPollCommand(cmd="uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7==\"min\") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0\"d\",h+0\"h\",m+0\"m\"}'", shell=True, fmt=' {}'),
                widget.GroupBox(
                    highlight_method="line",
                    #highlight_color=["#8224bd","#ff4dcf"],
                    highlight_color=["#000000","#8224bd"],
                    this_screen_border="#ff4dcf",
                    this_current_screen_border="#ff4dcf",
                                ),
                widget.Prompt(),
                widget.CurrentLayout(scale=0.7, mode="icon"), #not sure still if i prefer icon or not
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                #widget.TextBox("default config", name="default"),
#                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),


                ewidget.StatusNotifier(),
                #widget.Wlan(),
                widget.PulseVolume(
                    mouse_callbacks={"Button1":lazy.widget["pulsevolume1"].mute},
                    mute_format=""
                ),
                widget.PulseVolume(
                    emoji=True,
                    emoji_list=["","", "", ""],
                    #mouse_callbacks={"Button1":lazy.widget["pulsevolume1"].mute},
                    name="pulsevolume1"
                ), #requires pulsectl-asyncio and pulsectl
                widget.CPU(
                    format="{load_percent}% "
                ),
                widget.Memory(
                    measure_mem="G",
                    format="{MemUsed:.2f}/{MemTotal:.2f} "
                ),
                widget.DF(
                    format="{p} ({uf}{m}|{r:.0f}%) 🖴"
                ),
                widget.ThermalSensor(format="{temp:.0f}{unit}"),
                widget.Backlight(backlight_name='intel_backlight', format="{percent:2.0%} ☼"),
                widget.Battery(
                    #discharge_char="",
                    discharge_char="",
                    #charge_char="",
                    charge_char="",
                    #not_charging_char="",
                    #full_char="",
                    full_char="",
                    #format="{percent:2.0%} {char}",
                    format="{percent:2.0%}",
                    low_background="#f53c3c",
                    low_foreground="#ffffff",
                    low_percentage=0.16,
                    update_interval=3
                ), # TODO replace emojis with decent icon theme
                widget.BatteryIcon(),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                #widget.Systray(),
                widget.Clock(format="%A, %B %d, %Y %H:%M"),
            ],
            23,
            #background=["#FFFFFF","#FFFFFF"],
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        )
else:
    #bars["top"]=bar.Bar([], 25)
    bars["top"]=bar.Gap(size=25)


        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
if is_on_laptop:
    bars["wallpaper"]="/home/leneth/Pictures/wallpapers/ruckenfigur_unsorted/1699525592129581.png"
    bars["wallpaper_mode"]="fill"  #  "fill"
else:
    bars["wallpaper"]=random.choice(
        [os.path.join(r, f) for r, _, files in os.walk("/home/leneth/Pictures/wallpapers") if "/." not in r for f in files if not f.startswith('.')])

    bars["wallpaper_mode"]="stretch"  #  "fill"
screens = [
    Screen(
        **bars
    ),
]

# Drag floating layouts.
#if not is_on_laptop:
mouse = [
    Drag([mod], "Button1", lazy.window.set_position(), start=lazy.window.get_position()),
    Drag([mod, "shift"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="Whisker Menu"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_options="ctrl:nocaps,keypad:pointerkeys", 
        kb_layout="us",
        kb_variant="altgr-intl",
        kb_repeat_delay=220,
        kb_repeat_rate=40
    ),
    "type:touchpad": InputConfig(
        natural_scroll=True,
        tap=True
    )
}

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
#wmname = "compiz"

@hook.subscribe.startup
def tstsrt():
    send_notification("hi", "hiii")

@hook.subscribe.startup_once
def autostart():
    #qtile.spawn("kitty")
    #for item in qtile.windows():
    #    if "kitty-bg" in item["wm_class"]:
    #        
    if is_on_wayland:
        qtile.spawn('udiskie')
        qtile.spawn('nm-applet')
        qtile.spawn('systemctl --user start plasma-polkit-agent')
        qtile.spawn('wl-paste --type text --watch cliphist store')
        qtile.spawn('wl-paste --type image --watch cliphist store')
        qtile.spawn('dunst')
    else:
        qtile.spawn("picom")

