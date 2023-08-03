#!/bin/bash

#% ENVS
CPATH=/home/raspberry/Desktop/backcode

if [ -s /etc/environment ]; then
    echo "Variables de ambiente ya cargadas."
else
    echo "Configurando variables de ambiente."
	echo "CPATH=$CPATH" | sudo tee /etc/environment > /dev/null
	source /etc/environment
	export CPATH=$CPATH
fi




#/*/ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 0 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
#* Valida si esta en el lugar correcto
if [ "$(pwd)" == $CPATH ]; then
	
	#@ Cargar funciones
	echo "Cargando...."
	source $CPATH/functions/fn_check_internet.sh
	source $CPATH/functions/fn_prints.sh
	source $CPATH/functions/fn_reload_vars.sh
	source $CPATH/functions/fn_restart_conection.sh
	source $CPATH/functions/fn_set_wlan_credentials.sh
	source $CPATH/functions/fn_update_var.sh
	echo "Realizado. ✔"
    sleep 3; clear;

else
        echo "Posionate en la ruta correcta antes de continuar. ✘"
        echo "La ruta deberia ser: $CPATH/ ✘"
        sleep 3; exit 0;
fi
#/*/ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃





#% ▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 0 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
#% ▃▃▃▃▃▃▃▃  [ P R E S E N T A C I O N ]  ▃▃▃▃▃▃▃▃▃▃▃▃
#% ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 0"
fn_print_sublevel "VALIDACION DE UBICACION"
fn_print_log "Ubicado correctamente. ✔"
sleep 3; clear;




#@ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 1 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
#@ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 1"
fn_print_sublevel "VALIDACION DE CONFIGURACION INICIAL"
    
# Validar que existe la carpeta y el archivo
if ( grep -q "^FIRST_CONFIG" /etc/environment ); then
    fn_print_log "Configuracion inicial ya realizada. ✔"
    fn_reload_vars
else
    fn_print_log "Iniciando la configuracion inicial."

	sudo mkdir -p /home/raspberry/.config/lxsession/LXDE-pi/
	
        SET_PACKAGE=false
        SET_VNC=false
        SET_KIND_CONECTION=false
        SET_WIFI_OR_LAN=false
        SET_INACTIVITY=false
        SET_HDMI=false
        SET_SCHEDULER=false
        SET_APPS=false
		SET_PAGES_QTY=0
		FIRST_CONFIG="done"


        echo "SET_PACKAGE=$SET_PACKAGE" | sudo tee -a /etc/environment
        echo "SET_VNC=$SET_VNC" | sudo tee -a  /etc/environment
        echo "SET_KIND_CONECTION=$SET_KIND_CONECTION" | sudo tee -a  /etc/environment
        echo "SET_WIFI_OR_LAN=$SET_WIFI_OR_LAN" | sudo tee -a  /etc/environment
        echo "SET_INACTIVITY=$SET_INACTIVITY" | sudo tee -a  /etc/environment
        echo "SET_HDMI=$SET_HDMI" | sudo tee -a  /etc/environment
        echo "SET_APPS=$SET_APPS" | sudo tee -a  /etc/environment
        echo "SET_SCHEDULER=$SET_SCHEDULER" | sudo tee -a  /etc/environment
		echo "SET_PAGES_QTY=$SET_PAGES_QTY" | sudo tee -a  /etc/environment
		echo "FIRST_CONFIG=$FIRST_CONFIG" | sudo tee -a  /etc/environment

        # Cargar las variables al encender
        # echo "source /etc/environment" >> ~/.bashrc

        fn_reload_vars
        fn_print_log "¡Variables de ambiente configuradas! ✔"
fi
sleep 3; clear
#@ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃






#NOTE: ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 2 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 2"
fn_print_sublevel "VALIDACION DE INTERFAZ VNC"

vnc_status_real=$(raspi-config nonint get_vnc)
if [[ $vnc_status_real == "0" ]]; then
	fn_print_log "¡La interfaz VNC ya está activada! ✔"
else
	fn_print_log "No activada. ✘" 
	fn_print_log "Activando interfaz VNC..."
	raspi-config nonint do_vnc 0

	# Reiniciar el servicio VNC para aplicar los cambios
	sudo systemctl restart vncserver-x11-serviced.service
	fn_print_log "¡La interfaz VNC ha sido activada correctamente! ✔"
fi
# Cambiar el estado de la variable de ambiente
fn_update_var "SET_VNC" "true"
fn_reload_vars

sleep 3; clear
#NOTE: ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃A▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃






#+ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 3 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 3"
fn_print_sublevel "VALIDACION DE RED"

# Validar si ya se habia configurado anteriormente la conexion a red
fn_print_log "Revisando estado de la RED..."
if [[ $SET_KIND_CONECTION == false ]]; then
	# Pregunta a usuario como congirar la raspberry si aun no se ha definido
	while [[ $SET_KIND_CONECTION == false ]]; do
		echo "Ingresa el tipo de conexion para este dispositivo: (w:WLAN/l:LAN)"
		read kind_conection
		kind_conection=$(echo "$kind_conection" | tr '[:upper:]' '[:lower:]')

		case $kind_conection in
			"w")
				fn_print_log "Configurando para conexion WLAN. ✔"
				fn_update_var "SET_KIND_CONECTION" "WLAN"
				fn_reload_vars
				break
				;;
			"l")
				fn_print_log "Configurando para conexion LAN ✔"
				fn_update_var "SET_KIND_CONECTION" "LAN"
				fn_reload_vars
				break
				;;
			*)
				echo "¡Ingresa una configuracion valida imbecíl! ✘"
				sleep 3
				clear

                fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
                fn_print_level "NIVEL 4"
                fn_print_sublevel "VALIDACION DE RED"
				;;
		esac
	done	
else
    fn_print_log "Tipo de conexion: $SET_KIND_CONECTION"
fi
sleep 3; clear
#+ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃






#/*/ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 4 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 4.1"
fn_print_sublevel "RECONFIGURACION DE RED ($SET_KIND_CONECTION)"

case $SET_KIND_CONECTION in 
	"WLAN")
		# Validar que existan las contraseñas
		if [ -f "./credentials/wifi.txt" ]; then
		    fn_print_log "Credenciales encontradas. ✔"
		    source ./credentials/wifi.txt

		    fn_print_log "Tus crendenciales son:"
		    fn_print_log $SSID
		    fn_print_log $PWK

			# Validando que la conexion ya haya sido configurada
			if [[ $SET_WIFI_OR_LAN == false ]]; then
				fn_print_log "WIFI no configurado ✘"
				fn_print_log "Configurando conexión"

				# Activar la interfaz
				# Revisar el id de la interfaz bloqueada (casi siempre es 0)
				# sudo rfkill list
				sudo rfkill unblock 0 # desbloqueo la interfaz wlan
				sudo ifconfig wlan0 up # enciendo wlan
				sleep 3

				# Listar redes WiFi disponibles
				fn_print_log "Buscando redes WiFi..."
				sudo iwlist wlan0 scan | grep "ESSID"

				# Configurar archivo de red WiFi
				fn_set_wlan_credentials

				# Reiniciar el servicio de red WiFi
				fn_print_log "Conectando a la red WiFi $SSID..."
				
                sudo ifconfig wlan0 down
				sudo ifconfig wlan0 up

				fn_print_log "Conexión exitosa a la red WiFi $SSID. ✔"
                echo ""
                fn_print_log "¡Su dispositvo se va a reiniciar!"
                fn_print_log "Por favor vuelva abrir el programa de instalación una vez su dispositivo se reinicie"
                
                sleep 3
                sudo reboot
			else
				fn_print_log "WIFI ya configurado. ✔"
				fn_print_log  "Reestableciendo conexión"
				sudo ifconfig wlan0 down
				sudo ifconfig wlan0 up
				fn_print_log "¡Conexion establecida con exito! ✔"
			fi
			# Cambiar el estado de la variable de ambiente
			fn_update_var "SET_WIFI_OR_LAN" "true"
			fn_reload_vars

		else
			fn_print_log "Credenciales no encontradas, Intelo de nuevo. ✘"
			sleep 3
			exit 0
		fi 
		;;

	"LAN")
		# Apaga wifi
		sudo ifconfig wlan0 down
		# Desactivamos la interfaz
		sudo rfkill block 0 # bl oqueo la interfaz wlan
		# Cambiar el estado de la variable de ambiente
		fn_print_log "¡Conexión LAN exitosa! ✔"
		fn_update_var "SET_WIFI_OR_LAN" "true"
		fn_reload_vars
		;;

	*)
		echo "Esta linea no deberia ser impresa, solo esta para mantener la estructura"
		;;
esac
sleep 3; clear
#/*/ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃






#% ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 5 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
#* Valida si esta en el lugar correcto
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 5"
fn_print_sublevel "VALIDACION DEPENDENCIAS"

if [[ $SET_PACKAGE == false ]]; then
	fn_print_log "Instalando paquetes..."

	# Actualizar chromiun
	sudo apt update --yes
	sudo apt install chromium-browser --yes
	# sudo apt install --reinstall chromium --yes 

	# Revision de servicios en raspberry os
	# sudo dpkg --configure -a
	sudo apt-get install wmctrl --yes

	# Librerias extras
	sudo apt install xdotool unclutter sed --yes
	sudo apt-get install jq --yes
	sudo apt update --yes
	sudo apt-get install cec-utils --yes


	fn_print_log "Paquererias instaladas correctamente. ✔"
	fn_update_var "SET_PACKAGE" "true"
else
    fn_print_log "Paquererias ya instaladas. ✔"
fi
sleep 3; clear
#% ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃







#! ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 6 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
# Sin importar los casos, siempre actualiza la hora
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 6"
fn_print_sublevel "CONFIGURANDO FECHA Y HORA"

# Revisar que exista una conexion a internet
if [[ $(fn_check_internet) == false ]]; then
	tries=0
	# En caso de que no exista conexion, ilsntentamos restablecerla n veces
	while [[ $(fn_check_internet) == false && $tries -le 10 ]]; do
		fn_print_log "intento: $tries"
		tries=$((tries + 1))
		fn_restart_conection
	done

	if [[ $tries -ge 10 ]]; then
		fn_print_log "Maximo numero de intentos superados. ✘"
		fn_print_log "Reiniciando dispositivo..."
		# sudo reboot
	fi

else
	#Configuracion de la hora actual cuando ya hay internet
	date_raw=$(curl --insecure --silent "https://worldtimeapi.org/api/timezone/America/Mexico_City" | jq '.datetime')
	date_now=$(echo "$date_raw" | awk -F "T|\\." '{print $1, $2 }' | awk -F '"' '{print $2}')
	formatted_date=$(date -d "$date_now" +"%Y-%m-%d %H:%M:%S")
	sudo date -s "$formatted_date"

    fn_print_log "La fecha y hora han sido actualizadas. ✔"
fi
sleep 3; clear
#! ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃








#* ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 7 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
# Deshabilitar el bloqueo por inactividad
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 7"
fn_print_sublevel "VALIDACION BLOQUEO POR INACTIVIDAD"

if [[ $SET_INACTIVITY == false ]]; then

    # Desactivar suspensión por inactividad
    sudo xset -dpms
    sudo xset s off

    # Desactivar pantalla en blanco
    sudo sed -i 's/^#xserver-command=X/xserver-command=X -s 0 dpms/' /etc/lightdm/lightdm.conf

    # Desactivar suspensión de sistema
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

    # Mostrar un mensaje informativo
    fn_print_log "El bloqueo por inactividad ha sido deshabilitado. ✔"

    # Guardar los cambios en la configuración
    fn_update_var "SET_INACTIVITY" "true"
    # sudo systemctl restart lightdm
else
    fn_print_log "El bloqueo por inactividad ya ha sido configurado. ✔"
fi
sleep 3; clear
#* ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃








#@ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 8 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
# Habilitando configuracion hdmi
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 8"
fn_print_sublevel "VALIDACION DE HDMI"

if [[ $SET_HDMI == false ]]; then
    # Si los servicios no se han configurado, los añade para que se ejecuten cada que se reinicie
    
    fn_print_log "Configurando HDMI."

	sudo bash $CPATH/services/svc_restart_tv.sh
	sudo bash $CPATH/services/svc_clean_cache.sh

    # sudo nano /etc/rc.local | Solo si es necesario que se ejecute antes de que cargue la interfaz
    # sudo sed -i -e "s@^exit 0@REPLACE 1\nREPLACE 2\nREPLACE 3@g" /etc/rc.local
    # sudo sed -i -e "s@^REPLACE 1@sudo bash /home/raspberry/setup/services/svc_restart_tv.sh \&@g" /etc/rc.local
    # sudo sed -i -e "s@^REPLACE 2@sudo bash /home/raspberry/setup/services/svc_clean_cache.sh \&@g" /etc/rc.local
    # sudo sed -i -e "s@^REPLACE 3@exit 0@g" /etc/rc.local
    fn_update_var "SET_HDMI" "true"
    fn_print_log "Configuracion hecha. ✔"

else
    fn_print_log "Configuracion previamente realizada. ✔"
fi
sleep 3; clear
 #@ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃








#% ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 9 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
# Habilitando configuracion hdmi
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 9"
fn_print_sublevel "VALIDACION DE APPS"

if [[ $SET_APPS == false ]]; then
    fn_print_log "Iniciando configuracion de apps."

	#+ Configurar para que se vuelvan auto ejecutables
	sudo chmod +x $CPATH/apps/kiosk.sh
	sudo chmod +x $CPATH/reboot/reboot.sh
	sudo chmod +x $CPATH/services/svc_autotab.sh

	if ( grep -q "reboot.sh" /etc/xdg/lxsession/LXDE-pi/autostart ); then 
    	fn_print_log "APPS ya configuradas correctamenrte. ✔"
	else
		echo "$CPATH/reboot/reboot.sh" | sudo tee -a /etc/xdg/lxsession/LXDE-pi/autostart
		sudo cp /etc/xdg/lxsession/LXDE-pi/autostart /home/raspberry/.config/lxsession/LXDE-pi/
		fn_update_var "SET_APPS" "true"
		fn_print_log "APPS configuradas correctamenrte. ✔"
    fi
else
    fn_print_log "APPS previamente configuradas. ✔"
fi

sleep 3; clear
#% ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃







#+ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃ STEP 10 ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
# Habilitando configuracion scheduler
fn_print_centered_title "RASPBERRY PI SETUP | SMART MANUFACTURING MX "
fn_print_level "NIVEL 10"
fn_print_sublevel "VALIDACION DE SCHEDULER"

if [[ $SET_SCHEDULER == false ]]; then
    cd /home/raspberry/
    echo "0 5 * * * $CPATH/crontab/restart.sh" > task_crontab #Real
	echo "30 14 * * * $CPATH/crontab/restart.sh" >> task_crontab #Real
	# echo "*/10 * * * * $CPATH/crontab/reboot.sh" > task_crontab
    sudo crontab /home/raspberry/task_crontab
    fn_update_var "SET_SCHEDULER" "true"
    
    fn_print_log "Todo configurado correctamente. ✔"
    sleep 5
    exit 
	# Solo se reiniciará en caso de ser la primera configuracion
	sudo rebot
fi
#+ ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
