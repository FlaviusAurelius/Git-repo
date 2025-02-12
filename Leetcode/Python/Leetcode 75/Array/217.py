from typing import List

class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        if len(nums) < 2:
            return False
        
        
        # naive approach, could be better, extremly inefficient if array is massive
        # for pos, n in enumerate(nums):
        #     # print("Pos: ", pos, " n: ", n)
        #     for i in range(pos+1, len(nums)):
        #         # print("inner i: ", i)
        #         if n == nums[i]:
        #             return True

        # better approach, sort list first then check if adjacent elements are the same
        #  slightly better than previous, still not great because performance is input dependent
        # nums.sort()
        # for i in range (1, len(nums)):
        #     if nums[i] == nums[i -1]:
        #         return True
        
        # O(n) approach. add any num we've seen to hash set and check if any element was seen
        #  already in the hash set
        seen = set()
        for num in nums:
            if num in seen:
                return True
            seen.add(num)
        return False
        

if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        [1,2,3,1],
        [1,2,3,4],
        [1,1,1,3,3,4,3,2,4,2]
    ]

    for test in test_cases:
        print(f"Input: '{test}'")
        result = solution.containsDuplicate(test)
        print(f"Output: '{result}'\n")
