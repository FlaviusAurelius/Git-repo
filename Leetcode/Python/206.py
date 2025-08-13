from functools import reduce
from operator import xor

if __name__ == "__main__":
    nums = [9,6,4,2,3,5,7,0,1]
    
    size = (i ^ v for i, v in enumerate(nums, 1))
    
    final = reduce(xor, size)
    
    
    print(size)    
