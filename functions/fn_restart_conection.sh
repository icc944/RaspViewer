fn_restart_conection(){
	echo "Restableciendo servicio $SET_KIND_CONECTION"
	case $SET_KIND_CONECTION in 

		"WLAN")
			sudo rfkill unblock 0 # desbloqueo la interfaz wlan
			sudo ifconfig wlan0 down # apaga wlan
			sudo ifconfig wlan0 up # enciendo wlan
		;;

		"LAN")
			# Apaga wifi
			sudo ifconfig wlan0 down
			# Desactivamos la interfaz
			sudo rfkill block 0 # bloqueo la interfaz wlan
		;;

		*)
			echo ""
		;;
	esac
	
	# Reiniciamos el servicio 
	sudo systemctl restart networking.service
	sleep 3

	echo "Completado."
}
