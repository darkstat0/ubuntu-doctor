#!/bin/bash

# Проверка на root-права
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт нужно запускать с правами root. Используйте sudo перед запуском."
   exit 1
fi

echo "Запуск диагностики и исправления проблемы с логином в Ubuntu..."

# Обновление системы
echo "Обновление системы..."
apt update -y
apt upgrade -y

# Переустановка графической среды (gdm3/lightdm и ubuntu-desktop)
echo "Переустановка графической среды..."
apt install --reinstall -y gdm3 ubuntu-desktop
systemctl set-default graphical.target

# Сброс конфигурации пользователя (если проблема в сессии)
echo "Сброс настроек пользователя..."
for user in /home/*; do
    user=$(basename "$user")
    if [ -d "/home/$user" ]; then
        echo "Сброс настроек для пользователя $user..."
        rm -rf "/home/$user/.Xauthority" "/home/$user/.cache" "/home/$user/.config" 2>/dev/null
        chown "$user:$user" "/home/$user" -R
    fi
done

# Установка и настройка драйверов графики
echo "Установка драйверов графики..."
apt install -y ubuntu-drivers-common
ubuntu-drivers autoinstall

# Проверка и исправление системных логов
echo "Проверка системных логов на ошибки..."
journalctl -xb | grep -i error > /var/log/login_hang_errors.log
echo "Логи ошибок сохранены в /var/log/login_hang_errors.log. Проверьте их для диагностики."

# Перезапуск службы дисплейного менеджера
echo "Перезапуск дисплейного менеджера..."
systemctl restart gdm3

# Если gdm3 не используется, попробуем lightdm
if ! systemctl is-active --quiet gdm3; then
    echo "Переключение на lightdm..."
    apt install -y lightdm
    systemctl disable gdm3
    systemctl enable lightdm
    systemctl start lightdm
fi

echo "Скрипт завершён. Перезагрузите систему: sudo reboot"
echo "Если проблема сохраняется, проверьте /var/log/login_hang_errors.log."
