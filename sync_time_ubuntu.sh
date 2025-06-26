#!/bin/bash

# Проверка на root-права
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт нужно запускать с правами root. Используйте sudo перед запуском."
   exit 1
fi

# Обновление и установка time-syncd
echo "Обновление системы и установка time-syncd..."
apt update -y
apt install -y systemd-timesyncd

# Активация и перезапуск службы
echo "Активация службы time-syncd..."
systemctl enable systemd-timesyncd.service
systemctl restart systemd-timesyncd.service

# Проверка статуса службы
if ! systemctl is-active --quiet systemd-timesyncd.service; then
    echo "Ошибка: служба systemd-timesyncd не запущена. Пробуем исправить..."
    systemctl start systemd-timesyncd.service
fi

# Принудительная синхронизация времени
echo "Включение синхронизации NTP..."
timedatectl set-ntp true

# Проверка успешности синхронизации
echo "Проверка синхронизации времени..."
for i in {1..6}; do
    if timedatectl | grep -q "synchronized: yes"; then
        echo "Время успешно синхронизировано."
        break
    else
        echo "Ожидание синхронизации... Попытка $i/6"
        sleep 5
    fi
done

# Предупреждение при неудаче
if ! timedatectl | grep -q "synchronized: yes"; then
    echo "Предупреждение: синхронизация времени не удалась. Проверьте интернет или NTP-серверы."
fi

# Вывод текущего статуса
echo "Текущий статус времени:"
timedatectl
