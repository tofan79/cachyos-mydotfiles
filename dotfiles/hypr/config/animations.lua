-- Animation preset loader
ANIMATION_PRESET = "bounce"
require("config.animations_presets." .. ANIMATION_PRESET)

-- =========================================================
-- PAKSA OVERRIDE KHUSUS UNTUK BORDER ROTATE (LOOP BERULANG)
-- =========================================================

-- 1. Buat kurva linear murni (wajib agar putaran tidak mandek)
hl.curve("my_linear_curve", { type = "bezier", points = { {0, 0}, {1, 1} } })

-- 2. Atur animasi border default saat ganti fokus (kecepatan normal)
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })

-- 3. HAPUS animasi lama borderangle bawaan preset terlebih dahulu (jika ada)
hl.animation({ leaf = "borderangle", enabled = false })

-- 4. JALANKAN ULANG borderangle murni dengan memaksa style = "loop"
hl.animation({ leaf = "borderangle", enabled = true, speed = 20, bezier = "my_linear_curve", style = "loop" })
