Configs that cant be stored elsewhere
```bash
#/usr/share/makepkg/source/git.sh
# Add `--single-branch --depth 1` to both instances of `git clone`
```
```css
/*Calibre Styling*/
:root {
  --col: 1;
  --lh: 1;
  --color1: transparent; /*Linen*/
  --color2: #E8DCB6; /*Ivory*/
  
  --line: calc(var(--lh) * 1rem);
  --height: calc(var(--lh) * 2rem);

  columns: auto var(--col);
  line-height: var(--lh);
  overflow-x: auto;
}

body {
  padding: 0 20px;
}

p {
  background: linear-gradient(to bottom, var(--color1), var(--color1) var(--line), var(--color2) var(--line), var(--color2) var(--height));
  background-size: 100% var(--height);
  background-repeat: repeat;
  padding: 0 10px;
  margin: var(--line) 0;
}
```
```bash
git config --global --unset credential.helper
```
```bash
# android go overlay perms
adb shell pm grant <package-name> android.permission.SYSTEM_ALERT_WINDOW
```
```ini
#/etc/pacman.conf
ParallelDownloads = 5
```
```bash
# Thunar custom actions
# These should be in ~/.config/Thunar/uca.xml but it would have to be branch dependent (TODO?)
# True Delete
rm -rf %F
# Copy as Path (X11)
echo %F | xclip
# Copy as Path (WL)
wl-copy %F
# Full Size
du -chs %N | zenity --text-info
baobab %d
# Open Terminal Here (WL)
kitty -d %f --detach
```
