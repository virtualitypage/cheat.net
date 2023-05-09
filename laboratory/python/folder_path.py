import os

home_dir = os.path.expanduser("~")

# ファイル名とディレクトリ名を取得するディレクトリのパス
dir_path = "{}/Desktop/フォルダ".format(home_dir)

# ファイルに書き出すファイルパス
output_file = "{}/Desktop/フォルダ構成.txt".format(home_dir)

# ファイル名とディレクトリ名の一覧を再帰的に取得する関数
def get_files_and_dirs_recursive(path):
    files_and_dirs = []
    for entry in os.listdir(path):
        full_path = os.path.join(path, entry)
        if os.path.isfile(full_path):
            files_and_dirs.append(full_path)
        elif os.path.isdir(full_path):
            files_and_dirs.append(full_path + "/*")
            files_and_dirs.extend(get_files_and_dirs_recursive(full_path))
    return files_and_dirs

# ファイル名とディレクトリ名の一覧を取得
files_and_dirs = get_files_and_dirs_recursive(dir_path)

# ファイルに書き出す
with open(output_file, "w") as f:
    for file_or_dir in files_and_dirs:
        f.write(file_or_dir + "\n")


# def get_files_and_dirs_recursive(path):
# 指定されたパス内のすべてのファイルとディレクトリのリストを取得し、再帰的にサブディレクトリ内のすべてのファイルとディレクトリも取得する

# forループはリスト内の各要素を順番に処理する。

# for entry in os.path.isdir(path):
# 各エントリがファイルかディレクトリかを判断する

# full_path = os.path.join(path, entry)
# 親ディレクトリと各エントリのパスを連結して、各ファイルとディレクトリのフルパスを取得する

# os.path.isfile(full_path):　引数として渡されたパスがファイルかどうかを判定する関数
# "full_path"に指定されたパスがファイルである場合にのみ実行される

# os.path.isdir(full_path):　引数として渡されたパスがディレクトリかどうかを判定する関数
# "full_path"に指定されたパスが取得したディレクトリである場合にのみ実行される

# files_and_dirs.append(full_path + '/*')
# ディレクトリであることを示し、そのディレクトリにあるすべてのファイルやディレクトリを表す

# files_and_dirs.extend(get_files_and_dirs_recursive(full_path))
# full_pathがディレクトリである場合に"get_files_and_dirs_recursive()"関数を呼び出して、その中にあるすべてのファイルやディレクトリのパスを取得する
# 得られたリストを"files_and_dirs"リストに追加することで、再帰的に探索したディレクトリ内のファイルやディレクトリのフルパスをリストに追加する。
# 指定されたディレクトリのファイル構造全体を取得することができる

# return files_and_dirs
# "get_files_and_dirs_recursive()"関数から取得したファイルとディレクトリのリスト"files_and_dirs"を、呼び出し元に返す処理

# for file_or_dir in files_and_dirs:
# "files_and_dirs"は指定されたディレクトリ内のすべてのファイルとディレクトリのリストで、各要素は"file_or_dir"に代入される

# f.write(file_or_dir + '\n')
# "file_or_dir"にはforループで代入された要素が入る
# ファイル名とディレクトリ名の間には改行を挿入して、ファイルに書き出される各行が新しい行になるようにしている
