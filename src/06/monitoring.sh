#!/bin/bash

function monitoring {
    case $1 in
    1)
        # Все записи, отсортированные по коду ответа
        sudo goaccess -p /etc/goaccess ../04/log_*.log --sort-panel=STATUS_CODES,BY_DATA,ASC --date-format=%d/%b/%Y --log-format='%h %^ %^ [%d:%t %^] \"%r\" %s %b %^ %u' --time-format=%T -o "report_$1.html"
        ;;
    2)
        # Все уникальные IP, встречающиеся в записях
        sudo goaccess -p /etc/goaccess ../04/log_*.log --sort-panel=VISITORS,BY_VISITORS,ASC --date-format=%d/%b/%Y --log-format='%h %^ %^ [%d:%t %^] \"%r\" %s %b %^ %u' --time-format=%T -o "report_$1.html"
        ;;
    3)
        # Все запросы с ошибками (код ответа - 4xx или 5xx)
        sudo goaccess -p /etc/goaccess ../04/log_*.log --ignore-status=200 --ignore-status=201 --sort-panel=REQUESTS,BY_DATA,ASC --date-format=%d/%b/%Y --log-format='%h %^ %^ [%d:%t %^] \"%r\" %s %b %^ %u' --time-format=%T -o "report_$1.html"
        ;;
    4)
        # Все уникальные IP, которые встречаются среди ошибочных запросов
        sudo goaccess -p /etc/goaccess ../04/log_*.log --ignore-status=200 --ignore-status=201 --sort-panel=VISITORS,BY_VISITORS,ASC --date-format=%d/%b/%Y --log-format='%h %^ %^ [%d:%t %^] \"%r\" %s %b %^ %u' --time-format=%T -o "report_$1.html"
        ;;
    esac
}

