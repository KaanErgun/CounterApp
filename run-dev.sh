#!/bin/bash

# React Native Sayaç Uygulaması - Dev Mode
# Bu script uygulamayı development modunda başlatır

echo "🚀 React Native Sayaç Uygulaması başlatılıyor..."
echo ""

# Android SDK yolunu ayarla
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# Proje dizinine git
cd "$(dirname "$0")"

# Bağlı cihazları kontrol et
echo "📱 Bağlı cihazlar kontrol ediliyor..."
adb devices
echo ""

# Metro bundler'ı arka planda başlat
echo "🔄 Metro bundler başlatılıyor..."
npx react-native start &
METRO_PID=$!

# Metro'nun başlaması için bekle
sleep 5

# Android uygulamasını çalıştır
echo "📦 Uygulama Android cihaza yükleniyor..."
npx react-native run-android

# Script sonlandığında Metro'yu da durdur
trap "kill $METRO_PID 2>/dev/null" EXIT

echo ""
echo "✅ Uygulama başarıyla başlatıldı!"
echo "Metro bundler PID: $METRO_PID"
echo ""
echo "Durdurmak için Ctrl+C tuşlarına basın"

# Metro'nun çalışmasını bekle
wait $METRO_PID
