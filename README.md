# Pemahaman
Lambda calculus adalah bahasa pemrograman terkecil yang terdiri tiga term,
abstraksi, aplikasi, dan atom. Repo ini merupakan hasil dari eksplorasi
bahasa tersebut menggunakan bahasa haskell untuk membuat interpreter yang
berguna untuk mereduksi lambda term menjadi bentuk paling sederhana yang
dapat direduksi.

Selain dari belajar mengenai lambda calculus, pada pengembangan repo ini
saya juga belajar banyak mengenai haskell, seperti penggunaan parser untuk
mengubah string menjadi sebuah term lambda, serta mengenai beberapa operator
yang ada pada `Applicative` seperti `<*>` dan `<$>`.

# Modifikasi
Modifikasi yang saya lakukan pada source code, adalah dengan menambahkan
parser untuk digit dan operator seperti (+) dan (\*). Implementasi parser
tersebut saya pelajari dengan memahami parser-parser yang sudah dikembangkan
di source code sebelumnya, dengan membuat parser sendiri. Untuk church numeral
saya buat dengan membaca sebuah digit, jika berhasil kemudian mengubahnya
menjadi bentuk lambda dari church numeral, seperti berikut `0 := \\f x. x,
1 := \\f x. f x, n:= \\f x. f (f ... (f x))`. Kemudian untuk operator tambah
dengan memparse simbol (+) menjadi `\\m n f x.m f (n f x)`, untuk operator
kali (\*) menjadi `\\m n f x.m (n f) x`.

# Credits
repo ini di fork dari repo url berikut:
[sgillespie/lambda-calculus](https://github.com/sgillespie/lambda-calculus)
