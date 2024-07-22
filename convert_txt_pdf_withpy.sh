#!/bin/bash

# Check if Python is installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 could not be found"
    exit
fi

# Check if pip is installed
if ! command -v pip &> /dev/null
then
    echo "pip could not be found"
    exit
fi

# Install fpdf if not already installed
pip show fpdf &> /dev/null
if [ $? -ne 0 ]; then
    echo "Installing fpdf..."
    pip install fpdf
fi

# Python script to convert TXT to PDF
read -r -d '' PYTHON_SCRIPT << EOM
from fpdf import FPDF

class PDF(FPDF):
    def header(self):
        self.set_font('Arial', 'B', 12)
        self.cell(0, 10, 'Text to PDF Conversion', 0, 1, 'C')

    def footer(self):
        self.set_y(-15)
        self.set_font('Arial', 'I', 8)
        self.cell(0, 10, f'Page {self.page_no()}', 0, 0, 'C')

    def chapter_title(self, title):
        self.set_font('Arial', 'B', 12)
        self.cell(0, 10, title, 0, 1, 'L')
        self.ln(10)

    def chapter_body(self, body):
        self.set_font('Arial', '', 12)
        self.multi_cell(0, 10, body)
        self.ln()

def txt_to_pdf(input_file, output_file):
    pdf = PDF()
    pdf.add_page()

    with open(input_file, 'r') as file:
        content = file.read()

    pdf.chapter_title('Text Content')
    pdf.chapter_body(content)

    pdf.output(output_file)

# Usage
import sys
if len(sys.argv) != 3:
    print("Usage: python txt_to_pdf.py input.txt output.pdf")
else:
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    txt_to_pdf(input_file, output_file)
EOM

# Write the Python script to a temporary file
echo "$PYTHON_SCRIPT" > txt_to_pdf.py

# Run the Python script with input and output arguments
python3 txt_to_pdf.py "$1" "$2"

# Remove the temporary Python script
rm txt_to_pdf.py

echo "Conversion completed: $2"
