import json
import os

def json_to_text(json_file, text_file):
    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)

    with open(text_file, 'w', encoding='utf-8') as file:
        for item in data:
            file.write(item['title'] + '\n')
            file.write(item['url'] + '\n\n')

    print(f"{json_file} -> {text_file}")
    print("operation completed.")

for file_name in os.listdir():
    if file_name.endswith('.json'):

        text_file_name = os.path.splitext(file_name)[0] + '.txt'
        json_to_text(file_name, text_file_name)