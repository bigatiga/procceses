#!/bin/bash

# ===== НАСТРОЙКИ =====
CPU_THRESHOLD=70
LOG_FILE="/var/log/process_monitor.log"
AUTO_KILL=false

DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$DATE] ===== START CHECK =====" >> $LOG_FILE

# ===== LOAD AVERAGE =====
LOAD=$(uptime | awk -F'load average:' '{ print $2 }')
echo "[$DATE] Load Average: $LOAD" >> $LOG_FILE

# ===== CPU & MEMORY =====
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_USAGE=$(free | grep Mem | awk '{printf("%.2f"), $3/$2 * 100}')

echo "[$DATE] CPU Usage: $CPU_USAGE%" >> $LOG_FILE
echo "[$DATE] Memory Usage: $MEM_USAGE%" >> $LOG_FILE

# ===== ПРОЦЕССЫ ВЫШЕ ПОРОГА =====
HIGH_CPU_PROCESSES=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | awk -v threshold=$CPU_THRESHOLD '$3 > threshold {print}')

if [ -z "$HIGH_CPU_PROCESSES" ]; then
    echo "[$DATE] No processes above $CPU_THRESHOLD% CPU" >> $LOG_FILE
else
    echo "[$DATE] High CPU Processes Found:" >> $LOG_FILE
    echo "$HIGH_CPU_PROCESSES" >> $LOG_FILE

    if [ "$AUTO_KILL" = true ]; then
        echo "$HIGH_CPU_PROCESSES" | awk '{print $1}' | while read pid; do
            kill -9 $pid
            echo "[$DATE] Killed process $pid" >> $LOG_FILE
        done
    fi

    exit 1
fi

echo "[$DATE] ===== END CHECK =====" >> $LOG_FILE
echo "" >> $LOG_FILE

exit 0
