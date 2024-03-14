import numpy as np
import matplotlib.pyplot as plt

n = 16
r1 = np.linspace(1, 20, 100000, endpoint=False)
cska_delay = 4*r1 + 2 * (n/r1)
csea_delay = 2*r1 + 2*(16/r1)+2
cina_delay = 3*r1 + 2*np.ceil(16/r1)+1


plt.figure(figsize=(12,5))
plt.plot(r1, cska_delay, label='CSKA Delay')
plt.plot(r1, csea_delay, label='CSEA Delay')
plt.plot(r1, cina_delay, label='CINA Delay')
plt.title('Delay Optimization for 16 bit Adders')
plt.xlabel('r value')
plt.ylabel('Delay (delta)')
plt.grid(True)
plt.tight_layout()
plt.legend()
plt.show()
#print(min(cska_delay))
# Find the index of the minimum y-value
min_y_index = np.argmin(cska_delay)
# Print the x-value corresponding to the minimum y-value
min_x_value = r1[min_y_index]
print("X-value at the minimum y-value(CSKA):", np.round(min_x_value, decimals=2))

min_y_index = np.argmin(csea_delay)
# Print the x-value corresponding to the minimum y-value
min_x_value = r1[min_y_index]
print("X-value at the minimum y-value(CSEA):", np.round(min_x_value, decimals=2))

min_y_index = np.argmin(cina_delay)
# Print the x-value corresponding to the minimum y-value
min_x_value = r1[min_y_index]
print("X-value at the minimum y-value(CINA):", np.round(min_x_value, decimals=2))
