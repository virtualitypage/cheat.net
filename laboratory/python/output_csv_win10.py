import csv
import os

home_dir = os.path.expanduser("~")

text_file = "{}/input.txt".format(home_dir)
csv_file = "{}/output.csv".format(home_dir)

with open(text_file, "r") as f:  # テキストファイルを読み込み、リストに格納
    data = []  # 空行で区切られたデータを格納するためのリスト
    temp = []  # 1つの空行までに含まれる行を一時的に格納するためのリスト。空行に達したらdataリストに追加・リセットされる
    for line in f:  # fファイルオブジェクトから1行ずつ読み込むためのループ。line変数にはファイルから読み込んだ1行の文字列が代入される
        if line.strip():  # 行が空でなければtempに追加
            temp.append(line.strip())  # lineに含まれる改行文字(スペース、タブ、改行など)を取り除いてtempリストに追加する処理
        elif temp:  # 行が空でtempがある場合はdataに追加してtempをリセット
            data.append(temp)  # tempリストに格納された行のリストをdataリストに追加する処理
            temp = []
if temp:  # 空行が1つ以上ある場合はdataリストにデータを追加する処理
    data.append(temp)

# CSVファイルに書き込み
with open(csv_file, "w", newline="") as f:  # output.csvという名前のCSVファイルを新規作成、書き込みモードで開く処理
    writer = csv.writer(f)  # CSVファイルを書き込むためのオブジェクトを作成する関数。引数に書き込み対象のファイルオブジェクトを渡す
    for row in data:  # 行をリストに分割して書き込む
        writer.writerow(  # 引数に渡されたリストやタプルなどの要素をCSVファイルの1行として書き込むためのメソッド
            [col for cols in [line.split() for line in row] for col in cols])

# line.split()で、1行分の文字列を空白文字で分割する
# rowに格納された1行分の文字列が空白文字で分割され、リスト内包表記で[cols for line in row]のように1行分のデータがリスト化される
# colsは1行分の文字列を分割して作成されたリストを指し、colはcolsリスト内の各要素を指す
# 一連の処理でCSVファイルに書き込むために、1行分のデータがフラットなリストを作成する