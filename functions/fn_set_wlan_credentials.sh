fn_set_wlan_credentials(){
    cat <<EOF | sudo tee /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
country=MX
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="$SSID"
    psk="$PWK"
}
EOF
}