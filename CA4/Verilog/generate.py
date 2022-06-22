import math
import random

def binary(n):
	result = ""
	for i in range(32):
		result += str(n % 2)
		n >>= 1
	result = result[::-1]
	return result

binarydata = open('data.txt', 'w')
interpretation = open('data_interpretation.txt', 'w')

maxn = -math.inf
maxi = 0
for i in range(20):
	n = random.getrandbits(32)
	binarydata.write(f'{binary(n)}\n')
	if n >= 2**31:
		n -= 2**32
	if n > maxn:
		maxn = n
		maxi = i
	interpretation.write(f'{i}:\t{n}\n')
interpretation.write(f'max value = {maxn}, max index = {maxi}\n')
binarydata.close()
interpretation.close()