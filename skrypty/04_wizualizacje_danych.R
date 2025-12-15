# ==========================================================
# LEKCJA 4: Wizualizacja danych (ggplot2)
# ==========================================================

library(tidyverse)
library(ggplot2)
# Upewnijmy się, że mamy dane
ssaki <- read_csv('dane/ssaki.csv')

# 1. GRAMATYKA GRAFIKI - Krok po kroku 

# KROK A: Płótno (Definiujemy dane i osie)
# Oś X: waga ciała (bodywt), Oś Y: całkowity sen (sleep_total)
ggplot(data = ssaki, aes(x = bodywt, y = sleep_total))
# Uruchom to -> Zobaczysz puste tło z osiami. Brakuje geometrii!

# KROK B: Dodajemy geometrię (Punkty)
ggplot(ssaki, aes(x = bodywt, y = sleep_total)) +
  geom_point()

# KROK C: Poprawiamy czytelność (Skala logarytmiczna)
# W biologii dane często są skośne (słonie ważą dużo więcej niż myszy).
ggplot(ssaki, aes(x = bodywt, y = sleep_total)) +
  geom_point() +
  scale_x_log10() +  # Logarytmiczna oś X
  labs(x = "Waga ciała (log)", y = "Czas snu (h)", title = "Sen a waga ssaków")

# 2. KOLORY I GRUPY (Najtrudniejsza koncepcja!) 

# Wariant 1: Kolor zależy od zmiennej (Wewnątrz aes)
# "Pokoloruj punkty w zależności od diety (vore)"
ggplot(ssaki, aes(x = bodywt, y = sleep_total)) +
  geom_point(aes(color = vore)) + 
  scale_x_log10()

# Wariant 2: Kolor stały (Na zewnątrz aes)
# "Zrób wszystkie punkty czerwone"
ggplot(ssaki, aes(x = bodywt, y = sleep_total)) +
  geom_point(color = "red", size = 3, alpha = 0.5) + # alpha to przezroczystość
  scale_x_log10()


# 3. LINIE TRENDU (Statystyka na wykresie) 
# Dodajemy warstwę geom_smooth
ggplot(ssaki, aes(x = bodywt, y = sleep_total)) +
  geom_point() +
  scale_x_log10() +
  geom_smooth(method = "lm") # lm = Linear Model (regresja liniowa)
# Szare pole to 95% przedział ufności.


# 4. BOXPLOT - Porównywanie grup 
# Czy mięsożercy śpią dłużej niż roślinożercy?

ggplot(ssaki, aes(x = vore, y = sleep_total, fill = vore)) +
  geom_boxplot() +
  labs(title = "Dystrybucja snu wg diety")

# PRO-TIP NAUKOWY: Boxplot ukrywa liczebność próby.
# Dodajmy punkty (jitter), żeby pokazać prawdziwe dane "pod spodem".
ggplot(ssaki, aes(x = vore, y = sleep_total)) +
  geom_boxplot(outlier.shape = NA) + # Ukrywamy odstające, bo zaraz dodamy punkty
  geom_jitter(width = 0.2, alpha = 0.5) + # Rozrzucamy punkty na boki
  theme_bw() # Czysty styl (czarno-biały), dobry do druku


# 5. FACET WRAP - Wiele wykresów naraz 
# Chcemy zobaczyć zależność waga vs sen, ale OSOBNO dla każdej diety.

ggplot(ssaki, aes(x = bodywt, y = sleep_total)) +
  geom_point() +
  scale_x_log10() +
  geom_smooth(method = "lm", se = FALSE) + # Bez przedziału ufności
  facet_wrap(~vore) + # To jest magia! "~" czytamy jako "według"
  labs(title = "Relacja waga-sen w podgrupach diety")


# 6. WYKRES LINIOWY (Line Plot) - Zmiana w czasie 
# Pamiętasz dane "dane_dlugie" z poprzedniej lekcji? 
# (Jeśli ich nie masz, uruchom szybko kod z Lekcji 3)

# Ważne: Musimy powiedzieć R, które punkty łączyć (group = id)
ggplot(dane_dlugie, aes(x = czas_pomiaru, y = cisnienie, group = id, color = grupa)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  theme_minimal()


# 7. EKSPORT DO PUBLIKACJI (ggsave) 

# Najpierw przypisz wykres do zmiennej
moj_wykres <- ggplot(ssaki, aes(x = vore, y = sleep_total)) + geom_boxplot()

# Zapisz na dysku (R sam rozpoznaje format po rozszerzeniu)
ggsave("wykresy/wykres_do_publikacji.png", plot = moj_wykres, 
       width = 8, height = 6, dpi = 300) # dpi=300 to standard druku

ggsave("wykresy/wykres_wektorowy.pdf", plot = moj_wykres)
