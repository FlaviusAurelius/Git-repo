class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        # Use a hash map (dictionary) to store the complement (difference between the target and the current number) as the key, 
        #     and the index of the current number as the value.
        # As you traverse the list, check if the current number exists in the hash map. If it does, 
        #     you’ve found the pair. If not, store the complement.
        if len(nums) <= 1:
            return []

        tracker = {}
        # Traverse through the list
        for i in range(len(nums)):
            # Calculate the complement that would form the target
            complement = target - nums[i]
            # Check if complement exists in the dictionary
            if complement in tracker:
                # If complement exists, then we have found the indices pair
                return [tracker.get(complement), i]
                
            else:
                # If not, save the number and its indices in the dictionary for look up later
                tracker[nums[i]] = i

        return []



if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        [[1,2,3,4], 5],
        [[3,1,3,4,3], 6],
    ]

    for (ls, n) in test_cases:
        print(f"Input: '{ls, n}'")
        result = solution.twoSum(ls, n)
        print(f"Output: '{result}'\n")