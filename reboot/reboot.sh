#!/bin/bash

source /etc/environment
sleep 10

# Script 1
/bin/bash $CPATH/reboot/autorun.sh

# Script 2
/bin/bash $CPATH/services/svc_restart_tv.sh

# Script 3
/bin/bash $CPATH/services/svc_clean_cache.sh

#+ No ejecutar como superusuario 
#+ Script 4
$CPATH/services/svc_autotab.sh > /dev/null 2>&1  &

#+ Script 5
$CPATH/apps/kiosk.sh > /dev/null 2>&1 &