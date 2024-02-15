#!/bin/bash

#  Создания папок и файлов
function create_folders_and_files {
    local name_length=${#FOLDER_NAME}
    local offset=0

    ((name_length < 5)) && offset=$((5 - name_length))

    local subfolders_number=100

    path=`get_random_path`

    for ((i = offset; i < (subfolders_number + offset); i++)); do
        local dir_path=$(make_directory $path $i)

        local files_number=$((1 + $RANDOM % 100))
        
        for ((j = 0; j < files_number; j++)); do
            if [[ $(is_over_memory) == "true" ]]; then
                echo "Error: Out of space. At least 1GB of free space is required."
                exit
            else
                make_file $dir_path $j
            fi
        done
    done
}

# Функция для генерации случайного пути
function generate_random_path {
    echo `sudo bash -c "find / -maxdepth 2 -type d -writable | sort -R | tail -1 | grep -v -e "bin" -e "sbin" -e "run""`
}

# Получение случайного действительного пути
function get_random_path {
    until [[ -d "${path}" && ! -L "${path}" ]]; do
        path=$(generate_random_path)
    done
    echo $path
}

# Создание папки
function make_directory {
    local path=$1/$(generate_folder_name $2)_$(get_date)
    sudo mkdir -p $path

    add_log_folder $path $(get_date)
    echo $path
}

# Создание файла
function make_file {
    local baseCharset=${FILE_NAME%%.*}
    local baseLen=${#baseCharset}
    local nameLen=$((baseLen))

    ((nameLen < 5)) && ((nameLen += 5 - nameLen))
    ((nameLen += j))

    local file_name=$(generate_file_name $nameLen)

    add_log_file $1/$file_name $(get_date) $FILE_SIZE_MB
    sudo fallocate -l $FILE_SIZE_MB $1/$file_name
}

# Возвращает текущую дату в формате DDMMYY
function get_date {
    echo $(date +%d%m%y)
}

# Генерация имени для папки
function generate_folder_name {
    local str=$FOLDER_NAME
    local str_length=${#str}
    local max_length=$(( $1 + str_length ))

    for ((i = $str_length; i < $max_length; i++)); do
        str="${str:0:1}${str}" # Добавление символа в строку
        let "str_length+=1"
    done

    echo $str
}

# Генерация имени имя файла
function generate_file_name {
    local str_file=$FILE_NAME

    local ext_charset=${str_file#*.}
    local base_charset=${str_file%%.*}
    local base_max_len=$1

    local base=$base_charset
    local base_len=${#base_charset}

    for ((i = base_len; i < base_max_len; i++)); do
        base="${base:0:1}${base}"
    done

    local ext=$ext_charset
    local strlen_ext=${#ext_charset}
    local max_len_ext=3

    ((max_len_ext < 3)) && max_len_ext=3

    for ((i = strlen_ext; i < max_len_ext; i++)); do
        ext="${ext:0:1}${ext}"
    done

    echo "${base}.${ext}_$(get_date)"
}

# Возвращает свободное место в системе в мегабайтах
function get_free_size {
    echo $(df / -BM | awk '{print $4}' | tail -n 1 | cut -d 'M' -f1)
}

# Проверка закончилось ли свободное место
function is_over_memory {
    (( $(get_free_size) < 1024 )) && echo "true" || echo "false"
}

# Добавление строки в файл лога для файла
function add_log_file {
    local full_path=$1
    local date=$(date +"%d %b %Y %H:%M:%S")
    local size=$3

    echo "$full_path - $date - $size" >>log.txt
}

# Добавление строки в файл лога для папки
function add_log_folder {
    local full_path=$1
    local date=$(date +"%d %b %Y %H:%M:%S")

    echo "$full_path - $date" >> log.txt
}