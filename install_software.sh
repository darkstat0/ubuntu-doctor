#!/bin/bash

# Проверяем, что скрипт запущен с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами суперпользователя (sudo)"
  exit 1
fi

# Обновление системы
echo "Обновление системы..."
apt update && apt upgrade -y

# Установка необходимых утилит
echo "Установка утилит..."
apt install -y wget curl apt-transport-https software-properties-common

# Добавление репозитория Google Chrome и установка
echo "Установка Google Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt update
apt install -y google-chrome-stable

# Установка Telegram Desktop
echo "Установка Telegram Desktop..."
apt install -y telegram-desktop

# Добавление репозитория Visual Studio Code и установка
echo "Установка Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
rm -f packages.microsoft.gpg
apt update
apt install -y code

# Установка дополнительных популярных программ
echo "Установка дополнительных программ..."
apt install -y vlc gimp filezilla

# Очистка кэша и ненужных пакетов
echo "Очистка системы..."
apt autoremove -y
apt autoclean

echo "Установка завершена!"
