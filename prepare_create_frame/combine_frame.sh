#!/bin/bash
# Usage:1.Change abs data path of T503&T508
SAFE="SAFE_Filelist"
T503="/run/user/1000/gvfs/smb-share:server=192.168.1.10,share=insar_data/gmtsar_data/xiaojiang_fault/des/SA_raw/2016/T503"
T508="/run/user/1000/gvfs/smb-share:server=192.168.1.10,share=insar_data/gmtsar_data/xiaojiang_fault/des/SA_raw/2016/T508"
f2list="$(ls -d $T508/*.SAFE)"
eoflist="$(ls *.EOF)"
for f1 in $T503/*.SAFE
do
    fdate=$(echo "$f1" | grep -Eo '[0-9]{8}T' | head -1 | cut -c 1-8)
    f2=$(echo "$f2list" | grep $fdate)
    if [ ! -z "$f2" ]
    then
        echo $f1 > $SAFE
        echo $f2 >> $SAFE
        for eof in $eoflist
        do
            dates=($(echo "$eof" | grep -Eo '[0-9]{8}T' | tail -2 | cut -c 1-8))
            begin_date=${dates[0]}
            end_date=${dates[1]}
            if (( $fdate >= $begin_date && $fdate <= $end_date ))
            then
                create_frame_tops.csh $SAFE $eof two_pins.ll vv
            fi
        done
    fi
done

