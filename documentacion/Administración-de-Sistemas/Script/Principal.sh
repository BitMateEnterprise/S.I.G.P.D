#!/bin/bash

if [ $EUID -eq 0 ]; then

source mensajes.sh
source funcionesGenerales.sh
source scriptGrupos.sh
source scriptUsuarios.sh

 while true; do

 clear
 mensajePrincipal

 echo "Gestión de Usuarios y Grupos
1. Usuarios
2. Grupos
0. Salir"

 case $(leerOpcion) in
 1) menuUsuario ;;

 2) menuGrupos ;;

 0) clear && exit ;;

 *) opcionInvalida ;;

 esac

 done

else
 echo -e "[x] No tiene permisos para ejecutar el script [x]\n"
fi
