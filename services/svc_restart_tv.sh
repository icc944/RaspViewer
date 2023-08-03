#!/bin/bash

# Reconocer dispositivos
echo "scan" | cec-client RPI -s -d 1

# Apagamos la pantalla
echo 'Apagando pantalla'
echo "standby 0" | cec-client RPI -s -d 1 > /dev/null 2>&1

sleep 3

# Encendemos la tv
echo 'Encendiendo pantalla'
echo "on 0" | cec-client RPI -s -d 1 > /dev/null 2>&1
sleep 20