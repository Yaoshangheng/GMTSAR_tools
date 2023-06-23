import os
import shutil

merge_dir = 'merge'
sbas_dir = 'SBAS'

# 创建 SBAS 目录
os.makedirs(sbas_dir, exist_ok=True)

# 获取 merge 目录中的时间对目录列表
time_dirs = [d for d in os.listdir(merge_dir) if os.path.isdir(os.path.join(merge_dir, d))]

# 记录拷贝过程中不存在的目录
missing_dirs = []

# 拷贝文件到 merge 目录
for i, time_dir in enumerate(time_dirs, 1):
    corr_grd_file = os.path.join(merge_dir, time_dir, 'corr.grd')
    unwrap_grd_file = os.path.join(merge_dir, time_dir, 'unwrap.grd')

    if os.path.exists(corr_grd_file):
        shutil.copy(corr_grd_file, merge_dir)
    else:
        missing_dirs.append(os.path.join(merge_dir, time_dir))
        continue

    if os.path.exists(unwrap_grd_file):
        shutil.copy(unwrap_grd_file, merge_dir)
    else:
        missing_dirs.append(os.path.join(merge_dir, time_dir))
        continue

    # 创建 SBAS 目录中的时间对目录，并按照原时间目录命名
    sbas_time_dir = os.path.join(sbas_dir, time_dir)
    os.makedirs(sbas_time_dir, exist_ok=True)

    # 将文件拷贝到 SBAS 目录中的时间对目录
    shutil.copy(corr_grd_file, sbas_time_dir)
    shutil.copy(unwrap_grd_file, sbas_time_dir)

    # 打印拷贝进度
    print(f"拷贝进度: {i}/{len(time_dirs)}")

# 核对时间对数量
merge_time_dirs = len(time_dirs)
sbas_time_dirs = len(os.listdir(sbas_dir))

print(f"原来的 merge 目录中的时间对数量: {merge_time_dirs}")
print(f"新拷贝到 SBAS 目录中新建时间对目录数量: {sbas_time_dirs}")

# 输出不存在的目录信息
if missing_dirs:
    print("以下目录中的 corr.grd 或 unwrap.grd 文件不存在:")
    for missing_dir in missing_dirs:
        print(missing_dir)
