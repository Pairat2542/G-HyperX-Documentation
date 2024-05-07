***Settings***
Library     GRPA
Library     String
Library     Collections
Library     OperatingSystem
Library     DateTime
***Variables***
${vision_key}
${URL_Download}
${Upload_Detail_URL}
${error_message_url}
${Token}
${URL_Upload}
${URL_Success}
${URL_Page_Count}
${URL_create_transaction}
${output_path}
${img_path}
${page}    0
${success_transactions}    0
${total_transactions}    0
${Upload_ID}
${Download_Path}
${Upload_Path}
${pvid}
${label_jcy}
${result}
@{header}
@{csv_list}
@{row}
${out_date}
${part_no}
${p_no}
${quantity}
${uom}
${unitPrice}
${amount}
${desc}
${Company}
${File_Name}
${Page_Count}
@{img_file}
${config}
${addition_config}
${classify_label}
@{error_page}
${error_message}
${error_count}
@{missing_value}
${count_source}    ${0}
${count_invalid}    ${0}
${workspace_path}
${_AdditionData}

***Tasks***
Process Nestle Extractor version 1.0.2 Workflow
    ${runtime} =    Get Current Date    
    ${runtime} =    Add Time To Date    ${runtime}    7 hours    
    Log To Console    Start at ${runtime}
    ${vision_key} =    Get Asset String Variable    vision_key
    ${URL_Download} =    Get Asset String Variable    Download_URL
    ${Upload_Detail_URL} =    Get Asset String Variable    Upload_Detail_URL
    ${Token} =    Get Asset String Variable    Token
    ${error_message_url} =    Get Asset String Variable    Error_Message_URL
    ${URL_Upload} =    Get Asset String Variable    Upload_URL
    ${URL_Success} =    Get Asset String Variable    Success_URL
    ${URL_Page_Count} =    Get Asset String Variable    Page_Count_URL
    ${URL_create_transaction} =    Get Asset String Variable    Create_Transaction_URL
    ${pvid} =    Set Variable    096d9136-a867-4b26-8370-1e4aa1276ea5
    ${addition_config} =    Json To Dict    ${_AdditionData}
    ${start_url} =    Get Asset String Variable    Start_Flow_URL
    Logistics API Request Send Start    ${start_url}    ${addition_config['upload_id']}    ${Token}
    ${workspace_path} =    Get UUID   
    ${workspace_path} =    Set Variable    ${CURDIR}/${workspace_path}/
    Create Directory    ${workspace_path}
    ${output_path} =    Set Variable    ${workspace_path}
    ${img_path} =    Set Variable    ${workspace_path}imgs/
    ${config} =    Logistics API Request Get Upload Detail    ${Upload_Detail_URL}    ${addition_config['upload_id']}    ${Token}
    ${Upload_ID} =    Set Variable    ${config['id']}
    ${Company} =    Set Variable    ${config['in_format']['name']}

    # Label variable area

    ${header} =    Create List

    # CSV Header 
    Append To List    ${header}    Invoice    Date
    ${total_transactions} =    Set Variable    ${0}
    ${success_transactions} =    Set Variable    ${0}

    FOR    ${source}    IN    @{config['files']}
        ${count_source} =    Set Variable    ${count_source+1}
        Log To Console    Source ID : ${source['id']}
        ${Page_Count} =    Set Variable    ${0}
        ${Download_Path} =    Set Variable    ${output_path}${source['name']}
        ${File_Name} =    Set Variable    ${config['ship_type']['name']}_${config['mode']['name']}_${Company}_${config['out_format']['name']}_${source['name']}.csv
        ${File_Name} =    Replace String    ${File_Name}    .pdf    ${EMPTY}
        ${Upload_Path} =    Set Variable    ${output_path}${File_Name}
        @{words} =    Split String    ${source['name']}    .
        ${Company} =    Set Variable    ${words[0]}
        Logistics API Request Download File    ${URL_Download}    ${source['id']}    ${Token}    ${Download_Path}
        Sleep    3s
        Remove Directory    ${img_path}    recursive=${TRUE}
        Create Directory    ${img_path}
        ${response}    Convert PDF To Img    ${Download_Path}    ${page}    ${img_path}    img    jpg    ${6}
        @{img_file}    Get Files Sorted Modified Date   ${img_path}
        ${csv_list} =    Create List
        ${error_page} =    Create List
        Append To List    ${csv_list}    ${header}
        FOR    ${i}    IN    @{img_file}
            Log To Console    ${i}
            ${total_transactions} =    Set Variable     ${total_transactions+1}
            ${invalid_format} =    Set Variable    ${False}
            ${success_create} =    Set Variable    ${True}
            ${create_error_message} =    Set Variable    ${EMPTY}
            TRY
                ${Page_Count} =    Set Variable    ${Page_Count+1}
                ${missing_value} =    Create List
                
                # Invalid page exam
		# IF    ${check_page}
		# 	...
  		# ELSE
		#	Append To List    ${error_page}    ${Page_Count}
                #    	${invalid_format} =    Set Variable    ${True}
		# END

		# Invalid field exam
		# TRY    ${check_page}
		# 	...
  		# EXCEPT
		#	Append To List    ${missing_value}    Invoice date   <- field name
		# END
		
                # Add data row exam
		# ${row} =    Create List
		# Append To List    ${row}    ${inv}    ${inv_date}
  		# Append To List    ${csv_list}    ${row}


                ${missing_length} =    Get Length    ${missing_value}
                IF    "${missing_length}" != "0"
                    ${missing_mesage} =    Join List    ${missing_value}
                    ${error_message} =    Set Variable    ${error_message}${source['name']}: ${inv} missing ${missing_mesage}${\n}
                END
                ${success_transactions} =    Set Variable    ${success_transactions+1}
            EXCEPT    AS    ${er_message}
                Log To Console    ${er_message}
                Append To List    ${error_page}    ${Page_Count}
                ${invalid_format} =    Set Variable    ${True}
                ${success_create} =    Set Variable    ${False}
                ${create_error_message} =    Set Variable    ${er_message}
            END
            Logistics API Request Create Transaction    ${URL_create_transaction}    ${Upload_ID}    ${Token}    ${addition_config['user_id']}    ${addition_config['directory_id']}    ${addition_config['tenant_id']}    ${create_error_message}    ${1}    ${success_create}    UserPageCharge    ${invalid_format}
            Logistics API Request Create Transaction    ${URL_create_transaction}    ${Upload_ID}    ${Token}    ${addition_config['user_id']}    ${addition_config['directory_id']}    ${addition_config['tenant_id']}    ${create_error_message}    ${1}    ${success_create}    BackendOCRCharge    ${invalid_format}
        END
        ${error_count} =    Get Length    ${error_page}
        ${file_count} =    Get Length    ${img_file}
        IF    "${error_count}" == "${file_count}"
            ${count_invalid} =    Set Variable    ${count_invalid+1}
            ${error_message} =    Set Variable    ${error_message}${source['name']} invalid format${\n}
        ELSE IF    "${error_count}" != "0"
            ${string_page} =    Join List    ${error_page}
            ${error_message} =    Set Variable    ${error_message}${source['name']} invalid format at page ${string_page}${\n}
        END
        Write List To CSV    ${Upload_Path}    ${csv_list} 
        
        ${total_ocr_count} =    Get Length    ${img_file}
        Sleep    3s
        Logistics API Request Upload File    ${URL_Upload}  ${Upload_ID}  ${Token}  ${Company}  ${Upload_Path}  ${File_Name} 
        Logistics API Request Send Page Count    ${URL_Page_Count}  ${Upload_ID}  ${Token}  ${Page_Count}
        Remove File    ${Upload_Path}
        Remove Directory    ${img_path}    recursive=${TRUE}
        Remove File    ${Download_Path}
    END
    IF    "${count_source}" == "${count_invalid}"
        Logistics API Request Send Fail Message    ${error_message_url}    ${Upload_ID}    ${Token}    ${error_message}
    ELSE
        TRY
            IF    "${error_message}" == ""
                Logistics API Request Send Success    ${URL_Success}    ${Upload_ID}    ${Token}    ${False}
            ELSE
                Logistics API Request Send Success    ${URL_Success}    ${Upload_ID}    ${Token}    ${True}    ${error_message}
            END
        EXCEPT
            Logistics API Request Send Success    ${URL_Success}    ${Upload_ID}    ${Token}    ${True}    ${error_message}
        END
    END
    Remove Directory    ${workspace_path}    recursive=${TRUE}
