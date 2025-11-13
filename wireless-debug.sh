#!/bin/bash

# React Native Wireless Debug Setup
# Android cihazı kablosuz olarak bağlar

echo "📱 React Native Wireless Debug Kurulumu"
echo "======================================="
echo ""

# Android SDK yolunu ayarla
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Proje dizinine git
cd "$(dirname "$0")"

echo "1️⃣ USB ile bağlı cihazları kontrol ediyorum..."
adb devices
echo ""

# Kullanıcıdan cihazın IP adresini al
echo "2️⃣ Android cihazınızın IP adresini bulun:"
echo "   Ayarlar → Hakkında → Durum → IP adresi"
echo ""
read -p "Cihazın IP adresini girin: " device_ip

if [ -z "$device_ip" ]; then
    echo "❌ IP adresi boş olamaz!"
    exit 1
fi

echo ""
echo "3️⃣ ADB'yi TCP/IP moduna geçiriyorum..."
adb tcpip 5555

echo ""
echo "4️⃣ Kabloyu çıkarabilirsiniz."
echo "   Devam etmek için Enter'a basın..."
read

echo ""
echo "5️⃣ Kablosuz bağlantı kuruluyor: $device_ip:5555"
adb connect "$device_ip:5555"

echo ""
echo "6️⃣ Bağlı cihazlar:"
adb devices
echo ""

echo "✅ Kurulum tamamlandı!"
echo ""
echo "📋 Kullanım:"
echo "   - VS Code'da F5'e basın veya Debug menüsünden 'Debug Android' seçin"
echo "   - Veya: ./run-dev.sh ile uygulamayı başlatın"
echo ""
echo "🔌 Kablosuz bağlantıyı kesmek için:"
echo "   adb disconnect $device_ip:5555"
echo ""
echo "🔄 USB'ye geri dönmek için:"
echo "   adb usb"
