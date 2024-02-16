#!/bin/bash

# Права на исполнение скриптов
chmod +x *.sh
. ./check_param.sh
. ./create_folders_and_files.sh

# Создание или очистка лог-файла
LOG_FILE="log.log"
> "$LOG_FILE"

# Проверка успешного создания
if [ $? -ne 0 ]; then
    echo "Error: Unable to create log file."
    exit 1
fi

# Начало записи в лог-файл
echo "Start Time: $(date)" > "$LOG_FILE"

# Проверка переданных параметров
check_param $1 $2 $3 $4 $5 $6

# Создание папок и файлов
create_folders_and_files

# Конец записи в лог-файл
echo "End Time: $(date)" >> "$LOG_FILE"