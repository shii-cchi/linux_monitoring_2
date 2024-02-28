#!/bin/bash

function removing_folders {
    case $METHOD in
        1)
            # Удаление по лог файлу
            delete_from_log
            ;;
        2)
            # Удаление по дате и времени создания
            delete_by_datetime
            ;;
        3)
            # Удаление по маске имени
            delete_by_name_mask
            ;;
    esac
}

function delete_from_log {
    local log_file="../02/log.log"
    # Используем awk для извлечения путей к папкам из лог-файла
    folders=$(awk '{print $1}' "$log_file")

    # Перебираем каждую найденную папку и удаляем её
    for folder in $folders; do
        # Проверяем, является ли строка допустимым путем к папке
        if [ -d "$folder" ]; then
            sudo rm -R "$folder"
        fi
    done
}

function delete_by_datetime {
    read -p "Enter start date and time (in 'YYYY-MM-DD HH:MM:SS' format): " start_datetime
    read -p "Enter end date and time (in 'YYYY-MM-DD HH:MM:SS' format): " end_datetime

    # Преобразуем в UNIX timestamp
    start_timestamp=$(date -d "$start_datetime" +"%s")
    end_timestamp=$(date -d "$end_datetime" +"%s")

    # Ищем и удаляем папки, созданные в заданном промежутке времени в /home и всех его подкаталогах
    sudo find /home -type d -newermt "$start_datetime" ! -newermt "$end_datetime" -exec sudo rm -r {} \; -prune
}

function delete_by_name_mask {
    read -p "Enter name mask for folders (e.g., ab_150224): " folder_name_mask

    # Ищем и удаляем папки с указанной маской в /home и всех его подкаталогах
    sudo find /home -type d -name "*$folder_name_mask*" | grep -E "^.*$(echo "$folder_name_mask" | sed 's/_/[^_]*_/g')[^_]*$" | xargs sudo rm -r
}

