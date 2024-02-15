#!/bin/bash

function check_param {
    local error_occurred=0

    # Проверка количества параметров
    if [ "$#" -ne 3 ]; then
        echo "Error: Insufficient parameters. Please provide all 6 required parameters. Usage: $0 <folder_name> <file_name> <file_size_kb>"
        exit 1
    fi

    FOLDER_NAME=$1
    FILE_NAME=$2
    FILE_SIZE_MB=$3

    # Проверка, что FOLDER_NAME содержит только английские буквы и не более 7 символов
    if ! [[ "$FOLDER_NAME" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "Error: FOLDER_NAME should contain only English letters and be up to 7 characters long."
        error_occurred=1
    fi

    # Проверка, что FILE_NAME состоит только из английских букв и не более 7 символов для имени и 3 символов для расширения
    if ! [[ "$FILE_NAME" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "Error: FILE_NAME should contain only English letters, have up to 7 characters for the name, and up to 3 characters for the extension."
        error_occurred=1
    fi

    # Проверка, что FILE_SIZE_MB соответствует формату "число+Mb"
    if [[ "$FILE_SIZE_MB" =~ ^[1-9][0-9]*Mb$ ]]; then

        # Извлечение числа из строки (удаляем последние два символа 'Mb')
        size_value=${FILE_SIZE_MB%Mb}

        # Проверка, что число не больше 100
        if [ "$size_value" -gt 100 ]; then
            echo "Error: FILE_SIZE_MB should be no more than 100."
            error_occurred=1
        fi
    else
        echo "Error: FILE_SIZE_MB should be in the format of 'number+Mb' (e.g., 50Mb) and greater than zero."
        error_occurred=1
    fi

    return $error_occurred
}

# Общая проверка, верен ли ввод всех параметров, если есть хотя бы одна ошибка, то скрипт завершает работу
check_param "$@"
if [ $? -ne 0 ]; then
    echo "Error: Some parameter checks failed. Exiting script."
    exit 1
fi
