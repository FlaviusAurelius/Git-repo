from typing import List

class Solution:
    def maxArea(self, height: List[int]) -> int:
        # base case 1 or less height, just return 0
        if (len(height) <= 1):
            return 0
        # Current idea:
        # start from head and tail of the list, calculate the maximum valume achievable
        #  strategy to maximize efficiency:
        #  problem: The obvious strategy of running every combination with 2 for loops is suboptimal at best,
        #          running a O(n^2) time, which is unacceptable
        #  Solution: Since volume is limited by the lowest container wall, we try to maximize the height of the container wall
        #           on the lower side

        left = 0
        right = len(height)-1
        max_vol = 0
        # stop when the container wall is right next to each other
        while (left < right): 
            #print(left, height[left], height[right], right)
            #Compare left and right wall height
            if(height[left] < height[right]):
                # update max volume
                max_vol = max(max_vol, (min(height[left], height[right]) * (right - left)) )
                #print(max_vol)
                # move left toward right wall to try and find a taller wall
                left+=1
            elif (height[right] < height[left]):
                # update max volume
                max_vol = max(max_vol, (min(height[left], height[right]) * (right - left)) )
                #print(max_vol)
                #move right toward left wall to try and find a taller wall
                right -= 1
            #if both wall are the same size, move both
            else:
                # update max volume
                max_vol = max(max_vol, (min(height[left], height[right]) * (right - left)) )
                #print(max_vol)
                right-=1
                left +=1

        return max_vol
        
if __name__ == "__main__":
    # Create an instance of the Solution class
    solution = Solution()

    # Example test cases
    test_cases = [
        [1,8,6,2,5,4,8,3,7],
        [1,1],
    ]

    for test in test_cases:
        print(f"Input: '{test}'")
        result = solution.maxArea(test)
        print(f"Output: '{result}'\n")
