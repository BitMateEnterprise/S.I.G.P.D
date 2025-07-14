#!/bin/bash

nombreUsuario(){
 read -p "Nombre de usuario: " usuario
 echo $usuario
}

grupoPrincipal(){
 read -p "Grupo Principal: " grupoP
 echo $grupoP
}

grupoSecundario(){
 read -p "Grupo/s Secundario/s: " grupoS
 echo $grupoS
}

shellUsuario(){
 read -p "Ruta de Shell: " shell
 echo "$shell"
}

encontrarUsuario(){
 #grep -q "^$1:" /etc/passwd
 getent passwd $1 >/dev/null
}

noExisteUsuario(){
 echo -e "[x] El usuario no existe [x]\n"
}

errorUsuario(){
 echo -e "[x] Ingrese un usuario [x]\n"
}

validarShell(){
 grep -q "^$1$" /etc/shells
}

carpetaTrabajo(){
 read -p "Desea crear una carpeta con nombre personalizado [s/n]: " opcion

 if [[ $opcion == [Ss] ]]; then
  read -p "Ingrese el nombre de la carpeta: " carpeta
  echo "/home/$carpeta"
 else
  echo "/home/$1"
 fi
}

obtenerDatosUsuario(){
 local usuario=$(nombreUsuario)
 local grupoP=$(grupoPrincipal)
 local grupoS=$(grupoSecundario)
 local shell=$(shellUsuario)
 local home=$(carpetaTrabajo "$usuario")
 validarParametro "$usuario" "$grupoP" "$grupoS" "$shell" "$home"
}

validarGS(){
 if sinEspacios "$1"; then
  if validarGruposSecundarios $1; then
   return 0
  fi
   return 1
 fi
 echo -e "[x] Separa los grupos secundarios con ',' y sin espacios [x]\n"
 return 1
}

validarParametro(){
 local parametros=""

 if variableNoVacia $1 && ! encontrarUsuario $1 && sinEspacios "$1"; then

  if variableNoVacia $2; then
   if encontrarGrupo $2; then
    parametros+="-g $2"
   else
    noExisteGrupo
    return 1
  fi
 fi

 if variableNoVacia $3; then
  if validarGS "$3"; then
    parametros+=" -G $3"
  else
   return 1
  fi
 fi

 if validarShell $4; then
  parametros+=" -s $4"
  else
   echo -e "[x] Error en la shell [x]\n"
   return 1
 fi

 if sinEspacios "$5"; then
  parametros+=" -m -d $5"
  echo $parametros
 else
  echo -e "[x] El nombre de la carpeta no debe contener espacios [x]\n"
  return 1
 fi

 crearUsuario "$parametros $1"
 echo "$1:$1" | chpasswd 2>/dev/null
 chage -d 0 "$1"

 echo -e "[✔] Se creó el usuario '$usuario' con contraseña '$1' correctamente [✔]\n"
 return 0

 fi
 echo -e "[x] Error al ingresar el usuario [x]\n"
}

crearUsuario(){
 useradd $1
}

comprobarUsuario(){
 local usuario=$(nombreUsuario)
 if variableNoVacia $usuario; then
  if encontrarUsuario $usuario; then
   echo -e "[✔] El usuario '$usuario' existe [✔]\n"
   return 0
  fi
  noExisteUsuario
 return 1
 fi
 #errorUsuario
}

eliminarUsuario(){
 local usuario=$(nombreUsuario)
 if variableNoVacia $usuario; then
  if encontrarUsuario $usuario; then
  userdel -r $usuario 2>/dev/null
  echo -e "[✔] Usuario Eliminado [✔]\n"
  return 0
  fi
  noExisteUsuario
  return 1
 fi
 errorUsuario
}

menuUsuario(){
clear
mensajeUsuario
while true; do
echo "1. Añadir Usuario
2. Comprobar Existencia de Usuario
3. Modificar Usuario
4. Eliminar Usuario
0. Salir"

case $(leerOpcion) in

1) obtenerDatosUsuario;;

2) comprobarUsuario;;

3) menuModificar;;

4) eliminarUsuario;;

0) break;;

*) opcionInvalida ;;

esac
done
}

menuModificar(){
clear
while true; do
 echo "1. Shell
2- Grupo Principal
3. Añadir a Grupo
4. Directorio de trabajo
0. Salir"

case $(leerOpcion) in

2) cambiarGrupoP;;
3) añadirGrupoSec;;
0) clear && break ;;
*) opcionInvalida ;;
esac
done
}

añadirGrupoSec(){
local usuario=$(nombreUsuario)
if variableNoVacia $usuario && encontrarUsuario $usuario; then
local grupoS=$(grupoSecundario)

if variableNoVacia $grupoS; then
 if validarGS "$grupoS"; then
  modificarUsuario "-aG $grupoS $usuario"
  return 0
 fi
  return 1
fi
 echo -e "[x] Ingrese un grupo [x]\n"
 return 1
 fi
echo -e "Error con el usuario\n"

}

modificarUsuario(){
 echo "$1"
 usermod $1
 echo -e "[✔] Usuario modificado [✔]\n"
}

validarGruposSecundarios(){
local grupos="$1"

for i in $(echo "$grupos" | sed 's/,/ /g'); do
 if ! encontrarGrupo $i;then
 echo -e "[x] El grupo $i no se encontró [x]\n"
 return 1
 fi
done
return 0
}

cambiarGrupoP(){
local usuario=$(nombreUsuario)
if variableNoVacia $usuario && encontrarUsuario $usuario; then
local grupoP=$(grupoPrincipal)

if variableNoVacia "$grupoP" && sinEspacios "$grupoP"; then
 if encontrarGrupo "$grupoP"; then
  modificarUsuario " -g $grupoP $usuario"
  return 0
 fi
  noExisteGrupo
  #echo -e "No se encotró el grupo '$grupoP'\n"
  return 1
 fi
echo -e "[x] Error en el grupo [x]\n"
return 1
fi
echo -e "Error con el usuario\n"
}
