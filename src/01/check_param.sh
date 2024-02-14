#!/bin/bash

check_param() {
    local error_occurred=0

    # Проверка количества параметров
    if [ "$#" -ne 6 ]; then
        echo "Error: Insufficient parameters. Please provide all 6 required parameters. Usage: $0 <absolute_path> <folders_number> <folder_name> <files_number> <file_name> <file_size_kb>"
        exit 1
    fi

    ABSOLUTE_PATH=$1
    FOLDERS_NUMBER=$2
    FOLDER_NAME=$3
    FILES_NUMBER=$4
    FILE_NAME=$5
    FILE_SIZE_KB=$6

    # Проверка существования пути
    if [ ! -d "$ABSOLUTE_PATH" ]; then
        echo "Error: The specified path does not exist."
        error_occurred=1
    fi

    # Проверка, что FOLDERS_NUMBER является числовым значением
    if ! [[ "$FOLDERS_NUMBER" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: FOLDERS_NUMBER should be a non-zero numeric value."
        error_occurred=1
    fi

    # Проверка, что FOLDER_NAME содержит только английские буквы и не более 7 символов
    if ! [[ "$FOLDER_NAME" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "Error: FOLDER_NAME should contain only English letters and be up to 7 characters long."
        error_occurred=1
    fi

    # Проверка, что FILES_NUMBER является числовым значением
    if ! [[ "$FILES_NUMBER" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: FILES_NUMBER should be a non-zero numeric value."
        error_occurred=1
    fi

    # Проверка, что FILE_NAME состоит только из английских букв и не более 7 символов для имени и 3 символов для расширения
    if ! [[ "$FILE_NAME" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "Error: FILE_NAME should contain only English letters, have up to 7 characters for the name, and up to 3 characters for the extension."
        error_occurred=1
    fi

    # Проверка, что FILE_SIZE_KB соответствует формату "число+kb"
    if ! [[ "$FILE_SIZE_KB" =~ ^[1-9][0-9]*kb$ ]]; then
        echo "Error: FILE_SIZE_KB should be in the format of 'number+kb' (e.g., 50kb) and greater than zero."
        error_occurred=1
    fi

    # Извлечение числа из строки (удаляем последние два символа 'kb')
    size_value=${FILE_SIZE_KB%kb}

    # Проверка, что число не больше 100
    if [ "$size_value" -gt 100 ]; then
        echo "Error: FILE_SIZE_KB should be no more than 100."
        error_occurred=1
    fi

    return $error_occurred
}

check_param "$@"
if [ $? -ne 0 ]; then
    echo "Error: Some parameter checks failed. Exiting script."
    exit 1
fi
