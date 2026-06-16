import win32com.client
import fitz  # PyMuPDF
import os
import sys
import shutil
import uuid

def docx_to_png(docx_path, output_dir=None):
    docx_path = os.path.abspath(docx_path)
    if not os.path.exists(docx_path):
        print(f"Error: docx file not found at {docx_path}")
        return False

    if output_dir is None:
        output_dir = os.path.dirname(docx_path)
    output_dir = os.path.abspath(output_dir)
    os.makedirs(output_dir, exist_ok=True)

    base_name = os.path.splitext(os.path.basename(docx_path))[0]

    # 一時ファイル用のASCIIパスを用意（win32comのマルチバイト文字パス問題を回避するため）
    temp_id = str(uuid.uuid4())
    temp_dir = os.path.join(os.environ.get("TEMP", "c:\\temp"), f"docx_conv_{temp_id}")
    os.makedirs(temp_dir, exist_ok=True)

    temp_docx = os.path.join(temp_dir, "input.docx")
    temp_pdf = os.path.join(temp_dir, "output.pdf")

    shutil.copy2(docx_path, temp_docx)

    word = None
    try:
        # 1. DOCX -> PDF
        word = win32com.client.Dispatch("Word.Application")
        word.Visible = False
        
        doc = word.Documents.Open(temp_docx)
        doc.SaveAs(temp_pdf, FileFormat=17) # wdFormatPDF
        doc.Close()
        word.Quit()
        word = None
        
    except Exception as e:
        print(f"Error converting DOCX to PDF: {e}")
        if word:
            try:
                word.Quit()
            except:
                pass
        shutil.rmtree(temp_dir, ignore_errors=True)
        return False

    # 2. PDF -> PNG (PyMuPDF)
    try:
        pdf_doc = fitz.open(temp_pdf)
        generated_images = []
        for page_num in range(len(pdf_doc)):
            page = pdf_doc.load_page(page_num)
            zoom = 2.0  # 高解像度
            mat = fitz.Matrix(zoom, zoom)
            pix = page.get_pixmap(matrix=mat)
            
            out_png_name = f"{base_name}_page{page_num+1}.png"
            out_png_path = os.path.join(output_dir, out_png_name)
            
            pix.save(out_png_path)
            generated_images.append(out_png_path)
            print(f"Saved page {page_num+1} to {out_png_path}")
            
        pdf_doc.close()
        return generated_images
        
    except Exception as e:
        print(f"Error rendering PDF to PNG: {e}")
        return False
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python docx_to_png.py [path_to_docx] [optional_output_dir]")
        sys.exit(1)
        
    docx = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else None
    
    res = docx_to_png(docx, out_dir)
    if not res:
        sys.exit(1)
    print("Successfully generated images.")
