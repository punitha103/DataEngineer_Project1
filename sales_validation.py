import os
import csv

file_name = r"C:\Users\acer\OneDrive\Documents\data_folder\sales_datas.csv"

try:
    # File exists?
    if not os.path.exists(file_name):
        raise FileNotFoundError(f"{file_name} does not exist.")

    print("File found.")

    # Open CSV file
    with open(file_name, "r") as file:
        reader = csv.reader(file)
        data = list(reader)

    # Check if file is empty
    if len(data) == 0:
        raise ValueError("CSV file is empty.")

    print("File loaded successfully.")
    print("Total Rows    :", len(data) - 1)  # Header-ஐ கழித்து
    print("Total Columns :", len(data[0]))

except FileNotFoundError as e:
    print("Error:", e)

except PermissionError:
    print("Error: Permission denied to access the file.")

except ValueError as e:
    print("Error:", e)

except Exception as e:
    print("Unexpected Error:", e)

finally:
    print("Program completed.")