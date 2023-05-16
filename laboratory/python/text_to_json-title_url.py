import json
import os

def convert_to_json(title, url):
    json_data = {
        "title": title,
        "url": url
    }
    return json_data

for file_name in os.listdir():
    if file_name.endswith('.txt'):

        json_file_name = os.path.splitext(file_name)[0] + '.json'

        json_data_list = []
        with open(file_name, 'r', encoding='utf-8') as file:
            lines = file.readlines()
            for i in range(0, len(lines), 3):
                title = lines[i].strip()
                url = lines[i + 1].strip()
                json_data_list.append(convert_to_json(title, url))

        output_json = json.dumps(json_data_list, indent=2, ensure_ascii=False)

        with open(json_file_name, 'w', encoding='utf-8') as output_file:
            output_file.write(output_json)

        print("save to '{json_file_name}'")
        print("operation completed.")