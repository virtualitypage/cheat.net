import os

home_dir = os.path.expanduser("~")

folder_path = "{}/Downloads/chmod755".format(home_dir)

for root, dirs, files in os.walk(folder_path):
    for dir in dirs:
        os.chmod(os.path.join(root, dir), 0o755)  # ディレクトリに読み取り/実行権限を追加
    for file in files:
        os.chmod(os.path.join(root, file), 0o755)  # ファイルに読み取り/実行権限を追加
