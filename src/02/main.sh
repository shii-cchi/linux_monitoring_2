#!/bin/bash

# Права на исполнение скриптов
chmod +x *.sh
. ./check_param.sh
. ./create_folders_and_files.sh

# Создание или очистка лог-файла
LOG_FILE="log.txt"
> "$LOG_FILE"

# Проверка успешного создания
if [ $? -ne 0 ]; then
    echo "Error: Unable to create log file."
    exit 1
fi

# Начало записи в лог-файл
start_time=$(date)
echo "Start Time: $(date)" > "$LOG_FILE"

# Проверка переданных параметров
check_param $1 $2 $3

# Создание папок и файлов
create_folders_and_files

# Конец записи в лог-файл
end_time=$(date)
echo "End Time: $(date)" >> "$LOG_FILE"

# Общее время работы скрипта
start_timestamp=$(date -u -d "$start_time" +"%s")
end_timestamp=$(date -u -d "$end_time" +"%s")
elapsed_time=$((end_timestamp - start_timestamp))
echo "Elapsed Time: $elapsed_time seconds" >> "$LOG_FILE"

# Вывод в консоль
echo "Start Time: $start_time"
echo "End Time: $end_time"
echo "Elapsed Time: $elapsed_time seconds"