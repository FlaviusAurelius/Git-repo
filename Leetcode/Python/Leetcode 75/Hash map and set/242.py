class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        # Check if lengths are different; if yes, they cannot be anagrams
        if len(s) != len(t):
            return False

        # Dictionary to count character occurrences in string s
        counter = {}

        # Count each character in the first string s
        for char in s:
            # Increment the character count or set to 1 if not present
            counter[char] = counter.get(char, 0) + 1

        # Check each character in the second string t
        for char in t:
            # If the character is not in counter or the count is zero, not an anagram
            if char not in counter or counter[char] == 0:
                return False
            # Decrement the count for the current character
            counter[char] -= 1

        # If all counts balance out, s and t are anagrams
        return True

if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        ["temp", ""]
        ["anagram", "nagaram"],
        ["rat", "car"],
    ]

    for (s,t) in test_cases:
        print(f"Input: '{s, t}'")
        result = solution.isAnagram(s, t)
        print(f"Output: '{result}'\n")