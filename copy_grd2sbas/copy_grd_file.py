import os
import shutil
from datetime import datetime

# 获取当前目录
current_dir = os.getcwd()

# 指定merge目录路径
merge_dir = os.path.join(current_dir, "merge")

# 指定SBAS目录路径
sbas_dir = os.path.join(current_dir, "SBAS")

# 创建SBAS目录
os.makedirs(sbas_dir, exist_ok=True)

# 遍历merge目录下的子目录
for subdir in os.listdir(merge_dir):
    subdir_path = os.path.join(merge_dir, subdir)
    
    # 确保子目录为目录且非隐藏目录
    if os.path.isdir(subdir_path) and not subdir.startswith('.'):
        
        # 获取子目录下的corr.grd和unwrap.grd文件路径
        corr_file = os.path.join(subdir_path, "corr.grd")
        unwrap_file = os.path.join(subdir_path, "unwrap.grd")
        
        # 确保corr.grd和unwrap.grd文件存在
        if os.path.isfile(corr_file) and os.path.isfile(unwrap_file):
            
            # 拷贝corr.grd和unwrap.grd文件到merge目录
            shutil.copy2(corr_file, merge_dir)
            shutil.copy2(unwrap_file, merge_dir)
            
            # 输出复制的文件路径
            print(f"复制文件 {corr_file} 和 {unwrap_file} 到目录 {merge_dir}")
            
            # 解析子目录名称为日期时间
            try:
                date_str = subdir.split("_")[-1]
                date = datetime.strptime(date_str, "%Y%m%d")
                
                # 拷贝corr.grd和unwrap.grd文件到SBAS目录，并按照原来的时间目录命名
                sbas_subdir = os.path.join(sbas_dir, subdir)
                os.makedirs(sbas_subdir, exist_ok=True)
                shutil.copy2(corr_file, sbas_subdir)
                shutil.copy2(unwrap_file, sbas_subdir)
                
                # 输出复制的文件路径
                print(f"复制文件 {corr_file} 和 {unwrap_file} 到目录 {sbas_subdir}")
            
            except ValueError:
                print(f"无法解析目录 {subdir_path} 的日期时间")
                
        else:
            print(f"目录 {subdir_path} 中缺少corr.grd或unwrap.grd文件")