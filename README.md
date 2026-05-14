# Market-Siparis-VTYS-Projesi
Market şiparis ve teslimat sistemi veri tabanı yönetim sistemi projesi 
# Market Sipariş ve Teslimat Sistemi - Veri Sözlüğü

Bu döküman, projemizdeki 10 temel tablonun yapısını ve içereceği verileri tanımlar.

### 1. Kullanıcılar (Users)
- `KullaniciID` (PK), `Ad`, `Soyad`, `Email`, `SifreHash`, `Telefon`, `Rol` (Müşteri/Admin)

### 2. Adresler (Addresses)
- `AdresID` (PK), `KullaniciID` (FK), `Baslik`, `Sehir`, `Ilce`, `AcikAdres`

### 3. Kategoriler (Categories)
- `KategoriID` (PK), `KategoriAdi`, `Aciklama`

### 4. Ürünler (Products)
- `UrunID` (PK), `KategoriID` (FK), `UrunAdi`, `Fiyat`, `StokMiktari`, `Barkod`

### 5. Stok Hareketleri (Stock_Movements)
- `HareketID` (PK), `UrunID` (FK), `Miktar`, `Tip` (Giriş/Çıkış), `Tarih`

### 6. Siparişler (Orders)
- `SiparisID` (PK), `KullaniciID` (FK), `AdresID` (FK), `Tarih`, `ToplamTutar`, `Durum`

### 7. Sipariş Detayları (Order_Items)
- `DetayID` (PK), `SiparisID` (FK), `UrunID` (FK), `Adet`, `BirimFiyat`

### 8. Kuryeler (Couriers)
- `KuryeID` (PK), `Ad`, `Soyad`, `Plaka`, `Telefon`, `Aktiflik`

### 9. Ödemeler (Payments)
- `OdemeID` (PK), `SiparisID` (FK), `Tip` (Kart/Nakit), `Durum`, `IslemTarihi`

### 10. İndirim Kuponları (Coupons)
- `KuponID` (PK), `Kod`, `IndirimOrani`, `SonKullanimTarihi`
