*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    http://127.0.0.1:5000/
${BROWSER}    Chrome

*** Test Cases ***
Open Product Page
    Open Browser    ${URL}    ${BROWSER}
    Title Should Be    Product Management
    Close Browser

Add Product
    Open Browser    ${URL}    ${BROWSER}
    Input Text    id=product-name    Test Product
    Input Text    id=product-price   100
    Click Button    id=submit-product
    Wait Until Page Contains    Test Product    5s
    Close Browser


Edit Product
    Open Browser    ${URL}    ${BROWSER}
    Click Button    xpath=//tr[td[text()='Test Product']]/td/button[text()='Edit']
    Input Text    id=edit-product-name    Updated Product
    Input Text    id=edit-product-price   150
    Click Button    id=edit-product-button
    Wait Until Page Contains    Updated Product    5s
    Close Browser

Delete Product
    Open Browser    ${URL}    ${BROWSER}
    ${product_id}=    Get Text    xpath=//tr[td[text()='Updated Product']]/td[1]
    Click Button    xpath=//tr[td[text()='Updated Product']]/td/button[text()='Delete']
    Wait Until Page Does Not Contain    ${product_id}    5s
    Close Browser

Add Multiple Products
    Open Browser    ${URL}    ${BROWSER}
    Input Text    id=product-name    Product 1
    Input Text    id=product-price   50
    Click Button    id=submit-product
    Wait Until Page Contains    Product 1    5s
    Input Text    id=product-name    Product 2
    Input Text    id=product-price   75
    Click Button    id=submit-product
    Wait Until Page Contains    Product 2    5s
    Close Browser

Edit Product Price
    Open Browser    ${URL}    ${BROWSER}
    Click Button    xpath=//tr[td[text()='Product 1']]/td/button[text()='Edit']
    Input Text    id=edit-product-price    60
    Click Button    id=edit-product-button
    Wait Until Page Contains    Product 1    5s
    Close Browser

Delete Multiple Products
    Open Browser    ${URL}    ${BROWSER}
    ${product_id1}=    Get Text    xpath=//tr[td[text()='Product 1']]/td[1]
    ${product_id2}=    Get Text    xpath=//tr[td[text()='Product 2']]/td[1]
    Click Button    xpath=//tr[td[text()='Product 1']]/td/button[text()='Delete']
    Wait Until Page Does Not Contain    ${product_id1}    5s
    Click Button    xpath=//tr[td[text()='Product 2']]/td/button[text()='Delete']
    Wait Until Page Does Not Contain    ${product_id2}    5s
    Close Browser


Add Product with Empty Fields 
    Open Browser    ${URL}    ${BROWSER}
    Input Text    id=product-name    ""  # Trường tên sản phẩm trống
    Input Text    id=product-price   ""  # Trường giá sản phẩm trống
    Click Button    id=submit-product
    Wait Until Page Contains    Please fill in all fields.    5s  # Kiểm tra thông báo lỗi
    Close Browser


Add Product with Empty Fields name
    Open Browser    ${URL}    ${BROWSER}
    Input Text    id=product-name   ""  # Trường tên sản phẩm trống
    Input Text    id=product-price  Product without name  # Trường giá sản phẩm trống
    Click Button    id=submit-product
    Wait Until Page Contains    Please fill in all fields.    5s  # Kiểm tra thông báo lỗi
    Close Browser



Add Product with Missing Price
    Open Browser    ${URL}    ${BROWSER}
    Input Text    id=product-name    Product without price
    Input Text    id=product-price   ""  # Trường giá sản phẩm trống
    Click Button    id=submit-product
    Wait Until Page Contains    Please fill in all fields.    5s  # Kiểm tra thông báo lỗi
    Close Browser
