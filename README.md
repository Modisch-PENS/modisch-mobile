# SOP Kerja dengan Git

## Alur Kerja Git

### 1. Clone Repository
```bash
git clone https://github.com/Modisch-PENS/modisch-mobile.git
```
Secara default, perintah ini akan mengclone branch development.

### 2. Buat Branch Baru
Buatlah branch baru sesuai dengan fitur/modul yang akan dikerjakan:
```bash
git checkout -b nama_branch
```
Penamaan branch sebaiknya deskriptif sesuai dengan fitur yang dikerjakan.

### 3. Commit Perubahan
Setelah melakukan perubahan, lakukan commit dengan langkah berikut:
```bash
git add .
git commit -m "deskripsi singkat apa yang telah dibuat"
git push origin nama_branch
```

Jangan malas untuk melakukan commit! Lebih baik sering commit dalam ukuran kecil daripada jarang commit dalam ukuran besar.

### 4. Membuat Pull Request
Setelah fitur selesai dikembangkan:
1. Buka github.com
2. Buat Pull Request dari branch kamu ke branch development (sudah default)
3. Tambahkan reviewer: **mrrizzz**
4. Berikan deskripsi yang jelas tentang perubahan yang dibuat

### 5. Kebijakan Pull Request
- Pull Request ke branch development hanya dilakukan jika fitur sudah selesai
- Sebelum membuat Pull Request, konfirmasi di grup wa dengan tag PO

### 6. Struktur Branch
- **Branch development**: Branch default selama proses pengembangan
- **Branch main**: Branch untuk production yang hanya diupdate setelah sprint selesai

## Catatan Penting
- Lakukan commit secara teratur
- Usahakan commit message jelas dan deskriptif
- Selalu pull branch development terbaru sebelum membuat branch baru

## Semangat Coding! 💻🚀