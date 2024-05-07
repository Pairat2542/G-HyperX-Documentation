# GRPA Documentation
## Starts With
Check string starts with some string return True/False

#### Arguments
- wording : Full string
- value : Keyword
  
#### Example
```robotframework
${full_string} =    Set Variable    Gable company
${key} =    Set Variable    Gable
${out} =    Starts With    ${full_string}    ${key}
# result is True
```
##
## Ends With
Check string ends with some string return True/False

#### Arguments
- wording : Full string
- value : Keyword
  
#### Example
```robotframework
${full_string} =    Set Variable    Gable company
${key} =    Set Variable    company
${out} =    Ends With    ${full_string}    ${key}
# result is True
```
##
## Isnumeric
Check string in number format return True/False

#### Arguments
- wording : Keyword
  
#### Example
```robotframework
${key} =    Set Variable    1325.13
${out} =    Isnumeric    ${key}
# result is True
```
##
## Isalpha
Check string in alpha format return True/False

#### Arguments
- wording : Keyword
  
#### Example
```robotframework
${key} =    Set Variable    Abcde
${out} =    Isalpha    ${key}
# result is True
```
##
## Indexof
Find index of keyword in full string return start index of keyword in Integer format. If keyword not found return -1

#### Arguments
- word : Full string
- search : keyword to search
  
#### Example
```robotframework
${full_string} =    Set Variable    I'm working at my home
${key} =    Set Variable    my
${out} =    Indexof    ${full_string}    ${key}
# result is 15
```
```robotframework
${full_string} =    Set Variable    I'm working at my home
${key} =    Set Variable    hi
${out} =    Indexof    ${full_string}    ${key}
# result is -1
```
##
## Join List
Join value in list to string

#### Arguments
- collections : List of some data
- center : string between data when join list (defualt: ,)
  
#### Example
```robotframework
${list} =    Create List    Dog    Cat    Fish    Bird
${out} =    Join List    ${list}
# result : Dog,Cat,Fish,Bird
```
```robotframework
${list} =    Create List    Dog    Cat    Fish    Bird
${out} =    Join List    ${list}    -
# result : Dog-Cat-Fish-Bird
```
##
## Json To Dict
Convert JSON string to dictionary

#### Arguments
- jsonstr : JSON string
  
#### Example
```robotframework
${out} =    Json To Dict    ${json} 
```
##
## Get Asset String Variable
Get asset value from G-HyperX and convert to String variable

#### Arguments
- vname : Asset name
  
#### Example
```robotframework
${asset_name} =    Set Variable    input_folder
${out} =    Get Asset String Variable    ${asset_name} 
```
##
## Get Asset Integer Variable
Get asset value from G-HyperX and convert to Integer variable

#### Arguments
- vname : Asset name
  
#### Example
```robotframework
${asset_name} =    Set Variable    input_number
${out} =    Get Asset Integer Variable    ${asset_name} 
```
##
## Get Asset Float Variable
Get asset value from G-HyperX and convert to Float variable

#### Arguments
- vname : Asset name
  
#### Example
```robotframework
${asset_name} =    Set Variable    input_number
${out} =    Get Asset Float Variable    ${asset_name} 
```
##
## Google Vision Get OCR Text
Get full text from Google OCR

#### Arguments
- api_key : Google vision key
- file_path : Input file to OCR
  
#### Example
```robotframework
${key} =    Set Variable    Abxdftg735r123
${input} =    Set Variable    c:\input\img.jpg
${out} =    Google Vision Get OCR Text    ${key}    ${input}
```
##
## Google Vision Get OCR Text With Vertex
Get text and vertex for each word from Google OCR 

#### Arguments
- api_key : Google vision key
- file_path : Input file to OCR
  
#### Example
```robotframework
${key} =    Set Variable    Abxdftg735r123
${input} =    Set Variable    c:\input\img.jpg
${out} =    Google Vision Get OCR Text With Vertex    ${key}    ${input}
```
##
## Google Vision Get OCR Text With Label
Send input file to Google OCR and match word in area from labels. return list of labels and word in area for each label

#### Arguments
- api_key : Google vision key
- file_path : Input file to OCR
- labels : labels generate from g-hyperx
  
#### Example
```robotframework
${key} =    Set Variable    Abxdftg735r123
${input} =    Set Variable    c:\input\img.jpg
${label} =    Set Variable    [{"label":"inv","start":{"x":100,"y":100},"end":{"x":200,"y":200}},{"label":"date","start":{"x":300,"y":300},"end":{"x":400,"y":400}}]
${out} =    Google Vision Get OCR Text With Label    ${key}    ${input}    ${label}
# Result : {"inv": ["ABC", "12345"], "date": ["30", "/", "05", "/", "2024"]}
```
##
## Match Area
Match word in area from labels and OCR result. Work with "Google Vision Get OCR Text With Vertex" function 

#### Arguments
- vertexs : OCR result from "Google Vision Get OCR Text With Vertex" function 
- labels : labels generate from g-hyperx
- skipx : number of pixels to slide in horizontal (defualt: 0)
- skipy : number of pixels to slide in vertical (defualt: 0)
- full_response : result mode. if True return match word with vertex. if False return match word. (defualt: False)
  
#### Example
```robotframework
${key} =    Set Variable    Abxdftg735r123
${input} =    Set Variable    c:\input\img.jpg
${label} =    Set Variable    [{"label":"inv","start":{"x":100,"y":100},"end":{"x":200,"y":200}},{"label":"date","start":{"x":300,"y":300},"end":{"x":400,"y":400}}]
${ocr_result} =    Google Vision Get OCR Text With Vertex    ${key}    ${input}
${result} =    Match Area    ${ocr_result}    ${label}
# Result : {"inv": ["ABC", "12345"], "date": ["30", "/", "05", "/", "2024"]}
```
```robotframework
${key} =    Set Variable    Abxdftg735r123
${input} =    Set Variable    c:\input\img.jpg
${label} =    Set Variable    [{"label":"inv","start":{"x":100,"y":100},"end":{"x":200,"y":200}}]
${ocr_result} =    Google Vision Get OCR Text With Vertex    ${key}    ${input}
${result} =    Match Area    ${ocr_result}    ${label}    0    0    ${True}
# Result : {"inv": [{"description":"ABC", "vertices":[{x:110, y:110},{x:120, y:110},{x:120, y:120},{x:110, y:120}]}]}
```
##
## OCR Text Concat With Space Size
Concat string from match area full response mode with horizontal size

#### Arguments
- vertexs : result from match area full response mode
- space_x : horizontal size to add space
  
#### Example
```robotframework
...
${match_area_result} =    Match Area    ${ocr_result}    ${label}
${result} =    OCR Text Concat With Space Size    ${match_area_result}    10
# Result : ABC12345 12
```
##
## OCR Text Concat Average Size
Concat string from match area full response mode with auto horizontal size (not stable)

#### Arguments
- vertexs : result from match area full response mode
- space_x : horizontal size to add space
  
#### Example
```robotframework
...
${match_area_result} =    Match Area    ${ocr_result}    ${label}
${result} =    OCR Text Concat With Space Size    ${match_area_result}
# Result : ABC12345 12
```
##
## Sorted Vertexs To List
Sorted vertex from OCR result to 2-dimention list. first dimention is for each line. second dimention is for each word in line.

#### Arguments
- vertexs : result from Google OCR
- space_x : horizontal size
- space_y : vertical size
  
#### Example
```robotframework
...
${ocr_result} =    Google Vision Get OCR Text With Vertex    ${key}    ${input}
${result} =    Sorted Vertexs To List    ${ocr_result}    10    20
# Result : [["invoice",":","abc","12345"],["Date",":","30","/","05","/","2024"]]
```
##
## Sorted Vertexs By Line
Sorted vertex from OCR result by vertical size. return list of vertex like a result from OCR

#### Arguments
- vertexs : result from Google OCR
- space_y : vertical size
  
#### Example
```robotframework
...
${ocr_result} =    Google Vision Get OCR Text With Vertex    ${key}    ${input}
${result} =    Sorted Vertexs To List    ${ocr_result}    20
```
##
## Write List To CSV
Write list collection to csv file

#### Arguments
- file_name : CSV path and file name
- data : list of data (2-dimention list)
- encode : encode to write csv (defualt: utf-8-sig)
  
#### Example
```robotframework
...
${filename} =    Set Variable    c:\output\result.csv
${result} =    Write List To CSV    ${filename}     ${output_list}
```
##
## Convert PDF To Img
Convert for each page in PDF file to img file. return convert status success or error message

#### Arguments
- pdf_path : Path of input PDF
- pages : page number to convert. if 0 : convert all pages. if has - (1-5, 10-20) : convert page range. if has 1 number (4, 10) : Convert specific page
- output_path : Path to save img
- file_name : name of image file (defualt: "img")
- format_file : format of image file (defualt: "jpg")
- scale : resolution multiply (defualt: 300/72)
  
#### Example
```robotframework
...
${pdf} =    Set Variable    c:\input\doc.pdf
${out_path} =    Set Variable    c:\img\
${status} =    Convert PDF To Img    ${pdf}     0     ${out_path}
```
```robotframework
...
${pdf} =    Set Variable    c:\input\doc.pdf
${out_path} =    Set Variable    c:\img\
${status} =    Convert PDF To Img    ${pdf}     0     ${out_path}    img    jpg    ${6} # resolution multipy is 6
```
##
## Get PDF Full Text
Read full text from PDF (Without using OCR). return list of full text foreach pages of PDF

#### Arguments
- pdf_path : Path of input PDF
  
#### Example
```robotframework
...
${pdf} =    Set Variable    c:\input\doc.pdf
${status} =    Get PDF Full Text    ${pdf}
```
##
## Get PDF Full Text By Page
Read full text from PDF (Without using OCR) by specific page. return string of full text

#### Arguments
- pdf_path : Path of input PDF
- page : number of page to get full text
  
#### Example
```robotframework
...
${pdf} =    Set Variable    c:\input\doc.pdf
${status} =    Get PDF Full Text By Page    ${pdf}    5
```
##
