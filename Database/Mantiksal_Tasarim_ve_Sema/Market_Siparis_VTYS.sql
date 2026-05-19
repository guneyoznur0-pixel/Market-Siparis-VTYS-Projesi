-- ====================================================================
-- MARKET SİPARİŞ VE TESLİMAT SİSTEMİ - VERİ TABANI ŞEMASI (T-SQL)
-- ====================================================================

-- 1. KATEGORİLER TABLOSU
CREATE TABLE Kategoriler (
    KategoriID INT PRIMARY KEY IDENTITY(1,1),
    KategoriAdi NVARCHAR(100) NOT NULL UNIQUE,
    Aciklama NVARCHAR(500),
    OlusturmaTarihi DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT CHK_KategoriAdi_NotEmpty CHECK (LEN(KategoriAdi) > 0)
);

-- 2. KULLANICILAR TABLOSU
CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    SifreHash VARCHAR(255) NOT NULL,
    Telefon VARCHAR(11) NOT NULL,
    Rol VARCHAR(20) NOT NULL,
    KayitTarihi DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT CHK_Email_Format CHECK (Email LIKE '%@%.%'),
    CONSTRAINT CHK_Rol_Valid CHECK (Rol IN ('Müşteri', 'Kurye', 'Admin')),
    CONSTRAINT CHK_Ad_NotEmpty CHECK (LEN(Ad) > 0),
    CONSTRAINT CHK_Soyad_NotEmpty CHECK (LEN(Soyad) > 0)
);

-- 3. ADRESLER TABLOSU
CREATE TABLE Adresler (
    AdresID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT NOT NULL,
    Baslik NVARCHAR(100) NOT NULL,
    Sehir NVARCHAR(50) NOT NULL,
    Ilce NVARCHAR(50) NOT NULL,
    AcikAdres NVARCHAR(500) NOT NULL,
    VarsayilanMi BIT DEFAULT 0,
    OlusturmaTarihi DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Adresler_Kullanicilar FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID) ON DELETE CASCADE,
    CONSTRAINT CHK_Baslik_NotEmpty CHECK (LEN(Baslik) > 0),
    CONSTRAINT CHK_Sehir_NotEmpty CHECK (LEN(Sehir) > 0),
    CONSTRAINT CHK_Ilce_NotEmpty CHECK (LEN(Ilce) > 0),
    CONSTRAINT CHK_AcikAdres_NotEmpty CHECK (LEN(AcikAdres) > 0)
);

-- 4. KURYELER TABLOSU
CREATE TABLE Kuryeler (
    KuryeID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT NOT NULL UNIQUE,
    AracTipi VARCHAR(50),
    Plaka VARCHAR(20),
    AktifMi BIT DEFAULT 1,
    TeslimSayisi INT DEFAULT 0,
    CONSTRAINT FK_Kuryeler_Kullanicilar FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID) ON DELETE CASCADE,
    CONSTRAINT CHK_AracTipi_Valid CHECK (AracTipi IN ('Motorsiklet', 'Van', 'Bisiklet', 'Yaya')),
    CONSTRAINT CHK_Plaka_NotEmpty CHECK (Plaka IS NULL OR LEN(Plaka) > 0),
    CONSTRAINT CHK_TeslimSayisi_NonNegative CHECK (TeslimSayisi >= 0)
);

-- 5. KUPONLAR TABLOSU
CREATE TABLE Kuponlar (
    KuponID INT PRIMARY KEY IDENTITY(1,1),
    KuponKodu VARCHAR(20) NOT NULL UNIQUE,
    IndirimOrani DECIMAL(5,2) NOT NULL,
    SonKullanimTarihi DATE NOT NULL,
    MinimumAltLimit DECIMAL(12,2) DEFAULT 0,
    KullanimSayisi INT DEFAULT 0,
    MaxKullanimSayisi INT,
    AktifMi BIT DEFAULT 1,
    CONSTRAINT CHK_KuponKodu_NotEmpty CHECK (LEN(KuponKodu) > 0),
    CONSTRAINT CHK_IndirimOrani_Range CHECK (IndirimOrani BETWEEN 0 AND 100),
    CONSTRAINT CHK_MinimumAltLimit_NonNegative CHECK (MinimumAltLimit >= 0),
    CONSTRAINT CHK_MaxKullanimSayisi_Positive CHECK (MaxKullanimSayisi IS NULL OR MaxKullanimSayisi > 0)
);

-- 6. ÜRÜNLER TABLOSU
CREATE TABLE Urunler (
    UrunID INT PRIMARY KEY IDENTITY(1,1),
    KategoriID INT NOT NULL,
    UrunAdi NVARCHAR(150) NOT NULL,
    Marka NVARCHAR(100),
    BirimFiyat DECIMAL(10,2) NOT NULL,
    StokMiktari INT NOT NULL DEFAULT 0,
    Barkod VARCHAR(13),
    OlusturmaTarihi DATETIME2 DEFAULT GETDATE(),
    GuncellemeTarihi DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Urunler_Kategoriler FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID) ON DELETE NO ACTION,
    CONSTRAINT CHK_UrunAdi_NotEmpty CHECK (LEN(UrunAdi) > 0),
    CONSTRAINT CHK_BirimFiyat_Positive CHECK (BirimFiyat > 0),
    CONSTRAINT CHK_StokMiktari_NonNegative CHECK (StokMiktari >= 0),
    CONSTRAINT CHK_Barkod_Length CHECK (Barkod IS NULL OR LEN(Barkod) = 13)
);

-- 7. ÜRÜN FOTOĞRAFLARI TABLOSU
CREATE TABLE Urun_Fotograflari (
    FotoID INT PRIMARY KEY IDENTITY(1,1),
    UrunID INT NOT NULL,
    FotoURL NVARCHAR(500) NOT NULL,
    Sira INT DEFAULT 1,
    OlusturmaTarihi DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_UrunFotograflari_Urunler FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID) ON DELETE CASCADE,
    CONSTRAINT CHK_FotoURL_NotEmpty CHECK (LEN(FotoURL) > 8),
    CONSTRAINT CHK_Sira_Positive CHECK (Sira > 0)
);

-- 8. ÜRÜN YORUMLARI TABLOSU
CREATE TABLE Urun_Yorumlari (
    YorumID INT PRIMARY KEY IDENTITY(1,1),
    UrunID INT NOT NULL,
    KullaniciID INT NOT NULL,
    Puan TINYINT NOT NULL,
    YorumMetni NVARCHAR(1000),
    Tarih DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_UrunYorumlari_Urunler FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID) ON DELETE CASCADE,
    CONSTRAINT FK_UrunYorumlari_Kullanicilar FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID) ON DELETE CASCADE,
    CONSTRAINT CHK_Puan_Range CHECK (Puan BETWEEN 1 AND 5),
    CONSTRAINT UQ_Kullanici_Urun UNIQUE (KullaniciID, UrunID)
);

-- 9. STOK HAREKETLERİ TABLOSU
CREATE TABLE Stok_Hareketleri (
    HareketID INT PRIMARY KEY IDENTITY(1,1),
    UrunID INT NOT NULL,
    Miktar INT NOT NULL,
    IslemTipi VARCHAR(20) NOT NULL,
    Tarih DATETIME2 DEFAULT GETDATE(),
    Aciklama NVARCHAR(500),
    CONSTRAINT FK_StokHareketleri_Urunler FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID) ON DELETE NO ACTION,
    CONSTRAINT CHK_Miktar_Positive CHECK (Miktar > 0),
    CONSTRAINT CHK_IslemTipi_Valid CHECK (IslemTipi IN ('Giriş', 'Çıkış'))
);

-- 10. SİPARİŞLER TABLOSU
CREATE TABLE Siparisler (
    SiparisID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT NOT NULL,
    AdresID INT NOT NULL,
    KuponID INT,
    SiparisTarihi DATETIME2 DEFAULT GETDATE(),
    ToplamTutar DECIMAL(12,2) NOT NULL,
    MevcutDurum VARCHAR(50) NOT NULL,
    OdemeAdresi NVARCHAR(500),
    CONSTRAINT FK_Siparisler_Kullanicilar FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID) ON DELETE NO ACTION,
    CONSTRAINT FK_Siparisler_Adresler FOREIGN KEY (AdresID) REFERENCES Adresler(AdresID) ON DELETE NO ACTION,
    CONSTRAINT FK_Siparisler_Kuponlar FOREIGN KEY (KuponID) REFERENCES Kuponlar(KuponID) ON DELETE SET NULL,
    CONSTRAINT CHK_ToplamTutar_Positive CHECK (ToplamTutar >= 0),
    CONSTRAINT CHK_MevcutDurum_Valid CHECK (MevcutDurum IN ('Beklemede', 'Hazırlanıyor', 'Yolda', 'Teslim Edildi', 'İptal Edildi'))
);

-- 11. SİPARİŞ DETAYLARI TABLOSU
CREATE TABLE Siparis_Detaylari (
    DetayID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL,
    UrunID INT NOT NULL,
    Adet SMALLINT NOT NULL,
    SatisFiyati DECIMAL(10,2) NOT NULL,
    IndirimMiktari DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT FK_SiparisDetaylari_Siparisler FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID) ON DELETE CASCADE,
    CONSTRAINT FK_SiparisDetaylari_Urunler FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID) ON DELETE NO ACTION,
    CONSTRAINT CHK_Adet_Positive CHECK (Adet > 0),
    CONSTRAINT CHK_SatisFiyati_Positive CHECK (SatisFiyati > 0),
    CONSTRAINT CHK_IndirimMiktari_NonNegative CHECK (IndirimMiktari >= 0)
);

-- 12. SİPARİŞ DURUM GEÇMİŞİ TABLOSU
CREATE TABLE Siparis_Durum_Gecmisi (
    GecmisID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL,
    EskiDurum VARCHAR(50),
    YeniDurum VARCHAR(50) NOT NULL,
    GuncellemeTarihi DATETIME2 DEFAULT GETDATE(),
    GuncelleyenKullaniciID INT,
    Aciklama NVARCHAR(500),
    CONSTRAINT FK_SiparisGecmis_Siparisler FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID) ON DELETE CASCADE,
    CONSTRAINT CHK_YeniDurum_Valid CHECK (YeniDurum IN ('Beklemede', 'Hazırlanıyor', 'Yolda', 'Teslim Edildi', 'İptal Edildi'))
);

-- 13. ÖDEMELER TABLOSU
CREATE TABLE Odemeler (
    OdemeID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL,
    OdemeTipi VARCHAR(20) NOT NULL,
    OdemeTutari DECIMAL(12,2) NOT NULL,
    OdemeDurumu VARCHAR(20) NOT NULL,
    IslemNo VARCHAR(50),
    OdemeTarihi DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Odemeler_Siparisler FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID) ON DELETE NO ACTION,
    CONSTRAINT CHK_OdemeTipi_Valid CHECK (OdemeTipi IN ('Nakit', 'Kart', 'Banka Transferi')),
    CONSTRAINT CHK_OdemeDurumu_Valid CHECK (OdemeDurumu IN ('Başarılı', 'Beklemede', 'Başarısız')),
    CONSTRAINT CHK_OdemeTutari_Positive CHECK (OdemeTutari > 0)
);

-- 14. İADELER TABLOSU
CREATE TABLE Iadeler (
    IadeID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL,
    UrunID INT NOT NULL,
    IadeSebebi NVARCHAR(500) NOT NULL,
    IadeDurumu VARCHAR(50) NOT NULL,
    TalepTarihi DATETIME2 DEFAULT GETDATE(),
    KayitTarihi DATETIME2 DEFAULT GETDATE(),
    IadeTutari DECIMAL(12,2),
    CONSTRAINT FK_Iadeler_Siparisler FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID) ON DELETE NO ACTION,
    CONSTRAINT FK_Iadeler_Urunler FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID) ON DELETE NO ACTION,
    CONSTRAINT CHK_IadeSebebi_NotEmpty CHECK (LEN(IadeSebebi) > 0),
    CONSTRAINT CHK_IadeDurumu_Valid CHECK (IadeDurumu IN ('Talep', 'Onaylandı', 'Reddedildi', 'Tamamlandı')),
    CONSTRAINT CHK_IadeTutari_Positive CHECK (IadeTutari IS NULL OR IadeTutari > 0)
);