from typing import List

class Solution:
    def maxVowels(self, s: str, k: int) -> int:
        # establish the first window of size k and determine current vowel count
        cur_vowel = c_max = 0
        for l in range(k):
            cur_vowel += self.isVowel(s[l])
        c_max = cur_vowel
        
        # now move the sliding window
        for l in range(k, len(s)):
            cur_vowel += self.isVowel(s[l]) - self.isVowel(s[l - k])
            c_max = max(c_max, cur_vowel)
        
        return c_max
        
    def isVowel(self, c: str) -> int:
        return int(c.lower() in {'a', 'e', 'i', 'o', 'u'} )

if __name__ == "__main__":
    # Create an instance of the Solution class

    sol = Solution()

    # Example test cases
    test_cases = [
        ("abciiidef", 4),
        ("aeiou", 2),
        ("leetcode", 3)
    ]

    for test, k in test_cases:
        print(f"Input: '{test}'")
        #print(sol.isVowel('a'))
        result = sol.maxVowels(test, k);
        print(f"Output: '{result}'\n")