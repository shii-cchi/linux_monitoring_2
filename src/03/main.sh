#!/bin/bash

# Права на исполнение скриптов
chmod +x *.sh
. ./check_param.sh
. ./removing_folders.sh

# Проверка переданных параметров
check_param $1

# Удаление
removing_folders