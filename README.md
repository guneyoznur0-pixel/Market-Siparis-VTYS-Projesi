# 🛒 Market Sipariş ve Teslimat Sistemi - Veri Tabanı Tasarımı

Bu döküman, projemizdeki 14 temel tablonun yapısını, kolonlarını ve aralarındaki ilişkileri tanımlar. 

## 🏗️ 1. Kullanıcı ve Lokasyon Yönetimi
### Kullanicilar (Users)
- `KullaniciID` (PK), `Ad`, `Soyad`, `Email` (Unique), `SifreHash`, `Telefon`, `Rol` (Müşteri/Kurye/Admin), `KayitTarihi`

### Adresler (Addresses)
- `AdresID` (PK), `KullaniciID` (FK), `Baslik`, `Sehir`, `Ilce`, `AcikAdres`, `VarsayilanMi` (Bit)

## 📦 2. Ürün ve Stok Katmanı
### Kategoriler (Categories)
- `KategoriID` (PK), `KategoriAdi`, `Aciklama`

### Urunler (Products)
- `UrunID` (PK), `KategoriID` (FK), `UrunAdi`, `Marka`, `BirimFiyat`, `StokMiktari`, `Barkod`

### Urun_Fotograflari (Product_Images)
- `FotoID` (PK), `UrunID` (FK), `FotoURL`

### Urun_Yorumlari (Product_Reviews)
- `YorumID` (PK), `UrunID` (FK), `KullaniciID` (FK), `Puan` (1-5), `YorumMetni`, `Tarih`

### Stok_Hareketleri (Stock_Movements)
- `HareketID` (PK), `UrunID` (FK), `Miktar`, `IslemTipi` (Giriş/Çıkış), `Tarih`

## 💳 3. Satış ve Sipariş Operasyonu
### Siparisler (Orders)
- `SiparisID` (PK), `KullaniciID` (FK), `AdresID` (FK), `KuponID` (FK - Opsiyonel), `SiparisTarihi`, `ToplamTutar`, `MevcutDurum`

### Siparis_Detaylari (Order_Items)
- `DetayID` (PK), `SiparisID` (FK), `UrunID` (FK), `Adet`, `SatisFiyati` (Sipariş anındaki fiyat)

### Siparis_Durum_Gecmisi (Order_Status_History)
- `GecmisID` (PK), `SiparisID` (FK), `Durum` (Hazırlanıyor/Yolda/Teslim Edildi), `GuncellemeTarihi`

### Odemeler (Payments)
- `OdemeID` (PK), `SiparisID` (FK), `OdemeTipi` (Nakit/Kart), `OdemeDurumu` (Başarılı/Beklemede), `Tarih`

## 🚚 4. Lojistik ve Kampanya
### Kuryeler (Couriers)
- `KuryeID` (PK), `KullaniciID` (FK), `AracTipi`, `Plaka`, `AktifMi` (Bit)

### Kuponlar (Coupons)
- `KuponID` (PK), `KuponKodu`, `IndirimOrani`, `SonKullanimTarihi`, `MinimumAltLimit`

### Iadeler (Returns)
- `IadeID` (PK), `SiparisID` (FK), `UrunID` (FK), `IadeSebebi`, `IadeDurumu`, `TalepTarihi`
## 📊 Market Sipariş ve Teslimat Sistemi - E-R Diyagramı

![Market Veri Tabanı Şeması](E-R%20Diyagramam.drawio.png)
