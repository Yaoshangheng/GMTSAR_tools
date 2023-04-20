#Author：Yao Yuan
#usage：copy corr.grd unwrap.grd file to SBAS for reduce memory occupied.
#!/bin/bash
from_dir="merge"
to_dir="merge_copy"
mkdir -p "$to_dir"
for d in $(find "$from_dir" -mindepth 1 -maxdepth 1 -type d)
do
    folder_name="$(basename "$d")"
    mkdir -p $to_dir/$folder_name
    cp -u "$d/unwrap.grd" "$to_dir/$folder_name"
    cp -u "$d/corr.grd" "$to_dir/$folder_name"
    cp -u "$d/phasefilt.grd" "$to_dir/$folder_name"
    cp -u "$d/mask.grd" "$to_dir/$folder_name"
done
echo "copy to: $to_dir"

