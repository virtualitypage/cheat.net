import csv
import json
import os

def csv_to_json(csv_file, json_file):
    with open(csv_file, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        data = list(reader)

    with open(json_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=2, ensure_ascii=False)

    print(f"{csv_file} -> {json_file} ")
    print("operation completed.")

def csv_to_json_all():
    current_directory = os.getcwd()
    csv_files = [file for file in os.listdir(current_directory) if file.endswith('.csv')]

    for csv_file in csv_files:
        json_file = os.path.splitext(csv_file)[0] + '.json'
        csv_to_json(csv_file, json_file)

    print(f"{csv_file} -> {json_file}")
    print("operation completed.")

csv_to_json_all()