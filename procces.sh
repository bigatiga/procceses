#!/bin/bash

echo "===== ВСЕ ПРОЦЕССЫ ====="
ps aux

echo ""
echo "===== ТОП 10 ПО CPU ====="
ps aux --sort=-%cpu | head -n 11

echo ""
echo "===== ТОП 10 ПО ПАМЯТИ ====="
ps aux --sort=-%mem | head -n 11

echo ""
echo "===== ПРОВЕРКА ЗОМБИ ПРОЦЕССОВ ====="
zombies=$(ps aux | awk '{ if ($8=="Z") print $0 }')

if [ -z "$zombies" ]; then
    echo "Зомби процессов нет"
else
    echo "Найдены зомби процессы:"
    echo "$zombies"
fi
