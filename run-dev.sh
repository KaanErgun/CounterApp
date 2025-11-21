#!/bin/bash

# React Native Sayaç Uygulaması - Dev Mode
# Bu script uygulamayı development modunda başlatır

set -e  # Hata durumunda scripti durdur

echo "🚀 React Native Sayaç Uygulaması başlatılıyor..."
echo ""

# Android SDK yolunu ayarla
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# Proje dizinine git
cd "$(dirname "$0")"

# Node modüllerinin kurulu olup olmadığını kontrol et
if [ ! -d "node_modules" ]; then
    echo "📦 Node modülleri bulunamadı, yükleniyor..."
    npm install
    echo ""
fi

# Bağlı cihazları kontrol et
echo "📱 Bağlı cihazlar kontrol ediliyor..."
DEVICES=$(adb devices | grep -w "device" | wc -l)

if [ $DEVICES -eq 0 ]; then
    echo "⚠️  Hiç cihaz bulunamadı!"
    echo "   Lütfen bir Android cihaz veya emülatör bağlayın."
    echo ""
    echo "   Emülatör başlatmak için:"
    emulator -list-avds 2>/dev/null || echo "   (Emülatör bulunamadı)"
    exit 1
fi

adb devices
echo ""

# Kullanıcıya seçenek sun
echo "Çalıştırma modu seçin:"
echo "1) Normal başlat (Metro + App)"
echo "2) Cache temizleyerek başlat"
echo "3) Sadece Metro bundler başlat"
echo "4) Sadece uygulamayı yükle (Metro zaten çalışıyor)"
read -p "Seçiminiz (1-4) [1]: " choice
choice=${choice:-1}

echo ""

case $choice in
    1)
        # Metro bundler'ı arka planda başlat
        echo "🔄 Metro bundler başlatılıyor..."
        npx react-native start &
        METRO_PID=$!
        
        # Metro'nun başlaması için bekle
        echo "⏳ Metro bundler hazırlanıyor..."
        sleep 5
        
        # Android uygulamasını çalıştır
        echo "📦 Uygulama Android cihaza yükleniyor..."
        npx react-native run-android
        ;;
    2)
        echo "🧹 Cache temizleniyor..."
        npx react-native start --reset-cache &
        METRO_PID=$!
        
        echo "⏳ Metro bundler hazırlanıyor..."
        sleep 5
        
        echo "📦 Uygulama Android cihaza yükleniyor..."
        npx react-native run-android
        ;;
    3)
        echo "🔄 Metro bundler başlatılıyor..."
        npx react-native start
        exit 0
        ;;
    4)
        echo "📦 Uygulama Android cihaza yükleniyor..."
        npx react-native run-android
        exit 0
        ;;
    *)
        echo "❌ Geçersiz seçim!"
        exit 1
        ;;
esac

# Script sonlandığında Metro'yu da durdur
trap "kill $METRO_PID 2>/dev/null" EXIT

echo ""
echo "✅ Uygulama başarıyla başlatıldı!"
echo "Metro bundler PID: $METRO_PID"
echo ""
echo "💡 Faydalı komutlar:"
echo "   - Uygulamayı yeniden yüklemek için: r tuşuna basın"
echo "   - Dev menüsünü açmak için: cihazda uygulamayı çift tıklayın veya sallayın"
echo "   - Logları görmek için: npm run logs (başka bir terminalde)"
echo ""
echo "⛔ Durdurmak için Ctrl+C tuşlarına basın"

# Metro'nun çalışmasını bekle
wait $METRO_PID
