import csv
import json

def csv_to_json(csv_file, json_file):

    with open(csv_file, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        data = list(reader)

    with open(json_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=2, ensure_ascii=False)

    print("電気料金表.csv -> 電気料金データ.json")
    print("operation completed.")

csv_to_json('電気料金表.csv', '電気料金データ.json')