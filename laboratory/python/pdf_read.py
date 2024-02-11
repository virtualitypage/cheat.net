import os
import io
import pdfminer
from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.pdfpage import PDFPage

home_dir = os.path.expanduser("~")

# PDFファイルのパスを指定　{}に.format(home_dir)で取得したファイルパス(/Users/XXXX)を代入している
pdf_path = "{}/Desktop/PDF.pdf".format(home_dir)

# ファイルに書き出すファイルパス
output_file = "{}/Desktop/pdf_text.txt".format(home_dir)

# ファイルが存在するか確認
if os.path.exists(pdf_path):
    # PDFファイルを読み込む
    with open(pdf_path, "rb") as f:
        # PDFリソースマネージャーを作成
        resource_manager = PDFResourceManager()
        # テキストコンバーターを作成
        output_string = io.StringIO()
        text_converter = TextConverter(
            resource_manager, output_string, laparams=LAParams()
        )
        # PDFページインタープリターを作成
        page_interpreter = PDFPageInterpreter(resource_manager, text_converter)

        # PDFファイルの各ページに対して処理を行う
        for page in PDFPage.get_pages(f):
            page_interpreter.process_page(page)

        # 取得したテキストをファイルに書き出す
        with open(output_file, "a", encoding="utf-8") as output_file:
            output_file.write(output_string.getvalue())
else:
    print(f"{pdf_path} does not exist.")
