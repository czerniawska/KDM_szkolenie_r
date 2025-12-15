# ==========================================================
# LEKCJA 3: Tidy Data (tidyr) i łączenie (Joins)
# ==========================================================

library(tidyverse)

# CZĘŚĆ 1: RESTRUKTURYZACJA (PIVOTING) 

# 1. Stwórzmy typowe dane "Excelowe" (Format SZEROKI)
# Mamy 3 pacjentów i ich ciśnienie w trzech punktach czasu.
dane_szerokie <- tibble(
  id = c("Pacjent_A", "Pacjent_B", "Pacjent_C"), # Kolumna 1, funkcja c tworzy wektor z wartościami
  grupa = c("Lek", "Placebo", "Lek"), # Kolumna 2
  pomiar_T0 = c(120, 130, 115), # Kolumna 3
  pomiar_T1 = c(118, 128, 110), #...
  pomiar_T2 = c(115, 129, 108)
)

print(dane_szerokie)

# ------------------------------------------------------------------
# PROBLEM: Jak policzyć średnie ciśnienie dla każdego pacjenta?
# ------------------------------------------------------------------

# W formacie SZEROKIM musimy ręcznie dodawać kolumny:
dane_szerokie %>% 
  mutate(srednia = (pomiar_T0 + pomiar_T1 + pomiar_T2) / 3)

# Wyobraźcie sobie, że macie pomiary z 50 tygodni. 
# Musielibyście wypisać: (T1 + T2 + ... + T50) / 50. 

# Jeśli zmienimy format na długi...

# 2. PIVOT LONGER - Wydłużanie danych
# Zamieniamy kolumny z czasami na wiersze.

dane_dlugie <- dane_szerokie %>% 
  pivot_longer(
    cols = starts_with("pomiar"), 
    names_to = "czas", 
    values_to = "cisnienie"
  )

print(dane_dlugie) # W 1. kolumnie każdy pacjent pojawia się wielokrotnie. To jest okey.

# ...to obliczenie średniej (nawet dla 1000 pomiarów) jest banalne.
# Używamy tego, co już znacie: group_by + summarise

dane_dlugie %>% 
  group_by(id) %>% 
  summarise(srednia = mean(cisnienie))

# Wniosek: Komputer woli format długi.


# 3. PIVOT WIDER - Powrót do szerokości (np. do tabeli w publikacji)
# Czasami potrzebujemy tabeli przestawnej do druku.

tabela_do_druku <- dane_dlugie %>% 
  pivot_wider(
    names_from = czas_pomiaru,
    values_from = cisnienie
  )


# CZĘŚĆ 2: ŁĄCZENIE ZBIORÓW (JOINS) ------------------------

# Wyobraź sobie, że masz dane w dwóch osobnych plikach.

# Tabela 1: Demografia
pacjenci <- tibble(
  id = c("P1", "P2", "P3"),
  wiek = c(25, 30, 45),
  plec = c("K", "M", "K")
)

# Tabela 2: Wyniki badań (Zauważ: brak P3, ale jest P4!)
wyniki <- tibble(
  id = c("P1", "P2", "P4"),
  badanie_krwi = c(4.5, 5.2, 4.8)
)

# 5. LEFT JOIN - Najbezpieczniejszy standard
# "Zatrzymaj wszystkich z lewej tabeli (pacjenci) i doklej, co znajdziesz z prawej"

dane_polaczone <- left_join(pacjenci, wyniki, by = "id")

print(dane_polaczone)

# Analiza wyniku:
# - P1 i P2: Mają komplet danych.
# - P3: Ma NA w badaniu krwi (nie było go w drugiej tabeli).
# - P4: Został pominięty (bo nie było go w tabeli 'pacjenci' - głównej).

# Inne rodzaje (tylko do wspomnienia):
# inner_join() - zostawia tylko tych, co są w OBU tabelach (część wspólna)
# full_join()  - bierze wszystkich (P1, P2, P3 i P4)