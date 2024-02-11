import csv
import os

def csv_to_txt(csv_file, txt_file):
    with open(csv_file, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        data = list(reader)

    with open(txt_file, 'w', encoding='utf-8') as file:
        for row in data:
            file.write('\n'.join(row))
            file.write('\n\n')

    print(f"{csv_file} -> {txt_file}")
    print("CSV to TXT conversion completed.")

for file_name in os.listdir():
    if file_name.endswith('.csv'):
        txt_file_name = os.path.splitext(file_name)[0] + '.txt'
        csv_to_txt(file_name, txt_file_name)