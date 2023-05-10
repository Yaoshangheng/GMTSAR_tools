#!/bin/bash
trans=$(readlink -f trans.dat)
for d in $(ls -F "./" | grep '/$')
do    
    to=$(readlink -f $d/trans.dat)
    ln -sf "$trans" "$to"
done

