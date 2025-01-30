import sys
from typing import List

class Solution:
    def increasingTriplet(self, nums: List[int]) -> bool:        
        
        n1, n2 = sys.maxsize, sys.maxsize
        for n in nums:
            if n <= n1:
                n1 = n
            elif n <= n2:
                n2 = n
            if n > n2:
                n3 = n
                return True
            
        
        return False
    
    
if __name__ == "__main__":
    # Create an instance of the Solution class
    sol = Solution()

    # Example test cases
    test_cases = [
        [1,2,3,4,5],
        [5,4,3,2,1],
        [2,1,5,0,4,6]
    ]

    for test in test_cases:
        print(f"Input: '{test}'")
        result = sol.increasingTriplet(test);
        print(f"Output: '{result}'\n")