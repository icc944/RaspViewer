#!/bin/bash
# Limpieza de caché
echo "Limpiando caché..."
sudo sync
sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
echo "Caché limpiada."

# Liberar memoria
echo "Liberando memoria del buffer..."
sudo sync && echo 1 > sudo /proc/sys/vm/drop_caches
echo "Memoria liberada."