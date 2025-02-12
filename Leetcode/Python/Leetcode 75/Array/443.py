from typing import List

class Solution:
    def compress(self, chars: List[str]) -> int:
        length = len(chars)
        if length < 2:
            return length
        
        # pointer for the position of group of chars
        pt1 = 0

        # position to write next, increase whenever we wrote to the array chars
        write_counter = 0

        for pos, char in enumerate(chars):

            # If we reach the end of chars OR the next character is different, then:
            if (pos + 1) == length or char != chars[pos +1]:
                chars[write_counter] = char
                write_counter += 1

                # If a character repeats, calculate the count (repeat = pt1 - write_counter + 1).
                # Convert it into a string and write each digit separately (e.g., 12 → "1", "2").
                # Increment write accordingly.
                if pos > pt1:
                    # check how many times char's been repeated
                    repeat = pos - pt1 + 1

                    for num in str(repeat):
                        chars[write_counter] = num
                        write_counter += 1
                pt1 = pos + 1

        return write_counter
       


if __name__ == "__main__":
    # Create an instance of the Solution class

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