#!/bin/bash

# Проверка на root-права
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт нужно запускать с правами root. Используйте sudo перед запуском."
   exit 1
fi

echo "Обновление системы и установка time-syncd..."

# Обновление и установка пакетов
apt update -y
apt install -y systemd-timesyncd

# Убедимся, что служба активна и включена
systemctl enable systemd-timesyncd.service
systemctl restart systemd-timesyncd.service

# Проверка статуса службы
if ! systemctl is-active --quiet systemd-timesyncd.service; then
    echo "Ошибка: служба systemd-timesyncd не запущена. Пробуем исправить..."
    systemctl start systemd-timesyncd.service
fi

# Принудительная синхронизация времени
timedatectl set-ntp true

# Проверка успешности синхронизации (ожидание до 30 секунд)
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

# Если синхронизация не удалась, выводим предупреждение
if ! timedatectl | grep -q "synchronized: yes"; then
    echo "Предупреждение: синхронизация времени не удалась. Проверьте подключение к интернету или NTP-серверы."
fi

# Вывод текущего статуса
echo "Текущий статус времени:"
timedatectl
