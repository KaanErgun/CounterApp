#!/bin/bash

# React Native Wireless Debug Setup
# Android cihazı kablosuz olarak bağlar

set -e  # Hata durumunda scripti durdur

echo "📱 React Native Wireless Debug Kurulumu"
echo "======================================="
echo ""

# Android SDK yolunu ayarla
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Proje dizinine git
cd "$(dirname "$0")"

# ADB'nin kurulu olup olmadığını kontrol et
if ! command -v adb &> /dev/null; then
    echo "❌ ADB bulunamadı!"
    echo "   Android SDK'nın kurulu olduğundan emin olun."
    exit 1
fi

# Fonksiyon: Kablosuz bağlantı kur
connect_wireless() {
    echo "1️⃣ USB ile bağlı cihazları kontrol ediyorum..."
    DEVICES=$(adb devices | grep -w "device" | wc -l)
    
    if [ $DEVICES -eq 0 ]; then
        echo "⚠️  USB ile bağlı cihaz bulunamadı!"
        echo "   Lütfen cihazınızı USB ile bağlayın ve USB hata ayıklama açık olsun."
        exit 1
    fi
    
    adb devices
    echo ""
    
    # Kullanıcıdan cihazın IP adresini al
    echo "2️⃣ Android cihazınızın IP adresini bulun:"
    echo "   Ayarlar → Telefon hakkında → Durum → IP adresi"
    echo "   veya"
    echo "   Ayarlar → Wi-Fi → Bağlı ağa tıkla → IP adresi"
    echo ""
    read -p "Cihazın IP adresini girin (örn: 192.168.1.100): " device_ip
    
    # IP adresi formatını kontrol et
    if [[ ! $device_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "❌ Geçersiz IP adresi formatı!"
        exit 1
    fi
    
    echo ""
    echo "3️⃣ ADB'yi TCP/IP moduna geçiriyorum (port 5555)..."
    adb tcpip 5555
    
    echo ""
    echo "4️⃣ Kabloyu çıkarabilirsiniz."
    echo "   ⚠️  Cihazınız ve bilgisayarınız aynı Wi-Fi ağında olmalı!"
    echo "   Devam etmek için Enter'a basın..."
    read
    
    echo ""
    echo "5️⃣ Kablosuz bağlantı kuruluyor: $device_ip:5555"
    
    # Bağlantıyı dene
    if adb connect "$device_ip:5555"; then
        echo ""
        echo "6️⃣ Bağlı cihazlar:"
        adb devices
        echo ""
        echo "✅ Kablosuz bağlantı başarıyla kuruldu!"
        
        # IP adresini kaydet
        echo "$device_ip" > .wireless-device-ip
        
        echo ""
        echo "📋 Kullanım:"
        echo "   - npm run dev ile uygulamayı başlatın"
        echo "   - npm run android ile uygulamayı derleyip yükleyin"
        echo ""
        echo "💡 İpuçları:"
        echo "   - Cihazınızı her başlattığınızda IP adresi değişebilir"
        echo "   - Bağlantı kesilirse bu scripti tekrar çalıştırın"
        echo ""
        echo "🔌 Kablosuz bağlantıyı kesmek için:"
        echo "   adb disconnect $device_ip:5555"
        echo ""
        echo "🔄 USB'ye geri dönmek için:"
        echo "   adb usb"
    else
        echo ""
        echo "❌ Bağlantı kurulamadı!"
        echo "   Kontrol edin:"
        echo "   - Cihaz ve bilgisayar aynı Wi-Fi ağında mı?"
        echo "   - IP adresi doğru mu?"
        echo "   - Cihazda USB hata ayıklama açık mı?"
        exit 1
    fi
}

# Fonksiyon: Kaydedilmiş IP'ye bağlan
connect_saved() {
    if [ -f ".wireless-device-ip" ]; then
        device_ip=$(cat .wireless-device-ip)
        echo "💾 Kaydedilmiş IP bulundu: $device_ip"
        echo "   Bağlanıyor..."
        
        if adb connect "$device_ip:5555"; then
            echo "✅ Başarıyla bağlandı!"
            adb devices
        else
            echo "❌ Bağlantı kurulamadı. Yeni kurulum yapılıyor..."
            connect_wireless
        fi
    else
        echo "📝 Kaydedilmiş IP bulunamadı. İlk kurulum yapılıyor..."
        connect_wireless
    fi
}

# Fonksiyon: Bağlantıyı kes
disconnect_all() {
    echo "🔌 Tüm kablosuz bağlantılar kesiliyor..."
    adb disconnect
    echo "✅ Bağlantılar kesildi."
    
    if [ -f ".wireless-device-ip" ]; then
        rm .wireless-device-ip
        echo "🗑️  Kaydedilmiş IP silindi."
    fi
}

# Ana menü
echo "Ne yapmak istersiniz?"
echo "1) Yeni kablosuz bağlantı kur"
echo "2) Kaydedilmiş IP'ye bağlan"
echo "3) Tüm kablosuz bağlantıları kes"
echo "4) Bağlı cihazları listele"
read -p "Seçiminiz (1-4) [2]: " choice
choice=${choice:-2}

echo ""

case $choice in
    1)
        connect_wireless
        ;;
    2)
        connect_saved
        ;;
    3)
        disconnect_all
        ;;
    4)
        echo "📱 Bağlı cihazlar:"
        adb devices -l
        ;;
    *)
        echo "❌ Geçersiz seçim!"
        exit 1
        ;;
esac
