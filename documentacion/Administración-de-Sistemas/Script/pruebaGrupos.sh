#!/bin/bash
source scriptUsuarios.sh
source scriptGrupos.sh

grupoS=$(grupoSecundario)

validarGruposSecundarios(){
for i in $(echo $grupoS | sed 's/,/ /g'); do
 if ! encontrarGrupo $i;then
 echo "El grupo $i no se encontró"
 return 1
 fi
done
echo "Todos los grupos se encuentran"
return 0
}

if sinEspacios "$grupoS"; then
validarGruposSecundarios "$grupoS"
else
 echo "Separe los grupos por ',' y no ponga espacios"
fi

}
