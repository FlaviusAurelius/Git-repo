class Solution:
    def reverseWords(self, s: str) -> str:
        """
        :type s: str
        :rtype: str
        """
        words = s.split()
        reversed_words = words[::-1]
        reversed_string = ' '.join(reversed_words)
        return reversed_string


# Test the function locally
if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        "the sky is blue",
        "  hello world  ",
        "a good   example"
    ]

    for test in test_cases:
        print(f"Input: '{test}'")
        result = solution.reverseWords(test)
        print(f"Output: '{result}'\n")
