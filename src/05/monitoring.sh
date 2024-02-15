#!/bin/bash

log_files=(../04/log_1.txt ../04/log_2.txt ../04/log_3.txt ../04/log_4.txt ../04/log_5.txt)

function monitoring {
    case $1 in
    1)
        # Все записи, отсортированные по коду ответа
        sort_by_response_code
        ;;
    2)
        # Все уникальные IP, встречающиеся в записях
        unique_ips
        ;;
    3)
        # Все запросы с ошибками (код ответа - 4xx или 5xx)
        requests_with_errors
        ;;
    4)
        # Все уникальные IP, которые встречаются среди ошибочных запросов
        unique_ips_with_errors
        ;;
    esac
}

function sort_by_response_code {
    > sort_log_1.txt

    codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")

    # Используем awk для сортировки записей по коду ответа
    for code in "${codes[@]}"; do
        awk -v code="$code" '$10 == code' "${log_files[@]}" >> sort_log_1.txt
    done
}

function unique_ips {
    > sort_log_2.txt

    # Используем awk для для извлечения первого столбца и получения уникальных значений ip
    awk '!seen[$1]++ {print $1}' "${log_files[@]}" >> sort_log_2.txt
}

function requests_with_errors {
    > sort_log_3.txt

    codes=("400" "401" "403" "404" "500" "501" "502" "503")

    # Используем awk для выбора записей с заданными кодами ответа
    for code in "${codes[@]}"; do
        awk -v code="$code" '$10 == code' "${log_files[@]}" >> sort_log_3.txt
    done
}

function unique_ips_with_errors {
    > sort_log_4.txt

    codes=("400" "401" "403" "404" "500" "501" "502" "503")

    # Используем awk для выбора уникальных IP среди записей с заданными кодами ответа
    for code in "${codes[@]}"; do
        awk -v code="$code" '$10 == code {print $1}' "${log_files[@]}" | awk '!a[$0]++' >> sort_log_4.txt
    done
}