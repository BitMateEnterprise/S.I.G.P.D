#!/bin/bash

nombreGrupo(){
 read -p "Nombre del grupo: " grupo
 echo $grupo
}

encontrarGrupo(){
 grep -q "^$1:" /etc/group
 #getent group $1 > /dev/null
}

noExisteGrupo(){
 echo -e "[x] El grupo no existe [x]\n"
}

errorGrupo(){
 echo -e "[x] Ingrese un grupo [x]\n"
}

anadirGrupo(){
 local grupo=$(nombreGrupo)
 if variableNoVacia $grupo; then
  if ! encontrarGrupo $grupo; then
   groupadd $grupo
   echo -e "[✔] Grupo Añadido [✔]\n"
   return 0
  fi
  echo -e "[x] El grupo '$grupo' ya existe [x]\n"
 return 1
fi
 errorGrupo
}

comprobarGrupo(){
 local grupo=$(nombreGrupo)
 if variableNoVacia $grupo; then
  if encontrarGrupo $grupo; then
   echo -e "[✔] El grupo existe [✔]\n"
   return 0
  fi
  noExisteGrupo
  return 1
 fi
 errorGrupo
 return 1
}

eliminarGrupo(){
 local grupo=$(nombreGrupo)
 if variableNoVacia $grupo; then
  if encontrarGrupo $grupo; then
   groupdel -f $grupo
   echo -e "[✔] Grupo Eliminado [✔]\n"
   return 0
  fi
  noExisteGrupo
 return 1
 fi
 errorGrupo
}

menuGrupos(){
 clear
 mensajeGrupo
 while true; do
 echo "1. Añadir Grupo
2. Comprobar Existencia de Grupo
3. Eliminar Grupo
0. Salir"

case $(leerOpcion) in

1) anadirGrupo;;

2) comprobarGrupo;;

3) eliminarGrupo;;

0) break;;

*) opcionInvalida;;

esac
done
}
