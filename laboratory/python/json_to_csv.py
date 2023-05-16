import json
import csv
import os

def json_to_csv(json_file, csv_file):

    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)

    with open(csv_file, 'w', encoding='utf-8', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(data[0].keys())
        for item in data:
            writer.writerow(item.values())

    with open(csv_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    with open(csv_file, 'w', encoding='utf-8', newline='') as file:
        file.writelines(lines[1:])

    print(f"{json_file} -> {csv_file}")
    print("operation completed.")

for file_name in os.listdir():
    if file_name.endswith('.json'):

        csv_file_name = os.path.splitext(file_name)[0] + '.csv'
        json_to_csv(file_name, csv_file_name)