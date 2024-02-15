#!/bin/bash

function check_param {
    # Проверка количества параметров
    if [ "$#" -ne 1 ]; then
        echo "Error: Insufficient parameters. Please provide all 1 required parameters. Usage: $0 <method_for_removing>"
        exit 1
    fi

    METHOD=$1

    if [[ ! "$METHOD" =~ ^[1-3]$ ]]; then
        echo "Error: METHOD should be 1, 2, or 3."
        exit 1
    fi
}