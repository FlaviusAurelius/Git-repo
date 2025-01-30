from typing import List

class Solution:
    def compress(self, chars: List[str]) -> int:
        
        temp = []
        cur = ''
        count = 0
        for c in chars:
            if cur != c:
                cur = c
                count += 1
                      
        
        return len(chars)


if __name__ == "__main__":
    # Create an instance of the Solution class
    count = 0
    ++count
    sol = Solution()

    # Example test cases
    test_cases = [
        ["a","a","b","b","c","c","c"],
        ["a"],
        ["a","b","b","b","b","b","b","b","b","b","b","b","b"]
    ]

    for test in test_cases:
        print(f"Input: '{test}'")
        result = sol.compress(test);
        print(f"Output: '{result}'\n")