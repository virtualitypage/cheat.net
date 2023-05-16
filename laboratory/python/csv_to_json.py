import csv
import json
import os

def csv_to_json(csv_file, json_file):
    with open(csv_file, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        data = list(reader)

    with open(json_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=2, ensure_ascii=False)

    print(f"{csv_file} -> {json_file}")
    print("operation completed.")

for file_name in os.listdir():
    if file_name.endswith('.csv'):

        json_file_name = os.path.splitext(file_name)[0] + '.json'
        csv_to_json(file_name, json_file_name)