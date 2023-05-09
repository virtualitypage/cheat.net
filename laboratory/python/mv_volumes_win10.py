import os
import shutil

home_dir = os.path.expanduser("~")

src_folder = "F:\Mac\python"  # 防犯カメラ用レコーダーの内蔵HDDのパス

# フォルダのパスを指定　{}に.format(home_dir)で取得したファイルパス(/Users/XXXX)を代入している
dest_folder = "{}".format(home_dir)  # 外付けHDDのパス

# 指定したフォルダ内の各ファイルに対してforループで処理を行う
for file_name in os.listdir(src_folder):
    # 指定したファイルパスとファイル名を、OSに合わせて有効なファイルパスに変換する
    src_path = os.path.join(src_folder, file_name)
    dest_path = os.path.join(dest_folder, file_name)

    # ファイルのメタデータを保持しつつ、コピー先にデータをコピーする
    shutil.copy2(src_path, dest_path)