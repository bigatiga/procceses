#!/bin/bash

echo "Проверка зомби-процессов..."

ZOMBIES=$(ps -eo pid,ppid,user,stat,cmd | awk '$4 ~ /Z/')

if [ -z "$ZOMBIES" ]; then
  echo "Зомби-процессов не найдено."
else
  echo "Найдены зомби-процессы:"
  echo "$ZOMBIES"
fi
