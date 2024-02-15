#!/bin/bash\

# Права на исполнение скриптов
chmod +x *.sh
. ./check_param.sh
. ./monitoring.sh

# Проверка переданных параметров
check_param $1

# Мониторинг логов
monitoring $1