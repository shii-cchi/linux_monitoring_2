#!/bin/bash

function check_param {
    # Проверка количества параметров
    if [ "$#" -ne 1 ]; then
        echo "Error: Insufficient parameters. Please provide all 1 required parameters. Usage: $0 <method_for_monitoring>"
        exit 1
    fi

    METHOD=$1

    if [[ ! "$METHOD" =~ ^[1-4]$ ]]; then
        echo "Error: METHOD should be 1, 2, 3, or 4."
        exit 1
    fi
}