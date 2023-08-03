#!/bin/bash

source /etc/environment
source $CPATH/functions/fn_update_var.sh
source $CPATH/functions/fn_check_internet.sh

SET_PAGES_QTY=$(($(cat -n  $CPATH/apps/apps.txt | wc -l)+1))
fn_update_var "SET_PAGES_QTY" "$SET_PAGES_QTY"

time_next_page=30
counter=0

sleep 7
while true; do
    if (wmctrl -l | grep -q Chromium ); then
        counter=$((counter + 1))
        echo "Navegador abierto"

        if (( counter >= 600 )); then
            echo "Tiempo de actualización" 
                #+ Recargar todas las paginas
                for((i=1;i<=$(($SET_PAGES_QTY*2));i+=1)); do 
                    if [[ $(fn_check_internet) == true ]]; then
                        echo "Hay internet"
                        echo "Actualizando pagina $i "; 
                        xdotool key F5  #* Refresh
                        sleep 10
                        xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab; #* Change next page
                    fi
                done
                echo "Actualizaciones terminadas"
                echo ""
                echo "-------------------------------------------------------"
                counter=0
        else
            #+ Acción cada 30 segundos (presionar Ctrl+Tab)
            xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
            sleep $time_next_page
        fi

    fi
    sleep 1
done 