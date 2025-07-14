#!/bin/bash

leerOpcion(){
 read -p "Digite una opción: " op
 echo $op
}

variableNoVacia(){
 [ ! -z "$1" ]
}

opcionInvalida(){
 echo -e "[x] Opción Inválida [x]\n"
}

sinEspacios(){
echo $1
 [[ ! "$1" =~ [[:space:]] ]]
}
