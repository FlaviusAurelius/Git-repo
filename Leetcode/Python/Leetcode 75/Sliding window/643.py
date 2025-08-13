from typing import List

class Solution:
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        cur_sum = sum(nums[:k])
        max_num = cur_sum

        # iterate over input list whilst maintaining window
        for i in range(k, len(nums)):
            # Update the current sum by adding the element next to the sliding window and 
            # subtracting the element at the head of the sliding window, thus
            # sliding the window forward
            cur_sum += nums[i] - nums[i - k]
            # Update the max sum if the current sum is greater
            max_num = max(max_num, cur_sum)
      
        # Calculate the maximum average by dividing the max sum by k
        return max_num / k


if __name__ == "__main__":
    # Create an instance of the Solution class

    sol = Solution()

    # Example test cases
    test_cases = [
        ([1,12,-5,-6,50,3], 4),
        ([5], 1)
    ]

    for test, k in test_cases:
        print(f"Input: '{test}'")
        result = sol.findMaxAverage(test, k);
        print(f"Output: '{result}'\n")