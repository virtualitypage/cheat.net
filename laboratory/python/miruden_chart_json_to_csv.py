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

    # with open(csv_file, 'w', encoding='utf-8', newline='') as file:
    #     file.writelines(lines[1:])

    print(f"{json_file} -> {csv_file} ")
    print("operation completed.")

def json_to_csv_all():
    current_directory = os.getcwd()
    json_files = [file for file in os.listdir(current_directory) if file.endswith('.json')]

    for json_file in json_files:
        csv_file = os.path.splitext(json_file)[0] + '.csv'
        json_file = os.path.join(current_directory, json_file)
        csv_file = os.path.join(current_directory, csv_file)
        json_to_csv(json_file, csv_file)

    print(f"{json_file} -> {csv_file} ")
    print("operation completed.")

json_to_csv_all()