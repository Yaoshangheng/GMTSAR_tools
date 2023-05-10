#!/bin/bash
to_dir="interferograms"
from_dir="./project2"
merge_dir="$from_dir/merge"
raw_dir="$from_dir/F1/raw"

# merge子目录从这个文件复制对应文件名 project2/F1/raw
to_dir="$(readlink -f "$to_dir")"
from_dir="$(readlink -f "$from_dir")"
merge_dir="$(readlink -f "$merge_dir")"
raw_dir="$(readlink -f "$raw_dir")"
for d in $(ls -F "$merge_dir" | grep '/$')
do
    # 在interferograms创建merge里的同名目录
    mkdir -p "$to_dir/$d"
    rpm_files=""

    # 从baseline_table.dat文件找对应的RPM, LED文件名, 从project2/F1/raw复制到目录merge/2016019_2016043
    for year_date in $(echo "$d" | awk -F "[_/]" '{print $1" "$2}')
    do
        prefix="$(grep " $year_date" "$from_dir/baseline_table.dat" | awk '{print $1}')"
        echo "cp $raw_dir/$prefix.LED $merge_dir/$d"
        echo "cp $raw_dir/$prefix.RPM $merge_dir/$d"
        \cp -f $raw_dir/$prefix.LED $merge_dir/$d
        \cp -f $raw_dir/$prefix.PRM $merge_dir/$d
        rpm_files="$rpm_files $prefix.PRM"
    done

    #进入目录project2/2016019_2016043/merge 执行
    #SAT_baseline S1_20160120_ALL_F1.PRM S1_20160213_ALL_F1.PRM > baseline.txt
    cd "$merge_dir/$d"
    SAT_baseline $rpm_files > baseline.txt

    # 重命名一下S1_20160120_ALL_F1.PRM和S1_20160120_ALL_F1.LED文件,只保留中间的日期和后缀,变成20160120.PRM和20160120.LED
    for old_name in $(ls *.LED *.PRM)
    do
        new_name="$(echo "$old_name" | awk -F "[_.]" '{if($2 != $NF) print $2"."$NF}')"
        if [ ! -z "$new_name" ]
        then
            \rm -f "$new_name"
            echo "mv $old_name $new_name"
            mv $old_name $new_name
        fi
    done

    # 生成unwrap_ll.grd文件
    proj_ra2ll.csh trans.dat unwrap.grd unwrap_ll.grd

    #merge目录中的corr.grd、corr_ll.grd、unwrap.grd、unwrap_ll.grd复制到目标目录
    echo "\cp -f corr.grd corr_ll.grd unwrap.grd unwrap_ll.grd "$to_dir/$d""
    \cp -f *.LED *.PRM baseline.txt "$to_dir/$d"
    \cp -f corr.grd corr_ll.grd unwrap.grd unwrap_ll.grd "$to_dir/$d"
done
