import json
import csv

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

    print("電気料金データ.json -> 電気料金表.csv")
    print("operation completed.")

json_to_csv('電気料金データ.json', '電気料金表.csv')
