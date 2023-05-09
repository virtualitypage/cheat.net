import tkinter as tk
import os

root = tk.Tk()
root.title("Multiple Dropdown Menus")
root.geometry("400x300")

# ファイル名を入力するエントリーとラベルを追加
filename_label = tk.Label(root, text="filename:")
filename_label.grid(row=0, column=0, padx=45, ipady=10)
filename_entry = tk.Entry(root)
filename_entry.grid(row=0, column=1)

# 1つ目のプルダウンメニューと説明文を追加
menu1_label = tk.Label(root, text="Menu 1:")
menu1_label.grid(row=1, column=0, ipady=5)
menu1_options = ["Option 1", "Option 2", "Option 3"]
menu1_variable = tk.StringVar(root)
menu1_variable.set(menu1_options[0])
menu1_dropdown = tk.OptionMenu(root, menu1_variable, *menu1_options)
menu1_dropdown.grid(row=1, column=1)

# 2つ目のプルダウンメニューと説明文を追加
menu2_label = tk.Label(root, text="Menu 2:")
menu2_label.grid(row=3, column=0, ipady=5)
menu2_options = ["Option 4", "Option 5", "Option 6"]
menu2_variable = tk.StringVar(root)
menu2_variable.set(menu2_options[0])
menu2_dropdown = tk.OptionMenu(root, menu2_variable, *menu2_options)
menu2_dropdown.grid(row=3, column=1)

# 3つ目のプルダウンメニューと説明文を追加
menu3_label = tk.Label(root, text="Menu 3:")
menu3_label.grid(row=4, column=0, ipady=5)
menu3_options = ["Option 7", "Option 8", "Option 9"]
menu3_variable = tk.StringVar(root)
menu3_variable.set(menu3_options[0])
menu3_dropdown = tk.OptionMenu(root, menu3_variable, *menu3_options)
menu3_dropdown.grid(row=4, column=1)

# 4つ目のプルダウンメニューと説明文を追加
menu4_label = tk.Label(root, text="Menu 4:")
menu4_label.grid(row=5, column=0, ipady=5)
menu4_options = ["Option 10", "Option 11", "Option 12"]
menu4_variable = tk.StringVar(root)
menu4_variable.set(menu4_options[0])
menu4_dropdown = tk.OptionMenu(root, menu4_variable, *menu4_options)
menu4_dropdown.grid(row=5, column=1)

# 5つ目のプルダウンメニューと説明文を追加
menu5_label = tk.Label(root, text="Menu 5:")
menu5_label.grid(row=6, column=0, ipady=5)
menu5_options = ["Option 13", "Option 14", "Option 15"]
menu5_variable = tk.StringVar(root)
menu5_variable.set(menu5_options[0])
menu5_dropdown = tk.OptionMenu(root, menu5_variable, *menu5_options)
menu5_dropdown.grid(row=6, column=1)

def save_data():
    # ファイルに書き出すデータを作成する
    filename = filename_entry.get()
    # データをファイルに書き出す
    variable1 = menu1_variable.get()
    variable2 = menu2_variable.get()
    variable3 = menu3_variable.get()
    variable4 = menu4_variable.get()
    variable5 = menu5_variable.get()
    with open(filename, 'a') as f:
        f.write('\n')
        f.write(variable1 + '\n')
        f.write(variable2 + '\n')
        f.write(variable3 + '\n')
        f.write(variable4 + '\n')
        f.write(variable5 + '\n')
    message_label.config(text="Saved to {}".format(os.path.abspath(filename)))

# ボタンを追加して、クリックした時にファイルに書き込むようにする
submit_button = tk.Button(root, text="Submit", command=save_data)
submit_button.grid(row=7, column=1, pady=10)

message_label = tk.Label(root, text="")
message_label.grid(row=8, column=1)

root.mainloop()