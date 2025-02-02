from typing import List
class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        # store everything in the output array
        # two loops, one to calculate the prefix product
        # one for postfix product 
        #  store everything in the output array because it is excluded by space analysis
        output = [1] * len(nums)
        pre = 1
        post = 1
        for i in range(0, len(nums)):
            output[i] = pre
            pre *= nums[i]
        for i in range(len(nums)-1, -1, -1): 
            output[i] *= post
            post *= nums[i]
            
        
        return output
    
if __name__ == "__main__":
    # Create an instance of the Solution class
    sol = Solution()

    # Example test cases
    test_cases = [
        [1,2,3,4],
        [-1,1,0,-3,3]
    ]

    for test in test_cases:
        print(f"Input: '{test}'")
        result = sol.productExceptSelf(test);
        print(f"Output: '{result}'\n")