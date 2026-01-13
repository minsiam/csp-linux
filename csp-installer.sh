#!/bin/bash

# This script is used to install Clip Studio Paint on a Linux machine.
# made with love by minsiam

usage() {
    cat << EOF
usage: $0 OPTION

OPTIONS:
    [1|2|3|4]     Install CSP major version [1|2|3|4]
    help        Show this message
    uninstall   Uninstall CSP
EOF
}

# Check if the script is run on a supported platform
if [[ "$OSTYPE" != "linux" ]] && [[ "$OSTYPE" != "linux-gnu" ]]; then
    echo "This script is only supported on Linux" 1>&2
    exit 1
fi

export CSP_PATH=/home/$USER/.local/share/csp-linux
export APPLICATIONS_PATH=/home/$USER/.local/share/applications

# Check there is exactly 1 argument
if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

if [ $1 = "help" ]; then
    usage
    exit 0
# Remove CSP_PATH and csprc
elif [ $1 = "uninstall" ]; then
    echo "Removing CSP..."
    
    if [ -d $CSP_PATH ]; then
        rm -rf $CSP_PATH
        if [ $? -ne 0 ]; then
            echo "Failed to remove directory $CSP_PATH" 1>&2
            exit 1
        fi
    fi

    if [ -f /home/$USER/.config/csprc ]; then
        rm /home/$USER/.config/csprc
        if [ $? -ne 0 ]; then
            echo "Failed to remove /home/$USER/.config/csprc" 1>&2
            exit 1
        fi
    fi

    if [ -f $APPLICATIONS_PATH/Clip_Studio_Paint.desktop ]; then
        rm $APPLICATIONS_PATH/Clip_Studio_Paint.desktop $APPLICATIONS_PATH/csp.png
        if [ $? -ne 0 ]; then
            echo "Failed to remove $APPLICATIONS_PATH/Clip_Studio_Paint.desktop" 1>&2
            exit 1
        fi
    fi

    echo "Successfully removed CSP"
    exit 0
else
    CSP_VERSION=
    case $1 in
        1)
            CSP_VERSION=1
            ;;
        2)
            CSP_VERSION=2
            ;;
        3)
            CSP_VERSION=3
            ;;
        4)
            CSP_VERSION=4
            ;;
        *)
            echo "Unknown command or CSP version" 1>&2
            usage
            exit 1
            ;;
    esac

    # Check if wget is installed
    if ! command -v wget &>/dev/null; then
        echo "Please install wget before running this script" 1>&2
        exit 1
    fi

    # Check if pv is installed
    if ! command -v pv &>/dev/null; then
        echo "Please install pv before running this script" 1>&2
        exit 1
    fi

    # Check if winepath is installed
    if ! command -v winepath &>/dev/null; then
        echo "Please install winepath (usually part of wine) or CSP won't be able to open files from your file manager." 1>&2
    fi

    if [ ! -d $CSP_PATH ]; then
        mkdir $CSP_PATH
    fi

    if [ ! -d $APPLICATIONS_PATH ]; then
        mkdir -p $APPLICATIONS_PATH;
    fi

    cp Clip_Studio_Paint.desktop $APPLICATIONS_PATH
    mkdir "${CSP_PATH}/launch"
    cp csp-linux "${CSP_PATH}/launch"
    wget "https://upload.wikimedia.org/wikipedia/en/6/66/Clip_Studio_Paint_app_logo.png" -O "${APPLICATIONS_PATH}/csp.png"

    cd $CSP_PATH

    if [ -d "csp-pfx/pfx/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5" ]; then
        echo "CSP is already installed"
        exit 0
    fi

    # Install Proton
    if [ ! -d GE-Proton10-28 ]; then
        if [ ! -f "GE-Proton10-28.tar.gz" ]; then
            echo "Downloading GE-Proton 10-28..."
            wget -q --show-progress "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-28/GE-Proton10-28.tar.gz"
        fi

        echo "Extracting GE-Proton 10-28..."
        pv "GE-Proton10-28.tar.gz" | tar -xvz >/dev/null
        echo Removing GE-Proton 10-28.tar.gz...
        rm GE-Proton10-28.tar.gz
    fi

    # Install steam-container-runtime
    if [ ! -d steam-container-runtime ]; then
        if [ ! -f "steam-container-runtime.tar.gz" ]; then
            echo "Downloading steamrt..."
            wget -q --show-progress "https://repo.steampowered.com/steamrt-images-sniper/snapshots/0.20240125.75305/steam-container-runtime.tar.gz"
        fi

        pv steam-container-runtime.tar.gz | tar -xvz >/dev/null
        rm steam-container-runtime.tar.gz
    fi

    CSP_SETUP=
    case $CSP_VERSION in
        1)
            if [ ! -f CSP_1132w_setup.exe ]; then
                echo "Downloading CSP_1132w_setup.exe..."
                wget -q --show-progress "https://vd.clipstudio.net/clipcontent/paint/app/1132/CSP_1132w_setup.exe"
            fi
            CSP_SETUP="CSP_1132w_setup.exe"
            ;;
        2)
            if [ ! -f CSP_206w_setup.exe ]; then
                echo "Downloading CSP_206w_setup.exe..."
                wget -q --show-progress "https://vd.clipstudio.net/clipcontent/paint/app/206/CSP_206w_setup.exe"
            fi
            CSP_SETUP="CSP_206w_setup.exe"
            ;;
        3)
            if [ ! -f CSP_314w_setup.exe ]; then
                echo "Downloading CSP_314w_setup.exe..."
                wget -q --show-progress "https://vd.clipstudio.net/clipcontent/paint/app/314/CSP_314w_setup.exe"
            fi
            CSP_SETUP="CSP_314w_setup.exe"
            ;;
        4)
            if [ ! -f CSP_403w_setup.exe ]; then
                echo "Downloading CSP_403w_setup.exe..."
                wget -q --show-progress "https://vd.clipstudio.net/clipcontent/paint/app/403/CSP_403w_setup.exe"
            fi
            CSP_SETUP="CSP_403w_setup.exe"
            ;;
        *)
            echo "Error that should be impossible occurred (failed to properly set CSP_VERSION)" 1>&2
            exit 1
            ;;
    esac

    echo "Installing CSP..."

    mkdir csp-pfx

    export STEAM_COMPAT_CLIENT_INSTALL_PATH="$(realpath steam-container-runtime)"
    export STEAM_COMPAT_DATA_PATH="$(realpath csp-pfx)"

    echo "Setting Windows version to win81..."
    "GE-Proton10-28/proton" run winecfg -v win81
    if [ $? -ne 0 ]; then
        echo "Failed to set Windows version to win81"
        exit 1
    fi
    echo "Starting installer..."
    echo "Go through the process as you usually would then press enter (on terminal) to finish"
    "GE-Proton10-28/proton" run "$CSP_SETUP"

    while true; do
        read -r -n 1 key
        if [[ -z $key ]]; then
            break
        fi
    done

    if [ -f /home/$USER/.config/csprc ]; then
        rm /home/$USER/.config/csprc
    fi

    cat << EOF >>/home/$USER/.config/csprc
[Proton]
PROTON_PATH=$CSP_PATH/GE-Proton10-28
STEAM_COMPAT_DATA_PATH=$STEAM_COMPAT_DATA_PATH
STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_COMPAT_CLIENT_INSTALL_PATH
EOF

    echo "CSP is now installed!"
    echo "Find how to add ${CSP_PATH}/launch to your bash PATH, so you can use csp-linux to start CSP."
    echo "If you use a different shell, like fish or zsh, find instructions for that shell."
    echo "Even without that, some desktop environments like KDE will still find Clip Studio Paint and it'll appear in the program launcher."

    rm "$CSP_SETUP"
fi
