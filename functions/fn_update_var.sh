fn_update_var(){
    local ruta_vars="/etc/environment"
	local var_name=$1
	local state=$2
	echo "Actualizando variable: $var_name a $state"
	sudo sed -i "s/^$var_name=.*/$var_name=$state/g" "$ruta_vars"
}