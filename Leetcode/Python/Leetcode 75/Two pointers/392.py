class Solution:
    def isSubsequence(self, s: str, t: str) -> bool:
        if(len(s) == 0):
            return True
        s_ind = 0
        
        for i in range(len(t)):
            
            if(s_ind >= len(s)):
                break
            elif(s[s_ind] == t[i] and s_ind <= len(s)):
                s_ind+=1
            
        return s_ind >= len(s)
        
        
if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        ["abc","ahbgdc"],
        ["axc","ahbgdc"],
    ]

    for (fr,back) in test_cases:
        print(f"Input: '{fr, back}'")
        result = solution.isSubsequence(fr, back)
        print(f"Output: '{result}'\n")
