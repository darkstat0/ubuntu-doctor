#!/bin/bash

# Проверка на root-права
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт нужно запускать с правами root. Используйте sudo перед запуском."
   exit 1
fi

# Обновление системы
echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

# Переустановка ubuntu-desktop
echo "Переустановка ubuntu-desktop..."
sudo apt purge ubuntu-desktop -y
sudo apt install --reinstall ubuntu-desktop -y

# Исправление повреждённых пакетов
echo "Исправление повреждённых пакетов..."
sudo apt install -f -y
sudo dpkg --configure -a

# Установка рекомендуемых драйверов графики
echo "Установка драйверов графики..."
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall

# Очистка кеша
echo "Очистка кеша и временных файлов..."
sudo apt clean
sudo apt autoclean

# Настройка автоматических обновлений
echo "Настройка автоматических обновлений..."
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

echo "Скрипт завершён. Перезагрузите систему для применения изменений."
echo "Перезагрузка: sudo reboot"