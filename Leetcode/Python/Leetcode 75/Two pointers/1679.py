from typing import List

class Solution:
    def maxOperations(self, nums: List[int], k: int) -> int:
        # base case where if the size of nums is <=1, just return 0 cuz no pairs
        if (not nums or len(nums)==1 ):
            return 0
        
        # First sort the array
        
        # current strategy 
        #  1. start left and right and work the way inward
        left = 0
        right = len(nums)-1
        count = 0
        nums.sort()
        while ( left < right ):
            if(nums[left] ++ nums[right] == k):
                count+=1
            left+=1
            right-=1
        return count

if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        [[1,2,3,4], 5],
        [[3,1,3,4,3], 6],
    ]

    for (fr, back) in test_cases:
        print(f"Input: '{fr, back}'")
        result = solution.maxOperations(fr, back)
        print(f"Output: '{result}'\n")

