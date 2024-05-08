import numpy as np
from netCDF4 import Dataset

file = r"shuishen.nc"
print(Dataset(file))
data_lat = np.array(Dataset(file)['lat'])
data_lon = np.array(Dataset(file)['lon'])

depth = np.array(Dataset(file)['etopo1_ice_g_f4_Clip'])
print(depth.shape)
print(data_lat)
print(data_lon)

with open('depth.dat', 'w') as fw:
    for k in range(167):
        u = depth
        for i in range(480):  # lat
            for j in range(420):  # lon
                fw.write(f'{u[i, j]:10.4f}')
            fw.write('\n')




