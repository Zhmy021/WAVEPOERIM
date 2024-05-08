import numpy as np
from netCDF4 import Dataset

file = r"wind.nc"
data_lat = np.array(Dataset(file)['latitude'])
data_lon = np.array(Dataset(file)['longitude'])

u0 = np.array(Dataset(file)['u10'])
v0 = np.array(Dataset(file)['v10'])
print(v0.shape)
print(data_lat)
print(data_lon)

with open('Taiwan2018-2020.dat', 'w') as fw:
    for k in range(26304):
        u = u0[k, :, :]
        v = v0[k, :, :]
        for i in range(29):  # lat
            for j in range(29):  # lon
                fw.write(f'{u[i, j]:10.4f}')
            fw.write('\n')

        for i in range(29):  # lat
            for j in range(29):  # lon
                fw.write(f'{v[i, j]:10.4f}')
            fw.write('\n')



