# import unittest
# from functions.get_files_info import get_files_info
# from functions.get_file_content import get_file_content
# from functions.write_file import write_file
from functions.run_python import run_python_file



def test():
    result = run_python_file("calculator", "main.py")
    print(result)

    result = run_python_file("calculator", "tests.py")
    print(result)

    result = run_python_file("calculator", "../main.py")
    print(result)

    result = run_python_file("calculator", "nonexistent.py")
    print(result)


if __name__ == "__main__":
    test()

###     incomplete unit tests    ***
# class TestGetFilesInfo(unittest.TestCase):
#     def case1(self):
#         result = get_files_info("calculator", ".")
#         self.assertEqual(result, )
#     def case2(self):
#         result = get_files_info("calculator", "pkg")
#         self.assertEqual(result, )
#     def case3(self):
#         result = get_files_info("calculator", "/bin")
#         self.assertEqual(result, )
#     def case4(self):
#         result = get_files_info("calculator", "../")
#         self.assertEqual(result, )

# tests for get_files_info 
# print("------------------------------------")
# get_files_info("calculator", ".")
# print("------------------------------------")
# get_files_info("calculator", "pkg")
# print("------------------------------------")
# get_files_info("calculator", "/bin")
# print("------------------------------------")
# get_files_info("calculator", "../")
# print("------------------------------------")


# tests for get_file_content
# get_file_content("calculator", "lorem.txt")
# print("------------------------------------")
# get_file_content("calculator", "main.py")
# print("------------------------------------")
# get_file_content("calculator", "pkg/calculator.py")
# print("------------------------------------")
# get_file_content("calculator", "/bin/cat")
# print("------------------------------------")
# get_file_content("calculator", "pkg/does_not_exist.py")
# print("------------------------------------")

# tests for write_file
# write_file("calculator", "lorem.txt", "wait, this isn't lorem ipsum")
# print("------------------------------------")
# write_file("calculator", "pkg/morelorem.txt", "lorem ipsum dolor sit amet")
# print("------------------------------------")
# write_file("calculator", "/tmp/temp.txt", "this should not be allowed")
# print("------------------------------------")


# tests for run_python
# run_python_file("calculator", "main.py")
# print("------------------------------------")
# run_python_file("calculator", "main.py", ["3 + 5"])
# print("------------------------------------")
# run_python_file("calculator", "tests.py")
# print("------------------------------------")
# run_python_file("calculator", "../main.py")
# print("------------------------------------")
# run_python_file("calculator", "nonexistent.py")
# print("------------------------------------")
