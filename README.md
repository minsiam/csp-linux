# CSP Linux
This is a script to install Clip Studio Paint on Linux using the help of Valve's Proton (fork GE-Proton was used).

## Dependencies
- wget
- pv
- winepath (part of wine, without it CSP won't open .CLIP files from your file manager)

Arch Linux users can install them with `pacman -S wget pv wine`

## Installation (It's that easy!)
```bash
git clone https://github.com/minsiam/csp-linux
cd csp-linux
chmod +x csp-installer.sh
./csp-installer.sh 3
```
To launch CSP without having to return to the `csp-linux` folder every time,
find how to add `~/.local/share/csp-linux/launch` to your bash PATH, so you can
use csp-linux to start CSP.  
If you use a different shell, like fish or zsh, find instructions for that
shell.  
Even without that, some desktop environments like KDE will still find Clip
Studio Paint and it'll appear in the program launcher.  

## Uninstallation
To uninstall CSP, run `./csp-installer.sh uninstall`, or delete `~/.local/share/csp-linux`
& `~/.config/csprc` from your machine manually.

## Extra
If you use KDE, you can add a plugin to show .CLIP thumbnails, follow [this guide.](https://www.reddit.com/r/ClipStudio_on_Linux/comments/1pv8tft/clip_studio_kde_plugins_by_joshua_goins/)  
Besides Fedora users, SUSE users can also use the pre-built pacakges by
downloading them [from here.](https://copr.fedorainfracloud.org/coprs/redstrate/personal/package/clipstudio-kde/)  
Click on the latest Build ID, then on the folder under Chroot Name, and click on the file named `clipstudio-kde-<VERSION>.x86_64.rpm`,

## Made with love ❤️ 
