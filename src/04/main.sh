#!/bin/bash

user_agents_file="user_agents.txt"

# Проверка существования файла
if [ ! -f "$user_agents_file" ]; then
    echo "Error: File '$user_agents_file' does not exist."
    exit 1
fi

# Проверка наличия параметров
if [ "$#" -ne 0 ]; then
    echo "Usage: $0"
    echo "This script does not accept any arguments."
    exit 1
fi

# Массивы с вариантами для генерации
methods=("GET" "POST" "PUT" "PATCH" "DELETE")
get_codes=("200" "400" "401" "403" "404" "500" "502" "503")
post_codes=("201" "400" "401" "403" "404" "500" "502" "503")
put_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
patch_codes=("200" "400" "401" "403" "404" "500" "501" "502" "503")
delete_codes=("200" "400" "401" "403" "404" "500" "501" "502" "503")
urls="/about-us /contact /blog /images/logo.png /api/data /login /new-page /products /services /images/banner.jpg /faq /terms /images/header.jpg /downloads/file.zip"

# Дата начала дня
date_start="$(date +%Y)-$(date +%m)-$(date +%d) 00:00:00 $(date +%z)"

# Генерация рандомного IP-адреса в цикле до первого валидного значения
function generate_random_ip {
    while true; do
        generated_ip="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
        if is_valid_ip "$generated_ip"; then
            break
        fi
    done

    echo "$generated_ip"
}

# Проверка валидности IP-адреса 
function is_valid_ip {
    local ip=$1
    # Проверка валидности IP-адреса с использованием утилиты `ipcalc`
    if [[ $(ipcalc -cs $ip 2>&1) == *"INVALID"* ]]; then
        return 1
    else
        return 0
    fi
}

# Генерация рандомного значения из массива значений
function get_random_element {
    local array=("$@")
    local random_index=$((RANDOM % ${#array[@]}))
    echo "${array[$random_index]}"
}

# Генерация рандомного значения кода ответа для соответствующего метода
function get_response_code {
    local method=$1
    local codes=()

    case $method in
        "GET")
            codes=("${get_codes[@]}")
            ;;
        "POST")
            codes=("${post_codes[@]}")
            ;;
        "PUT")
            codes=("${put_codes[@]}")
            ;;
        "PATCH")
            codes=("${patch_codes[@]}")
            ;;
        "DELETE")
            codes=("${delete_codes[@]}")
            ;;
    esac
  
    get_random_element "${codes[@]}"
}

# Генерация логов
for i in {1..5}; do
    # Генерация случайного числа записей от 100 до 1000
    num_records=$((RANDOM % 901 + 100))
    step_seconds=$(shuf -i 10-100 -n1)

    # Генерация лога за 1 день
    for ((j = 0; j < num_records; j++)); do
        # Генерация случайных значений
        ip=$(generate_random_ip)
        method=$(get_random_element "${methods[@]}")
        response_code=$(get_response_code "$method")
        date_new=$(date -d "$date_start + $step_seconds seconds" "+%Y-%m-%d %H:%M:%S %z")
        url="$(shuf -e ${urls}  -n1)"
        user_agent=$(shuf -n 1 "$user_agents_file")

        # Формирование строки лога и запись в файл
        echo "${ip} - - [${date_new}] \"${method} ${url} HTTP/1.1\" ${response_code} - \"${user_agent}\"" >> log_${i}.txt
        ((step_seconds+=$(shuf -i 10-100 -n1) ))
    done
    date_start="$(date +%Y)-$(date +%m)-$(date +%d) 00:00:00 $(date +%z)"
    date_start="$(date -d "$date0 - $((6-$i)) days" +'%Y-%m-%d')" 
done

# 200 OK: Запрос успешно выполнен.
# 201 Created: Запрос успешно выполнен, и ресурс был успешно создан.
# 400 Bad Request: Сервер не может понять запрос из-за некорректного синтаксиса. Клиент должен исправить запрос перед повторением.
# 401 Unauthorized: Требуется аутентификация пользователя для доступа к ресурсу. Клиент должен предоставить правильные учетные данные.
# 403 Forbidden: Сервер понял запрос, но отказывается выполнять его. Клиент не имеет необходимых прав доступа.
# 404 Not Found: Запрашиваемый ресурс не найден на сервере.
# 500 Internal Server Error: Общая ошибка сервера, указывающая на проблемы с сервером, которые могут быть вызваны различными причинами.
# 501 Not Implemented: Сервер не поддерживает функциональность, необходимую для выполнения запроса. Это обычно означает, что сервер не распознает метод запроса.
# 502 Bad Gateway: Сервер, действуя в качестве шлюза или прокси, получил недействительный ответ от вышестоящего сервера.
# 503 Service Unavailable: Сервер временно не может обработать запрос. Это может быть вызвано временным перегрузками сервера или проведением технического обслуживания.