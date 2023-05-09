import os

home_dir = os.path.expanduser("~")

# フォルダのパスを指定　{}に.format(home_dir)で取得したファイルパス(/Users/XXXX)を代入している
folder_path = "{}".format(home_dir)

# ファイルに書き出すファイルパス
output_file = "{}/Desktop/users.txt".format(home_dir)

# フォルダ内の全ファイルとフォルダのパスを再帰的に取得
file_list = []
for root, dirs, files in os.walk(folder_path):
    for file in files:
        file_list.append(os.path.join(root, file))
    for dir in dirs:
        file_list.append(os.path.join(root, dir))

# 結果をファイルに書き出す
with open(output_file, "w") as f:
    for file in file_list:
        f.write(file + "\n")
