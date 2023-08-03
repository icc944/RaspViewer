#!/bin/bash
#+ Este archivo no debe ejecutarse como super usuario

# Básicamente, estos tres comandos configuran el xsession actual para que no borre el protector de pantalla 
# y luego deshabilita el protector de pantalla por completo.
source /etc/environment
source $CPATH/functions/fn_check_internet.sh
source $CPATH/functions/fn_restart_conection.sh


xset s noblank
xset s off
xset -dpms

# Ocultar el cursor
sudo pkill unclutter
unclutter -idle 0.5 -root &



tries=0
while [[ $(fn_check_internet) == false && $tries -le 10 ]]; do
    echo "intento: $tries"
    tries=$((tries + 1))
    fn_restart_conection
done

if [[ $tries -ge 10 ]]; then
    echo "Maximo numero de intentos superados."
    echo "Reiniciando dispositivo..."
    sudo reboot
else
    file_apps=$(cat $CPATH/apps/apps.txt)
    enlaces=()

    for link in $file_apps; do
        enlaces+=("${link}")
    done

    #+ Lanzar apps
    chromium-browser --start-fullscreen --start-maximized --noerrdialogs --disable-infobars  ${enlaces[@]}
fi


